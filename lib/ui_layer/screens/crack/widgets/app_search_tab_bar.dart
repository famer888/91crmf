import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/report/ui_layer/report_gesture_detector.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/search_app_bar.dart';
import 'package:jycrpj/ui_layer/screens/crack/crack_app_type.dart';
import 'package:jycrpj/ui_layer/screens/crack/widgets/app_tab_bar.dart';
import 'package:jycrpj/ui_layer/screens/image_paths.dart';
import 'package:jycrpj/ui_layer/screens/theme.dart';

typedef OnChangeTabCallBack = void Function(int index);

class AppSearchTabBar extends StatefulWidget {
  final CrackAppType type;
  final ValueNotifier<int> tabIndexNotifier;
  final List<CustomTabItem> tabs;

  final Color? backgroundColor;
  final Color? sideColor;
  final Color? searchAppBackgroundColor;
  final OnChangeTabCallBack onChangeTab;
  final VoidCallback? openEndDrawer;
  final bool isCrackApp;
  final VoidCallback? onTap;

  const AppSearchTabBar({
    super.key,
    required this.type,
    required this.tabIndexNotifier,
    required this.tabs,
    required this.onChangeTab,
    this.backgroundColor,
    this.sideColor,
    this.searchAppBackgroundColor,
    this.isCrackApp = false,
    this.onTap,
    this.openEndDrawer,
  });

  @override
  State<AppSearchTabBar> createState() => _AppSearchTabBarState();
}

class _AppSearchTabBarState extends State<AppSearchTabBar> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    if (widget.tabIndexNotifier.value < 0 || widget.tabIndexNotifier.value >= widget.tabs.length) {
      widget.tabIndexNotifier.value = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor ?? const Color.fromRGBO(0, 0, 0, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: MyTheme.statusHeight - 7.w),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: SearchAppBar(
                  showLeftBack: false,
                  type: widget.type,
                  onTap: widget.onTap,
                  sideColor: widget.sideColor,
                  isCrackApp: widget.isCrackApp,
                  backgroundColor: widget.searchAppBackgroundColor ?? MyTheme.defaultSearchBarBackgroundColor,
                ),
              ),
              ReportGestureDetector(
                onTap: () {
                  widget.openEndDrawer?.call();
                },
                child: Container(
                  padding: EdgeInsets.only(top: 20.w, bottom: 10.w),
                  child: SizedBox.square(
                    dimension: 23.w,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.w),
                      child: const MyImage.asset(MyImagePaths.appMore, fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
              SizedBox(width: MyTheme.pagePadding),
            ],
          ),
          SizedBox(height: 2.w),
          CustomGradientTabBar(tabs: widget.tabs, selectedIndex: widget.tabIndexNotifier, onChangeTab: widget.onChangeTab),
        ],
      ),
    );
  }
}
