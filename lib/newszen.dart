import 'package:flutter/material.dart';
//import 'package:sizer/sizer.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:news_zen/core/utils/pref_utils.dart';
import 'package:news_zen/features/main/presentation/bottom_nav/bottom_nav.dart';
import 'package:news_zen/features/main/presentation/login_form/bloc/login_cubit.dart';
import 'package:news_zen/features/main/presentation/login_form/login_form_screen.dart';

import 'features/main/presentation/pseudo_home_screen/bloc/news_cubit.dart';
import 'features/main/presentation/signupform/bloc/signup_cubit.dart';

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
    final String? phoneNumber = await PrefUtils.getEmail();
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
        BlocProvider<NewsCubit>(create: (_) => NewsCubit()),
        BlocProvider<SignupCubit>(create: (_) => SignupCubit()),
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
