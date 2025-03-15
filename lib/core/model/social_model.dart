class SocialModel {
  final String platform; // e.g., Facebook, Twitter, YouTube
  final String postContent;
  final String author;
  final DateTime dateTime;

  SocialModel({
    required this.platform,
    required this.postContent,
    required this.author,
    required this.dateTime,
  });

  factory SocialModel.fromJson(Map<String, dynamic> json) {
    return SocialModel(
      platform: json['platform'],
      postContent: json['postContent'],
      author: json['author'],
      dateTime: DateTime.parse(json['dateTime']),
    );
  }
}