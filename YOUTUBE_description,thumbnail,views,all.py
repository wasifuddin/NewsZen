from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from webdriver_manager.chrome import ChromeDriverManager
import csv
import time
from selenium.common.exceptions import TimeoutException, StaleElementReferenceException, NoSuchElementException


def initialize_driver():
    chrome_options = Options()
    chrome_options.page_load_strategy = 'eager'
    chrome_options.add_argument('--no-sandbox')
    chrome_options.add_argument('--disable-dev-shm-usage')
    chrome_options.add_argument('--disable-gpu')
    chrome_options.add_argument('--disable-software-rasterizer')
    service = Service(ChromeDriverManager().install())
    return webdriver.Chrome(service=service, options=chrome_options)


def check_videos(driver, channel_url, csv_writer, seen_urls, tag, source_mapping):
    # Load the channel page
    driver.get(channel_url)
    time.sleep(5)

    try:
        # Get the channel name from the channel page
        channel_name_element = WebDriverWait(driver, 30).until(
            EC.presence_of_element_located((By.CSS_SELECTOR, 'yt-formatted-string#text'))
        )
        channel_name = channel_name_element.text.strip()

        # Use mapping for specific channels if available, otherwise default to channel name + URL
        if channel_url in source_mapping:
            source = source_mapping[channel_url]
        else:
            source = f"{channel_name} ({channel_url})"

        # Get all video elements from the channel page
        videos = WebDriverWait(driver, 30).until(
            EC.presence_of_all_elements_located((By.CSS_SELECTOR, 'ytd-rich-item-renderer'))
        )

        for video in videos:
            url = video.find_element(By.CSS_SELECTOR, 'a#thumbnail').get_attribute('href')
            if url not in seen_urls:
                seen_urls.add(url)

                title_element = video.find_element(By.CSS_SELECTOR, 'yt-formatted-string#video-title')
                title = title_element.text.strip() if title_element else 'null'

                # Scrape the video thumbnail URL from the channel page
                try:
                    thumbnail_element = video.find_element(By.CSS_SELECTOR, 'a#thumbnail img')
                    imgsrc = thumbnail_element.get_attribute('src')
                except Exception as e:
                    print(f"Error fetching thumbnail for {url}: {e}")
                    imgsrc = 'null'

                # Open video page in a new tab to get the description, view count, etc.
                driver.execute_script("window.open('');")
                driver.switch_to.window(driver.window_handles[-1])
                driver.get(url)

                try:
                    # Attempt to click the "Show More" button to expand the description if available
                    try:
                        show_more_button = WebDriverWait(driver, 5).until(
                            EC.element_to_be_clickable((By.CSS_SELECTOR, "tp-yt-paper-button#more"))
                        )
                        show_more_button.click()
                        time.sleep(2)  # Allow time for the full description to load
                    except Exception as e:
                        print(f"Show More button not found or not clickable for {url}: {e}")

                    # Wait for the description element to appear
                    description_element = WebDriverWait(driver, 30).until(
                        EC.presence_of_element_located((By.CSS_SELECTOR, "div#description"))
                    )

                    # Additionally, click on the description element to ensure full expansion
                    try:
                        driver.execute_script("arguments[0].click();", description_element)
                        time.sleep(2)
                    except Exception as e:
                        print(f"Could not click on description element for {url}: {e}")

                    # Now fetch the full description text
                    video_description = description_element.text.strip()
                except Exception as e:
                    print(f"Error fetching description for {url}: {e}")
                    video_description = 'null'

                # Scrape view count
                try:
                    view_count_element = WebDriverWait(driver, 30).until(
                        EC.presence_of_element_located((By.CSS_SELECTOR, "span.view-count"))
                    )
                    view_count = view_count_element.text.strip()
                except Exception as e:
                    print(f"Error fetching view count for {url}: {e}")
                    view_count = 'null'

                # Instead of scraping like count, extract it from the first word of the description
                try:
                    # Assume the description begins with the view count as the first word
                    first_word = video_description.split()[0]
                    like_count = int(first_word.replace(',', '').strip())
                except Exception as e:
                    print(f"Error converting first word of description to int for {url}: {e}")
                    like_count = 'null'

                # Close the video tab and switch back to the channel tab
                driver.close()
                driver.switch_to.window(driver.window_handles[0])

                # Placeholders for other fields not extracted
                date = 'null'
                videosource = url  # Using the URL as the video source

                # Set language: BBC and CNN are in English; the rest are Bangla
                language = "English" if source in ("BBC", "CNN") else "Bangla"
                priority = 'null'

                # Write a new row with the updated CSV format including the parsed like count, view count, and thumbnail URL
                csv_writer.writerow(
                    [title, video_description, date, source, imgsrc, videosource, tag, language, like_count, view_count,
                     priority])
                print(f"New Video Found - Title: {title}, URL: {url}")
    except Exception as e:
        print(f"Error checking videos for {channel_url}:", e)


driver = initialize_driver()
csv_filename = 'YT_dynamicscrape.csv'
file = open(csv_filename, mode='a', newline='', encoding='utf-8')
csv_writer = csv.writer(file)
# Updated CSV header now includes 'ViewCount' and 'Imgsrc'
csv_writer.writerow(
    ['Title', 'Description', 'Date', 'Source', 'Imgsrc', 'Videosource', 'Type', 'Language', 'Likecount', 'ViewCount',
     'Priority'])

channels = {
    "https://www.youtube.com/@IndependentTelevision/videos": ("BDCHANNEL", set()),
    "https://www.youtube.com/@JamunaTVbd/videos": ("BDCHANNEL", set()),
    "https://www.youtube.com/@NTVlatestnews/videos": ("BDCHANNEL", set()),
    "https://www.youtube.com/@somoynews360/videos": ("BDCHANNEL", set()),
    "https://www.youtube.com/@ChanneliNews/videos": ("BDCHANNEL", set()),
    "https://www.youtube.com/@EkusheyETV/videos": ("BDCHANNEL", set()),
    "https://www.youtube.com/@CNN/videos": ("International News", set()),
    "https://www.youtube.com/@BBCNews/videos": ("International News", set())
}

# Mapping specific channels to the desired source names
source_mapping = {
    "https://www.youtube.com/@IndependentTelevision/videos": "Independent TV",
    "https://www.youtube.com/@JamunaTVbd/videos": "Jamuna TV",
    "https://www.youtube.com/@NTVlatestnews/videos": "NTV",
    "https://www.youtube.com/@somoynews360/videos": "SHOMOY TV",
    "https://www.youtube.com/@ChanneliNews/videos": "CHANNEL I",
    "https://www.youtube.com/@EkusheyETV/videos": "Ekushey TV",
    "https://www.youtube.com/@CNN/videos": "CNN",
    "https://www.youtube.com/@BBCNews/videos": "BBC"
}

try:
    while True:
        for channel_url, (tag, seen_urls) in channels.items():
            check_videos(driver, channel_url, csv_writer, seen_urls, tag, source_mapping)
        time.sleep(10)
except Exception as e:
    print("Error during execution:", e)
finally:
    driver.quit()
    file.close()

print("Dynamic data fetching script terminated.")
