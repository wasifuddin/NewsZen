// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:news_zen/core/data/remote/mock_data.dart';
// import 'package:news_zen/core/model/news_model.dart';
// import 'package:news_zen/core/theme/colors.dart';
// import 'package:news_zen/core/utils/app_assets.dart';
// import 'package:news_zen/core/widgets/horizontal_news_card.dart';
// import 'package:news_zen/core/widgets/news_card.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// import 'package:news_zen/features/main/presentation/notifications_screen/notifications_screen.dart';
// import 'bloc/home_bloc.dart';
//
// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => HomeBloc()..add(LoadHomeDataEvent()),
//       child: Scaffold(
//         appBar: PreferredSize(
//           preferredSize: const Size.fromHeight(70),
//           child: AppBar(
//             automaticallyImplyLeading: false,
//             backgroundColor: main_background_colour,
//             title: Column(
//               children: [
//                 const SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(left: 8.0),
//                       child: Image.asset(
//                         AppAssets.image.img_med_logo,
//                         width: 140,
//                       ),
//                     ),
//                     const Spacer(),
//                     IconButton(
//                       onPressed: () {
//                         showNotificationScreen(context);
//                       },
//                       icon: Icon(Icons.notifications, color: primary_red),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//         backgroundColor: main_background_colour,
//         body: BlocBuilder<HomeBloc, HomeState>(
//           builder: (context, state) {
//             if (state is HomeLoadingState) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (state is HomeLoadedState) {
//               return _buildHomeScreen(context, state);
//             }
//             return const Center(child: Text('Something went wrong!'));
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHomeScreen(BuildContext context, HomeLoadedState state) {
//     final PageController _pageController = PageController();
//     final topics = [
//       'All',
//       'World',
//       'Sports',
//       'Technology',
//       'Health',
//       'Space',
//       'Food',
//       'Politics',
//       'Automotive'
//     ];
//
//     return CustomScrollView(
//       slivers: [
//         // Featured News Carousel
//         SliverToBoxAdapter(
//           child: Column(
//             children: [
//               const SizedBox(height: 12),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                 child: SizedBox(
//                   height: 200,
//                   child: PageView.builder(
//                     controller: _pageController,
//                     scrollDirection: Axis.horizontal,
//                     itemCount: mockNewsData.length,
//                     itemBuilder: (context, index) {
//                       final newsItem = mockNewsData[index];
//                       return HorizontalNewsCard(newsItem: newsItem);
//                     },
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16.0),
//               Center(
//                 child: SmoothPageIndicator(
//                   controller: _pageController,
//                   count: mockNewsData.length,
//                   effect: ExpandingDotsEffect(
//                     dotHeight: 8.0,
//                     dotWidth: 8.0,
//                     activeDotColor: Colors.red,
//                     dotColor: Colors.grey.shade400,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16.0),
//             ],
//           ),
//         ),
//         // Sticky Header for "Browse By" and Category Selector
//         SliverPersistentHeader(
//           pinned: true,
//           delegate: _StickyHeaderDelegate(
//             child: Column(
//               children: [
//                 const Padding(
//                   padding: EdgeInsets.only(left: 25.0, right: 8.0, bottom: 0.0, top: 8.0),
//                   child: Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       'Browse By',
//                       style: TextStyle(
//                         fontSize: 17,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.black,
//                         fontFamily: "Montserrat",
//                       ),
//                     ),
//                   ),
//                 ),
//                 SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: topics.map((topic) => _buildTopicButton(context, topic, state.selectedTopic)).toList(),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         // Filtered News List
//         SliverList(
//           delegate: SliverChildBuilderDelegate(
//                 (context, index) {
//               final newsItem = state.news[index];
//               return Padding(
//                 padding: const EdgeInsets.only(left: 20, bottom: 4, top: 4, right: 8.0),
//                 child: NewsCard(newsItem: newsItem),
//               );
//             },
//             childCount: state.news.length,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildTopicButton(BuildContext context, String topic, String selectedTopic) {
//     return Padding(
//       padding: const EdgeInsets.only(right: 8.0),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           TextButton(
//             onPressed: () {
//               context.read<HomeBloc>().add(ChangeTopicEvent(topic));
//             },
//             style: TextButton.styleFrom(
//               foregroundColor: topic == selectedTopic ? Colors.red : Colors.black,
//               padding: EdgeInsets.zero,
//             ),
//             child: Text(
//               topic,
//               style: const TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.bold,
//                 fontFamily: 'Montserrat',
//               ),
//             ),
//           ),
//           if (topic == selectedTopic)
//             Container(
//               margin: const EdgeInsets.only(top: 0.0),
//               height: 4,
//               width: 20,
//               color: Colors.red,
//             ),
//         ],
//       ),
//     );
//   }
// }
//
// // Custom delegate for the sticky header
// class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
//   final Widget child;
//
//   _StickyHeaderDelegate({required this.child});
//
//   @override
//   Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return Container(
//       color: main_background_colour,
//       child: child,
//     );
//   }
//
//   @override
//   double get maxExtent => 100;
//
//   @override
//   double get minExtent => 100;
//
//   @override
//   bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
//     return true;
//   }
// }