import requests
from bs4 import BeautifulSoup
import csv
import os
from datetime import datetime
from pymongo import MongoClient


#title, imageurl, source, description, url, dateTime, topic

# url = 'https://bdnews24.com/'
# url = 'https://www.thedailystar.net/'
# url = 'https://mzamin.com/#gsc.tab=0'

article_data = []


#To send data to mongdb
MONGO_URI = 'mongodb+srv://demo_user:tNwYzQbHbta4j_G@newszen.eup0l.mongodb.net/?retryWrites=true&w=majority&appName=Newszen'
COllECTION_NAME = 'youtube'
DATABASE_NAME = 'mydatabase'
client = MongoClient(MONGO_URI)

database = client[DATABASE_NAME]
collection = database[COllECTION_NAME]


def fetch_article_data(url, selector, title_link_selector, description_title_selector, description_details_selector, news_source, img_source_selector, img_selector_attribute):
# def fetch_article_data(url):

    response = requests.get(url)

    # client = pymongo.MongoClient(MONGO_URI)
    # db = client[DATABASE_NAME]
    # collection = db[COllECTION_NAME]
    

    if response.status_code != 200:
        print(f"Failed to retrieve data from {url}")
        return []

    soup = BeautifulSoup(response.content, 'html.parser')
    
    # articles = soup.find_all('div', class_='col-lg-3 col-md-6 order-lg-1 order-2')

    news = soup.select(selector)
    # news = soup.find('div', class_='col-sm-4')
    # print("the news is ",news)


    for news_details in news:

            title_link = news_details.find(title_link_selector)['href']
            # title_link = news_details.find('a')['href']


            # article_details_url = url + title_link if news_source != 'mzamin' else "https://mzamin.com/"+title_link+"#gsc.tab=0"

            if title_link.startswith("http"):  # Absolute URL
                article_details_url = title_link
            else:  # Relative URL
                if news_source != 'mzamin':
                    article_details_url = url + title_link
                else:
                    article_details_url = "https://mzamin.com/" + title_link + "#gsc.tab=0"



            print("title link is ",article_details_url)

            article_details = fetch_details(article_details_url, description_title_selector, description_details_selector, news_source, img_source_selector, img_selector_attribute)


            if article_details: 
                article_data.append(article_details)

    return article_data
    
    
def fetch_details(article_url, description_title_selector, description_details_selector, news_source, img_source_selector, img_selector_attribute) :

    response = requests.get(article_url)

    news_details = []

    if response.status_code != 200 :
        print(f"failed to retrieve data from {article_url}")
        return none
    
    soup = BeautifulSoup(response.content, 'html.parser')


    # print("===="*10)

    title = soup.select_one(description_title_selector).text.strip()

    print("the title is ", title)

    topic = ""
    topic = soup.select_one('body > main > section.Deatils-wrapper.mt-4 > div > div > div.col-md-9.Dtop-30.rowresize > div.breadcrump.d-flex.align-items-center.ignore-print > ul > li:nth-child(2) > a').text if news_source == 'bdnews24' else 'National & International'
    

    # title = soup.find('div', class_ = 'd-flex live').find('h1').text.strip()
    # # print(title)

    # pic_tag = soup.select_one('div.col-sm-8 > img')
    pic_tag = soup.select_one(img_source_selector)

    imgsrc = ""

    print("picture tag is ", pic_tag)

    if pic_tag:
        # imgsrc = "https://mzamin.com/"+pic_tag[img_selector_attribute] if news_source == 'mzamin' else img_source_selector[img_selector_attribute]
        
        imgsrc = pic_tag[img_selector_attribute] if news_source != 'mzamin' else "https://mzamin.com/" + pic_tag[img_selector_attribute]
    else :
        imgsrc = 'https://dummyimage.com/300x300/fff/aaa'
        print("No imgsrc")

    # # for description adding the text of all p tags

    # print_section = soup.find('div', class_='details-brief dNewsDesc print-section')
    print_section = soup.select(description_details_selector)


    full_description = ""
    if print_section :
        # description_section = print_section.find_all('p')

        for descriptions in print_section:
            # print(descriptions.get_text(strip = True))
            descriptions = descriptions.text.strip()
            full_description = full_description + "\n" + descriptions
    else :
        full_description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
        print("No description found")

    print(full_description)


    #adding date

    now = datetime.now()
    publish_time = now.strftime("%d-%m-%y")

    # pub_section = soup.select('body > div.container > article > div > div.col-sm-8')
    # # pub_section = soup.find('div', class_ = 'pub-up print-section d-lg-flex')

    # for pubs in pub_section:
    # #     date_times = pub_section.find_all('span')
    # #     publish_time = date_times[1].get_text(strip = True)
    #     # print("publish time is: ", pubs.text)
    # print(formatted_date)


        

    # # print("===="*10)

    news_details = {
        'title' : title,
        'imageurl' : imgsrc,
        'source' : news_source,
        'description' : full_description,
        'url' : article_url,
        'dateTime' : publish_time,
        'topic' : topic
    }

    return news_details




