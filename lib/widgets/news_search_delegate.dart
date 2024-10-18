import 'package:flutter/material.dart';
import '../models/news_model.dart';
import '../screens/detail_screen.dart'; // Assuming you have a details page for news

class NewsSearchDelegate extends SearchDelegate {
  final List<NewsModel> allNews;
  final double padding;
  final EdgeInsetsGeometry iconPadding;
  final double iconTouchSize;

  NewsSearchDelegate(
      this.allNews, {
        this.padding = 0.0,
        this.iconPadding = const EdgeInsets.all(0.0),
        this.iconTouchSize = 80.0,
      });

  @override
  TextStyle? get searchFieldStyle => TextStyle(
    fontSize: 18, // Change this value to set the text size
    color: Colors.black, // You can also change the text color if needed
  );

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.only(top: 0), // Custom padding for the action (clear) button
        child: GestureDetector(
          onTap: () {
            query = ''; // Clear the search query
          },
          child: Container(
            width: iconTouchSize, // Expand the touch area
            height: iconTouchSize, // Expand the touch area
            alignment: Alignment.center, // Center the icon
            child: Icon(Icons.clear, color: Colors.red), // Clear button
          ),
        ),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0), // Custom padding for the leading (back) button
      child: GestureDetector(
        onTap: () {
          close(context, null); // Close the search bar
        },
        child: Container(
          width: iconTouchSize, // Expand the touch area
          height: iconTouchSize, // Expand the touch area
          alignment: Alignment.center, // Center the icon
          child: Icon(Icons.arrow_back, color: Colors.red), // Back button
        ),
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Filter news based on the search query
    List<NewsModel> filteredNews = allNews.where((news) {
      return news.title.toLowerCase().contains(query.toLowerCase()) ||
          news.description.toLowerCase().contains(query.toLowerCase());
    }).toList();

    // Show a message if no results found
    if (filteredNews.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0), // Add top padding to bring down the content
          child: Text(
            "No results found",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
        ),
      );
    }

    // Display search results
    return Padding(
      padding: const EdgeInsets.only(top: 0.0), // Add top padding to bring down the list
      child: Container(
        color: Colors.white, // Set background color to white
        child: ListView.builder(
          itemCount: filteredNews.length,
          itemBuilder: (context, index) {
            final newsItem = filteredNews[index];
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: padding),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0), // Add margins around the card
                child: Card(
                  color: Colors.white, // Change the background color of the card
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: ListTile(
                    title: Text(
                      newsItem.title,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        newsItem.description,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    onTap: () {
                      // Navigate to the news detail screen when a result is tapped
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewsDetailPage(newsItem: newsItem), // News detail page
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Provide suggestions as the user types
    List<NewsModel> suggestions = allNews.where((news) {
      return news.title.toLowerCase().contains(query.toLowerCase()) ||
          news.description.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return Padding(
      padding: const EdgeInsets.only(top: 0.0), // Add top padding to bring down the suggestions list
      child: Container(
        color: Colors.white, // Set background color to white
        child: ListView.builder(
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            final newsItem = suggestions[index];
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: padding),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0), // Add margins around the card
                child: Card(
                  color: Colors.white, // Change the background color of the card
                  child: ListTile(
                    title: Text(
                      newsItem.title,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    onTap: () {
                      query = newsItem.title; // Update search query with selected suggestion
                      showResults(context); // Show results based on the suggestion
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
