import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_zen/core/data/remote/mock_data.dart';
import 'package:news_zen/core/model/news_model.dart';
import 'package:news_zen/core/widgets/horizontal_news_card.dart';
import 'package:news_zen/core/widgets/latest_news_card.dart';
import 'package:news_zen/core/widgets/news_card.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/utils/app_assets.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {

  String selectedTopic = 'All';
  final List<String> topics = ['All', 'World'];


  List<NewsModel> getFilteredNews() {
    if (selectedTopic == 'All') {
      return mockNewsData;
    }
    return mockNewsData.where((news) => news.topic == selectedTopic).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBar(
          backgroundColor: main_background_colour,
          title: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left:0.0),
                    child: Image.asset(
                      AppAssets.image.img_med_logo,
                      width: 140,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                        Icons.notifications, color: primary_red
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      backgroundColor: main_background_colour,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0), // Adjust padding as needed
              child: Container(
                height: 45, // Custom height
                decoration: BoxDecoration(
                  color: Color(0xFFFFE3E3), // Gray background
                  borderRadius: BorderRadius.circular(15), // Rounded corners
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search',
                          border: InputBorder.none, // No visible border
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.0), // Padding within TextField
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0), // Padding for the icon
                      child: Icon(Icons.search, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(22.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Popular Tags',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontFamily: "montserrat"
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Add your onClick action here
                    },
                    child: Text(
                      'View All',
                      style: TextStyle(
                        color: Colors.black, // Customize color
                        fontSize: 14, // Customize font size
                        fontFamily: 'Montserrat', // Customize font family
                        fontWeight: FontWeight.w400, // Customize weight if needed
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Wrap(
                spacing: 8.0, // Space between each text
                runSpacing: 8.0, // Space between rows when wrapping
                children: [
                  'Science', 'Elon Musk', 'Politics', 'Weather', 'Cricket', 'Technology', 'Health', 'Business', 'Entertainment', 'Travel'
                ].map((text) {
                  return GestureDetector(
                    onTap: () {

                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200], // Background color for the text
                        borderRadius: BorderRadius.circular(8.0), // Optional: add border radius
                      ),
                      child: Text(
                        text, // Static text content
                        style: TextStyle(
                          fontSize: 12, // Customize font size
                          fontWeight: FontWeight.w500, // Customize font weight
                          fontFamily: 'Montserrat', // Customize font family
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(22.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Latest News',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontFamily: "montserrat"
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Add your onClick action here
                    },
                    child: Text(
                      'View All',
                      style: TextStyle(
                        color: Colors.black, // Customize color
                        fontSize: 14, // Customize font size
                        fontFamily: 'Montserrat', // Customize font family
                        fontWeight: FontWeight.w400, // Customize weight if needed
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                height: 200,
                child: PageView.builder(
                  //controller: _pageController,
                  scrollDirection: Axis.horizontal,
                  itemCount: mockNewsData.length,
                  onPageChanged: (int index) {

                  },
                  itemBuilder: (context, index) {
                    final newsItem = mockNewsData[index];
                    return HorizontalNewsCard(newsItem: newsItem);
                  },
                  pageSnapping: true,
                ),
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(top: 22.0,left: 22.0,right: 22.0,bottom: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Recommended',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontFamily: "montserrat"
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Add your onClick action here
                    },
                    child: Text(
                      'View All',
                      style: TextStyle(
                        color: Colors.black, // Customize color
                        fontSize: 14, // Customize font size
                        fontFamily: 'Montserrat', // Customize font family
                        fontWeight: FontWeight.w400, // Customize weight if needed
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:20,bottom:8,top:8,right:8.0),
              child: ListView.builder(
                itemCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final newsItem = getFilteredNews()[index];
                  return NewsCard(newsItem: newsItem);
                },
              ),
            ),






          ],
        ),
      ),
    );
  }
}
