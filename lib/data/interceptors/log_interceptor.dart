import 'package:dio/dio.dart';
import 'package:flutter_simple_base_project/utils/helpers/system_utils.dart';

const _source = 'LogInterceptor';

class LogInterceptor extends InterceptorsWrapper {
  static List<Map> sHttpResponses = [];
  static List<String> sResponsesHttpUrl = [];

  static List<Map<String, dynamic>> sHttpRequest = [];
  static List<String> sRequestHttpUrl = [];

  static List<Map<String, dynamic>> sHttpError = [];

  static List<String> sHttpErrorUrl = [];

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    super.onRequest(options, handler);

    SystemUtils.debugLog(
      _source,
      '''
      URL: ${options.path}
      Method: ${options.method}
      header: ${options.headers}
      body/query: ${options.data}
    ''',
    );

    try {
      addLogic(sRequestHttpUrl, options.path);

      var data = options.data ?? {};

      var map = {
        "header": {...options.headers},
      };

      if (options.method == "POST") map["data"] = options.data;

      addLogic(sHttpRequest, data);
    } catch (e) {
      SystemUtils.debugLog(_source, e.toString());
    }
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);

    SystemUtils.debugLog(
      _source,
      '''
      Error: ${err.toString()}
      Error response: ${err.response?.toString()}
    ''',
    );

    try {
      addLogic(sHttpErrorUrl, err.requestOptions.path);
      var errors = {};
      errors["error"] = err.message;
      addLogic(sHttpError, errors);
    } catch (e) {
      SystemUtils.debugLog(_source, e.toString());
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
    SystemUtils.debugLog(
      _source,
      '''
      Response: ${response.requestOptions.path}
      ${response.toString()}
    ''',
    );

    // ignore: prefer_typing_uninitialized_variables
    late var data;
    try {
      if (response.data is Map ||
          response.data is List ||
          response.data is String) {
        data = {};
        data["data"] = response.data;
      } else if (response.data != null) {
        data = response.data.toRecruiterJson(); // type String
      }
    } catch (e) {
      SystemUtils.debugLog(_source, e.toString());
    }

    addLogic(
      sResponsesHttpUrl,
      response.requestOptions.uri.toString(),
    );
    addLogic(sHttpResponses, data);
  }

  static addLogic(List list, data) {
    if (list.length > 20) {
      SystemUtils.debugLog(_source, list.toString());
      list.removeAt(0);
    }

    list.add(data);
  }
}
