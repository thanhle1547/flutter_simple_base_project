import 'dart:convert' show JsonCodec, utf8;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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
  late final List<Map<String, dynamic>> jsonArray;
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
      final effectiveResponse =
          response is! String ? response : _jsonCodec.decode(response);
      json =
          effectiveResponse is Map ? Map.castFrom(effectiveResponse) : const {};
      jsonArray = effectiveResponse is List
          ? List.castFrom(effectiveResponse)
          : const [];
      error = json['error'] == null ? null : Error.fromJson(json['error']);
    } catch (e) {
      error = Error(
        code: AppErrorCode.jsonDecodeError,
        messages: e.toString(),
      );
    }
  }

  /// If the response is a string and larger than 50 KB,
  /// the decoding process is delegated to an isolate
  /// to avoid jank on the main thread.
  static Future<RequestResponse> parseJsonIsolate(
    dynamic response,
    int? code,
    dynamic headers,
  ) async {
    if (response is String) {
      final lengthInBytes = utf8.encode(response).length;

      // 50 KB of data should take 2-3 ms to parse on a Moto G4, and about
      // 400 μs on a Pixel 4.
      //
      // For strings larger than 50 KB, run the computation in an isolate to
      // avoid causing main thread jank.
      if (lengthInBytes >= 50 * 1024) {
        return RequestResponse(
          await compute(_jsonCodec.decode, response),
          code,
          headers,
        );
      }
    }

    return RequestResponse(response, code, headers);
  }

  static Future<RequestResponse> fromDioResponse(
    Response response, {
    int defaultStatusCode = StatusCode.ok,
  }) {
    return parseJsonIsolate(
      response.data,
      response.statusCode ?? defaultStatusCode,
      response.headers,
    );
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
