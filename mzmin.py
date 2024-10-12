import requests
from bs4 import BeautifulSoup
import csv
import os

url = 'https://mzamin.com/category.php?cat=4'

def fetch_article_data(url):
    response = requests.get(url)
    

    if response.status_code != 200:
        print(f"Failed to retrieve data from {url}")
        return []

    soup = BeautifulSoup(response.content, 'html.parser')
    
    articles = soup.find_all('div', class_='col-sm-8 col-7')
    article_data = []

    for article in articles:
        title_tag = article.find('h4')

        if title_tag:
            title = title_tag.get_text(strip=True)
            link = title_tag.find('a')['href']  # to fetch href attribute

            # fetching the intro
            intro_tag = article.find('p', class_='text-black-50')
            intro = intro_tag.get_text(strip=True) if intro_tag else 'No introduction found'

            article_data.append({
                'title': title,
                'link': link,
                'date': intro
            })

    return article_data

def save_to_csv(articles):
    directory = 'websites'
    filename = 'mzamin.csv'
    
    os.makedirs(directory, exist_ok=True)

    file_path = os.path.join(directory, filename)
    
    with open(file_path, mode='w', newline='', encoding='utf-8') as file:
        headers = ['title', 'link', 'date']
        writer = csv.DictWriter(file, fieldnames=headers)
        writer.writeheader()
        writer.writerows(articles)


if __name__ == "__main__":
    articles = fetch_article_data(url)

    save_to_csv(articles)

    for article in articles:
        print(f"Title: {article['title']}")
        print(f"Link: {url + article['link']}")  
        print(f"Introduction: {article['date']}")
        print("-" * 40)