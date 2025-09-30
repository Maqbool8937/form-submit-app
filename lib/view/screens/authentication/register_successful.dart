import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_submit_app/controllers/utils/app_textstyles.dart';
import 'package:get/get.dart';

import '../../widgets/custom_button.dart';
import 'login_screen.dart';

class RegisterSuccessfull extends StatelessWidget {
  const RegisterSuccessfull({super.key});

  @override
  Widget build(BuildContext context) {
    Size mediaQuerySize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: mediaQuerySize.width * 0.15.w,
            vertical: mediaQuerySize.height * 0.03.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: mediaQuerySize.height * 0.1.h),
              Center(
                child: Container(
                  height: mediaQuerySize.height * 0.15.h,
                  width: mediaQuerySize.width * 0.2.w,
                  decoration: BoxDecoration(
                    // color: AppColors.buttonColor,
                    image: DecorationImage(
                      image: AssetImage('assets/images/Vector (1).png'),
                    ),
                  ),
                  child: Icon(Icons.check, color: Colors.white, size: 40),
                ),
              ),
              Text(
                'Registration Successful!',
                style: AppTextstyles.BoldBlackText(),
              ),
              SizedBox(height: mediaQuerySize.height * 0.008.h),
              Text(
                'Your account is awaiting admin approval. You will receive a notification once your profile is activated. ',
                style: AppTextstyles.simpleGreyText(),
              ),
              SizedBox(height: mediaQuerySize.height * 0.03.h),
              CustomButton(
                onTap: () {
                  Get.to(() => LoginScreen());
                },
                width: mediaQuerySize.width * 0.9.w,
                name: 'Continue',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
