import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:news_zen/newszen.dart';
/*

Future<void> main() async {
*/
/*  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);*//*

  //await initializeDependencies();

  Future.wait([
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]),
    //PrefUtils().init(),
  ]).then((value){
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    runApp(const Newszen());
  });
}*/

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Newszen(),
  ));
}