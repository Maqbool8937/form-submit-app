import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextstyles {
  static TextStyle simpleTextBold() {
    return TextStyle(
      fontFamily: 'medium',
      color: AppColors.whiteColor,
      fontSize: 16,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle simpleText() {
    return TextStyle(
      fontFamily: 'regular',
      color: AppColors.whiteColor,
      fontSize: 14,
    );
  }

  static TextStyle simpleGreyText() {
    return TextStyle(
      fontFamily: 'regular',
      color: AppColors.greyColor,
      fontSize: 16,
    );
  }

  static TextStyle BoldBlackText() {
    return TextStyle(
      color: AppColors.blackColor,
      fontSize: 22,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle simpleRedText() {
    return TextStyle(
      fontFamily: 'medium',
      color: AppColors.buttonColor,
      fontSize: 18,
    );
  }

  static TextStyle SimpleBlackText() {
    return TextStyle(
      color: AppColors.greyColor,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle FullBlackBoldText() {
    return TextStyle(
      fontFamily: 'bold',
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: AppColors.fullBlackColor,
    );
  }
}
