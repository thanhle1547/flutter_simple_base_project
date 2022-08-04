import 'package:flutter/material.dart';

import 'app_border_and_radius.dart';
import 'app_colors.dart';

class AppDecoration {
  static const formDecocationShadow = BoxDecoration(
    color: Colors.white,
    borderRadius: AppBorderAndRadius.formBorderRadius,
    boxShadow: formShadow,
  );

  static const formShadow = [
    BoxShadow(
      offset: Offset(0, -2),
      blurRadius: 15,
      color: AppColors.formShadow,
    ),
  ];
}
