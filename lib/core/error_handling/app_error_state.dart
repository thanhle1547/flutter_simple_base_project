// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:dio/dio.dart';

import 'exceptions.dart';

enum AppErrorState {
  lostConnection,
  poorConnection,
  serverDataResponseStructureChanged,
  serverDataResponseStructureError,
  lookupServerFailure,
  systemOutOfMemoryToSaveFile,
  unkownn,
}

final _incorrectFormatRegex = RegExp(
  '(FormatException: '
  'Unexpected character'
  '|'
  'IncorrectJsonFormatException'
  '|'
  'DataParsingException'
  ')',
);

extension AppErrorStateExt on AppErrorState {
  String get friendlyMessage {
    switch (this) {
      case AppErrorState.lostConnection:
        return 'Không có kết nối mạng.';
      case AppErrorState.poorConnection:
        return 'Kết nối mạng kém.';
      case AppErrorState.serverDataResponseStructureChanged:
        return 'Có vẻ như ứng dụng cần được cập nhật '
            'phiên bản mới để phản ánh những thay đổi ở phía chúng tôi.';
      case AppErrorState.lookupServerFailure:
      case AppErrorState.serverDataResponseStructureError:
        return 'Có vẻ như đã có sự cố xảy ra ở phía chúng tôi, '
            'vui lòng thử lại sau.';
      case AppErrorState.systemOutOfMemoryToSaveFile:
        return 'Thiết bị của bạn không còn '
            'đủ bộ nhớ để tải xuống tệp này.';
      case AppErrorState.unkownn:
        return 'Đã có lỗi xảy ra, vui lòng thử lại sau.';
    }
  }

  static String getFriendlyErrorString(
    Object e, {
    bool rethrowUnhandled = false,
  }) {
    if (e is String) {
      if (e.startsWith(_incorrectFormatRegex)) {
        return AppErrorState.serverDataResponseStructureError.friendlyMessage;
      }

      return e;
    }

    return AppErrorStateExt.getAppErrorState(
      e,
      rethrowUnhandled: rethrowUnhandled,
    ).friendlyMessage;
  }

  static AppErrorState getAppErrorState(
    Object e, {
    bool rethrowUnhandled = false,
  }) {
    if (e is NoConnectionException) return AppErrorState.lostConnection;
    if (e is PoorConnectionException) return AppErrorState.poorConnection;
    if (e is InternalServerErrorException)
      return AppErrorState.lookupServerFailure;
    if (e is DataParsingException || e is IncorrectJsonFormatException)
      return AppErrorState.serverDataResponseStructureError;
    if (e is SystemOutOfMemoryToSaveFileException)
      return AppErrorState.systemOutOfMemoryToSaveFile;
    if (e is DioError && e.message.contains('SocketException'))
      return AppErrorState.lostConnection;

    if (rethrowUnhandled) throw e;

    return AppErrorState.unkownn;
  }
}
