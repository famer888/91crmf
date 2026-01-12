import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jycrpj/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jycrpj/ui_layer/router/paths.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/general_banner.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_app_bar.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:jycrpj/ui_layer/screens/image_paths.dart';
import 'package:jycrpj/ui_layer/screens/theme.dart';
import 'package:provider/provider.dart';

import '../../../report/ui_layer/report_general_banner.dart';

import '../../../report/ui_layer/report_gesture_detector.dart';

class AiServerScreen extends StatefulWidget {
  const AiServerScreen({super.key});

  @override
  State<AiServerScreen> createState() => _AiServerScreenState();
}

class _AiServerScreenState extends State<AiServerScreen> {
  @override
  Widget build(BuildContext context) {
    final config = context.read<HomeConfigNotifier>().config;
    final banners = config.aiNav.ads;
    final navs = config.aiNav.nav;

    return ScreenBackground(
      appBg: MyImage.asset(MyImagePaths.appBg, fit:BoxFit.cover, width: ScreenUtil().screenWidth, height: 148.w),
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
            child: Column(
              children: [
                SizedBox(height: 20.w),
                ReportGeneralAppsListVidget(data: banners),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: navs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.w),
                      child: ReportGestureDetector(
                          onTap: () {
                            //跳转各个ai功能
                            _onTapAiFunction(navs[index].type);
                          },
                          child: AspectRatio(
                            aspectRatio: 350 / 108,
                            child: MyImage.network(
                              navs[index].icon,
                              fit: BoxFit.cover,
                              // borderRadius: 10.w,
                            ),
                          )),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTapAiFunction(int type) {
    switch (type) {
      case 1:
        //跳转AI魔法
        context.push(AppRouterPaths.aiMagic);
        break;
      case 2:
        //跳转AI去衣
        context.push(AppRouterPaths.aiOffDeRobe);
        break;
      case 3:
        //跳转AI接吻
        context.push(AppRouterPaths.aiKiss);
        break;
      case 4:
        //跳转AI换脸
        context.push(AppRouterPaths.aiFaceSwap);
        break;
      case 5:
        //跳转AI小说
        context.push(AppRouterPaths.aiNovel);
        break;
      case 6:
        //跳转AI语音
        context.push(AppRouterPaths.aiAudio);
        break;
      case 7:
        //跳转视频换脸
        context.push(AppRouterPaths.aiVideoFaceSwap);
        break;
      case 8:
        //跳转AI绘画
        context.push(AppRouterPaths.aiArt);
        break;
    }
  }
}
