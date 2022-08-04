import 'dart:convert' show JsonCodec;

import 'package:flutter_simple_base_project/core/constants/app_error_code.dart';
import 'package:flutter_simple_base_project/core/constants/string_constant.dart';
import 'package:flutter_simple_base_project/utils/helpers/system_utils.dart';

import 'error.dart';
import 'status_code.dart';

const _jsonCodec = JsonCodec();

const String _source = 'RequestResponse';

class RequestResponse {
  final dynamic response;
  late final Map<String, dynamic> json;
  final int? code;
  final dynamic headers;
  Error? error;

  bool get result {
    try {
      return json['result'] ?? false;
    } catch (e) {
      throw _buildJsonErrorMessage(e, 'result');
    }
  }

  Map<String, dynamic> get data {
    try {
      return code == StatusCode.notFound ? {} : json['data'];
    } catch (e) {
      throw _buildJsonErrorMessage(e, 'data');
    }
  }

  List<dynamic> get items {
    try {
      return code == StatusCode.notFound ? [] : data['items'] ?? [];
    } catch (e) {
      throw _buildJsonErrorMessage(e, 'items');
    }
  }

  int get totalRecords {
    try {
      return data['total'] is String ? int.parse(data['total']) : data['total'];
    } catch (e) {
      throw _buildJsonErrorMessage(e, 'total');
    }
  }

  bool get hasData => json['data'] != null;

  bool get hasError => error != null;

  RequestResponse(this.response, this.code, this.headers) {
    try {
      json = response is String
          ? _jsonCodec.decode((response as String).trim())
          : response is Map
              ? response
              : {};
      error = json['error'] == null ? null : Error.fromJson(json['error']);
    } catch (e) {
      error = Error(
        code: AppErrorCode.jsonDecodeError,
        messages: e.toString(),
      );
    }
  }

  static Map<String, dynamic> parseResponseDataString(String str) =>
      RequestResponse(str, StatusCode.ok, null).data;

  _buildJsonErrorMessage(Object e, String key) {
    if (error != null) return error!.messages;

    if (e.runtimeType.toString().contains('_TypeError')) {
      SystemUtils.debugLog(
        _source,
        '''
${e.toString()}
==> Response json did not contain key: $key
    reponse data: ${response.toString()}
''',
      );
    }

    if (e is NoSuchMethodError) {
      SystemUtils.debugLog(
        _source,
        '''
NoSuchMethodError: The method '[]' was called on null
==> Response json did not contain key: $key
    reponse data: ${response.toString()}
''',
      );

      return StringConst.errorHappenedTryAgain;
    }

    return e.toString();
  }
}
