from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from webdriver_manager.chrome import ChromeDriverManager
import pandas as pd
import time

# Initialize WebDriver with ChromeDriverManager using Service
service = Service(ChromeDriverManager().install())
driver = webdriver.Chrome(service=service)
driver.get("https://www.nasa.gov/news/all-news/")

# Wait for the page to load fully
wait = WebDriverWait(driver, 10)
wait.until(EC.presence_of_all_elements_located((By.CLASS_NAME, "hds-content-card")))

# Scroll down to load more articles if the page uses infinite scrolling
last_height = driver.execute_script("return document.body.scrollHeight")
while True:
    driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
    time.sleep(3)  # Wait to load
    new_height = driver.execute_script("return document.body.scrollHeight")
    if new_height == last_height:
        break
    last_height = new_height

# Lists to store extracted data
titles = []
urls = []
image_urls = []
times = []
tags_list = []

# Find all article elements
articles = driver.find_elements(By.CLASS_NAME, 'hds-content-card')

for article in articles:
    # Extract title
    title_element = article.find_element(By.TAG_NAME, 'h3')
    title = title_element.text if title_element else 'N/A'
    titles.append(title)

    # Extract URL
    url = article.get_attribute('href') if article else 'N/A'
    urls.append(url)

    # Extract image URL
    try:
        image_url = article.find_element(By.TAG_NAME, 'img').get_attribute('src')
    except:
        image_url = 'N/A'
    image_urls.append(image_url)

    # Extract time
    try:
        time_element = article.find_element(By.XPATH, ".//span[contains(text(), 'ago')]")
        time_text = time_element.text
    except:
        time_text = 'N/A'
    times.append(time_text)

    # Extract tags
    tags = []
    tag_elements = article.find_elements(By.CLASS_NAME, 'label')
    for tag in tag_elements:
        tags.append(tag.text)
    tags_str = ', '.join(tags) if tags else 'N/A'
    tags_list.append(tags_str)

# Close the driver
driver.quit()

# Create a DataFrame and save to CSV
df = pd.DataFrame({
    'URL': urls,
    'Image URL': image_urls,
    'Time': times,
    'Tags': tags_list
})

df.to_csv('nasa_news_dynamic.csv', index=False, encoding='utf-8')
print("Data has been saved to nasa_news_dynamic.csv")