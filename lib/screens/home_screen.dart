import 'package:flutter/material.dart';
import '../widgets/news_card.dart';
import '../data/mock_data.dart';
import '../widgets/horizontal_news_card.dart';
import '../models/news_model.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedTopic = 'All';
  final List<String> topics = ['All', 'World', 'Sports', 'Technology', 'Health', 'Space', 'Food', 'Politics', 'Automotive'];

  List<NewsModel> getFilteredNews() {
    if (selectedTopic == 'All') {
      return mockNewsData;
    }
    return mockNewsData.where((news) => news.topic == selectedTopic).toList();
  }

  
  final PageController _pageController = PageController();
  int currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Padding(
          padding: EdgeInsets.only(left: 8.0, top: 20.0),
          child: Text(
            'NewsZen',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.red),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: topics.map((topic) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedTopic = topic;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedTopic == topic ? Colors.red : Colors.white,
                          foregroundColor: selectedTopic == topic ? Colors.white : Colors.black,
                        ),
                        child: Text(topic),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 0.0),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Breaking News',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 200,
                      child: PageView.builder(
                        controller: _pageController,
                        scrollDirection: Axis.horizontal,
                        itemCount: mockNewsData.length,
                        onPageChanged: (int index) {
                          setState(() {
                            currentPage = index; 
                          });
                        },
                        itemBuilder: (context, index) {
                          final newsItem = mockNewsData[index];
                          return HorizontalNewsCard(newsItem: newsItem);
                        },
                        pageSnapping: true,
                      ),
                    ),

                    
                    const SizedBox(height: 16.0),
                    Center(
                      child: SmoothPageIndicator(
                        controller: _pageController, 
                        count: mockNewsData.length,
                        effect: ExpandingDotsEffect(
                          dotHeight: 8.0,
                          dotWidth: 8.0,
                          activeDotColor: Colors.red,
                          dotColor: Colors.grey.shade400,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16.0),
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Suggestions',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                    ),
                    ListView.builder(
                      itemCount: getFilteredNews().length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final newsItem = getFilteredNews()[index];
                        return NewsCard(newsItem: newsItem);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
