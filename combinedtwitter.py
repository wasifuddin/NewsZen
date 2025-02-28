from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from webdriver_manager.chrome import ChromeDriverManager
import csv
import time
from selenium.common.exceptions import NoSuchElementException, TimeoutException, StaleElementReferenceException


def initialize_driver():
    chrome_options = Options()
    chrome_options.page_load_strategy = 'eager'
    chrome_options.add_argument('--no-sandbox')
    chrome_options.add_argument('--disable-dev-shm-usage')
    chrome_options.add_argument('--disable-gpu')
    chrome_options.add_argument('--disable-software-rasterizer')
    chrome_options.add_argument('--headless')  # Run headless for improved performance
    service = Service(ChromeDriverManager().install())
    return webdriver.Chrome(service=service, options=chrome_options)


def extract_tweets_from_page(driver, tweets, username, tag, url, csv_writer, unique_posts, file_handle):
    print(f"Found {len(tweets)} tweets for {username}")
    new_found = 0
    for tweet in tweets:
        try:
            # Click "Show" if present to reveal full tweet text.
            try:
                show_button = tweet.find_element(By.XPATH, './/div[contains(text(), "Show")]')
                if show_button.is_displayed():
                    driver.execute_script("arguments[0].click();", show_button)
                    time.sleep(2)
            except NoSuchElementException:
                pass

            # Extract tweet content and timestamp.
            content = tweet.find_element(By.XPATH, './/div[@data-testid="tweetText"]').text.strip()
            timestamp = tweet.find_element(By.XPATH, './/time').get_attribute('datetime').strip()
            # Extract image URLs.
            image_elements = tweet.find_elements(By.XPATH, './/img[contains(@src, "media")]')
            image_urls = [img.get_attribute('src') for img in image_elements]
            # Extract video URLs.
            video_elements = tweet.find_elements(By.XPATH, './/video')
            video_urls = [video.get_attribute('src') for video in video_elements]

            tweet_id = (timestamp, content)
            if tweet_id not in unique_posts:
                unique_posts.add(tweet_id)
                csv_writer.writerow([
                    username, tag, timestamp, url, content,
                    ', '.join(image_urls) if image_urls else "null",
                    ', '.join(video_urls) if video_urls else "null"
                ])
                file_handle.flush()  # Immediately save changes
                new_found += 1
                print(f"{username}: New Tweet - {timestamp}, {content}")
        except (NoSuchElementException, StaleElementReferenceException) as e:
            print(f"Error processing a tweet for {username}: {e}")
            continue
    return new_found


def process_profile(driver, profile_data, csv_writer, unique_posts, file_handle):
    url = profile_data["url"]
    username = profile_data["username"]
    tag = profile_data["tag"]
    scroll_count = profile_data.get("scroll_count", 0)

    driver.get(url)
    try:
        WebDriverWait(driver, 20).until(EC.presence_of_element_located((By.XPATH, '//body')))
    except TimeoutException:
        print(f"Page load timeout for {url}")
        return
    time.sleep(3)

    initial_count = len(unique_posts)
    if scroll_count > 0:
        for scroll in range(scroll_count):
            print(f"{username}: Scrolling {scroll + 1} / {scroll_count}")
            try:
                tweets = WebDriverWait(driver, 20).until(
                    EC.presence_of_all_elements_located((By.XPATH, '//article[@role="article"]'))
                )
            except TimeoutException:
                print(f"Timeout finding tweets for {username}")
                break
            new_found = extract_tweets_from_page(driver, tweets, username, tag, url, csv_writer, unique_posts,
                                                 file_handle)
            driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
            time.sleep(5)
        if len(unique_posts) == initial_count:
            print(f"{username}: No new tweets found at this time.")
    else:
        try:
            tweets = WebDriverWait(driver, 20).until(
                EC.presence_of_all_elements_located((By.XPATH, '//article[@role="article"]'))
            )
        except TimeoutException:
            print(f"Timeout finding tweets for {username}")
            return
        new_found = extract_tweets_from_page(driver, tweets, username, tag, url, csv_writer, unique_posts, file_handle)
        if len(unique_posts) == initial_count:
            print(f"{username}: No new tweets found at this time.")


def main():
    driver = initialize_driver()
    # Define profiles with URL, username, tag, and optionally, scroll_count.
    profiles = {
        "KKRiders": {
            "url": "https://x.com/KKRiders",
            "username": "KolkataKnightRiders",
            "tag": "Cricket, IPL",
            "scroll_count": 10
        },
        "zulkarnainsaer": {
            "url": "https://x.com/zulkarnainsaer",
            "username": "zulkarnainsaer",
            "tag": "Bangladesh",
            "scroll_count": 0
        },
        "Timesofgaza": {
            "url": "https://x.com/Timesofgaza",
            "username": "Timesofgaza",
            "tag": "Palestine",
            "scroll_count": 0
        },
        "muftimenk": {
            "url": "https://x.com/muftimenk",
            "username": "muftimenk",
            "tag": "Islam, religion",
            "scroll_count": 10
        }
    }
    csv_filename = "combined_tweets.csv"
    unique_posts = set()

    with open(csv_filename, mode='a', newline='', encoding='utf-8') as file:
        csv_writer = csv.writer(file)
        # Write header if file is empty
        file.seek(0, 2)
        if file.tell() == 0:
            csv_writer.writerow(['Username', 'Tag', 'Timestamp', 'URL', 'Content', 'Image URLs', 'Video URLs'])

        try:
            while True:
                # Cycle through each profile
                for profile_name, profile_data in profiles.items():
                    process_profile(driver, profile_data, csv_writer, unique_posts, file)
                time.sleep(60)  # Check every 1 minute
        except KeyboardInterrupt:
            print("Stopped by user.")
        finally:
            driver.quit()

    print("Dynamic fetching complete.")


if __name__ == "__main__":
    main()
