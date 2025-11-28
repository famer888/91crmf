import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/keep_alive_wrapper.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_app_bar.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:jycrpj/ui_layer/screens/mine/visitrecord/visit_app_screen.dart';
import 'package:jycrpj/ui_layer/screens/mine/visitrecord/visit_black_screen.dart';

import '../../common_widgets/my_tab_bar.dart';

class VisitRecordTabModel {

  final String title;
  final int type;

  VisitRecordTabModel({required this.title, required this.type});

}

class VisitRecordScreen extends StatefulWidget {
  const VisitRecordScreen({super.key});

  @override
  State<VisitRecordScreen> createState() => _VisitRecordScreenState();
}

class _VisitRecordScreenState extends State<VisitRecordScreen> {

  final _tabTitles = [
    VisitRecordTabModel(title: tr('app'), type: 0),
    VisitRecordTabModel(title: tr('home_hl'), type: 1),
  ];


  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        appBar: MyAppBar(title: 'lljl'.tr(context: context)),
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
          titles: _tabTitles.map((e) => e.title).toList(),
          views: const [
            KeepAliveWrapper(child: VisitAppScreen(type: 0)),
            KeepAliveWrapper(child: VisitBlackScreen(type: 1)),
          ],
        ),
      ),
    );
  }
}
