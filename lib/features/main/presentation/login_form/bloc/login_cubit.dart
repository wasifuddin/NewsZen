import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_zen/core/utils/pref_utilis.dart';
import 'package:news_zen/core/utils/pref_utilis.dart';
import 'package:news_zen/features/main/presentation/bottom_nav/bottom_nav.dart';

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

}