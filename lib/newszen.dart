import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_zen/features/main/presentation/bottom_nav/bottom_nav.dart';
import 'package:news_zen/features/main/presentation/home_screen/home_screen.dart';

class Newszen extends StatefulWidget {
  const Newszen({super.key});

  @override
  State<Newszen> createState() => _NewszenState();
}

class _NewszenState extends State<Newszen> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainBottomBar(),
    );
  }
}
