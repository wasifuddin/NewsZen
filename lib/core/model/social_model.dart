class SocialModel {
  final String id;
  final String title;
  final List<String> imageUrls;
  final List<String> videoUrls;
  final String source;
  final DateTime dateTime;
  final String description;
  final String topic;
  final String language;
  final int likeCount;
  final int priority;

  SocialModel({
    required this.id,
    required this.title,
    required this.imageUrls,
    required this.videoUrls,
    required this.source,
    required this.dateTime,
    required this.description,
    required this.topic,
    required this.language,
    required this.likeCount,
    required this.priority,
  });

  factory SocialModel.fromJson(Map<String, dynamic> json) {
    return SocialModel(
      id: json['_id'].toString(),
      title: json['title'],
      imageUrls: List<String>.from(json['image_urls']),
      videoUrls: List<String>.from(json['video_urls']),
      source: json['source'],
      dateTime: DateTime.parse(json['timestamp']),
      description: json['content'],
      topic: json['tag'],
      language: json['language'],
      likeCount: json['like_count'],
      priority: json['priority'],
    );
  }
}