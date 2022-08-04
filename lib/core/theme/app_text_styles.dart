import 'package:flutter/material.dart';
import 'package:flutter_simple_base_project/core/constants/app_constants.dart';

import 'app_colors.dart';

class AppTextStyles {
  static const TextStyle appbarTitle = TextStyle(
    // fontFamily: AppConst.robotoFont,
    color: AppColors.primary,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  // Button

  static const TextStyle button = TextStyle(
    // fontFamily: AppConst.robotoFont,
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle textButton = TextStyle(
    // fontFamily: AppConst.robotoFont,
    color: AppColors.primary,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  // Form

  static const TextStyle formTitle = TextStyle(
    // fontFamily: AppConst.robotoFont,
    color: AppColors.formTitle,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle formFieldLabel = TextStyle(
    // fontFamily: AppConst.robotoFont,
    color: AppColors.formFieldLabel,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle hintText = TextStyle(
    // fontFamily: AppConst.robotoFont,
    color: AppColors.hintText,
    fontSize: 13,
    fontWeight: FontWeight.w400,
  );

  // Text

  static const TextStyle text = TextStyle(
    // fontFamily: AppConst.robotoFont,
    color: AppColors.text,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  // Intro

  static const TextStyle introDescription = text;
}
