import 'package:flutter_simple_base_project/core/constants/app_constants.dart';

class TimeUtils {
  /*
  static final dateFormat = DateFormat(AppConst.datePattern);
  static final apiDateFormat = DateFormat(AppConst.apiDatePattern);
  static final timeFormat = DateFormat(AppConst.timePattern);
  */

  static tomorrow() => DateTime.now().add(const Duration(days: 1));
  static theDayAfterTomorrow() => DateTime.now().add(const Duration(days: 2));
}
