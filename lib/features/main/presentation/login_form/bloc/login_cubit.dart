import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_zen/core/utils/pref_utils.dart';
import 'package:news_zen/features/main/presentation/bottom_nav/bottom_nav.dart';
import 'package:news_zen/features/main/presentation/login_form/login_form_screen.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState>
{
  LoginCubit() : super (LoginState());

  final formkey =GlobalKey<FormState>();


  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void validateInput(BuildContext context)
  {
    if(formkey.currentState!.validate())
    {
      _login(context);
    }
  }

  Future<void> _login(BuildContext context) async{
    String phoneNumber = phoneNumberController.text.trim();
    String password = passwordController.text.trim();

    PrefUtils.saveLoginInfo(phoneNumber, password);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MainBottomBar()),
    );
  }

   void logout(BuildContext context) async {
    //await PrefUtils.clearLoginInfo(); // Remove stored credentials

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginFormScreen()),
          (route) => false, // Clear navigation stack
    );
  }
}