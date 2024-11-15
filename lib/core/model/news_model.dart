class NewsModel {
  final String title;
  final String imageurl;
  final String source;
  final String description;
  final String url;
  final String topic;
  final DateTime dateTime;

  NewsModel({required this.title, required this.imageurl, required this.source, required this.description, required this.url, required this.topic, required this.dateTime});

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      title: json['title'],
      imageurl: json['imageurl'],
      source: json['source'],
      description: json['description'],
      url: json['url'],
      topic: json['topic'],
      dateTime: json['dateTime'],
    );
  }
}