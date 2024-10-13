import requests
from bs4 import BeautifulSoup
import csv
import os

url = 'https://thefinancialexpress.com.bd/'

def fetch_article_data(url):
    response = requests.get(url)
    
    if response.status_code != 200:
        print(f"Failed to retrieve data from {url}")
        return []

    soup = BeautifulSoup(response.content, 'html.parser')
    
    articles = soup.find_all('article', class_='grid xl:grid-cols-2 gap-x-4 mb-4 last:mb-0')
    article_data = []

    for article in articles:
        h3_tag = article.find('h3')
        
        if h3_tag:
            second_a_tag = h3_tag.find('a')
            title_link = second_a_tag['href'] if second_a_tag else 'No link found'
        else:
            title_link = 'No link found'

        title_tag = article.find('p')
        if title_tag:
            title = title_tag.get_text(strip=True)
        else:
            title = 'No title found'

        article_data.append({
            'title': title,
            'link': title_link
        })

    return article_data

def save_to_csv(articles):
    directory = 'websites'
    filename = 'financialexpressbd.csv'
    
    os.makedirs(directory, exist_ok=True)

    file_path = os.path.join(directory, filename)
    
    with open(file_path, mode='w', newline='', encoding='utf-8') as file:
        headers = ['title', 'link']
        writer = csv.DictWriter(file, fieldnames=headers)
        writer.writeheader()
        writer.writerows(articles)

if __name__ == "__main__":
    articles = fetch_article_data(url)

    save_to_csv(articles)

    for article in articles:
        print(f"Title: {article['title']}")
        print(f"Link: {url.rstrip('/') + article['link']}")  
        print("-" * 40)



