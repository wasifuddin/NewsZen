import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_zen/core/theme/colors.dart';
import 'package:news_zen/core/utils/app_assets.dart';
import 'package:news_zen/core/widgets/news_card.dart';
import 'package:news_zen/core/model/news_model.dart';
import 'package:news_zen/features/main/presentation/saved_screen/bloc/saved_news_bloc.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SavedNewsBloc()..add(FetchSavedNews(email: 'janina@gmail.com')), // Replace with the user's email
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: main_background_colour,
            title: Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Image.asset(
                        AppAssets.image.img_med_logo, // Your logo asset
                        width: 140,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context); // Go back to the previous screen
                      },
                      icon: Icon(Icons.close, color: primary_red),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        backgroundColor: main_background_colour,
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Saved Articles",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontFamily: "Montserrat",
                ),
              ),
              const SizedBox(height: 20),
              BlocBuilder<SavedNewsBloc, SavedNewsState>(
                builder: (context, state) {
                  if (state is SavedNewsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is SavedNewsError) {
                    return Center(child: Text(state.message));
                  } else if (state is SavedNewsLoaded) {
                    if (state.news.isEmpty) {
                      return const Center(
                        child: Text(
                          'No saved articles found.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.news.length,
                      itemBuilder: (context, index) {
                        final newsItem = state.news[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: NewsCard(newsItem: newsItem),
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}