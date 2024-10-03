import requests
from bs4 import BeautifulSoup
import csv
import os

url = 'https://bdnews24.com/archive'

def fetch_article_data(url):
    response = requests.get(url)
    

    if response.status_code != 200:
        print(f"Failed to retrieve data from {url}")
        return []

    soup = BeautifulSoup(response.content, 'html.parser')
    
    articles = soup.find_all('div', class_='col-md-8 col-8')
    article_data = []

    for article in articles:
        title_tag = article.find('h5', class_='')
        if title_tag:
            title = title_tag.get_text(strip=True)

            article_data.append({
                'title': title,
            })

    return article_data

def save_to_csv(articles):
    directory = 'websites'
    filename = 'bdnews24.csv'
    
    os.makedirs(directory, exist_ok=True)

    file_path = os.path.join(directory, filename)
    
    with open(file_path, mode='w', newline='', encoding='utf-8') as file:
        headers = ['title']
        writer = csv.DictWriter(file, fieldnames=headers)
        writer.writeheader()
        writer.writerows(articles)


if __name__ == "__main__":
    articles = fetch_article_data(url)

    save_to_csv(articles)

    for article in articles:
        print(f"Title: {article['title']}")
        # print(f"Link: {url + article['link']}")  
        # print(f"Introduction: {article['intro']}")
        print("-" * 40)