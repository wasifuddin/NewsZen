import 'package:flutter/material.dart';
import 'package:news_zen/core/model/social_model.dart';
import 'package:news_zen/core/theme/colors.dart';

class SocialPostCard extends StatelessWidget {
  final SocialModel post;

  const SocialPostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    // Determine the background color based on the platform
    final Color backgroundColor = post.source.toLowerCase().contains('twitter')
        ? Colors.blue[50]! // Bluish hue for Twitter
        : Colors.red[50]!; // Reddish hue for YouTube

    // Split the source field into account name and username
    final List<String> sourceParts = post.source.split(',');
    final String accountName = sourceParts[0].trim();
    final String username1 = sourceParts.length > 1 ? sourceParts[1].trim() : '';
    String username = post.source;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      color: backgroundColor, // Set the background color
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with platform logo, account name, and username
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Platform logo
                Image.asset(
                  post.source.toLowerCase().contains('twitter')
                      ? 'assets/social_icons/twitter.png' // Replace with your Twitter logo path
                      : 'assets/social_icons/youtube.png', // Replace with your YouTube logo path
                  width: 32,
                  height: 32,
                ),
                const SizedBox(width: 12),
                // Account name and username
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      accountName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    //if (username.isNotEmpty)
                      Text(
                        '@$username',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontFamily: 'Montserrat',
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          // Post content
          if (post.description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                post.description,
                style: const TextStyle(
                  fontSize: 15,
                  fontFamily: 'Montserrat',
                  height: 1.4,
                ),
              ),
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}