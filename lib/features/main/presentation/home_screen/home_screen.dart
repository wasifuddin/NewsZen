import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_zen/core/widgets/custom_appbar.dart';
import 'package:news_zen/core/data/remote/mock_data.dart';
import 'package:news_zen/core/model/news_model.dart';
import 'package:news_zen/core/theme/colors.dart';
import 'package:news_zen/core/utils/app_assets.dart';
import 'package:news_zen/core/widgets/horizontal_news_card.dart';
import 'package:news_zen/core/widgets/news_card.dart';
import 'package:news_zen/features/main/presentation/home_screen/bloc/news_cubit.dart';
import 'package:news_zen/features/main/presentation/home_screen/bloc/news_state.dart';
import 'package:news_zen/features/main/presentation/news_sites_screen/news_sites_screen.dart';
import 'package:news_zen/features/main/presentation/notifications_screen/notifications_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final NewsCubit _newsCubit;
  String selectedTopicPageview = 'All';
  String? selectedNewsSource;
  final List<String> topicsPageview = [
    'all',
    'national',
    'world',
    'politics',
    'sports',
    'business',
    'finance',
    'technology',
    'entertainment'
  ];
  String selectedTopicListView = 'All';
  final List<String> topicsListview = [
    'All',
    'Trending',
    'Recomended',
    'Newsest',
    'MostViewed',
    'TopRated',
    'EditorsPick'
  ];
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _newsCubit = context.read<NewsCubit>();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print('lazy loading working');
        _newsCubit.currentPage++;
        _newsCubit.loadNews(currentPage: _newsCubit.currentPage);
      }
    });
  }

  List<NewsModel> getFilteredNews() {
    if (selectedTopicPageview == 'All') {
      if (selectedNewsSource == null) {
        return _newsCubit.pageViewNews;
      }
      return _newsCubit.pageViewNews
          .where((news) => news.source == selectedNewsSource)
          .toList();
    }
    return _newsCubit.pageViewNews
        .where((news) => news.topic == selectedTopicPageview)
        .toList();
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
      appBar: const CustomAppBar(),
      backgroundColor: Colors.white,
      body: BlocBuilder<NewsCubit, NewsState>(
        builder: (context, state) {
          if (state is NewsError) {
            return Center(child: Text("Failed to  news"));
          }
          if (state is NewsLoading) {
            initialnewsload = true;
            return previousWidget ?? Center(child: CircularProgressIndicator());
          } else if (state is NewsLoaded) {
            previousWidget = Column(
              children: [
                SingleChildScrollView(
                  //first filter design
                  scrollDirection: Axis.horizontal,

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: topicsPageview.map((topic) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  selectedTopicPageview = topic;
                                });
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: selectedTopicPageview == topic
                                    ? Colors.red
                                    : Colors.black,
                                padding: EdgeInsets
                                    .zero, // Removes padding for minimal look
                              ),
                              child: Text(
                                topic,
                                style: TextStyle(
                                  fontSize: 12, // Set font size
                                  fontWeight: FontWeight
                                      .bold, // Adjust font weight if needed
                                  fontFamily:
                                  'Montserrat', // Replace with desired font family
                                ),
                              ),
                            ),
                            if (selectedTopicPageview == topic)
                              Container(
                                margin: const EdgeInsets.only(top: 4.0),
                                height: 2,
                                width: 20,
                                color: Colors.red, // Color of the underline
                              ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          //first news card
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: SizedBox(
                            height: 200,
                            child: PageView.builder(
                              controller: _pageController,
                              scrollDirection: Axis.horizontal,
                              itemCount: _newsCubit
                                  .filterPageViewNews(selectedTopicPageview)
                                  .length +
                                  (context.read<NewsCubit>().hasMoreData
                                      ? 1
                                      : 0),
                              /*+ (context.read<NewsCubit>().hasMoreData ? 1 : 0)*/
                              onPageChanged: (int index) {
                                setState(() {
                                  currentPage = index;
                                });
                              },
                              itemBuilder: (context, index) {
                                final newsItem = _newsCubit.filterPageViewNews(
                                    selectedTopicPageview)[index];
                                ;
                                return HorizontalNewsCard(newsItem: newsItem);
                              },
                              pageSnapping: true,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Center(
                          child: SmoothPageIndicator(
                            controller: _pageController,
                            count: _newsCubit.pageViewNews.length,
                            effect: ExpandingDotsEffect(
                              dotHeight: 8.0,
                              dotWidth: 8.0,
                              activeDotColor: Colors.red,
                              dotColor: Colors.grey.shade400,
                            ),
                          ),
                        ),
                        //suggestions
                        const SizedBox(height: 30.0),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 25.0, right: 25.0, bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween, // Align children to the edges
                            children: [
                              // "Popular Redactions" text aligned to the left
                              const Text(
                                'Popular Redactions',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontFamily: "montserrat",
                                ),
                              ),
                              // "See All" text aligned to the right and clickable
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                      const NewsSitesScreen(),
                                    ),
                                  );
                                  print('See All clicked');
                                },
                                child: Text(
                                  'See All',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey,
                                    decoration: TextDecoration.underline,
                                    fontFamily: "montserrat",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  NewsSourceCircle(
                                    imagePath: AppAssets.image.img_bbc_logo,
                                    isSelected:
                                    selectedNewsSource == 'BBC News',
                                    onTap: () {
                                      setState(() {
                                        selectedNewsSource =
                                        selectedNewsSource == 'BBC News'
                                            ? null
                                            : 'BBC News';
                                      });
                                    },
                                  ),
                                  NewsSourceCircle(
                                    imagePath: AppAssets.image.img_cnn_logo,
                                    isSelected: selectedNewsSource == 'CNN',
                                    onTap: () {
                                      setState(() {
                                        selectedNewsSource =
                                        selectedNewsSource == 'CNN'
                                            ? null
                                            : 'CNN';
                                      });
                                    },
                                  ),
                                  NewsSourceCircle(
                                    imagePath:
                                    AppAssets.image.img_aljazeera_logo,
                                    isSelected:
                                    selectedNewsSource == 'Al Jazeera',
                                    onTap: () {
                                      setState(() {
                                        selectedNewsSource =
                                        selectedNewsSource == 'Al Jazeera'
                                            ? null
                                            : 'Al Jazeera';
                                      });
                                    },
                                  ),
                                  NewsSourceCircle(
                                    imagePath:
                                    AppAssets.image.img_prothom_alo_logo,
                                    isSelected:
                                    selectedNewsSource == 'Prothom Alo',
                                    onTap: () {
                                      setState(() {
                                        selectedNewsSource =
                                        selectedNewsSource == 'Prothom Alo'
                                            ? null
                                            : 'Prothom Alo';
                                      });
                                    },
                                  ),
                                  NewsSourceCircle(
                                    imagePath:
                                    AppAssets.image.img_daily_star_logo,
                                    isSelected:
                                    selectedNewsSource == 'The Daily Star',
                                    onTap: () {
                                      setState(() {
                                        selectedNewsSource =
                                        selectedNewsSource ==
                                            'The Daily Star'
                                            ? null
                                            : 'The Daily Star';
                                      });
                                    },
                                  ),
                                  NewsSourceCircle(
                                    imagePath:
                                    AppAssets.image.img_bdnews24_logo,
                                    isSelected:
                                    selectedNewsSource == 'bdnews24',
                                    onTap: () {
                                      setState(() {
                                        selectedNewsSource =
                                        selectedNewsSource == 'bdnews24'
                                            ? null
                                            : 'bdnews24';
                                      });
                                    },
                                  ),
                                  NewsSourceCircle(
                                    imagePath: AppAssets.image.img_ittefaq_logo,
                                    isSelected: selectedNewsSource == 'Ittefaq',
                                    onTap: () {
                                      setState(() {
                                        selectedNewsSource =
                                        selectedNewsSource == 'Ittefaq'
                                            ? null
                                            : 'Ittefaq';
                                      });
                                    },
                                  ),
                                  NewsSourceCircle(
                                    imagePath: AppAssets.image.img_mzamin_logo,
                                    isSelected:
                                    selectedNewsSource == 'Manab Zamin',
                                    onTap: () {
                                      setState(() {
                                        selectedNewsSource =
                                        selectedNewsSource == 'Manab Zamin'
                                            ? null
                                            : 'Manab Zamin';
                                      });
                                    },
                                  ),
                                ],
                              )),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 8.0, bottom: 8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Browse By',
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontFamily: "montserrat"),
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          //list news filter
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: topicsListview.map((topic) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          selectedTopicListView = topic;
                                        });
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor:
                                        selectedTopicListView == topic
                                            ? Colors.red
                                            : Colors.black,
                                        padding: EdgeInsets
                                            .zero, // Removes padding for minimal look
                                      ),
                                      child: Text(
                                        topic,
                                        style: TextStyle(
                                          fontSize: 12, // Set font size
                                          fontWeight: FontWeight
                                              .bold, // Adjust font weight if needed
                                          fontFamily:
                                          'Montserrat', // Replace with desired font family
                                        ),
                                      ),
                                    ),
                                    if (selectedTopicListView == topic)
                                      Container(
                                        margin: const EdgeInsets.only(top: 4.0),
                                        height: 2,
                                        width: 20,
                                        color: Colors
                                            .red, // Color of the underline
                                      ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(
                          height: 500,
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, bottom: 8, top: 8, right: 8.0),
                              child: ListView.builder(
                                itemCount: _newsCubit
                                    .filterHorizontalNews(
                                    selectedTopicListView)
                                    .length +
                                    (context.read<NewsCubit>().hasMoreData
                                        ? 1
                                        : 0),
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  if (index ==
                                      _newsCubit.horizontalNews.length) {
                                    print('rih');
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  final newsItem =
                                  _newsCubit.filterHorizontalNews(
                                      selectedTopicListView)[index];
                                  return NewsCard(newsItem: newsItem);
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
            return previousWidget!;
          }

          //hopefully lagbe na eita
          return Column(
            children: [
              SingleChildScrollView(
                //horizontal news filter
                scrollDirection: Axis.horizontal,

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: topicsListview.map((topic) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                selectedTopicListView = topic;
                              });
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: selectedTopicListView == topic
                                  ? Colors.red
                                  : Colors.black,
                              padding: EdgeInsets
                                  .zero, // Removes padding for minimal look
                            ),
                            child: Text(
                              topic,
                              style: TextStyle(
                                fontSize: 12, // Set font size
                                fontWeight: FontWeight
                                    .bold, // Adjust font weight if needed
                                fontFamily:
                                'Montserrat', // Replace with desired font family
                              ),
                            ),
                          ),
                          if (selectedTopicListView == topic)
                            Container(
                              margin: const EdgeInsets.only(top: 4.0),
                              height: 2,
                              width: 20,
                              color: Colors.red, // Color of the underline
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        //horizontal news card
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: SizedBox(
                          height: 200,
                          child: PageView.builder(
                            controller: _pageController,
                            scrollDirection: Axis.horizontal,
                            itemCount: _newsCubit.pageViewNews
                                .length /*+ (context.read<NewsCubit>().hasMoreData ? 1 : 0)*/,
                            onPageChanged: (int index) {
                              setState(() {
                                currentPage = index;
                              });
                            },
                            itemBuilder: (context, index) {
                              final newsItem = _newsCubit.pageViewNews[index];
                              return HorizontalNewsCard(newsItem: newsItem);
                            },
                            pageSnapping: true,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Center(
                        child: SmoothPageIndicator(
                          controller: _pageController,
                          count: _newsCubit.pageViewNews.length,
                          effect: ExpandingDotsEffect(
                            dotHeight: 8.0,
                            dotWidth: 8.0,
                            activeDotColor: Colors.red,
                            dotColor: Colors.grey.shade400,
                          ),
                        ),
                      ),
                      //suggestions
                      const SizedBox(height: 30.0),
                      const Padding(
                        padding: EdgeInsets.only(
                            left: 25.0, right: 8.0, bottom: 8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Browse By',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontFamily: "montserrat"),
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        //list news filter
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: topicsPageview.map((topic) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        selectedTopicPageview = topic;
                                      });
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor:
                                      selectedTopicPageview == topic
                                          ? Colors.red
                                          : Colors.black,
                                      padding: EdgeInsets
                                          .zero, // Removes padding for minimal look
                                    ),
                                    child: Text(
                                      topic,
                                      style: TextStyle(
                                        fontSize: 12, // Set font size
                                        fontWeight: FontWeight
                                            .bold, // Adjust font weight if needed
                                        fontFamily:
                                        'Montserrat', // Replace with desired font family
                                      ),
                                    ),
                                  ),
                                  if (selectedTopicPageview == topic)
                                    Container(
                                      margin: const EdgeInsets.only(top: 4.0),
                                      height: 2,
                                      width: 20,
                                      color:
                                      Colors.red, // Color of the underline
                                    ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, bottom: 8, top: 8, right: 8.0),
                        child: ListView.builder(
                          itemCount: _newsCubit
                              .filterHorizontalNews(selectedTopicPageview)
                              .length +
                              (context.read<NewsCubit>().hasMoreData ? 1 : 0),
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            if (index == _newsCubit.horizontalNews.length) {
                              print('rih');
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            final newsItem = _newsCubit.filterHorizontalNews(
                                selectedTopicPageview)[index];
                            return NewsCard(newsItem: newsItem);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class NewsSourceCircle extends StatelessWidget {
  final String imagePath;
  final bool isSelected;
  final VoidCallback onTap;

  const NewsSourceCircle({
    Key? key,
    required this.imagePath,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.red : Colors.transparent,
            width: 2,
          ),
        ),
        child: ClipOval(
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
