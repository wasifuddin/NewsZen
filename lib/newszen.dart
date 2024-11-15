import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:news_zen/core/utils/pref_utilis.dart';
import 'package:news_zen/features/main/presentation/bottom_nav/bottom_nav.dart';
import 'package:news_zen/features/main/presentation/home_screen/home_screen.dart';
import 'package:news_zen/features/main/presentation/login_form/bloc/login_cubit.dart';
import 'package:news_zen/features/main/presentation/login_form/login_form_screen.dart';

class Newszen extends StatefulWidget {
  const Newszen({super.key});

  @override
  State<Newszen> createState() => _NewszenState();
}

class _NewszenState extends State<Newszen> {

  bool isLoggedIn = false;
  bool isDataFetch = false;

  @override
  void initState() {
    islogin();
    super.initState();


  }

  Future<void> islogin() async {
    final String? phoneNumber = await PrefUtils.getPhoneNumber();
    final String? password = await PrefUtils.getPassword();
    isLoggedIn = phoneNumber != null && password != null;
    print(MediaQuery.of(context).size.height);
    print(isLoggedIn);
    print(phoneNumber);
    print(password);
    isDataFetch = true;
    FlutterNativeSplash.remove();
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    /*return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainBottomBar(),
    );*/
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginCubit>(create: (_) => LoginCubit()),

      ],
      child: ResponsiveSizer(
          builder: (context,orientation,devicetype) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: isDataFetch
                  ? isLoggedIn ? MainBottomBar() : LoginFormScreen()
                  : CircularProgressIndicator(),

            );
          }
      ),
    );
  }
}
