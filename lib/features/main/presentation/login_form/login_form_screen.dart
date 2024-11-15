import 'package:news_zen/core/localization/app_strings.dart';
import 'package:news_zen/core/theme/colors.dart';
import 'package:news_zen/core/utils/app_assets.dart';
import 'package:news_zen/core/utils/validation_functions.dart';
import 'package:news_zen/core/widgets/custome_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/login_cubit.dart';


class LoginFormScreen extends StatefulWidget {
  const LoginFormScreen({super.key});

  @override
  State<LoginFormScreen> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginFormScreen> {
  late final LoginCubit _loginCubit;

  void _onLoginClick()
  {
    _loginCubit.validateInput(context);
  }
  @override
  void initState() {
    super.initState();
    _loginCubit = context.read<LoginCubit>();
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;

    bool isTablet = screenWidth > 600;

    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: main_background_colour,
        body: isTablet ? mobileScreen(context, _loginCubit, _onLoginClick)
            : mobileScreen(context, _loginCubit, _onLoginClick)
    );
  }
}

Widget mobileScreen(BuildContext context, LoginCubit loginCubit , Function() onLoginClick)
{
  return SingleChildScrollView(
    child: Form(
      key: loginCubit.formkey,
      child: Container(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 90),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(right: 60.0),
                child: Image.asset(
                  AppAssets.image.img_logoname,
                ),
              ),
            ),
            Text(
              AppStrings.lblWelcome,
              style: TextStyle(
                color: Colors.black.withOpacity(1.00),
                fontSize: 14,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w200,
              ),
            ),
            SizedBox(
                height: 45),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 18),
              child: CustomTextFormField(
                controller: loginCubit.phoneNumberController,
                validator: (value)
                {
                  return isValidPhone(value);
                },
                hintText: AppStrings.lblPhoneNumber,
              ),
            ),

            SizedBox(
                height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 23,right: 23, bottom: 23),
              child: CustomTextFormField(
                controller: loginCubit.passwordController,
                validator: (value)
                {
                  return isValidPassword(value);
                },
                hintText: AppStrings.lblPassword,
                obscureTextOn: true,
              ),
            ),
            SizedBox(
                height: 35),
            Padding(
              padding: const EdgeInsets.only(right: 50,left:50),
              child: SizedBox(
                width: double.infinity,
                height:55,
                child: ElevatedButton(
                    onPressed: onLoginClick,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: primary_red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        )
                    ),
                    child: const Text(
                      AppStrings.lblLogin,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                      ),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Align(
                alignment: Alignment.center,
                child:  const Text(
                  AppStrings.lblFotgetPassword,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

