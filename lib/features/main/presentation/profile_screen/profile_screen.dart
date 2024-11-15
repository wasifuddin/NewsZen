/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/utils/app_assets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
    );
  }
}
*/
import 'package:news_zen/core/localization/app_strings.dart';
import 'package:news_zen/core/theme/colors.dart';
import 'package:news_zen/core/utils/app_assets.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isTablet = screenWidth > 600;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBar(
          backgroundColor: main_background_colour,
          title: Column(
            children: [
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 0.0),
                    child: Image.asset(
                      AppAssets.image.img_med_logo, // Your logo asset
                      width: 140,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.notifications, color: primary_red),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      backgroundColor: main_background_colour,
      body: isTablet
          ? profileScreen(context)
          : profileScreen(context),
    );
  }

  Widget profileScreen(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 90),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: Image.asset(
                  AppAssets.image.img_user_profile, // Profile image asset
                  width: 100, // Adjust size for profile picture
                  height: 100,
                ),
              ),
            ),
            SizedBox(height: 20,),
            Text(
              "Rihila Sumayya", // Static name for the profile
              style: TextStyle(
                color: Colors.black.withOpacity(1.00),
                fontSize: 18,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "rihila@iut-dhaka.edu", // Static email
              style: TextStyle(
                color: Colors.black.withOpacity(0.6),
                fontSize: 14,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "123-456-7890", // Static phone number
              style: TextStyle(
                color: Colors.black.withOpacity(0.6),
                fontSize: 14,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 30),
            // Edit Profile Button
            Padding(
              padding: const EdgeInsets.only(right: 50, left: 50),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to Edit Profile screen or perform an action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary_red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "Edit Profile", // Custom text for editing profile
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Logout Button
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Align(
                alignment: Alignment.center,
                child: const Text(
                  "Logout", // Static text for logout
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
