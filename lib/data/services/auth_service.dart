import 'package:flutter_simple_base_project/core/app_authentication.dart';
import 'package:sp_util/sp_util.dart';

const String _userInfoKey = 'user_info';

class AuthService {
  static AuthService? _instance;

  factory AuthService() => _instance ??= AuthService._();

  AuthService._() {
    AppAuthenticationBinding.initInstance();
  }

  Future<void> refreshToken() async {
    try {
      // call api
    } catch (e) {
      rethrow;
    }
  }

  void notifyTokenChanged() =>
      AppAuthenticationBinding.instance!.notifyTokenChanged();

  void _saveInfo({Map<String, dynamic>? info}) {
    SpUtil.putObject(_userInfoKey, info ?? {});
  }
}
