import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_zen/core/theme/colors.dart';
import 'package:news_zen/core/utils/app_assets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 0),
              child: Container(
                color: main_background_colour,
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: CategoryTab (title: "All news", isSelected: true),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: CategoryTab(title: "Business"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: CategoryTab(title: "Politics"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: CategoryTab(title: "Tech"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: CategoryTab(title: "Health"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: CategoryTab(title: "Science"),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'কর্মস্থলে শাটডাউনের সকল কার্যসূচি প্রত্যাহার...',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'JAMUNA TV | 04 সেপ্টেম্বর 2024, 01:45',
                    style: TextStyle(color: Colors.red),
                  ),
                  SizedBox(height: 8),
                  Center(
                    child: Image.asset(
                    AppAssets.image.img_news,
                    fit: BoxFit.cover),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Popular Redactions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Container(
              height: 80,
              child: Padding(
                padding: const EdgeInsets.only(left: 09.0),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    NewsSourceCircle(imagePath: AppAssets.image.img_cnn_logo),
                    NewsSourceCircle(imagePath: AppAssets.image.img_ittefaq_logo),
                    NewsSourceCircle(imagePath: AppAssets.image.img_independent_logo),
                    NewsSourceCircle(imagePath: AppAssets.image.img_kaler_kontho_logo),
                    NewsSourceCircle(imagePath: AppAssets.image.img_bbc_logo),
                    NewsSourceCircle(imagePath: AppAssets.image.img_prothom_alo_logo),
                    NewsSourceCircle(imagePath: AppAssets.image.img_cnn_logo),
                    NewsSourceCircle(imagePath: AppAssets.image.img_independent_logo),
                  ],
                ),
              ),
            ),

            // Browse By section
            Padding(
              padding: const EdgeInsets.only(left: 16.0 , bottom: 8),
              child: Text(
                'Browse By',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Container(
              color: main_background_colour,
              height: 40,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CategoryTab(title: "Trending", isSelected: true),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CategoryTab(title: "Recommended"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CategoryTab(title: "Newest"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CategoryTab(title: "Noteworthy"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CategoryTab(title: "Interacting"),
                    ),
                  ],
                ),
              ),
            ),
            NewsContainer(),
            NewsContainer(),
            NewsContainer(),


          ],

        ),
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

class NewsContainer extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return Container(
      color: main_background_colour,
      height: 90,
      child: Row(
        children:
        [
          SizedBox(
            width: 270,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left:16.0),
                  child: Text(
                   'ডায়মন্ড ওয়ার্ল্ডের এমডি দিলীপ কুমার আগরওয়ালা গ্রেপ্তার',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(right: 65.0),
                  child: Text(
                    'JAMUNA TV | 04 সেপ্টেম্বর 2024',
                    style: TextStyle(color: Colors.red,
                    fontSize: 12),

                  ),
                ),
              ],
            ),
          ),
          Image.asset(
            AppAssets.image.img_dilip_kumar,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }

}
