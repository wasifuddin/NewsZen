import 'package:flutter/material.dart';
import 'package:news_zen/core/theme/colors.dart';
import 'package:news_zen/core/utils/app_assets.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

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
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Profile Picture
            Center(
              child: Stack(
                children: [
                  Image.asset(
                    AppAssets.image.img_user_profile, // Profile image asset
                    width: 100,
                    height: 100,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: primary_red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Name Field
            _buildTextField("Name", "Rihila Sumayya"),
            const SizedBox(height: 20),
            // Email Field
            _buildTextField("Email", "rihila@iut-dhaka.edu"),
            const SizedBox(height: 20),
            // Phone Number Field
            _buildTextField("Phone Number", "123-456-7890"),
            const SizedBox(height: 30),
            // Save Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    // Save profile changes
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary_red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "Save Changes",
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
          ],
        ),
      ),
    );
  }

  // Helper method to build text fields
  Widget _buildTextField(String label, String initialValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.black.withOpacity(0.6),
            fontSize: 14,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: initialValue,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }
}