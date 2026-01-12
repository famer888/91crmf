import 'package:flutter/material.dart';
import 'package:jycrpj/ui_layer/screens/crack/crack_app_type.dart';
import 'package:jycrpj/ui_layer/screens/crack/widgets/app_search_tab_bar.dart';
import 'package:jycrpj/ui_layer/screens/crack/widgets/app_tab_bar.dart';

class StickySearchTabBar extends StatelessWidget {
  final ValueNotifier<List<CustomTabItem>> searchTabBarDataNotifier;
  final ValueNotifier<int> searchTabBarIndexNotifier;
  final CrackAppType searchAppBarType;
  final Color? backgroundColor;
  final Color? sideColor;
  final Color? searchAppBackgroundColor;
  final OnChangeTabCallBack onChangeTab;
  final bool isCrackApp;
  final VoidCallback? onTap;
  final VoidCallback? openEndDrawer;

  const StickySearchTabBar({
    super.key,
    required this.searchTabBarDataNotifier,
    required this.searchTabBarIndexNotifier,
    required this.searchAppBarType,
    required this.onChangeTab,
    this.backgroundColor,
    this.sideColor,
    this.searchAppBackgroundColor,
    this.isCrackApp = false,
    this.onTap,
    this.openEndDrawer,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: searchTabBarDataNotifier,
        builder: (context, customTabItems, _) {
          if (customTabItems.isEmpty) return const SizedBox.shrink();

          return AppSearchTabBar(
            type: searchAppBarType,
            backgroundColor: backgroundColor,
            searchAppBackgroundColor: searchAppBackgroundColor,
            sideColor: sideColor,
            tabIndexNotifier: searchTabBarIndexNotifier,
            tabs: customTabItems,
            onTap: onTap,
            openEndDrawer: openEndDrawer,
            isCrackApp: isCrackApp,
            onChangeTab: onChangeTab,
          );
        });
  }
}
