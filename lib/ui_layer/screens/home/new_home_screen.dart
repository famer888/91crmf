import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/keep_alive_wrapper.dart';
import 'package:jycrpj/ui_layer/screens/home/page/home_ads_page.dart';

import '../common_widgets/my_image.dart';
import '../common_widgets/my_tab_bar.dart';
import '../common_widgets/screen_background.dart';
import '../image_paths.dart';
import '../theme.dart';
import 'home_ads_type.dart';

class NewHomeScreen extends StatefulWidget {
  const NewHomeScreen({super.key});

  @override
  State<NewHomeScreen> createState() => _NewHomeScreenState();
}

class _NewHomeScreenState extends State<NewHomeScreen> with TickerProviderStateMixin {
  late final _screenUtil = ScreenUtil();
  late final TabController _tabController;
  final _tabs = [
    HomeAdsType.hot,
    HomeAdsType.video,
    HomeAdsType.live,
    HomeAdsType.eatingMelons,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      appBg: MyImage.asset(MyImagePaths.appBg, fit:BoxFit.cover, width: ScreenUtil().screenWidth, height: 148.w),
      child: Container(
        padding: EdgeInsets.only(top: _screenUtil.statusBarHeight, left: MyTheme.pagePadding, right: MyTheme.pagePadding),
        child: TabBarWithView.line(
          tabController: _tabController,
          initialIndex: 0,
          labelStyle: const TextStyle(color: MyTheme.blueColor64, fontSize: 18, fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(color: MyTheme.whiteColor, fontSize: 17, fontWeight: FontWeight.w500),
          titles: _tabs.map((e) => e.name.tr(context: context)).toList(),
          views: _tabs.map((e) {
            return KeepAliveWrapper(child: HomeAdsPage(pos: e.value));
          }).toList(),
        ),
      ),
    );
  }
}
