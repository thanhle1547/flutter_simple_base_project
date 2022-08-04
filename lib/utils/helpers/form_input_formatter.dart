import 'package:flutter/services.dart';

import 'string_extension.dart';

class FormInputFormatter {
  static final List<TextInputFormatter> fullNameInputFormatters = [
    _FullNameInputFormatter(),
  ];

  static final List<TextInputFormatter> phoneNumberInputFormatters = [
    FilteringTextInputFormatter.allow(RegExp(r'[0-9\.-]')),
  ];

  static final List<TextInputFormatter> currencyInputFormatters = [
    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
  ];
}

class _FullNameInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(
      text: newValue.text.capitalizeEachWords,
    );
  }
}
