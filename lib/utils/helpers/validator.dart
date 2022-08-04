import 'package:flutter_simple_base_project/core/constants/app_constants.dart';

final RegExp _nonWordPattern = RegExp(
  r'[^\d\p{L}-]+',
  multiLine: true,
  unicode: true,
);

class Validator {
  static String? validateStringBlank(String? value, String msg,
          [bool autoToLowerCase = true]) =>
      (value == null || value.isEmpty)
          ? "Vui lòng nhập ${autoToLowerCase ? msg.toLowerCase() : msg}"
          : null;

  static String? validateSelectNone(String? value, String msg,
          [bool autoToLowerCase = true]) =>
      (value == null || value.isEmpty)
          ? "Vui lòng chọn ${autoToLowerCase ? msg.toLowerCase() : msg}"
          : null;

  static String? validateBeforeSelectNone(String? value, String msg,
          [bool autoToLowerCase = true]) =>
      validateSelectNone(value, '$msg trước', autoToLowerCase);

  static String? validateStringMinimumLength(
    String? value, [
    int minimumLength = 50,
  ]) {
    final int count = value == null ? 0 : value.split(_nonWordPattern).length;

    return count < minimumLength
        ? "Bạn phải nhập ít nhất $minimumLength từ (đã nhập $count/$minimumLength từ)"
        : null;
  }

  static bool _isValidEmail(String email) =>
      RegExp(r'^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$')
          .hasMatch(email);

  static String? inputEmailValidator(String? value) {
    if (value == null || value.isEmpty) return null;

    if (!_isValidEmail(value)) return 'Email không đúng định dạng';

    return null;
  }

  static String? requiredInputEmailValidator(String? value) {
    if (value == null || value.isEmpty) return 'Email không được để trống';

    if (!_isValidEmail(value)) return 'Email không đúng định dạng';

    return null;
  }

  static String? _isValidPassword(String password) {
    return password.length < AppConst.minPasswordLength
        ? "Mật khẩu phải phải nhiều hơn ${AppConst.minPasswordLength - 1} ký tự"
        : null;
  }

  static String? inputPasswordValidator(String? value) {
    if (value == null || value.isEmpty) return 'Mật khẩu không được để trống';

    return _isValidPassword(value);
  }
}
