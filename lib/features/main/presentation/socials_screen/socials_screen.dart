import 'package:flutter/material.dart';
import 'package:news_zen/core/data/remote/mock_social_data.dart';
import 'package:news_zen/core/model/social_model.dart';
import 'package:news_zen/core/theme/colors.dart';
import 'package:news_zen/core/utils/app_assets.dart';
import 'package:news_zen/core/widgets/social_post_card.dart';
import 'package:news_zen/features/main/presentation/notifications_screen/notifications_screen.dart';

class SocialsScreen extends StatefulWidget {
  const SocialsScreen({super.key});

  @override
  State<SocialsScreen> createState() => _SocialsScreenState();
}

class _SocialsScreenState extends State<SocialsScreen> {
  String selectedPlatform = 'All'; // Default selected platform

  List<SocialModel> getFilteredPosts() {
    if (selectedPlatform == 'All') {
      return mockSocialData; // Show all posts
    }
    return mockSocialData.where((post) => post.platform == selectedPlatform).toList();
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
                      showNotificationScreen(context);
                    },
                    icon: Icon(Icons.notifications, color: primary_red),
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
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSocialIcon('assets/icons/globe.png', 'All'), // Globe icon
                  _buildSocialIcon('assets/icons/facebook.png', 'Facebook'),
                  _buildSocialIcon('assets/icons/twitter.png', 'Twitter'),
                  _buildSocialIcon('assets/icons/youtube.png', 'YouTube'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Filtered Posts
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: getFilteredPosts().length,
                itemBuilder: (context, index) {
                  final post = getFilteredPosts()[index];
                  return SocialPostCard(post: post);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build social media icons
  Widget _buildSocialIcon(String iconPath, String platform) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPlatform = platform; // Update selected platform
        });
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: selectedPlatform == platform
              ? Border.all(
            color: primary_red, // Red border for selected icon
            width: 2,
          )
              : null, // No border for unselected icons
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Image.asset(
            iconPath,
            width: 30,
            height: 30,
          ),
        ),
      ),
    );
  }
}