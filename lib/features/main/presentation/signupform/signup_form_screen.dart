import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_zen/core/localization/app_strings.dart';
import 'package:news_zen/core/theme/colors.dart';
import 'package:news_zen/core/utils/app_assets.dart';
import 'package:news_zen/core/utils/validation_functions.dart';
import 'package:news_zen/core/widgets/custom_text_form_field.dart';
import 'package:news_zen/features/main/presentation/signupform/bloc/signup_cubit.dart';

class SignupFormScreen extends StatefulWidget {
  const SignupFormScreen({super.key});

  @override
  State<SignupFormScreen> createState() => _SignupFormScreenState();
}

class _SignupFormScreenState extends State<SignupFormScreen> {
  late final SignupCubit _signupCubit;

  void _onsignupClick() {
    _signupCubit.validateInput(context);
  }

  @override
  void initState() {
    super.initState();
    _signupCubit = context.read<SignupCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: main_background_colour,
      body: SingleChildScrollView(
        child: Form(
          key: _signupCubit.signupformkey,
          child: Container(
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 90,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 50.0),
                  child: Image.asset(
                    AppAssets.image.img_logoname,
                  ),
                ),
                Text(
                  AppStrings.lblWelcomeSignup,
                  style: TextStyle(
                    color: Colors.black.withOpacity(1.00),
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 23.0, vertical: 18),
                  child: CustomTextFormField(
                    controller: _signupCubit.emailController,
                    validator: (value) {
                      return isValidEmail(value);
                    },
                    hintText: AppStrings.lblEmail,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 23.0, vertical: 18),
                  child: CustomTextFormField(
                    controller: _signupCubit.usernameController,
                    validator: (value) {
                      return isEmptyErrorMessage(value);
                    },
                    hintText: AppStrings.lblUsername,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 23.0, vertical: 18),
                  child: CustomTextFormField(
                    controller: _signupCubit.passwordController,
                    validator: (value) {
                      return isValidPassword(value);
                    },
                    hintText: AppStrings.lblPassword,
                    obscureTextOn: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 23.0, vertical: 18),
                  child: CustomTextFormField(
                    controller: _signupCubit.confirmpasswordController,
                    validator: (value) {
                      return arePasswordsSame(
                          _signupCubit.passwordController.text.trim(), value);
                    },
                    hintText: AppStrings.lblConfirmPassword,
                    obscureTextOn: true,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                  child: SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                        onPressed: _onsignupClick,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primary_red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            )),
                        child: const Text(
                          AppStrings.lblRegister,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600,
                          ),
                        )),
                  ),
                ),
                Text(
                  AppStrings.lblAlreadyHaveanAccount,
                  style: TextStyle(
                    color: Colors.black.withOpacity(1.00),
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
