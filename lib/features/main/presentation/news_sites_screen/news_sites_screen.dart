import 'package:flutter/material.dart';
import 'package:news_zen/core/data/remote/mock_social_data.dart';
import 'package:news_zen/core/model/social_model.dart';
import 'package:news_zen/core/theme/colors.dart';
import 'package:news_zen/core/utils/app_assets.dart';
import 'package:news_zen/core/widgets/social_post_card.dart';

import '../../../../core/widgets/news_card.dart';

class NewsSitesScreen extends StatefulWidget {
  const NewsSitesScreen({super.key});

  @override
  State<NewsSitesScreen> createState() => _NewsSitesScreenState();
}

class _NewsSitesScreenState extends State<NewsSitesScreen> {
  String selectedPlatform = 'All'; // Default selected platform

  List<SocialModel> getFilteredPosts() {
    if (selectedPlatform == 'All') {
      return mockSocialData; // Show all posts
    }
    return mockSocialData.where((post) => post.platform == selectedPlatform)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: main_background_colour,
          title: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Image.asset(
                      AppAssets.image.img_med_logo, // Your logo asset
                      width: 140,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context); // Go back to the previous screen
                    },
                    icon: Icon(Icons.close, color: primary_red),
                  ),
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
            const SizedBox(height: 20),
            // Social Media Icons
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: SingleChildScrollView

                (scrollDirection: Axis.horizontal,child:Row(
                children: [
                  NewsSourceCircle(imagePath: AppAssets.image.img_bbc_logo),
                  NewsSourceCircle(imagePath: AppAssets.image.img_cnn_logo),
                  NewsSourceCircle(imagePath: AppAssets.image.img_aljazeera_logo),
                  NewsSourceCircle(imagePath: AppAssets.image.img_prothom_alo_logo),
                  NewsSourceCircle(imagePath: AppAssets.image.img_daily_star_logo),
                  NewsSourceCircle(imagePath: AppAssets.image.img_bdnews24_logo),
                  NewsSourceCircle(imagePath: AppAssets.image.img_ittefaq_logo),
                  NewsSourceCircle(imagePath: AppAssets.image.img_mzamin_logo),
                ],
              )),
            ),
            const SizedBox(height: 20),
            // Filtered Posts

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
        //color: Colors.red,
        decoration: BoxDecoration(
          color: Colors.white, // Set the fill color for the CircleAvatar
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.2), // Shadow color
              spreadRadius: 3,
              blurRadius: 5, // Controls the softness of the shadow
              offset: Offset(0, 3), // Controls the position of the shadow
            ),
          ],
        ),
        child: ClipOval(
          // Directly sets the image
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover, // Ensures the image fills the CircleAvatar
            width: 60, // Matches the diameter
            height: 60,
          ),
        ),

      ),
    );
  }
}