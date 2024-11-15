import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_zen/core/data/remote/mock_data.dart';
import 'package:news_zen/core/model/news_model.dart';
import 'package:news_zen/core/theme/colors.dart';
import 'package:news_zen/core/utils/app_assets.dart';
import 'package:news_zen/core/widgets/horizontal_news_card.dart';
import 'package:news_zen/core/widgets/news_card.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
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
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: topics.map((topic) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            selectedTopic = topic;
                          });
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: selectedTopic == topic ? Colors.red : Colors.black,
                          padding: EdgeInsets.zero, // Removes padding for minimal look
                        ),
                        child: Text(
                          topic,
                          style: TextStyle(
                            fontSize: 12, // Set font size
                            fontWeight: FontWeight.bold, // Adjust font weight if needed
                            fontFamily: 'Montserrat', // Replace with desired font family
                          ),
                        ),
                      ),
                      if (selectedTopic == topic)
                        Container(
                          margin: const EdgeInsets.only(top: 4.0),
                          height: 2,
                          width: 20,
                          color: Colors.red, // Color of the underline
                        ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child:  Column(
                children: [
                  SizedBox(
                    height: 20,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
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
                  //suggestions
                  const SizedBox(height: 30.0),
                  const Padding(
                    padding: EdgeInsets.only(left: 25.0, right: 8.0, bottom: 8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Browse By',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontFamily: "montserrat"
                        ),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: topics.map((topic) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    selectedTopic = topic;
                                  });
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: selectedTopic == topic ? Colors.red : Colors.black,
                                  padding: EdgeInsets.zero, // Removes padding for minimal look
                                ),
                                child: Text(
                                  topic,
                                  style: TextStyle(
                                    fontSize: 12, // Set font size
                                    fontWeight: FontWeight.bold, // Adjust font weight if needed
                                    fontFamily: 'Montserrat', // Replace with desired font family
                                  ),
                                ),
                              ),
                              if (selectedTopic == topic)
                                Container(
                                  margin: const EdgeInsets.only(top: 4.0),
                                  height: 2,
                                  width: 20,
                                  color: Colors.red, // Color of the underline
                                ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:20,bottom:8,top:8,right:8.0),
                    child: ListView.builder(
                      itemCount: getFilteredNews().length,
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
          ),
        ],
      ),
    );
  }
}

class NewsSourceCircle extends StatelessWidget{
  final String imagePath;

  NewsSourceCircle({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(

        decoration: BoxDecoration(
          color: Colors.grey[200], // Set the fill color for the CircleAvatar
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), // Shadow color
              spreadRadius: 1,
              blurRadius: 5, // Controls the softness of the shadow
              offset: Offset(0, 3), // Controls the position of the shadow
            ),
          ],
        ),
        child: CircleAvatar(
          radius: 25,
          foregroundImage: AssetImage(imagePath),
          backgroundColor: Colors.transparent, // Keeps the CircleAvatar background transparent
        ),
      ),
    );


  }


}

class CategoryTab extends StatelessWidget {

  final String title;
  final bool isSelected;

  CategoryTab({required this.title, this.isSelected = false});
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontFamily: 'Montserrat',
      ),
    );
  }

}


