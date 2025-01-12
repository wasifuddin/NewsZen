class NewsModel {
  final String title;
  final String imageurl;
  final String source;
  final String description;
  final String url;
  final String topic;
  // final String dateTime;
  final DateTime dateTime;


  NewsModel({required this.title, required this.imageurl, required this.source, required this.description, required this.url, required this.topic, required this.dateTime});

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      title: json['title'] ?? '',
      imageurl: json['imageurl'] ?? '',
      source: json['source'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      topic: json['topic'] ?? '',
      dateTime: json['dateTime'] != null ? DateTime.tryParse(json['dateTime']) ?? DateTime.now() : DateTime.now(),
    );
  }

    factory NewsModel.fromMap(Map<String, dynamic> map) {
    return NewsModel(
      title: map['title'] ?? '',
      imageurl: map['imageurl'] ?? '',
      source: map['source'] ?? '',
      description: map['description'] ?? '',
      url: map['url'] ?? '',
      dateTime: map['dateTime'] != null ? (map['dateTime'] is DateTime ? map['dateTime'] : DateTime.tryParse(map['dateTime']) ?? DateTime.now()) : DateTime.now(),
      topic: map['topic'] ?? '',
    );
  }
}
