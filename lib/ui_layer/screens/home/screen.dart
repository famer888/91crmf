import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/app_global.dart';
import 'package:provider/provider.dart';

import '../../notifiers/home_config_notifier.dart';
import '../common_widgets/my_image.dart';
import '../common_widgets/screen_background.dart';
import '../common_widgets/top_navi_view.dart';
import '../common_widgets/search_app_bar.dart';
import '../image_paths.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final homeConfigNotifier = context.read<HomeConfigNotifier>();
  late final id = homeConfigNotifier.config.navId;

  @override
  Widget build(BuildContext context) {
    AppGlobal.context = context;
    return ScreenBackground(
      appBg: MyImage.asset(MyImagePaths.appBg, width: ScreenUtil().screenWidth, height: 148.w),
      child: Scaffold(
        appBar: const SearchAppBar(),
        body: TopNaviView(id: id),
      ),
    );
  }
}
