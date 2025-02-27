import 'package:flutter/material.dart';
import 'package:news_zen/core/theme/colors.dart';
import 'package:news_zen/core/utils/app_assets.dart';
import 'package:news_zen/features/main/presentation/edit_profile_screen/edit_profile_screen.dart';
import 'package:news_zen/features/main/presentation/saved_screen/saved_screen.dart';
import 'package:news_zen/features/main/presentation/preferred_tags_screen/preferred_tags_screen.dart';
import 'package:news_zen/features/main/presentation/notifications_screen/notifications_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isTablet = screenWidth > 600;

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
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              // Profile Picture
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Image.asset(
                    AppAssets.image.img_user_profile, // Profile image asset
                    width: 100, // Adjust size for profile picture
                    height: 100,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // User Name
              Text(
                "Rihila Sumayya", // Static name for the profile
                style: TextStyle(
                  color: Colors.black.withOpacity(1.00),
                  fontSize: 24,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              // User Email
              Text(
                "rihila@iut-dhaka.edu", // Static email
                style: TextStyle(
                  color: Colors.black.withOpacity(0.6),
                  fontSize: 16,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),
              // User Phone Number
              Text(
                "123-456-7890", // Static phone number
                style: TextStyle(
                  color: Colors.black.withOpacity(0.6),
                  fontSize: 16,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 30),
              // Edit Profile Button
              _buildProfileButton(
                context,
                icon: Icons.edit,
                text: "Edit Profile",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfileScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              // Saved Button
              _buildProfileButton(
                context,
                icon: Icons.bookmark,
                text: "Saved",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SavedScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              // Preferred Tags Button
              _buildProfileButton(
                context,
                icon: Icons.tag,
                text: "Preferred Tags",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PreferredTagsScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              // Logout Button
              _buildProfileButton(
                context,
                icon: Icons.logout,
                text: "Logout",
                onPressed: () {
                  // Handle logout
                },
                isLogout: true,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build profile buttons
  Widget _buildProfileButton(
      BuildContext context, {
        required IconData icon,
        required String text,
        required VoidCallback onPressed,
        bool isLogout = false,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: isLogout ? Colors.red : Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 10),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}