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
driver = webdriver.Chrome(service=service, options=chrome_options)

# Use WebDriverWait for explicit waits
wait = WebDriverWait(driver, 30)

# Define CSV file name
csv_filename = 'Janakantha_videos.csv'

try:
    # Open YouTube channel videos page
    driver.get("https://www.youtube.com/@janakanthanews/videos")

    # Allow time for the page to load
    time.sleep(5)

    # Open CSV file and write headers
    with open(csv_filename, mode='w', newline='', encoding='utf-8') as file:
        writer = csv.writer(file)
        writer.writerow(['Title', 'URL', 'Timestamp', 'Tag'])

        # Set up scrolling to load more videos
        scroll_count = 1 # Adjust scroll count as needed to load more videos
        for scroll in range(scroll_count):
            print(f"Scrolling {scroll + 1} / {scroll_count}")

            # Scroll down to load more videos
            driver.execute_script("window.scrollTo(0, document.documentElement.scrollHeight);")
            time.sleep(3)  # Allow time for new videos to load

            # Attempt to locate video elements
            try:
                videos = wait.until(
                    EC.presence_of_all_elements_located((By.CSS_SELECTOR, 'ytd-rich-item-renderer'))
                )
            except TimeoutException:
                print("Timeout while waiting for video elements.")
                continue

            # Extract and save video information
            for video in videos:
                try:
                    # Scroll each video into view individually
                    driver.execute_script("arguments[0].scrollIntoView();", video)
                    time.sleep(1)

                    # Extract title, URL, and timestamp
                    title_element = wait.until(EC.visibility_of(video.find_element(By.CSS_SELECTOR, 'yt-formatted-string#video-title')))
                    title = title_element.text.strip()
                    url = video.find_element(By.CSS_SELECTOR, 'a#thumbnail').get_attribute('href')
                    timestamp_element = video.find_element(By.CSS_SELECTOR, 'span.inline-metadata-item')
                    timestamp = timestamp_element.text.strip()

                    # Debug print each video's information
                    print(f"Title: {title}")
                    print(f"URL: {url}")
                    print(f"Timestamp: {timestamp}\n")

                    # Write data to CSV with "BangladeshNewsChannel" tag
                    writer.writerow([title, url, timestamp, "BangladeshNewsChannel"])
                except (StaleElementReferenceException, NoSuchElementException) as e:
                    print("Error locating video details, skipping this video:", e)
                    continue
                except Exception as e:
                    print("Error extracting video details:", e)
                    continue

except Exception as e:
    print("Error loading page:", e)
finally:
    # Close the driver
    driver.quit()

print(f"Data has been saved to {csv_filename}")
