import 'package:dio/dio.dart';
import 'package:flutter_simple_base_project/core/constants/app_constants.dart';
import 'package:flutter_simple_base_project/data/api_client.dart';
import 'package:flutter_simple_base_project/data/models/status_code.dart';
import 'package:flutter_simple_base_project/data/services/auth_service.dart';
import 'package:flutter_simple_base_project/utils/helpers/system_utils.dart';

class TokenInterceptor extends InterceptorsWrapper {
  TokenInterceptor() : authService = AuthService();

  final AuthService authService;

  int _times = 1;

  @override
  void onError(
    DioError err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == StatusCode.unauthorized &&
        _times <= AppConst.refetchApiThreshold) {
      try {
        _times++;
        SystemUtils.debugLog('TokenInterceptor', _times.toString());
        await authService.refreshToken();
      } catch (e) {
        handler.reject(DioError(
          requestOptions: err.requestOptions..data = e,
        ));
        return;
      }

      handler.resolve(
          await ApiClient().fetchWithRequestOptions(err.requestOptions));
    } else {
      if (_times > AppConst.refetchApiThreshold) {
        _times = 1;
        handler.resolve(Response(
          requestOptions: err.requestOptions..data = err.response,
        ));
        authService.notifyTokenChanged();
      } else {
        _times = 1;
        handler.next(err);
      }
    }
  }
}
