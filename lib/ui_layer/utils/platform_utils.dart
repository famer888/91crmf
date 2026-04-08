import 'package:flutter/foundation.dart';
import 'package:jycrpj/ui_layer/utils/common_utils.dart';
import 'package:universal_html/html.dart' as html;

class PlatformUtils {
  const PlatformUtils._();

  static bool get isWeb => kIsWeb;

  static bool get isIosWeb {
    if (!kIsWeb) return false;

    final navigator = html.window.navigator;
    final ua = (navigator.userAgent ?? '').toLowerCase();
    final platform = (navigator.platform ?? '').toLowerCase();
    final maxTouchPoints = navigator.maxTouchPoints ?? 0;
    return ua.contains('iphone') ||
        ua.contains('ipad') ||
        ua.contains('ipod') ||
        (platform.contains('mac') && maxTouchPoints > 1);
  }

  static bool get isIosPwa => isIosWeb && CommonUtils.isPWA();
}
