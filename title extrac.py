import pandas as pd
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from webdriver_manager.chrome import ChromeDriverManager
import time

# Read the CSV file to get the URLs
df = pd.read_csv('nasa_news_dynamic.csv')

# Initialize Selenium WebDriver with ChromeDriverManager
service = Service(ChromeDriverManager().install())
driver = webdriver.Chrome(service=service)

# Lists to store the extracted data
extracted_titles = []
extracted_times = []

for url in df['URL']:
    # Visit each article URL
    driver.get(url)
    time.sleep(2)  # Wait for the page to load fully

    # Extract the title from <h1> element with specific class
    try:
        title_element = WebDriverWait(driver, 10).until(
            EC.presence_of_element_located((By.CSS_SELECTOR, 'h1.display-48.margin-bottom-2'))
        )
        title = title_element.text
    except Exception as e:
        print(f"Could not find title on page {url}: {e}")
        title = 'N/A'
    extracted_titles.append(title)

    # Extract the publication time from <span> element with specific class
    try:
        time_element = WebDriverWait(driver, 10).until(
            EC.presence_of_element_located((By.CSS_SELECTOR, 'span.heading-12.text-uppercase'))
        )
        publication_time = time_element.text
    except Exception as e:
        print(f"Could not find publication time on page {url}: {e}")
        publication_time = 'N/A'
    extracted_times.append(publication_time)

# Close the driver after extraction
driver.quit()

# Add the extracted data to the original DataFrame
df['Extracted Title'] = extracted_titles
df['Time'] = extracted_times

# Save the updated DataFrame to a new CSV file
df.to_csv('nasa_news_updated.csv', index=False, encoding='utf-8')
print("Data has been saved to nasa_news_updated.csv")
