from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from webdriver_manager.chrome import ChromeDriverManager
import csv
import time

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

try:
    # Open OnlinePalEng's profile page
    driver.get("https://x.com/OnlinePalEng")

    # Allow time for the page to load
    time.sleep(5)

    # Define CSV file name
    csv_filename = 'OnlinePalEng_tweets.csv'
    unique_tweets = set()  # To track unique tweets

    # Open CSV file and write headers
    with open(csv_filename, mode='w', newline='', encoding='utf-8') as file:
        writer = csv.writer(file)
        writer.writerow(['Username', 'Posted At', 'Post Content', 'Image URL', 'Video URL'])

        # Set up scroll to load more tweets
        scroll_count = 10  # Increase scroll count to load more tweets
        for _ in range(scroll_count):
            # Wait for tweets to load by checking for tweet elements
            tweets = driver.find_elements(By.XPATH, '//article[@role="article"]')

            # Extract and save information to CSV
            for tweet in tweets:
                try:
                    # Extract text content
                    content = tweet.find_element(By.XPATH, './/div[@data-testid="tweetText"]').text
                    timestamp = tweet.find_element(By.XPATH, './/time').get_attribute('datetime')

                    # Extract image URLs
                    image_elements = tweet.find_elements(By.XPATH, './/img[@alt="Image"]')
                    image_urls = [img.get_attribute('src') for img in image_elements]

                    # Extract video URL if present
                    video_elements = tweet.find_elements(By.XPATH, './/video')
                    video_urls = [video.get_attribute('src') for video in video_elements]

                    # Unique identifier to avoid duplicates
                    tweet_id = (timestamp, content)
                    if tweet_id not in unique_tweets:
                        unique_tweets.add(tweet_id)  # Mark tweet as seen

                        # Debug print each tweet's content, image URLs, and video URLs
                        print(f"Timestamp: {timestamp}")
                        print(f"Content: {content}")
                        print(f"Image URLs: {image_urls}")
                        print(f"Video URLs: {video_urls}\n")

                        # Write data to CSV
                        writer.writerow(['OnlinePalEng', timestamp, content, ', '.join(image_urls), ', '.join(video_urls)])
                except Exception as e:
                    print("Error extracting tweet:", e)
                    continue

            # Scroll down to load more tweets
            driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
            time.sleep(5)  # Wait for tweets to load

except Exception as e:
    print("Error loading page:", e)
finally:
    # Close the driver
    driver.quit()

print(f"Data has been saved to {csv_filename}")
