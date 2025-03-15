import 'package:news_zen/core/model/social_model.dart';

final mockSocialData = [
  SocialModel(
    platform: 'Facebook',
    postContent: 'Check out this amazing news!',
    imageUrl: 'https://example.com/facebook1.jpg',
    author: 'John Doe',
    dateTime: DateTime.now(),
  ),
  SocialModel(
    platform: 'Twitter',
    postContent: 'Breaking news: Something happened!',
    imageUrl: 'https://example.com/twitter1.jpg',
    author: 'Jane Smith',
    dateTime: DateTime.now(),
  ),
  SocialModel(
    platform: 'YouTube',
    postContent: 'Watch this video for the latest updates.',
    imageUrl: 'https://example.com/youtube1.jpg',
    author: 'News Channel',
    dateTime: DateTime.now(),
  ),
];