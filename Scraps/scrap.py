from bs4 import BeautifulSoup
from requests_html import HTMLSession

session = HTMLSession()

url = 'https://www.thedailystar.net/'


r = session.get(url)

r.html.render(sleep = 1, scrolldown = 0)

# Function to extract the title and data from a single tag
def extract_article_data(tag):
    title_tag = tag.find('href')
    title = title_tag.get_text(strip=True) if title_tag else 'No title found'

    # data_tag = tag.find('data')  
    # data = data_tag.get_text(strip=True) if data_tag else 'No data found'

    return title


def process_document(document):
    soup = BeautifulSoup(document, 'html.parser')
    
    articles = soup.find_all('article')  
    article_data = []

    
    for article in articles:
        title = extract_article_data(article)
        article_data.append({'links': title})
    
    return article_data


if __name__ == "__main__":

    extracted_data = process_document(r)

    
    for article in extracted_data:
        print(f"Title: {article['links']}")
        # print(f"Data: {article['data']}")
        print("-" * 40)
