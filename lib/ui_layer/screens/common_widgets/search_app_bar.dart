import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jycrpj/ui_layer/screens/crack/crack_app_type.dart';

import '../../../report/ui_layer/report_gesture_detector.dart';
import '../../router/routes.dart';
import '../image_paths.dart';
import '../theme.dart';

//请自行按需添加
// enum SearchAppBarType {
//   normal(appName: '', topNavApi: ''),
//   clsq(appName: 'hjgj', topNavApi: 'elementhjgj/getElementById'),
//   awjq(appName: 'awjq', topNavApi: 'elementawjq/getElementById'),
//   aw91(appName: '91aw', topNavApi: 'element91aw/getElementById'),
//   zpc(appName: 'zpc', topNavApi: 'elementzpc/getElementById'),
//   pzhan(appName: 'pzhan', topNavApi: 'navigationpzhan/index'),
//   ;
//
//   const SearchAppBarType({required this.appName, required this.topNavApi});
//
//   final String appName;
//   final String topNavApi;
// }

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? backArrowOnTap;
  final bool showLeftBack;
  final bool showRightRank;
  final Color backgroundColor;
  final Color? sideColor;
  final CrackAppType? type;
  final bool isCrackApp;
  final VoidCallback? openEndDrawer;
  final VoidCallback? onTap;

  bool isCrackAppSearch() {
    final searchAppBarTypeList = [
      CrackAppType.clsq,
      CrackAppType.awjq,
      CrackAppType.aw91,
      CrackAppType.zpc,
      CrackAppType.pzhan,
    ];
    return searchAppBarTypeList.contains(type);
  }

  const SearchAppBar({
    super.key,
    this.backArrowOnTap,
    this.showLeftBack = false,
    this.showRightRank = false,
    this.backgroundColor = Colors.transparent,
    this.type = CrackAppType.normal,
    this.isCrackApp = false,
    this.sideColor,
    this.onTap,
    this.openEndDrawer,
  });

  @override
  Widget build(BuildContext context) {
    if (isCrackApp) {
      return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(left: MyTheme.pagePadding, right: MyTheme.pagePadding, top: MyTheme.statusHeight, bottom: 0.w),
        child: Row(
          children: [
            Expanded(
              child: SearchBarContent(
                showLeftBack: showLeftBack,
                showRightRank: showRightRank,
                type: type,
                backArrowOnTap: backArrowOnTap,
                backgroundColor: backgroundColor,
                sideColor: sideColor,
                onTap: onTap,
              ),
            ),
            SizedBox(width: 12.w),
            ReportGestureDetector(
              onTap: () {
                openEndDrawer?.call();
              },
              child: Container(
                padding: EdgeInsets.only(top: 8.w, bottom: 8.w),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  SizedBox.square(
                    dimension: 22.w,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.w),
                      child: const MyImage.asset(MyImagePaths.appMore, fit: BoxFit.cover),
                    ),
                  ),
                  Text('gd'.tr(context: context), style: MyTheme.white255_12.s11),
                ]),
              ),
            ),
          ],
        ),
      );
    } else {
      return SafeArea(
        bottom: false,
        child: SearchBarContent(
          showLeftBack: showLeftBack,
          showRightRank: showRightRank,
          type: type,
          backArrowOnTap: backArrowOnTap,
          sideColor: sideColor,
          onTap: onTap,
        ),
      );
    }
  }

  @override
  final Size preferredSize = const Size.fromHeight(60);
}

class SearchBarContent extends StatelessWidget {
  final bool showLeftBack;
  final bool showRightRank;
  final CrackAppType? type;
  final Color? backgroundColor;
  final Color? sideColor;
  final VoidCallback? onTap;
  final VoidCallback? backArrowOnTap;

  const SearchBarContent({
    super.key,
    this.showLeftBack = false,
    this.showRightRank = false,
    this.type = CrackAppType.normal,
    this.backgroundColor,
    this.sideColor,
    this.onTap,
    this.backArrowOnTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (showLeftBack)
          ReportGestureDetector(
            child: Image.asset(
              MyImagePaths.appBackIcon,
              width: 20.w,
              height: 20.w,
              color: type == CrackAppType.zpc ? const Color.fromRGBO(17, 16, 18, 1) : null,
            ),
            onTap: () {
              if (backArrowOnTap != null) {
                backArrowOnTap?.call();
              } else {
                context.pop();
              }
            },
          ),
        if (showLeftBack) SizedBox(width: 10.w),
        Expanded(
          child: ReportGestureDetector(
            onTap: () {
              if (onTap != null) {
                onTap?.call();
              } else {
                const SearchRoute().push(context);
              }
            },
            child: Container(
              height: 36.w,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17.5.w),
                  side: BorderSide(color: sideColor ?? const Color.fromRGBO(45, 45, 45, 0.8), width: 0.5),
                ),
                color: backgroundColor,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 12.w),
                  Image.asset(MyImagePaths.appSearchIcon, width: 12.w, height: 12.w),
                  SizedBox(width: 2.w),
                  Container(
                    width: 1.w,
                    height: 16.w,
                    color: const Color.fromRGBO(255, 255, 255, 0.04),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(child: Text('stzdmmhbt'.tr(context: context), style: MyTheme.gray172_14)),
                ],
              ),
            ),
          ),
        ),
        if (showRightRank) SizedBox(width: 10.w),
        if (showRightRank)
          ReportGestureDetector(
            onTap: () {
              // const MineWelfareRoute(index: 1).push(context);
              const RankRoute().push(context);
            },
            child: Image.asset(
              MyImagePaths.appRankList,
              // MyImagePaths.appSearchLogo,
              width: 45.w,
              fit: BoxFit.fitHeight,
            ),
          ),
      ],
    );
  }
}
