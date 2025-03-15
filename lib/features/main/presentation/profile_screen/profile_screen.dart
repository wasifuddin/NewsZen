import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_zen/core/theme/colors.dart';
import 'package:news_zen/core/utils/app_assets.dart';
import 'package:news_zen/features/main/presentation/edit_profile_screen/edit_profile_screen.dart';
import 'package:news_zen/features/main/presentation/saved_screen/saved_screen.dart';
import 'package:news_zen/features/main/presentation/preferred_tags_screen/preferred_tags_screen.dart';
import 'package:news_zen/features/main/presentation/notifications_screen/notifications_screen.dart';
import 'package:news_zen/features/main/presentation/login_form/login_form_screen.dart';
import 'package:news_zen/features/main/presentation/login_form/bloc/login_cubit.dart';
import 'package:news_zen/features/weather/presentation/widgets/weather_widget.dart';
import 'package:news_zen/features/weather/presentation/screens/detailed_weather_screen.dart';

import '../../../../core/widgets/custom_appbar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // Profile Picture and Info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage:
                            AssetImage(AppAssets.image.img_user_profile),
                      ),
                      //const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'Rihila Sumayya',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'rihila@iut-dhaka.edu',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20,)
                    ],
                  ),
                  // const SizedBox(height: 20),
                  // // Edit Profile Button
                  // SizedBox(
                  //   width: double.infinity,
                  //   child: ElevatedButton(
                  //     onPressed: () {
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (context) => const EditProfileScreen(),
                  //         ),
                  //       );
                  //     },
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: const Color(0xFFD32F2F),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(12),
                  //       ),
                  //       padding: const EdgeInsets.symmetric(vertical: 16),
                  //     ),
                  //     child: const Text('Edit Profile'),
                  //   ),
                  // ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Weather Widget
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: WeatherWidget(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DetailedWeatherScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            // Menu Items
            _buildMenuItem(
              icon: Icons.edit,
              title: 'Edit Profile',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditProfileScreen(),
                  ),
                );
              },
            ),
            _buildMenuItem(
              icon: Icons.bookmark,
              title: 'Saved',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SavedScreen(),
                  ),
                );
              },
            ),
            _buildMenuItem(
              icon: Icons.tag,
              title: 'Preferred Tags',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PreferredTagsScreen(),
                  ),
                );
              },
            ),
            _buildMenuItem(
              icon: Icons.logout,
              title: 'Logout',
              isLogout: true,
              onTap: () {
                BlocProvider.of<LoginCubit>(context).logout(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey[200]!,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isLogout ? primary_red : Colors.black54,
              size: 24,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: isLogout ? primary_red : Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Colors.grey,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
