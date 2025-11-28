import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/keep_alive_wrapper.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_app_bar.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_tab_bar.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:jycrpj/ui_layer/screens/mine/collection/collection_app_screen.dart';
import 'package:jycrpj/ui_layer/screens/mine/collection/collection_black_screen.dart';

class MineNewCollectionScreen extends StatefulWidget {
  const MineNewCollectionScreen({super.key});

  @override
  State<MineNewCollectionScreen> createState() => _MineNewCollectionScreenState();
}

class _MineNewCollectionScreenState extends State<MineNewCollectionScreen> {
  final _tabTitles = [tr('app'), tr('home_hl')];

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        appBar: MyAppBar(title: 'wdsc'.tr(context: context)),
        body: TabBarWithView.line(
          labelStyle: TextStyle(
            color: const Color.fromRGBO(255, 255, 255, 1),
            fontSize: 18.sp,
            overflow: TextOverflow.visible,
            decoration: TextDecoration.none,
          ),
          unselectedLabelStyle: TextStyle(
            color: const Color.fromRGBO(255, 255, 255, 0.8),
            fontSize: 17.sp,
            overflow: TextOverflow.visible,
            decoration: TextDecoration.none,
          ),
          linearColors: const [Color.fromRGBO(0, 0, 0, 0), Color.fromRGBO(0, 0, 0, 0)],
          tabBarHeight: 40.w,
          isScrollable: true,
          titles: _tabTitles,
          views: const [
            KeepAliveWrapper(child: CollectionAppScreen()),
            KeepAliveWrapper(child: CollectionBlackScreen()),
          ],
        ),
      ),
    );
  }
}
