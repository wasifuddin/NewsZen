import csv
import time
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from webdriver_manager.chrome import ChromeDriverManager


def initialize_driver(headless=False):
    chrome_options = Options()
    if headless:
        chrome_options.headless = True
    chrome_options.add_argument('--no-sandbox')
    chrome_options.add_argument('--disable-dev-shm-usage')
    chrome_options.add_argument('--disable-gpu')
    chrome_options.add_argument(
        "user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
        "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36"
    )
    chrome_options.add_argument("--window-size=1280,800")
    service = Service(ChromeDriverManager().install())
    return webdriver.Chrome(service=service, options=chrome_options)


def login_facebook(driver, username, password):
    """
    Navigates to https://www.facebook.com, waits for the login fields,
    and logs in using the provided credentials.
    """
    print("Navigating to facebook.com for login...")
    driver.get("https://www.facebook.com/")
    time.sleep(3)
    try:
        email_field = WebDriverWait(driver, 15).until(
            EC.presence_of_element_located((By.ID, "email"))
        )
        pass_field = driver.find_element(By.ID, "pass")
        login_button = driver.find_element(By.NAME, "login")
        email_field.clear()
        email_field.send_keys(username)
        pass_field.clear()
        pass_field.send_keys(password)
        login_button.click()
        print("Logged in successfully.")
        time.sleep(5)
    except Exception as e:
        print("Login failed:", e)


def close_login_popup(driver):
    """
    Attempts to close a login popup by clicking the close button.
    Adjust the XPath selector if Facebook changes its structure.
    """
    try:
        close_button = WebDriverWait(driver, 5).until(
            EC.element_to_be_clickable((By.XPATH, "//div[@aria-label='Close']"))
        )
        close_button.click()
        print("Login popup closed.")
    except Exception as e:
        print("No login popup to close:", e)


def fetch_facebook_posts(driver, url, scroll_count=1):
    """
    Navigates to the specified Facebook profile/page URL, attempts to close any popup,
    scrolls down, and extracts post data from <div role='article'> elements.
    Clicks "See More" if available to expand the full text.
    Returns only the three most recent posts.
    """
    posts = []
    print(f"Navigating to profile/page: {url}")
    driver.get(url)
    time.sleep(5)  # Wait for the profile page to load

    # Attempt to close any lingering login popup.
    close_login_popup(driver)
    time.sleep(3)

    # Optionally scroll a bit so posts come into view.
    driver.execute_script("window.scrollTo(0, document.body.scrollHeight/2);")
    time.sleep(2)

    for i in range(scroll_count):
        try:
            posts_elements = WebDriverWait(driver, 15).until(
                EC.presence_of_all_elements_located((By.XPATH, "//div[@role='article']"))
            )
        except Exception as e:
            print("Error waiting for posts:", e)
            posts_elements = driver.find_elements(By.XPATH, "//div[@role='article']")
        print(f"Scroll {i + 1}/{scroll_count}: Found {len(posts_elements)} post containers.")

        for post_element in posts_elements:
            # Click "See More" within the post if available.
            try:
                see_more = post_element.find_element(By.XPATH, ".//span[contains(text(),'See More')]")
                if see_more.is_displayed():
                    driver.execute_script("arguments[0].click();", see_more)
                    time.sleep(1)
                    print("Expanded a post with 'See More'.")
            except Exception:
                pass

            try:
                description = post_element.text.strip()
            except Exception:
                description = "null"

            try:
                timestamp_element = post_element.find_element(By.XPATH, ".//abbr")
                timestamp = timestamp_element.get_attribute("title")
            except Exception:
                timestamp = "Unknown"

            images = []
            try:
                img_elements = post_element.find_elements(By.XPATH, ".//img")
                for img in img_elements:
                    src = img.get_attribute("src")
                    if src:
                        images.append(src)
            except Exception:
                images = []

            try:
                post_link = post_element.find_element(By.XPATH, ".//a[contains(@href, '/posts/')]").get_attribute(
                    "href")
            except Exception:
                post_link = "Unknown"

            try:
                reaction_element = post_element.find_element(By.XPATH, ".//span[contains(@aria-label, 'reaction')]")
                reaction_text = reaction_element.get_attribute("aria-label")
                reaction_count = reaction_text.split()[0]
            except Exception:
                reaction_count = "0"

            post = {
                "Title": "",
                "Description": description,
                "Date": timestamp,
                "Source": "saerzulkarnain",
                "Imgsrc": ", ".join(images) if images else "null",
                "Videosource": "null",
                "Post URL": post_link,
                "Type": "Facebook Post",
                "Language": "Bangla",
                "Likecount": reaction_count,
                "Priority": 0
            }
            posts.append(post)

        driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
        time.sleep(3)

    return posts[:3]


def save_posts_to_csv(posts, filename='facebook_posts.csv'):
    with open(filename, mode='w', newline='', encoding='utf-8') as file:
        csv_writer = csv.writer(file)
        csv_writer.writerow([
            'Title', 'Description', 'Date', 'Source', 'Imgsrc',
            'Videosource', 'Post URL', 'Type', 'Language', 'Likecount', 'Priority'
        ])
        for post in posts:
            csv_writer.writerow([
                post["Title"],
                post["Description"],
                post["Date"],
                post["Source"],
                post["Imgsrc"],
                post["Videosource"],
                post["Post URL"],
                post["Type"],
                post["Language"],
                post["Likecount"],
                post["Priority"]
            ])
    print(f"Data saved to {filename}")


def main():
    # Your Facebook credentials.
    username = "rigayla"
    password = "NewsZenGAYregela6c"
    # Target profile to scrape (change the URL as needed if different).
    fb_profile_url = "https://web.facebook.com/zulkarnainsair"

    driver = initialize_driver(headless=False)

    # First log in at facebook.com.
    login_facebook(driver, username, password)

    # Then navigate to the target profile to scrape posts.
    posts = fetch_facebook_posts(driver, fb_profile_url, scroll_count=1)
    driver.quit()

    save_posts_to_csv(posts, 'facebook_posts.csv')


if __name__ == "__main__":
    main()
