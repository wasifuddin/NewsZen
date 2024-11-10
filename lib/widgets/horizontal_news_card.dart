import 'package:flutter/material.dart';
import '../models/news_model.dart';
import '../screens/detail_screen.dart'; 
import 'package:intl/intl.dart'; 

class HorizontalNewsCard extends StatelessWidget {
  final NewsModel newsItem;

  const HorizontalNewsCard({required this.newsItem, super.key});

  @override
  Widget build(BuildContext context) {
    
    String formattedDate = DateFormat('MMM dd, yyyy').format(newsItem.dateTime);

    return GestureDetector(
      onTap: () {
        
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetailPage(newsItem: newsItem),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4.0), 
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), 
          image: DecorationImage(
            image: NetworkImage(newsItem.imageurl), 
            fit: BoxFit.cover, 
          ),
        ),
        child: Stack(
          children: [
            
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12), 
                  gradient: const LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black87, 
                      Colors.transparent, 
                    ],
                  ),
                ),
              ),
            ),

            
            Positioned(
              top: 16,
              left: 18,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16), 
                ),
                child: Text(
                  newsItem.topic, 
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            
            Positioned(
              bottom: 16, 
              left: 18, 
              right: 10, 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, 
                children: [
                  
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0), 
                    child: Text(
                      '${newsItem.source} | $formattedDate', 
                      style: const TextStyle(
                        color: Colors.white70, 
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                      textAlign: TextAlign.left,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis, 
                    ),
                  ),
                  
                  Text(
                    newsItem.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left, 
                    maxLines: 2, 
                    overflow: TextOverflow.ellipsis, 
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
