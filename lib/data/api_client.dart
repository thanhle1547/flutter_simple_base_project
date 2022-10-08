import 'dart:collection';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_simple_base_project/core/constants/api_path.dart';
import 'package:flutter_simple_base_project/core/constants/app_constants.dart';
import 'package:flutter_simple_base_project/core/error_handling/exceptions.dart';
import 'package:flutter_simple_base_project/utils/helpers/system_utils.dart';

import 'interceptors/token_interceptor.dart';
import 'models/request_method.dart';
import 'models/request_response.dart';
import 'models/status_code.dart';
import 'services/connectivity_service.dart';

const _exceptionCanResolveByReFetch = [
  'HttpException: Connection closed before full header was received',
  'HandshakeException: Connection terminated during handshake',
  'Connecting timed out',
  'Receiving data timeout',
];

bool _shouldReFetch(DioError e, int retryTimes) {
  return _exceptionCanResolveByReFetch.any((el) => e.message.contains(el)) &&
      retryTimes <= AppConst.refetchApiThreshold;
}

final _baseOptions = BaseOptions(
  connectTimeout: 10000,
  receiveTimeout: 10000,
  baseUrl: ApiPath.baseUrl,
  responseType: ResponseType.json,
);

class ApiClient {
  late final Dio _dio;

  static ApiClient? _instance;

  factory ApiClient() => _instance ??= ApiClient._();

  ApiClient._()
      : _dio = Dio(_baseOptions)
          ..interceptors.addAll([
            // LogInterceptor(),
            // AwesomeDioInterceptor(),
            // PrettyDioLogger(),
            TokenInterceptor(),
          ]);

  /// [Eng]
  ///
  /// [asyncDataGetter]
  ///
  /// Used to avoid some cases (below) when the data containing [MultipartFile]
  ///
  ///   - Bad network ⇒ retry calling API, but Dio throws:
  /// `Bad state: Can't finalize a finalized MultipartFile`
  ///
  ///   - After running `Hot Reload`
  ///
  /// [token] (bearer tokens) will be put in `Authorization` header if
  /// [headers] did not contain `Authorization`
  ///
  /// See: Bearer Authentication (token authentication)
  ///
  /// ---
  ///
  /// [Vie]
  ///
  /// [asyncDataGetter] dùng trong trường hợp dữ liệu được gửi lên server
  /// bao gồm [MultipartFile]
  ///
  /// Tác dụng: Tránh 1 số tình trạng như
  ///
  ///   - Mạng kém ⇒ phải gọi lại api 1 lần nữa, nhưng lại xảy ra lỗi:
  /// `Bad state: Can't finalize a finalized MultipartFile`
  ///
  ///   - Sau khi chạy `Hot Reload`
  ///
  /// [token] (bearer tokens) sẽ được đặt vào trong `Authorization` header
  /// nếu như [headers] không có `Authorization`
  ///
  /// Xem: Bearer Authentication (token authentication)
  Future<RequestResponse> fetch(
    String url,
    RequestMethod method, {
    Map<String, dynamic>? data,
    Future<Map<String, dynamic>> Function()? asyncDataGetter,
    Map<String, String>? searchParams,
    Map<String, dynamic>? headers,
    Options? options,
    String? token,
  }) async {
    assert(
      data == null || asyncDataGetter == null,
      '[Eng] Only using [data] or [asyncDataGetter]\n'
      '[Vie] Chỉ dùng 1 trong 2 trường [data] hoặc [asyncDataGetter]',
    );

    SystemUtils.debugLog('ApiClient', url);

    headers ??= HashMap();

    if (options == null) {
      options = method.options;
    } else {
      options.method = method.name;
    }

    if (token != null) {
      headers.putIfAbsent('Authorization', () => "Bearer $token");
    }

    options.headers = headers;
    options.contentType ??= headers.containsKey('Authorization')
        ? ContentType('application', 'x-www-form-urlencoded', charset: "utf-8")
            .mimeType
        : ContentType.json.mimeType;

    Response response;
    int retryTimes = 1;

    while (true) {
      try {
        final Map<String, dynamic>? effectiveData =
            data ?? await asyncDataGetter?.call();

        response = await _dio.request(
          url,
          data: method == RequestMethod.post && effectiveData != null
              ? FormData.fromMap(effectiveData)
              : effectiveData,
          queryParameters: searchParams,
          options: options,
        );

        break;
      } on DioError catch (e) {
        if (_shouldReFetch(e, retryTimes)) {
          retryTimes++;
          continue;
        }

        throw await _requestFailure(e, retryTimes);
      }
    }

    return RequestResponse.fromDioResponse(response);
  }

  Future<Response> fetchWithRequestOptions(RequestOptions options) =>
      _dio.request(
        options.path,
        data: options.data,
        options: Options(
          method: options.method,
          headers: options.headers,
        ),
      );

  /// [Eng]
  ///
  /// [savePath] is the path to the folder (e.g `library/download/`) + the name
  /// of the file (e.g `xs.jpg`)
  ///
  /// ---
  ///
  /// [Vie]
  ///
  /// [savePath] là đường dẫn tới thư mục (ví dụ `library/download/`) + tên
  /// của file sẽ được tạo ra (ví dụ `xs.jpg`)
  Future<dynamic> download({
    required String url,
    required String savePath,
    ProgressCallback? onReceiveProgress,
  }) async {
    Response response;
    int retryTimes = 1;

    while (true) {
      try {
        response = await _dio.download(
          url,
          savePath,
          onReceiveProgress: onReceiveProgress,
        );

        break;
      } on DioError catch (e) {
        if (_shouldReFetch(e, retryTimes)) {
          retryTimes++;
          continue;
        }

        throw await _requestFailure(e, retryTimes);
      }
    }

    return response.data;
  }

  Future<dynamic> _requestFailure(DioError e, int retryTimes) async {
    if (e.message.contains('Failed host lookup')) {
      if ((await ConnectivityService.canConnectToNetwork()) == false) {
        return NoConnectionException();
      } else {
        return InternalServerErrorException();
      }
    }

    if (retryTimes == AppConst.refetchApiThreshold) {
      return PoorConnectionException();
    }

    return e;
  }
}
