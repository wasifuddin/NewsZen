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


def check_videos(driver, channel_url, csv_file, seen_urls, tag):
    driver.get(channel_url)
    time.sleep(5)

    try:
        channel_name_element = WebDriverWait(driver, 30).until(
            EC.presence_of_element_located((By.CSS_SELECTOR, 'yt-formatted-string#text'))
        )
        channel_name = channel_name_element.text.strip()

        videos = WebDriverWait(driver, 30).until(
            EC.presence_of_all_elements_located((By.CSS_SELECTOR, 'ytd-rich-item-renderer'))
        )

        for video in videos:
            url = video.find_element(By.CSS_SELECTOR, 'a#thumbnail').get_attribute('href')
            if url not in seen_urls:
                seen_urls.add(url)

                title_element = video.find_element(By.CSS_SELECTOR, 'yt-formatted-string#video-title')
                title = title_element.text.strip() if title_element else 'null'

                # Example: Using 'null' for unavailable fields from your list
                web_scraper_order = 'null'  # Placeholder for demonstrative purposes
                web_scraper_start_url = channel_url
                newsitem = title  # Using the title as news item
                newsitem_href = url
                description = 'null'  # Not typically available on the listing page
                image_link_src = 'null'  # Would need to navigate into video for this
                topic = 'null'  # Not available without specific metadata or video analysis

                csv_file.writerow([web_scraper_order, web_scraper_start_url, newsitem, newsitem_href,
                                   title, description, image_link_src, topic, tag, channel_name, 'null'])

                print(f"New Video Found - Title: {title}, URL: {url}")
    except Exception as e:
        print(f"Error checking videos for {channel_url}:", e)


driver = initialize_driver()
csv_filename = 'YT_dynamicscrape.csv'
file = open(csv_filename, mode='a', newline='', encoding='utf-8')
csv_file = csv.writer(file)
csv_file.writerow(['Web-Scraper-Order', 'Web-Scraper-Start-URL', 'Newsitem', 'Newsitem-Href',
                   'Title', 'Description', 'Image-Link-Src', 'Topic', 'Tag', 'Username', 'Image URL'])

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

try:
    while True:
        for channel_url, (tag, seen_urls) in channels.items():
            check_videos(driver, channel_url, csv_file, seen_urls, tag)
        time.sleep(10)
except Exception as e:
    print("Error during execution:", e)
finally:
    driver.quit()
    file.close()

print("Dynamic data fetching script terminated.")
