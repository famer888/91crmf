import 'package:flutter/foundation.dart';

class BuildConfig {
  static const key = kIsWeb ? '' : '2acf7e91e9864673';
  static const iv = kIsWeb ? '' : '1c29882d3ddfcfd6';
  static const appKey = kIsWeb ? '' : '5589d41f92a597d016b037ac37db243d';
  static const ver = kIsWeb ? 'v3' : 'v2';
  static const mediaKey = 'f5d965df75336270';
  static const mediaIv = '97b60394abc2fbe1';
  static const secretKey = '0cd8091ddd83a5a8';
  static const secretIv = 'c5546fcdd6f004b2';
  static const defaultFdsKey =
      'P/D/+MulHay6Jzah0AnECON76PVOS4idWjlv/W9FmBnsXsGE+wXTI/uP4UpmvvPD';

  static final apiLines = kIsWeb
      ? [
          'https://wapi.kqtwctnb.xyz/api.php',
        ]
      : [
          'https://api1.kqtwctnb.xyz/api.php',
          'https://api2.kqtwctnb.xyz/api.php',
          'https://api3.kqtwctnb.xyz/api.php',
          'https://api4.kqtwctnb.xyz/api.php',
          'https://api5.kqtwctnb.xyz/api.php',
          'https://api6.kqtwctnb.xyz/api.php',
        ];

  /// 备用线路
  static const githubLine =
      'https://raw.githubusercontent.com/ailiu258099-blip/master/main/91box.txt';

  static final fdsKeyApi = [
    'https://wvseee.jsbacjr.com/fds.txt',
    'https://gitee.com/fdsaw/ffewelmcxww/raw/master/hj.txt',
  ];

  /// 跳转webview路径
  static const webViewPathName = 'ktloadwebview';

  static const affCodeKey = '91crmf_aff';

  static const webBundleId = 'com.pwa.jycrpj';

  static const cacheKeys = (
    appBox: 'hjsqbox',
    chats: 'hjsqbox_Chats',
    videoBox: 'hjsq_video_box',
    imageBox: 'hjsqbox_ImageCache',
    imageCacheSalt: 'aQhW1oUSlY',
  );
}