if __name__ == "__main__" :
    # fetch_article_data(url, 'div.card-image position-relative radius-16 overflow-hidden', 'a')
    # fetch_article_data(url, 'div.TopLeadList', 'a')

    # prothom alo has some issues

    # final_data_prothomalo = fetch_article_data('https://www.prothomalo.com/bangladesh/crime', 'div.Ib8Zz > div', 'a', 'div.story-head.NKo24 > div.story-title-info.BG103 > div > h1','','','','')

    final_data_bdnews24 = fetch_article_data('https://bdnews24.com/', 'div.TopLeadList', 'a', 'div.details-title.print-section > div > h1', '#contentDetails > p', 'bdnews24', 'div.details-img > picture > img','src')


    # final_data = fetch_article_data('https://mzamin.com/#gsc.tab=0', 'div.row.gx-5.mt-3 > div.col-sm-4', 'a','h1.lh-base.fs-1', 'div.col-sm-10.offset-sm-1.fs-5.lh-base.mt-4.mb-5')
    # final_data_mzamin = fetch_article_data('https://mzamin.com/category.php?cat=4#gsc.tab=0', 'div.col-sm-8.col-7 > h4', 'a','h1.lh-base.fs-1', 'div.col-sm-10.offset-sm-1.fs-5.lh-base.mt-4.mb-5', 'mzamin')

    final_data_mzamin = fetch_article_data('https://mzamin.com/category.php?cat=5#gsc.tab=0', 'div.col-sm-8.col-7 > h4', 'a','h1.lh-base.fs-1', 'div.col-sm-10.offset-sm-1.fs-5.lh-base.mt-4.mb-5', 'mzamin','body > div.container > article > div > div.col-sm-8 > img','data-src')

    

    final_data_dailystar_general = fetch_article_data('https://www.thedailystar.net/', 'div.card-content.card-content.pb-20.pr-20 > h4', 'a','article > h1', 'article > div.pb-20.clearfix > p', 'The Daily Star','div.section-media.sm-float-none.position-relative.small-full-extended.mb-30.no-margin-lr > span > picture > img','data-srcset')
    
    final_data_ittefaq_general = fetch_article_data('https://www.ittefaq.com.bd/', 'div.info > div.title_holder > div > h2', 'a','div.content_detail_outer > div.content_detail_inner > div.content_detail_left > div > div > div:nth-child(1) > div > h1', 'div.content_detail_content_outer > div > article > div > p', 'The Daily Ittefaq','div.row.detail_holder > div > div > div.detail_inner > div.featured_image > span > a', 'src')
    
    # # international newspapers

    final_data_cnn_general = fetch_article_data('https://edition.cnn.com/', 'div.container_lead-package__cards-wrapper > div > div > div:nth-child(1)', 'a','#maincontent', 'div.article__content-container > div.article__content > p', 'CNN','div.image__lede.article__lede-wrapper > div > div.image__container > picture > img', 'src')
    
    # #bbc has some issues, maybe restriction from the website directly
    # # final_data_bbc_general = fetch_article_data('https://www.bbc.com/news', 'div.sc-93223220-0.sc-b38350e4-2.cmkdDu.QUMNJ > div.sc-b38350e4-3.gugNoq > div > div', 'a','#maincontent', 'div.article__content-container > div.article__content > p', 'CNN','div.image__lede.article__lede-wrapper > div > div.image__container > picture > img', 'src')
    
    final_data_alzazeera_general = fetch_article_data('https://www.aljazeera.com/', 'article > div.gc__content > div.gc__header-wrap > h3', 'a','#main-content-area > header > h1', '#main-content-area > div.wysiwyg.wysiwyg--all-content.css-ibbk12 > p', 'Al Zazeera','#main-content-area > img', 'src')

    # for data in article_data:
    #     print(data)

    for news in article_data:
        print(news)
        collection.insert_one(news)

    print("News data updated successfully")

    # for data in final_data_dailystar_general:
    #     print(data)

    # for data in final_data_ittefaq_general:
    #     print(data)

    # for data in final_data_cnn_general:
    #     print(data)

    # for data in final_data_bbc_general:
    #     print(data)

    # for data in final_data_alzazeera_general:
    #     print(data)

    


