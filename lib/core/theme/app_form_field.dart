import 'package:flutter/material.dart';

import 'app_border_and_radius.dart';
import 'app_padding.dart';
import 'app_text_styles.dart';

class AppFormField {
  static const InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    hintStyle: AppTextStyles.hintText,
    errorMaxLines: 2,
    contentPadding: AppPad.formFieldContent,
    border: AppBorderAndRadius.shadowInputBorder,
    enabledBorder: AppBorderAndRadius.shadowInputBorder,
    disabledBorder: AppBorderAndRadius.shadowInputDisabledBorder,
    focusedBorder: AppBorderAndRadius.shadowInputFocusedBorder,
    errorBorder: AppBorderAndRadius.shadowInputErrorBorder,
    focusedErrorBorder: AppBorderAndRadius.shadowInputErrorBorder,
    filled: true,
    fillColor: Colors.white,
    floatingLabelBehavior: FloatingLabelBehavior.never,
  );

  static const InputDecoration shadowInputDecoration = InputDecoration(
    hintStyle: AppTextStyles.hintText,
    errorMaxLines: 2,
    contentPadding: AppPad.formFieldContent,
    border: AppBorderAndRadius.shadowInputBorder,
    enabledBorder: AppBorderAndRadius.shadowInputBorder,
    disabledBorder: AppBorderAndRadius.shadowInputDisabledBorder,
    focusedBorder: AppBorderAndRadius.shadowInputFocusedBorder,
    errorBorder: AppBorderAndRadius.shadowInputErrorBorder,
    focusedErrorBorder: AppBorderAndRadius.shadowInputErrorBorder,
    filled: true,
    fillColor: Colors.white,
    floatingLabelBehavior: FloatingLabelBehavior.never,
  );

  static const InputDecoration multilineShadowInputDecoration = InputDecoration(
    hintStyle: AppTextStyles.hintText,
    errorMaxLines: 2,
    contentPadding: AppPad.a16,
    border: AppBorderAndRadius.shadowInputBorder,
    enabledBorder: AppBorderAndRadius.shadowInputBorder,
    disabledBorder: AppBorderAndRadius.shadowInputDisabledBorder,
    focusedBorder: AppBorderAndRadius.shadowInputFocusedBorder,
    errorBorder: AppBorderAndRadius.shadowInputErrorBorder,
    focusedErrorBorder: AppBorderAndRadius.shadowInputErrorBorder,
    filled: true,
    fillColor: Colors.white,
    floatingLabelBehavior: FloatingLabelBehavior.never,
  );
}
