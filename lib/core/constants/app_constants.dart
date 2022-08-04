class AppConst {
  static const String appName = '';

  // UI

  static const String robotoFont = 'Roboto';

  static const int otpLength = 6;

  static const int minPasswordLength = 6;

  // Api

  static const int refecthApiThreshold = 3;

  static const int limitOfListDataLengthForEachRequest = 20;

  static const Duration timesToFetchCommonDataAgain = Duration(days: 7);

  static const int inputDebounceTimeInMilliseconds = 440;

  static const int nextPageThreshold = 3;
}