# #inner-wrap > div.off-canvas-content > main > div.main > div.block-content.content > div.panel-pane.pane-home-2024-v4.no-title.block > div > div > div.row.mt-10.smt-0 > div:nth-child(2) > div:nth-child(1) > div.card-content.card-content.pb-20.pr-20 > h4
# #node-3773406 > h1
# #node-3773406 > div.pb-20.clearfix > p

#node-3773521 > h1

#node-3773521



#ittefaq

#div.info > div.title_holder > div > h2 > a
#div.content_detail_outer > div.content_detail_inner > div.content_detail_left > div.row > div.col_in > h1
#widget_322 > div > div > div > div.content_detail_outer > div.content_detail_inner > div.content_detail_left > div > div > div:nth-child(1) > div > h1

# #adf-overlay
#widget_322 > div > div > div > div.content_detail_outer > div.content_detail_inner > div.content_detail_left > div > div > div.row.detail_holder > div > div > div.detail_inner > div.featured_image > span > a


# div.content_detail_outer > div.content_detail_inner > div.content_detail_left > div > div > div.row.detail_holder > div > div > div.detail_inner > div.featured_image > span > a

#widget_322 > div > div > div > div.content_detail_outer > div.content_detail_inner > div.content_detail_left > div > div > div.row.detail_holder > div > div > div.detail_inner > div.content_detail_content_outer > div > article > div > p




#cnn

#body > div.layout__content-wrapper.layout-homepage__content-wrapper > section.layout__wrapper.layout-homepage__wrapper > section > div > section > div > div > div > div.zone.zone--t-light.zone-2-observer > div > div.zone__items.layout--wide-left-balanced-2 > div:nth-child(2) > div > div.stack__items > div:nth-child(1) div.container_lead-package__cards-wrapper > div > div > div:nth-child(1) > a:nth-child(2)
# #maincontent


# body > div.layout__content-wrapper.layout-with-rail__content-wrapper > section.layout__wrapper.layout-with-rail__wrapper > section.layout__main-wrapper.layout-with-rail__main-wrapper > section.layout__main.layout-with-rail__main > article > section > main > div.image__lede.article__lede-wrapper > div > div.image__container > picture > img
#body > div.layout__content-wrapper.layout-with-rail__content-wrapper > section.layout__wrapper.layout-with-rail__wrapper > section.layout__main-wrapper.layout-with-rail__main-wrapper > section.layout__main.layout-with-rail__main > article > section > main > div.article__content-container > div.article__content > p:nth-child(2) 


#bbc

#main-content > article > section:nth-child(3) > div > div.sc-b38350e4-1.dlepEy > div.sc-93223220-0.sc-b38350e4-2.cmkdDu.QUMNJ > div.sc-b38350e4-3.gugNoq > div > div > a

#main-content > article > section:nth-child(3) > div > div.sc-b38350e4-1.dlepEy > div.sc-93223220-0.sc-b38350e4-2.cmkdDu.QUMNJ > div:nth-child(2) > div > a


# al zazeera

# #news-feed-container > article > div.gc__content > div.gc__header-wrap > h3 > a

# #featured-news-container > div > div.hp-featured-second-stories > ul > li:nth-child(1) > article.article-card.article-card-home-page.article-card--medium.article-card--type-post.u-clickable-card.article-card--with-image > div.article-card__content-wrap.article-card__content-wrap--start-image > a
# #featured-news-container > div > div.hp-featured-second-stories > ul > li:nth-child(2) > article > div.article-card__content-wrap.article-card__content-wrap--end-image > a

# #main-content-area > header > h1

# #main-content-area > div.wysiwyg.wysiwyg--all-content.css-ibbk12 > p

# #main-content-area > figure > div > img