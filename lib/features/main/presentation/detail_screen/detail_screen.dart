import 'package:flutter/material.dart';
import 'package:news_zen/core/model/news_model.dart';
import 'package:intl/intl.dart';
import 'package:news_zen/core/theme/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailPage extends StatefulWidget {
  final NewsModel newsItem;

  const NewsDetailPage({required this.newsItem, super.key});

  @override
  _NewsDetailPageState createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  late ScrollController _scrollController;
  Color appBarColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          if (_scrollController.offset > 150) {
            appBarColor = Colors.white;
          } else {
            appBarColor = Colors.transparent;
          }
        });
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('MMM dd, yyyy').format(widget.newsItem.dateTime);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            backgroundColor: main_background_colour,
            expandedHeight: MediaQuery.of(context).size.height * 0.4,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.newsItem.imageurl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.9),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 36,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        widget.newsItem.topic,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat'
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${widget.newsItem.source} | ',
                              style: const TextStyle(fontSize: 16, color: Colors.grey,  fontFamily: 'Montserrat'),
                            ),
                            Text(
                              formattedDate,
                              style: const TextStyle(fontSize: 16, color: Colors.grey ,  fontFamily: 'Montserrat'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.7,
                          ),
                          child: Text(
                            widget.newsItem.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                                fontFamily: 'Montserrat'
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            pinned: true,
          ),
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, 0),
              child: Container(
                decoration: BoxDecoration(
                  color: main_background_colour,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.newsItem.description,
                      style: const TextStyle(fontSize: 16, fontFamily: 'Montserrat'),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        _openNewsUrl(context, widget.newsItem.url);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary_red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Go to Website', style: TextStyle( fontFamily: 'Montserrat'),),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openNewsUrl(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication); // Use external application mode
    } else {
      throw 'Could not launch $url';
    }
  }

}