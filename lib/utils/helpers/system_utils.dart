import 'dart:async';
import 'dart:developer' show log;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_simple_base_project/core/error_handling/exceptions.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SystemUtils {
  static Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  static Future<void> openUrlInBrowser(String url) => _launchUrl(url);

  static Future<void> openFile(FutureOr<String> filePath) async {
    final OpenResult result = await OpenFile.open(await filePath);

    switch (result.type) {
      case ResultType.noAppToOpen:
        throw 'Không có ứng dụng khả dụng để mở file này!';
      case ResultType.fileNotFound:
        throw FileNotFoundException();
      case ResultType.permissionDenied:
        throw PermissionDeniedException('Vui lòng cấp quyền truy cập!');
      default:
        break;
    }
  }

  static Future<String> getAppDirectory() async {
    if (Platform.isAndroid) {
      return (await getExternalStorageDirectory() ??
              await getApplicationSupportDirectory())
          .path;
    } else {
      return (await getApplicationSupportDirectory()).path;
    }
  }

  static Future<String> getDeviceTemporaryDirectory() async {
    return (await getTemporaryDirectory()).path;
  }

  static debugLog(String source, String message) {
    if (kDebugMode) log(message, name: source);
  }
}
