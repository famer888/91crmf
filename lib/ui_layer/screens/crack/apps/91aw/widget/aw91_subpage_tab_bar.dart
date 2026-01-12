import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/domain/model/home_data_model.dart';
import 'package:jycrpj/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jycrpj/ui_layer/screens/crack/widgets/app_search_tab_bar.dart';
import 'package:jycrpj/ui_layer/screens/crack/widgets/app_tab_bar.dart';
import 'package:jycrpj/ui_layer/screens/crack/widgets/grid_list_switch.dart';
import 'package:jycrpj/ui_layer/screens/theme.dart';
import 'package:provider/provider.dart';

class Aw91SubPageTabBar extends StatefulWidget {
  final ValueNotifier<bool> isListNotifier;
  /// second tab bar的选中位置
  final ValueNotifier<int> subPageBarIndexNotifier;
  final Function(AppNavModel)? onChangeTab;

  const Aw91SubPageTabBar({
    super.key,
    required this.isListNotifier,
    required this.subPageBarIndexNotifier,
    this.onChangeTab,
  });

  @override
  State<Aw91SubPageTabBar> createState() => _Aw91SubPageTabBarState();
}

class _Aw91SubPageTabBarState extends State<Aw91SubPageTabBar> {

  late final _homeConfig = context.read<HomeConfigNotifier>();

  List<AppNavModel> _getAppNavList() {
    return _homeConfig.config.aw91SortNav ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return AppCrackSecondTabBar(
      appNavModels: _getAppNavList(),
      activeTextColor: MyTheme.aw91AppPrimaryColor,
      inactiveTextColor: MyTheme.whiteColor,
      tabIndexNotifier: widget.subPageBarIndexNotifier,
      backgroundColor: MyTheme.aw91AppBgColor,
      showRightWidget: true,
      rightWidget: GridListSwitch(
          color: MyTheme.aw91AppPrimaryColor,
          callback: (isList) {
            widget.isListNotifier.value = isList;
          }),
      onChangeTab: (index) {
        final model = _getAppNavList()[index];
        widget.onChangeTab?.call(model);
      },
    );
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
