import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_decoration.dart';
import 'shadow_input_border.dart';

class AppBorderAndRadius {
  static const Radius defaultRadius = Radius.circular(15);

  static const Radius formRadius = defaultRadius;

  static const BorderRadius defaultBorderRadius =
      BorderRadius.all(defaultRadius);

  static const BorderRadius formBorderRadius = defaultBorderRadius;

  static const OutlineInputBorder shadowInputDisabledBorder = ShadowInputBorder(
    borderRadius: formBorderRadius,
    boxShadow: AppDecoration.formShadow,
  );

  static const OutlineInputBorder shadowInputFocusedBorder = ShadowInputBorder(
    borderSide: BorderSide(color: AppColors.primary, width: 0.5),
    borderRadius: formBorderRadius,
    boxShadow: AppDecoration.formShadow,
  );

  static const OutlineInputBorder shadowInputErrorBorder = ShadowInputBorder(
    borderSide: BorderSide(color: AppColors.error, width: 0.5),
    borderRadius: formBorderRadius,
    boxShadow: AppDecoration.formShadow,
  );

  static const OutlineInputBorder shadowInputBorder = ShadowInputBorder(
    borderSide: BorderSide.none,
    borderRadius: formBorderRadius,
    boxShadow: AppDecoration.formShadow,
  );
}
