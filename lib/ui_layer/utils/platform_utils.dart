import 'package:flutter/foundation.dart';
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

  static bool get isPwaStandalone {
    if (!kIsWeb) return false;

    final isDisplayModeStandalone = html.window.matchMedia('(display-mode: standalone)').matches;
    final isNavigatorStandalone = (html.window.navigator as dynamic).standalone == true;
    return isDisplayModeStandalone || isNavigatorStandalone;
  }

  static bool get isIosPwa => isIosWeb && isPwaStandalone;
}
