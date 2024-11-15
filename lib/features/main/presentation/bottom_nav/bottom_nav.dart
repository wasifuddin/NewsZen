import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_zen/features/main/presentation/ai_screen/ai_screen.dart';
import 'package:news_zen/features/main/presentation/discover_screen/discover_screen.dart';
import 'package:news_zen/features/main/presentation/explore_screen/explore_screen.dart';
import 'package:news_zen/features/main/presentation/home_screen/home_screen.dart';
import 'package:news_zen/features/main/presentation/login_form/login_form_screen.dart';
import 'package:news_zen/features/main/presentation/profile_screen/profile_screen.dart';
import 'package:news_zen/features/main/presentation/saved_screen/saved_screen.dart';

import '../../../../core/utils/app_assets.dart';
import '../../domain/models/bottom_menu_model.dart';

class MainBottomBar extends StatefulWidget {
  const MainBottomBar({super.key});

  @override
  State<MainBottomBar> createState() => _MainBottomBarState();
}

class _MainBottomBarState extends State<MainBottomBar> {

  late PageController _pageController;
  int _selectedIndex = 0;


  final List<BottomMenuModel> _bottomMenuList = [
    BottomMenuModel(
        icon: AppAssets.image.img_home_icon,
        activeIcon: AppAssets.image.img_home_icon_active,
        body: HomeScreen()),

    BottomMenuModel(
        icon: AppAssets.image.img_explore_icon,
        activeIcon: AppAssets.image.img_explore_icon_active,
        body: ExploreScreen()),

    BottomMenuModel(
        icon: AppAssets.image.img_saved_icon,
        activeIcon: AppAssets.image.img_saved_icon_active,
        body: AIChatScreen()),

    BottomMenuModel(
        icon: AppAssets.image.img_profile_icon,
        activeIcon: AppAssets.image.img_profile_icon_active,
        body: ProfileScreen()),
  ];

  @override
  void initState()
  {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  void _onItemSelect(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );// _pageController.jumpToPage(index);
    });
  }

  Widget _item({
    required int index,
    required String selectedIcon,
    required String unSelectedIcon,
  }) {

    bool isSelected = _selectedIndex == index;

    return Expanded(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 35,
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              top: -24,
              child: AnimatedContainer(
                width: isSelected ? 40 : 0,
                height: isSelected ? 40 : 0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ), duration: const Duration(milliseconds: 300),
              ),
            ),

            SizedBox(
              width: double.maxFinite,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => _onItemSelect(index),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(isSelected? selectedIcon : unSelectedIcon),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomNavBar() {
    return Container(
      height: 65,
      margin: const EdgeInsets.all(0.0),
      padding: EdgeInsets.only(top:8.00),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: List.generate(_bottomMenuList.length, (index) {
          return _item(
            index: index,
            selectedIcon: _bottomMenuList[index].activeIcon,
            // selectedIcon: '',
            unSelectedIcon: _bottomMenuList[index].icon,
            //title: '',
          );
        }),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(_bottomMenuList.length, (index) => _bottomMenuList[index].body),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _bottomNavBar(),
          ),
        ],
      ),
    );
  }
}
