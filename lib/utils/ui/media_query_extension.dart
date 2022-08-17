import 'package:flutter/widgets.dart';

extension MediaQueryExt on BuildContext {
  MediaQueryData get mediaQueryData => MediaQuery.of(this);

  double get screenWidth => mediaQueryData.size.width;

  double get screenHeight => mediaQueryData.size.height;

  double get textScaleFactor => mediaQueryData.textScaleFactor;

  /// The parts of the display that are partially obscured by system UI,
  /// typically by the hardware display "notches" or the system status bar.
  double get viewPaddingTop => mediaQueryData.viewPadding.top;

  /// The parts of the display that are partially obscured by system UI,
  /// typically by the hardware display "notches" or the system status bar.
  double get viewPaddingBottom => mediaQueryData.viewPadding.bottom;
}
