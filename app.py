import streamlit as st
from qdrant_query import predict

# st.set_page_config(layout="wide")

st.markdown(
    """
    <style>
    .chatbox {
        height: 20px;
        width: 150px;
        font-size: 20px;
        overflow: auto;
    }
    .container {
        display: flex;
        justify-content: space-between;
        width: 100%;
        gap: 10px;
    }
    .center-title {
        text-align: center;
    }
    </style>
    """,
    unsafe_allow_html=True
)

# Centered title
st.markdown("<h1 class='center-title'>NewsZen</h1>", unsafe_allow_html=True)
st.image("./assets/newszen.png", width=150)
query = st.text_input("Enter your query:", key="query_input")
submit_button = st.button("Submit")

# Only run the prediction when submit_button is clicked and query is not empty
if submit_button:
    if not query:
        st.error("Please enter a query.")
    else:
        reply, payload = predict(query=query, stream=False)
        st.write(f"NewsZen AI Assist: {reply}")
        st.markdown(f"###### {payload['news_heading']}")
        st.image(payload['img_link'], width=200)
        st.markdown(f"[Read more here]({payload['news_link']})")


