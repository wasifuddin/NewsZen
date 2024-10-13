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
    
    articles = soup.find_all('div', class_='SubCat-wrapper')
    article_data = []

    for article in articles:

        title_link = article.find('a')['href']

        title_tag = article.find('h5')
        publish_time = article.find('span', class_ = 'publish-time') # it is class_, not class
        publish_time = publish_time.get_text(strip = True) if publish_time else 'No publish time'

        catagory_arch = article.find('span', class_ = 'catagory-arch') # it is class_, not class
        catagory_arch = catagory_arch.get_text(strip = True) if catagory_arch else 'No catagory'

        if title_tag:
            title = title_tag.get_text(strip=True)
        

            article_data.append({
                'title': title,
                'link' : title_link,
                'catagory' : catagory_arch,
                'publish_time' : publish_time
            })

    return article_data

def save_to_csv(articles):
    directory = 'websites'
    filename = 'bdnews24.csv'
    
    os.makedirs(directory, exist_ok=True)

    file_path = os.path.join(directory, filename)
    
    with open(file_path, mode='w', newline='', encoding='utf-8') as file:
        headers = ['title', 'link', 'catagory','publish_time']
        writer = csv.DictWriter(file, fieldnames=headers)
        writer.writeheader()
        writer.writerows(articles)


if __name__ == "__main__":
    articles = fetch_article_data(url)

    save_to_csv(articles)

    for article in articles:
        print(f"Title: {article['title']}")
        print(f"Link: {url + article['link']}")  
        print(f"Catagory: {url + article['catagory']}")  
        print(f"Publication_time: {article['publish_time']}")
        print("-" * 40)