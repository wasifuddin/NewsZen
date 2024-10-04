import pandas as pd

# Load the Excel file
file_path = 'NewsZen_AI_Mini_Dataset.xlsx'  # Replace with the actual path to your Excel file
df = pd.read_excel(file_path)

# Rename the columns as per your provided mapping
df = df.rename(columns={
    df.columns[0]: "news_heading",  # Column A
    df.columns[1]: "news_content",  # Column B
    df.columns[2]: "news_link",     # Column C
    df.columns[3]: "news_category", # Column D
    df.columns[4]: "img_link"       # Column F (skip E, which is a preview)
})

# Loop through each row and print it as a dictionary
for index, row in df.iterrows():
    row_dict = row.to_dict()  # Convert each row to a dictionary
    print(f"Row {index}: {row_dict}")
