import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../controllers/utils/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String name;
  Color color;
  TextStyle textStyle;
  Function()? onTap;
  final double width;
  final bool isEnabled;
  bool isLoading;

  CustomButton({
    super.key,
    required this.name,
    this.isLoading = false,
    this.color = AppColors.buttonColor,
    this.textStyle = const TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    this.onTap,
    this.width = 300,
    this.isEnabled = false,
  });

  @override
  Widget build(BuildContext context) {
    Size mediaQuerySize = MediaQuery.of(context).size;
    return Container(
      height: mediaQuerySize.height * 0.07,
      width: width,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.buttonColor),
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: isLoading
          ? SpinKitThreeInOut(color: AppColors.whiteColor, size: 35)
          : TextButton(
              onPressed: onTap,
              child: Text(name, style: textStyle),
            ),
    );
  }
}
