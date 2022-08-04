abstract class AppException implements Exception {
  final String? message;
  final String? from;

  AppException(this.message, this.from);
}

class UnhandledException extends AppException {
  UnhandledException([String? message, String? from])
      : super(message ?? 'Unkown', from);

  @override
  String toString() {
    return '''
UnhandledException: $message
              from: $from
''';
  }
}

class DataNotFoundException extends AppException {
  DataNotFoundException(String message, [String? from]) : super(message, from);

  /*
  static DataNotFoundException whereValueOfFieldBuilder<T extends Object>({
    required String fieldName,
    required Object? value,
    String? source,
  }) =>
      DataNotFoundException(
        "${T.toString()}.$fieldName == $value",
        source == null ? null : "${T.toString()}.$source",
      );
  */

  @override
  String toString() {
    return '''
DataNotFoundException: $message not found
                 from: $from
''';
  }
}

class InternalServerErrorException extends AppException {
  InternalServerErrorException([String? message, String? from])
      : super(message, from);

  @override
  String toString() {
    return '''
InternalServerException: $message
                   from: $from
''';
  }
}

class NoConnectionException extends AppException {
  NoConnectionException([String? message, String? from]) : super(message, from);

  @override
  String toString() {
    return '''
NoConnectionException: $message
                 from: $from
''';
  }
}

class PoorConnectionException extends AppException {
  PoorConnectionException([String? message, String? from])
      : super(message, from);

  @override
  String toString() {
    return '''
PoorConnectionException: $message
                   from: $from
''';
  }
}

class DataParsingException extends AppException {
  DataParsingException(String message, [String? from]) : super(message, from);

  @override
  String toString() {
    return '''
DataParsingException: $message
                from: $from
''';
  }
}

class IncorrectJsonFormatException implements Exception {
  @override
  String toString() => 'IncorrectJsonFormatException: Định dạng Json sai';
}

class DataMappingException extends AppException {
  DataMappingException(String message, [String? from]) : super(message, from);

  @override
  String toString() {
    return '''
DataMappingException: $message
                from: $from
''';
  }
}

class FileNotFoundException implements Exception {
  @override
  String toString() => 'Không tìm thấy file!';
}

class SystemOutOfMemoryToSaveFileException implements Exception {}

class PermissionDeniedException implements Exception {
  final String message;

  PermissionDeniedException(this.message);

  @override
  String toString() => "Permission denied: $message";
}
