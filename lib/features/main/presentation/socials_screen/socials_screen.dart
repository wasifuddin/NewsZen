import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_zen/core/data/remote/mock_social_data.dart';
import 'package:news_zen/core/model/social_model.dart';
import 'package:news_zen/core/theme/colors.dart';
import 'package:news_zen/core/widgets/social_post_card.dart';
import 'package:intl/intl.dart';
import 'package:news_zen/features/main/presentation/socials_screen/bloc/social_news_cubit.dart';

import 'bloc/social_news_state.dart';

class SocialsPage extends StatefulWidget {
  const SocialsPage({super.key});

  @override
  State<SocialsPage> createState() => _SocialsPageState();
}

class _SocialsPageState extends State<SocialsPage> {

  late final SocialNewsCubit _newsCubit;
  String selectedPlatform = 'Twitter';
  String searchQuery = '';
  String selectedTag = 'All';

  final List<String> tags = [
    'Cricket', 'Bangladesh', 'Palestine', 'Islam', 'Football', 'Technology', 'World'
  ];

  List<SocialModel> getFilteredPosts() {
    DateTime now = DateTime.now();
    return mockSocialData.where((post) {
      bool matchesPlatform = post.source == selectedPlatform;
      bool matchesSearch = searchQuery.isEmpty || post.title.toLowerCase().contains(searchQuery.toLowerCase());
      bool matchesTag = selectedTag == 'All' || post.topic.contains(selectedTag);
      return matchesPlatform && matchesSearch && matchesTag;
    }).toList();
  }

  bool isNewPost(DateTime postTime) {
    return DateTime.now().difference(postTime).inHours <= 3;
  }

  final PageController _pageController = PageController();
  int currentPage = 0;
  bool initialnewsload = false;

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }
  Widget? previousWidget;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Socials')),
      backgroundColor: main_background_colour,
      body:
          BlocBuilder<SocialNewsCubit, SocialNewsState>(
            builder: (context, state){
              if(state is SocialNewsError){
                return Center(child: Text("Failed to fetch news"));
              }
              if(state is SocialNewsLoading){
                initialnewsload = true;
                return previousWidget ?? Center(child: CircularProgressIndicator());

              }
              else if(state is SocialNewsLoaded)
              {
                  previousWidget = Column(
                    children: [
                      // Platform Toggle
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildTab('Twitter'),
                          _buildTab('YouTube'),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Search Bar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextField(
                          onChanged: (value) => setState(() => searchQuery = value),
                          decoration: InputDecoration(
                            hintText: 'Search Twitter Persona',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Horizontal Tag Scroll
                      SizedBox(
                        height: 40,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          itemCount: tags.length,
                          itemBuilder: (context, index) {
                            String tag = tags[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: GestureDetector(
                                onTap: () => setState(() => selectedTag = tag),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: selectedTag == tag ? primary_red : Colors.grey),
                                    borderRadius: BorderRadius.circular(20),
                                    color: selectedTag == tag ? primary_red.withOpacity(0.2) : Colors.white,
                                  ),
                                  child: Text(tag, style: TextStyle(color: selectedTag == tag ? primary_red : Colors.black)),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Posts List
                      Expanded(
                        child: ListView.builder(
                          itemCount: getFilteredPosts().length,
                          itemBuilder: (context, index) {
                            final post = getFilteredPosts()[index];
                            return Stack(
                              children: [
                                SocialPostCard(post: post),
                                if (isNewPost(post.dateTime))
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Text(
                                        'New Post',
                                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
              }
            }



          ), // BlockBuilder

    );
  }

  Widget _buildTab(String platform) {
    return GestureDetector(
      onTap: () => setState(() => selectedPlatform = platform),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: selectedPlatform == platform ? primary_red : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          platform,
          style: TextStyle(
            color: selectedPlatform == platform ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
