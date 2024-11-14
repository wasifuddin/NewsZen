from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from webdriver_manager.chrome import ChromeDriverManager
import csv
import time
from selenium.common.exceptions import StaleElementReferenceException, NoSuchElementException

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

# Set timeout to allow more time for page load
driver.set_page_load_timeout(240)

# Use WebDriverWait for explicit waits
wait = WebDriverWait(driver, 20)

try:
    # Open ICT div profile page
    driver.get("https://x.com/KKRiders")

    # Allow time for the page to load
    time.sleep(5)

    # Define CSV file name
    csv_filename = 'KKR_tweets.csv'
    unique_tweets = set()  # To track unique tweets

    # Open CSV file and write headers
    with open(csv_filename, mode='w', newline='', encoding='utf-8') as file:
        writer = csv.writer(file)
        writer.writerow(['Username', 'Posted At', 'Post Content', 'Image URLs', 'Video URLs', 'Tag'])

        # Set up scroll to load more tweets
        scroll_count = 10  # Increase scroll count to load more tweets
        for scroll in range(scroll_count):
            print(f"Scrolling {scroll + 1} / {scroll_count}")

            # Wait for tweets to load by checking for tweet elements
            try:
                tweets = wait.until(EC.presence_of_all_elements_located((By.XPATH, '//article[@role="article"]')))
            except Exception as e:
                print("Error locating tweets:", e)
                continue

            # Extract and save information to CSV
            for tweet in tweets:
                try:
                    # Check and click "Show" button if content warning is present
                    try:
                        show_button = tweet.find_element(By.XPATH, './/div[contains(text(), "Show")]')
                        if show_button.is_displayed():
                            driver.execute_script("arguments[0].click();", show_button)
                            time.sleep(2)  # Wait for the content to load
                    except NoSuchElementException:
                        pass  # If no "Show" button is found, continue

                    # Extract text content
                    try:
                        content = tweet.find_element(By.XPATH, './/div[@data-testid="tweetText"]').text
                        timestamp = tweet.find_element(By.XPATH, './/time').get_attribute('datetime')
                    except NoSuchElementException:
                        print("Content or timestamp not found, skipping this tweet.")
                        continue

                    # Extract image URLs
                    image_elements = tweet.find_elements(By.XPATH, './/img[contains(@src, "media")]')
                    image_urls = [img.get_attribute('src') for img in image_elements]

                    # Attempt to extract video URLs from video elements and video containers
                    video_urls = []
                    video_elements = tweet.find_elements(By.XPATH, './/video')
                    for video in video_elements:
                        src = video.get_attribute('src')
                        if src:
                            video_urls.append(src)

                    # Additional check for video containers
                    video_container_elements = tweet.find_elements(By.XPATH, './/div[@data-testid="videoPlayer"]')
                    for container in video_container_elements:
                        src = container.get_attribute('src')
                        if src:
                            video_urls.append(src)

                    # Unique identifier to avoid duplicates
                    tweet_id = (timestamp, content)
                    if tweet_id not in unique_tweets:
                        unique_tweets.add(tweet_id)  # Mark tweet as seen

                        # Debug print each tweet's content, image URLs, and video URLs
                        print(f"Timestamp: {timestamp}")
                        print(f"Content: {content}")
                        print(f"Image URLs: {image_urls}")
                        print(f"Video URLs: {video_urls}\n")

                        # Write data to CSV with "Islam" tag in the "Tag" column
                        writer.writerow(['KolkataKnightRiders', timestamp, content, ', '.join(image_urls), ', '.join(video_urls), 'Cricket, IPL'])
                except StaleElementReferenceException:
                    print("Stale element reference exception - retrying tweet extraction")
                    continue  # Skip this tweet and continue with the next one
                except Exception as e:
                    print("Error extracting tweet:", e)
                    continue

            # Scroll down to load more tweets and wait for new tweets to load
            driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
            time.sleep(5)  # Increase wait time to ensure new tweets load fully

except Exception as e:
    print("Error loading page:", e)
finally:
    # Close the driver
    driver.quit()

print(f"Data has been saved to {csv_filename}")
