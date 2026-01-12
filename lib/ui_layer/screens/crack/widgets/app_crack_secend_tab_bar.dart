import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/domain/model/home_data_model.dart';
import 'package:jycrpj/ui_layer/screens/crack/crack_app_type.dart';
import 'package:jycrpj/ui_layer/screens/crack/widgets/app_search_tab_bar.dart';
import 'package:jycrpj/ui_layer/screens/crack/widgets/app_tab_bar.dart';
import 'package:jycrpj/ui_layer/screens/crack/widgets/grid_list_switch.dart';
import 'package:jycrpj/ui_layer/screens/theme.dart';

class SubPageTabBar extends StatefulWidget {
  final ValueNotifier<CrackAppType> searchAppBarTypeNotifier;
  final ValueNotifier<bool> isListNotifier;
  final ValueNotifier<int> subPageBarIndexNotifier;
  final ValueNotifier<List<AppNavModel>> subpageTabBarListNotifier;
  final Function(AppNavModel)? onChangeTab;

  const SubPageTabBar({
    super.key,
    required this.searchAppBarTypeNotifier,
    required this.isListNotifier,
    required this.subPageBarIndexNotifier,
    required this.subpageTabBarListNotifier,
    this.onChangeTab,
  });

  @override
  State<SubPageTabBar> createState() => _SubPageTabBarState();
}

class _SubPageTabBarState extends State<SubPageTabBar> {

  Color getActiveTextColor(CrackAppType searchAppBarType) {
    if (searchAppBarType == CrackAppType.clsq) {
      return MyTheme.clAppPrimaryColor;
    } else if (searchAppBarType == CrackAppType.awjq) {
      return MyTheme.awjqAppPrimaryColor;
    } else if (searchAppBarType == CrackAppType.aw91) {
      return MyTheme.aw91AppPrimaryColor;
    } else if (searchAppBarType == CrackAppType.zpc) {
      return MyTheme.zpcAppPrimaryColor;
    } else if (searchAppBarType == CrackAppType.pzhan) {
      return MyTheme.pzhanAppPrimaryColor;
    }
    return MyTheme.whiteColor;
  }

  Color getTabBarBackgroundColor(CrackAppType searchAppBarType) {
    if (searchAppBarType == CrackAppType.clsq) {
      return MyTheme.clAppBgColor;
    } else if (searchAppBarType == CrackAppType.awjq) {
      return MyTheme.awjqAppBgColor;
    } else if (searchAppBarType == CrackAppType.aw91) {
      return MyTheme.aw91AppBgColor;
    } else if (searchAppBarType == CrackAppType.zpc) {
      return MyTheme.zpcAppBgColor;
    } else if (searchAppBarType == CrackAppType.pzhan) {
      return MyTheme.pzhanAppBgColor;
    }
    return MyTheme.defaultSearchBarBackgroundColor;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: widget.subpageTabBarListNotifier,
        builder: (_, subpageTabBarList, __) {
          return ValueListenableBuilder(
              valueListenable: widget.searchAppBarTypeNotifier,
              builder: (_, searchAppBarType, __) {

                return AppCrackSecondTabBar(
                  appNavModels: subpageTabBarList,
                  activeTextColor: getActiveTextColor(searchAppBarType),
                  inactiveTextColor: MyTheme.whiteColor,
                  tabIndexNotifier: widget.subPageBarIndexNotifier,
                  backgroundColor: getTabBarBackgroundColor(searchAppBarType),
                  showRightWidget: true,
                  rightWidget: GridListSwitch(
                      color: getActiveTextColor(searchAppBarType),
                      callback: (isList) {
                        widget.isListNotifier.value = isList;
                      }),
                  onChangeTab: (index) {
                    final model = subpageTabBarList[index];
                    widget.onChangeTab?.call(model);
                  },
                );
              });
        });
  }
}

class AppCrackSecondTabBar extends StatefulWidget {
  final List<AppNavModel> appNavModels;
  final Color activeTextColor;
  final Color inactiveTextColor;
  final ValueNotifier<int> tabIndexNotifier;
  final OnChangeTabCallBack onChangeTab;
  final bool showRightWidget;
  final Widget? rightWidget;
  final Color? indicatorColor1;
  final Color? indicatorColor2;
  final Color? backgroundColor;

  const AppCrackSecondTabBar({
    super.key,
    required this.appNavModels,
    required this.activeTextColor,
    required this.inactiveTextColor,
    required this.tabIndexNotifier,
    required this.onChangeTab,
    this.showRightWidget = false,
    this.rightWidget,
    this.backgroundColor,
    this.indicatorColor1,
    this.indicatorColor2,
  });

  @override
  State<AppCrackSecondTabBar> createState() => _AppCrackSecondTabBarState();
}

class _AppCrackSecondTabBarState extends State<AppCrackSecondTabBar> {
  List<CustomTabItem> tabs = [];

  void _buildTabs() {
    tabs = widget.appNavModels.map((item) {
      return CustomTabItem(
        title: item.title,
        activeTextSize: 18.sp,
        inactiveTextSize: 16.sp,
        activeTextColor: widget.activeTextColor,
        inactiveTextColor: widget.inactiveTextColor,
        indicatorGradient: LinearGradient(
          colors: [
            widget.indicatorColor1 ?? Colors.transparent,
            widget.indicatorColor2 ?? Colors.transparent,
          ],
        ),
      );
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _buildTabs();
  }

  @override
  void didUpdateWidget(covariant AppCrackSecondTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 🔥 关键：当数据源或样式发生变化时，重建 tabs
    if (oldWidget.appNavModels != widget.appNavModels ||
        oldWidget.activeTextColor != widget.activeTextColor ||
        oldWidget.inactiveTextColor != widget.inactiveTextColor ||
        oldWidget.indicatorColor1 != widget.indicatorColor1 ||
        oldWidget.indicatorColor2 != widget.indicatorColor2) {
      _buildTabs();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomGradientTabBar(
      tabs: tabs,
      selectedIndex: widget.tabIndexNotifier,
      onChangeTab: widget.onChangeTab,
      showRightWidget: widget.showRightWidget,
      rightWidget: widget.rightWidget,
      backgroundColor: widget.backgroundColor,
    );
  }
}
