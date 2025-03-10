import pandas as pd
import time

from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from webdriver_manager.chrome import ChromeDriverManager

# Set the main URL to the news releases page
main_url = "https://www.nasa.gov/2025-news-releases/"

# Initialize Selenium WebDriver using ChromeDriverManager
service = Service(ChromeDriverManager().install())
driver = webdriver.Chrome(service=service)

# ===============================
# STEP 1: Scrape the Main NASA News Releases Page
# ===============================
driver.get(main_url)
wait = WebDriverWait(driver, 10)
# Wait for the article cards to load; adjust the class name if necessary
wait.until(EC.presence_of_all_elements_located((By.CLASS_NAME, "hds-content-card")))

# Scroll down to load all articles (for pages using infinite scrolling)
last_height = driver.execute_script("return document.body.scrollHeight")
while True:
    driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
    time.sleep(3)  # wait for new articles to load
    new_height = driver.execute_script("return document.body.scrollHeight")
    if new_height == last_height:
        break
    last_height = new_height

# Lists to store data from the article cards
article_urls = []
article_img_urls = []

# Extract URL and image URL from each card
cards = driver.find_elements(By.CLASS_NAME, 'hds-content-card')
for card in cards:
    try:
        url = card.get_attribute('href')
    except Exception:
        url = 'N/A'
    article_urls.append(url)

    try:
        img_element = card.find_element(By.TAG_NAME, 'img')
        img_url = img_element.get_attribute('src')
    except Exception:
        img_url = 'N/A'
    article_img_urls.append(img_url)

# ===============================
# STEP 2: Visit Each Article URL for Detailed Data
# ===============================
detailed_titles = []
detailed_dates = []
detailed_descriptions = []

for url in article_urls:
    if url == 'N/A':
        detailed_titles.append('N/A')
        detailed_dates.append('N/A')
        detailed_descriptions.append('N/A')
        continue

    driver.get(url)
    time.sleep(2)  # wait for page load

    # --- Extract Title ---
    try:
        title_elem = WebDriverWait(driver, 10).until(
            EC.presence_of_element_located((By.CSS_SELECTOR, 'h1.display-48.margin-bottom-2'))
        )
        detailed_title = title_elem.text.strip()
    except Exception as e:
        print(f"Could not find title on page {url}: {e}")
        detailed_title = 'N/A'
    detailed_titles.append(detailed_title)

    # --- Extract Publication Date ---
    try:
        time_elem = WebDriverWait(driver, 10).until(
            EC.presence_of_element_located((By.CSS_SELECTOR, 'span.heading-12.text-uppercase'))
        )
        detailed_date = time_elem.text.strip()
    except Exception as e:
        print(f"Could not find publication time on page {url}: {e}")
        detailed_date = 'N/A'
    detailed_dates.append(detailed_date)

    # --- Extract Description from div.entry-content ---
    try:
        # Grab all <p> elements inside <div class="entry-content">
        desc_elems = driver.find_elements(By.CSS_SELECTOR, "div.entry-content p")
        # Concatenate them into one string (separated by newlines or spaces)
        desc_texts = [elem.text.strip() for elem in desc_elems if elem.text.strip()]
        detailed_desc = "\n".join(desc_texts)
    except Exception as e:
        print(f"Could not extract paragraphs on page {url}: {e}")
        detailed_desc = ""

    # If we got nothing from the paragraphs, try the meta description as a fallback
    if not detailed_desc:
        try:
            meta_desc = driver.find_element(By.CSS_SELECTOR, "meta[name='description']")
            detailed_desc = meta_desc.get_attribute("content").strip()
        except Exception as e:
            print(f"Could not extract meta description on page {url}: {e}")
            detailed_desc = 'N/A'

    detailed_descriptions.append(detailed_desc)

# Close the driver once scraping is complete
driver.quit()

# ===============================
# STEP 3: Create the Final CSV with the Specified Columns
# ===============================
final_df = pd.DataFrame({
    'title': detailed_titles,
    'Description': detailed_descriptions,
    'Date': detailed_dates,
    'Source': ['NASA'] * len(article_urls),
    'Imgsource': article_img_urls,
    'Type': ['News'] * len(article_urls),
    'Language': ['English'] * len(article_urls),
    'Likecount': [0] * len(article_urls),
    'Priority': [0] * len(article_urls)
})

final_df.to_csv('nasa_news_final.csv', index=False, encoding='utf-8')
print("Data has been saved to nasa_news_final.csv")
