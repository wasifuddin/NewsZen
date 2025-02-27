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
    # Set Chrome options for optimal performance
    chrome_options = Options()
    chrome_options.page_load_strategy = 'eager'
    chrome_options.add_argument('--no-sandbox')
    chrome_options.add_argument('--disable-dev-shm-usage')
    chrome_options.add_argument('--disable-gpu')
    chrome_options.add_argument('--disable-software-rasterizer')
    # chrome_options.add_argument('--headless')  # Uncomment to run in headless mode if not testing visually

    # Initialize WebDriver with ChromeDriverManager using Service
    service = Service(ChromeDriverManager().install())
    return webdriver.Chrome(service=service, options=chrome_options)

def check_videos(driver, channel_url, csv_file, seen_urls, tag):
    driver.get(channel_url)
    time.sleep(5)  # Allow time for the page to load

    try:
        videos = WebDriverWait(driver, 30).until(
            EC.presence_of_all_elements_located((By.CSS_SELECTOR, 'ytd-rich-item-renderer'))
        )

        new_data_found = False

        for video in videos:
            url = video.find_element(By.CSS_SELECTOR, 'a#thumbnail').get_attribute('href')
            if url not in seen_urls:
                new_data_found = True
                seen_urls.add(url)

                title = video.find_element(By.CSS_SELECTOR, 'yt-formatted-string#video-title').text.strip()
                timestamp = video.find_element(By.CSS_SELECTOR, 'span.inline-metadata-item').text.strip()

                csv_file.writerow([title, url, timestamp, tag])
                print(f"New Video Found - Title: {title}, URL: {url}, Timestamp: {timestamp}")

        if not new_data_found:
            print("No new videos found for", channel_url)

    except Exception as e:
        print(f"Error checking videos for {channel_url}:", e)

driver = initialize_driver()

# CSV file setup
csv_filename = 'YT_dynamicscrape.csv'
file = open(csv_filename, mode='a', newline='', encoding='utf-8')
csv_file = csv.writer(file)
csv_file.writerow(['Title', 'URL', 'Timestamp', 'Tag'])

# Define URLs and maintain a set for seen URLs
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
        time.sleep(10)  # Wait 10 seconds before the next check cycle
except Exception as e:
    print("Error during execution:", e)
finally:
    driver.quit()
    file.close()  # Ensure file is closed after script termination

print("Dynamic data fetching script terminated.")
