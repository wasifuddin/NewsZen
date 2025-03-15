import 'package:intl/intl.dart';
class NewsModel {
  final String title;
  final String imageurl;
  final String source;
  final String description;
  final String url;
  final String topic;
  final DateTime? dateTime;

  NewsModel({required this.title, required this.imageurl, required this.source, required this.description, required this.url, required this.topic,  this.dateTime});

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    DateTime? parsedDateTime;
    if (json['dateTime'] != null) {
      try {
        String dateString = json['dateTime'];
        DateTime originalDate = DateTime.parse(dateString);

        parsedDateTime = DateTime(
            originalDate.year,
            originalDate.day,
            originalDate.month,
            originalDate.hour,
            originalDate.minute,
            originalDate.second,
            originalDate.millisecond,
            originalDate.microsecond
        );
      } catch (e) {
        print("Error correcting date: ${e.toString()}");
      }
    }

    return NewsModel(
      title: json['title'],
      imageurl: json['imageurl'],
      source: json['source'],
      description: json['description'],
      url: json['url'],
      topic: json['topic'],
      dateTime: parsedDateTime,
    );
  }
}