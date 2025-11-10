import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_submit_app/controllers/utils/app_textstyles.dart';
import 'package:form_submit_app/view/screens/authentication/login_screen.dart';
import 'package:form_submit_app/view/widgets/custom_field.dart';
import 'package:get/get.dart';

import '../../../controllers/utils/app_extension.dart';
import '../../widgets/custom_button.dart';

// ignore: must_be_immutable
class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});
  GlobalKey<FormState> formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    Size mediaQuerySize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: mediaQuerySize.height * 0.015.h,
            horizontal: mediaQuerySize.width * 0.03.w,
          ),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(height: mediaQuerySize.height * 0.06.h),
                Center(
                  child: Text(
                    'Forgot Password',
                    style: AppTextstyles.BoldBlackText(),
                  ),
                ),
                SizedBox(height: mediaQuerySize.height * 0.02.h),
                Text(
                  'Enter your Email Address to receive ',
                  style: AppTextstyles.SimpleBlackText(),
                ),
                SizedBox(height: mediaQuerySize.height * 0.01.h),
                Text(
                  'a password reset link. ',
                  style: AppTextstyles.SimpleBlackText(),
                ),
                SizedBox(height: mediaQuerySize.height * 0.03.h),
                CustomField(
                  text: 'Email',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter the email field';
                    }

                    if (!AppExtension.emailExtension.hasMatch(value.trim())) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: mediaQuerySize.height * 0.03.h),
                CustomButton(
                  width: mediaQuerySize.width * 0.9.w,
                  name: 'Send Reset Link',
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      // Get.to(() => EditProfileOne());
                    }
                  },
                ),
                SizedBox(height: mediaQuerySize.height * 0.03.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Remember Password?',
                      style: AppTextstyles.simpleGreyText(),
                    ),
                    Row(
                      children: [
                        Text(
                          '  Back to',
                          style: AppTextstyles.simpleGreyText(),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.to(() => LoginScreen());
                            // Get.to(() => EditProfileOne());
                          },
                          child: Text(
                            'Log in',
                            style: AppTextstyles.simpleRedText(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
