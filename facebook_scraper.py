import requests
import csv


def fetch_public_posts(user_id, access_token):
    base_url = f'https://graph.facebook.com/v12.0/{user_id}/posts'
    params = {
        'access_token': access_token,
        'fields': 'message,created_time,id,from{name},attachments{media,type,url},likes.summary(true),comments.summary(true)',
        'limit': 100  # fetch up to 100 posts per page
    }
    all_posts = []
    url = base_url
    while url:
        response = requests.get(url, params=params)
        if response.status_code == 200:
            data = response.json()
            posts = data.get('data', [])
            all_posts.extend(posts)
            paging = data.get('paging', {})
            # Use the "next" URL for pagination if available
            url = paging.get('next', None)
            params = {}  # Subsequent calls use the next URL, which already includes parameters
        else:
            print(f"Failed to fetch posts. Error: {response.status_code} - {response.text}")
            break
    return all_posts


def save_posts_to_csv(posts, filename='facebook_posts.csv'):
    with open(filename, mode='w', newline='', encoding='utf-8') as file:
        csv_writer = csv.writer(file)
        # Write CSV header in the requested format
        csv_writer.writerow(
            ['Title', 'Description', 'Date', 'Source', 'Imgsrc', 'Videosource', 'Type', 'Language', 'Likecount',
             'Priority'])

        for post in posts:
            # Use the first line (up to 50 characters) as the title, or a default if no message exists
            message = post.get('message', '')
            title = message.split("\n")[0][:50] if message else "No Title"
            description = message if message else "No content"
            date = post.get('created_time', 'Unknown time')
            source = post.get('from', {}).get('name', 'Unknown Source')

            # Process attachments for images and videos
            attachments = post.get('attachments', {}).get('data', [])
            images = []
            videos = []
            for att in attachments:
                att_type = att.get('type')
                if att_type == 'photo':
                    image_src = att.get('media', {}).get('image', {}).get('src', '')
                    if image_src:
                        images.append(image_src)
                elif att_type == 'video':
                    video_url = att.get('url', '')
                    if video_url:
                        videos.append(video_url)

            imgsrc = ', '.join(images) if images else "null"
            videosource = ', '.join(videos) if videos else "null"

            # Set "Type" to Facebook, "Language" to Mixed (you can adjust these as needed)
            type_field = "Facebook"
            language = "Mixed"
            likecount = post.get('likes', {}).get('summary', {}).get('total_count', 0)
            priority = 0

            csv_writer.writerow(
                [title, description, date, source, imgsrc, videosource, type_field, language, likecount, priority])

    print(f"Data saved to {filename}")


# Example usage: Replace with the appropriate user ID and your access token.
user_id = 'saerzulkarnain'  # Replace with the Facebook profile ID or username
access_token = 'EAAIPrQv0XhIBO8U2k5RfEKFlB6qKenPetmdtxwz5hl44PiC1mRIaAa7mTUfrTZBUigpzDxkywZAFkNArLOpKM52AV5rZAC5WmfFgEGE4n90JfwgYXaTb6eLa9hIIx7Alftgf347nZCXQIbymrq4OeZBn0zOIG1ZCmMosMpq2T0iSkKJ3D2Mcmmu0Bovrvve2SN2JEFpZBXq85PZBLM5ti3AAz1Cv4oSvZAIHWy3x4s6WuG68hMQmXaN3bsu6zmY5sXwZDZD'  # Replace with your access token

posts = fetch_public_posts(user_id, access_token)
save_posts_to_csv(posts)
