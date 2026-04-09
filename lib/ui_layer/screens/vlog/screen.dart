import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/domain/async_value.dart';
import 'package:jycrpj/domain/model/navigator_model.dart';
import 'package:jycrpj/report/ui_layer/report_gesture_detector.dart';
import 'package:jycrpj/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jycrpj/ui_layer/router/routes.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/keep_alive_wrapper.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_tab_bar.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/status/loading.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/status/network_error.dart';
import 'package:jycrpj/ui_layer/screens/image_paths.dart';
import 'package:jycrpj/ui_layer/screens/live_video/live_nav/screen.dart';
import 'package:jycrpj/ui_layer/screens/theme.dart';
import 'package:jycrpj/ui_layer/screens/vlog/discover_screen.dart';
import 'package:jycrpj/ui_layer/screens/vlog/vlog_focus_page.dart';
import 'package:jycrpj/ui_layer/screens/vlog/vlog_play_screen.dart';
import 'package:provider/provider.dart';

class VlogScreen extends StatefulWidget {
  const VlogScreen({super.key});

  @override
  State<VlogScreen> createState() => _VlogScreenState();
}

class _VlogScreenState extends State<VlogScreen> with TickerProviderStateMixin {
  late final config = context.read<HomeConfigNotifier>().config;
  late final navList = (config.vlogNav ?? []).where((e) => e.value != 1 && e.value != 4).toList();
  AsyncValue<List<VlogNavigatorModel>> _asyncValue = const AsyncInit();
  late final TabController _tabController;

  final GlobalKey<VlogPlayScreenState> _globalVlogPageKey = GlobalKey<VlogPlayScreenState>();
  int? selSortIndex = 2;

  int initialIndex = 0;

  @override
  void initState() {
    _init();
    super.initState();
  }

  Future<void> _init() async {
    if (_asyncValue.isLoading) return;

    setState(() {
      _asyncValue = const AsyncLoading();
    });

    for (var element in navList) {
      if (element.value == 2) {
        initialIndex = navList.indexOf(element);
      }
    }
    _tabController = TabController(length: navList.length, vsync: this, initialIndex: initialIndex);
    _asyncValue = AsyncData(navList);

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _asyncValue.maybeWhen(
      data: (data) => Scaffold(
        // appBar: SearchAppBar(),
        body: Stack(
          children: [
            TabBarWithView.line(
              isStack: true,
              isCenter: true,
              labelPadding: 20.w,
              tabBarHeight: 40.h,
              initialIndex: initialIndex,
              tabController: _tabController,
              tabBarLeftWidget: SizedBox(width: 31.w),
              tabBarRightWidget: const _SearchButton(),
              titles: data.map((e) => e.label).toList(),
              tabBarPadding: EdgeInsets.only(top: MyTheme.statusHeight),
              linearColors: const [Colors.transparent, Colors.transparent],
              labelStyle: MyTheme.white16medium.copyWith(color: MyTheme.whiteColor),
              unselectedLabelStyle: MyTheme.white16medium.copyWith(color: const Color.fromRGBO(255, 255, 255, 0.8), fontWeight: FontWeight.w500),
              views: navList.map((e) {
                if (e.value == 1) {
                  return KeepAliveWrapper(
                    child: Padding(
                      padding: EdgeInsets.only(top: MyTheme.statusHeight + MyTheme.navbarHegiht),
                      child: const VlogFocusPage(),
                    ),
                  );
                } else if (e.value == 2) {
                  return (selSortIndex == null || selSortIndex == 0)
                      ? Padding(padding: const EdgeInsets.only(top: 0), child: VlogPlayScreen(apiUrl: 'vlog/list_sort'))
                      : KeepAliveWrapper(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: VlogPlayScreen(key: _globalVlogPageKey, apiUrl: 'vlog/list_sort', selSortIndex: selSortIndex),
                          ),
                        );

                  // return KeepAliveWrapper(
                  //   child: Padding(
                  //     padding: EdgeInsets.only(
                  //         top: MyTheme.statusHeight + MyTheme.navbarHegiht),
                  //     child: const BroadcastTopNavView(),
                  //   ),
                  // );
                } else if (e.value == 3) {
                  return const KeepAliveWrapper(
                    child: Padding(padding: EdgeInsets.only(top: 0), child: DiscoverScreen()),
                  );
                } else if (e.value == 4) {
                  return const LiveBroadcastScreen();
                } else {
                  return Container();
                }
              }).toList(),
            ),
          ],
        ),
      ),
      error: (_, __) => NetworkErrorView(onTap: _init),
      orElse: () => const LoadingView(),
    );
  }
}

class _SearchButton extends StatelessWidget {
  const _SearchButton();

  @override
  Widget build(BuildContext context) {
    return ReportGestureDetector(
      onTap: () {
        const VlogSearchRoute(word: '').push(context);
      },
      child: Padding(
        padding: EdgeInsets.all(MyTheme.pagePadding),
        child: MyImage.asset(
          width: 18.w,
          height: 18.w,
          MyImagePaths.appSearchIcon,
          color: const Color.fromRGBO(255, 255, 255, 1),
        ),
      ),
    );
  }
}
