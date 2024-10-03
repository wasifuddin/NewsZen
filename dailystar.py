import requests
from bs4 import BeautifulSoup
import csv

url = 'https://www.thedailystar.net/'

def fetch_article_data(url):
    response = requests.get(url)
    

    if response.status_code != 200:
        print(f"Failed to retrieve data from {url}")
        return []

    soup = BeautifulSoup(response.content, 'html.parser')
    
    articles = soup.find_all('div', class_='card-content')
    article_data = []

    for article in articles:
        title_tag = article.find('h3', class_='title')
        if title_tag:
            title = title_tag.get_text(strip=True)
            link = title_tag.find('a')['href']  # to fetch href attribute

            # fetching the introduction paragraph
            intro_tag = article.find('p', class_='lc-3 intro')
            intro = intro_tag.get_text(strip=True) if intro_tag else 'No introduction found'

            # append data
            article_data.append({
                'title': title,
                'link': link,
                'intro': intro
            })

    return article_data

def save_to_csv(data, filename='articles.csv'):
    headers = ['Title', 'Link', 'Introduction']
    
    with open(filename, mode='w', newline='', encoding='utf-8') as file:
        writer = csv.DictWriter(file, fieldnames=headers)
        
        writer.writeheader()
        
        for article in data:
            writer.writerow({
                'Title': article['title'],
                'Link': article['link'],
                'Introduction': article['intro']
            })

if __name__ == "__main__":
    articles = fetch_article_data(url)

    save_to_csv(articles)

    for article in articles:
        print(f"Title: {article['title']}")
        print(f"Link: {url + article['link']}")  
        print(f"Introduction: {article['intro']}")
        print("-" * 40)
