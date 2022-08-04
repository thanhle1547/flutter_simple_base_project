import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sp_util/sp_util.dart';

import 'utils/ui/system_chrome_extension.dart';

/// Bootstrap is responsible for any common setup and calls
/// [runApp] with the widget returned by [builder].
Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();

  await SpUtil.getInstance();

  await SystemChromeExtension.allowVerticalPortraitOnly();

  await SystemChromeExtension.makeSystemOverlaysDisplayedPermanently();

  runApp(await builder());
}
