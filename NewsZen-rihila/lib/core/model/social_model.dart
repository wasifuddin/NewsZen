class SocialModel {
  final String platform; // e.g., Facebook, Twitter, YouTube
  final String postContent;
  final String imageUrl;
  final String author;
  final DateTime dateTime;

  SocialModel({
    required this.platform,
    required this.postContent,
    required this.imageUrl,
    required this.author,
    required this.dateTime,
  });

  factory SocialModel.fromJson(Map<String, dynamic> json) {
    return SocialModel(
      platform: json['platform'],
      postContent: json['postContent'],
      imageUrl: json['imageUrl'],
      author: json['author'],
      dateTime: DateTime.parse(json['dateTime']),
    );
  }
}