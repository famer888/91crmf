import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/domain/async_value.dart';
import 'package:jycrpj/domain/model/crack_model.dart';
import 'package:jycrpj/domain/remote_domain/domains/crack.dart';
import 'package:jycrpj/domain/remote_domain/domains/user.dart';
import 'package:jycrpj/report/ui_layer/report_gesture_detector.dart';
import 'package:jycrpj/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jycrpj/ui_layer/notifiers/user_notifier.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/keep_alive_wrapper.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/status/loading.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/status/network_error.dart';
import 'package:jycrpj/ui_layer/screens/crack/app_util.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/51tiktok/screen/tiktok51_community_screen.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/91aw/screen/screen.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/awjq/screen/screen.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/clsq/screen/screen.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/hjsq/screen/hjsq_community_screen.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/pzhan/screen/pzhan_community_screen.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/zpc/screen/screen.dart';
import 'package:jycrpj/ui_layer/screens/crack/crack_app_type.dart';
import 'package:jycrpj/ui_layer/screens/crack/unlock_status_notifier.dart';
import 'package:jycrpj/ui_layer/screens/crack/widgets/crack_app_drawer.dart';
import 'package:jycrpj/ui_layer/screens/crack/widgets/lazy_indexed_stack.dart';
import 'package:jycrpj/ui_layer/screens/image_paths.dart';
import 'package:jycrpj/ui_layer/screens/theme.dart';
import 'package:jycrpj/ui_layer/utils/common_utils.dart';
import 'package:provider/provider.dart';

class NewCrackScreen extends StatefulWidget {
  const NewCrackScreen({super.key});

  @override
  State<NewCrackScreen> createState() => _NewCrackScreenState();
}

class _NewCrackScreenState extends State<NewCrackScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final _screenUtil = ScreenUtil();
  late final _crackDomain = context.read<CrackDomain>();
  late final _userDomain = context.read<UserDomain>();
  late final _homeConfigNotifier = context.read<HomeConfigNotifier>();
  late final _userNotifier = context.read<UserNotifier>();
  late final _unlockStatusNotifier = context.read<UnlockStatusNotifier>();
  final ValueNotifier<List<CrackApp>> _noCrackAppsNotifier = ValueNotifier([]);
  final ValueNotifier<int> _crackAppIndexNotifier = ValueNotifier(0);
  AsyncValue<List<CrackApp>> _asyncValue = const AsyncInit();

  bool _showGuide_ = false;

  /// 获取破解App列表数据
  Future<void> _getCrackData() async {
    // 开始显示 loading（可选）
    _asyncValue = const AsyncLoading();
    if (!mounted) return;
    setState(() {});

    try {
      final resCrackRes = await _crackDomain.getCrackList(isCrack: 1);
      // 如果任一接口返回 status != 1 则视为错误
      if (resCrackRes.status != 1) {
        _asyncValue = const AsyncError();
      } else {
        final crackApps = resCrackRes.data?.crackApps ?? <CrackApp>[];
        final sortedApps = [...crackApps]..sort((a, b) => b.weight.compareTo(a.weight));
        // 设置初始的颜色
        if (sortedApps.isNotEmpty) {
          AppUtil.initialAppUnlockStatus(_unlockStatusNotifier, _userNotifier, sortedApps);
        }
        _asyncValue = AsyncData(sortedApps);
      }
    } catch (e, st) {
      CommonUtils.log('出错: $e\n$st');
      _asyncValue = const AsyncError();
    }

    if (!mounted) return;
    setState(() {});
  }

  /// 获取未破解的App数据
  Future<void> _getNoCrackData() async {
    try {
      final resCrackRes = await _crackDomain.getCrackList(isCrack: 0);
      CommonUtils.log(': $resCrackRes');
      if (resCrackRes.status == 1) {
        final noCrackApps = resCrackRes.data?.noCrackApps ?? <CrackApp>[];
        _noCrackAppsNotifier.value = noCrackApps;
      }
    } catch (e) {
      CommonUtils.log('出错: $e');
    }
  }

  Future<void> _showGuide() async {
    _showGuide_ = await _homeConfigNotifier.readGuide();
  }

  @override
  void initState() {
    _showGuide();
    _getNoCrackData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      appBg: MyImage.asset(MyImagePaths.appBg, fit: BoxFit.cover, width: _screenUtil.screenWidth, height: 148.w),
      child: _asyncValue.maybeWhen(
          init: () {
            _getCrackData();
            return const LoadingView();
          },
          error: (_, __) => NetworkErrorView(onTap: _getCrackData),
          orElse: () => const LoadingView(),
          data: (data) {
            return Stack(
              children: [
                Scaffold(
                  key: _scaffoldKey,
                  endDrawer: ValueListenableBuilder<int>(
                    valueListenable: _crackAppIndexNotifier,
                    builder: (_, appIndex, __) {
                      return CrackAppDrawer(
                          crackApps: data,
                          initialIndex: appIndex,
                          noCrackAppsNotifier: _noCrackAppsNotifier,
                          changeAppCallback: (index, crackApp) {
                            _crackAppIndexNotifier.value = index;
                            // 检查解锁的状态
                            AppUtil.checkUnlockStatus(
                              context: context,
                              crackApp: crackApp,
                              userNotifier: _userNotifier,
                              unlockStatusNotifier: _unlockStatusNotifier,
                              userDomain: _userDomain,
                            );
                            // 切换状态栏颜色
                            if (crackApp.appName == CrackAppType.zpc.appName) {
                              SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
                            } else {
                              SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
                            }
                          });
                    },
                  ),
                  body: Builder(builder: (scaffoldContext) {
                    return ValueListenableBuilder<int>(
                      valueListenable: _crackAppIndexNotifier,
                      builder: (_, appIndex, __) {
                        return LazyIndexedStack(
                          index: appIndex,
                          builders: List.generate(
                            data.length,
                            (index) => (BuildContext _) {
                              final crackApp_ = data[index];
                              // 根据类型动态返回对应页面
                              Widget page;
                              if (crackApp_.appName == CrackAppType.clsq.appName) {
                                page = ClCommunityScreen(
                                  id: 1,
                                  crackApp: crackApp_,
                                  openEndDrawer: () {
                                    Scaffold.of(scaffoldContext).openEndDrawer();
                                  },
                                );
                              } else if (crackApp_.appName == CrackAppType.awjq.appName) {
                                SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
                                page = AwRestrictedAreaScreen(
                                  id: 1,
                                  crackApp: crackApp_,
                                  openEndDrawer: () {
                                    Scaffold.of(scaffoldContext).openEndDrawer();
                                  },
                                );
                              } else if (crackApp_.appName == CrackAppType.aw91.appName) {
                                SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
                                page = Aw91CommunityScreen(
                                  id: 1,
                                  crackApp: crackApp_,
                                  openEndDrawer: () {
                                    Scaffold.of(scaffoldContext).openEndDrawer();
                                  },
                                );
                              } else if (crackApp_.appName == CrackAppType.zpc.appName) {
                                SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
                                page = ZpcCommunityScreen(
                                  id: 1,
                                  crackApp: crackApp_,
                                  openEndDrawer: () {
                                    Scaffold.of(scaffoldContext).openEndDrawer();
                                  },
                                );
                              } else if (crackApp_.appName == CrackAppType.pzhan.appName) {
                                SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
                                page = PZhanCommunityScreen(
                                  id: 1,
                                  crackApp: crackApp_,
                                  openEndDrawer: () {
                                    Scaffold.of(scaffoldContext).openEndDrawer();
                                  },
                                );
                              } else if (crackApp_.appName == CrackAppType.tiktok51.appName) {
                                SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
                                page = Tiktok51CommunityScreen(
                                  id: 1,
                                  crackApp: crackApp_,
                                  openEndDrawer: () {
                                    Scaffold.of(scaffoldContext).openEndDrawer();
                                  },
                                );
                              } else if (crackApp_.appName == CrackAppType.hjsq.appName) {
                                SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
                                page = HjsqCommunityScreen(
                                  id: 1,
                                  crackApp: crackApp_,
                                  openEndDrawer: () {
                                    Scaffold.of(scaffoldContext).openEndDrawer();
                                  },
                                );
                              } else {
                                page = const SizedBox.shrink();
                              }
                              return KeepAliveWrapper(child: page);
                            },
                          ),
                        );
                      },
                    );
                  }),
                ),
                Positioned(
                  top: 25.w,
                  left: 20.w,
                  child: GestureDetector(
                    onTap: () async {
                      await _getCrackData();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 5.w, horizontal: 10.w),
                      decoration: BoxDecoration(color: MyTheme.blueColor63, borderRadius: BorderRadius.all(Radius.circular(5.w))),
                      child: Text(
                        'getCrackList',
                        style: TextStyle(color: Colors.white, fontSize: 16.sp),
                      ),
                    ),
                  ),
                ),
                if (_showGuide_)
                  Positioned.fill(
                    child: Builder(builder: (scaffoldContext) {
                      return Container(
                        padding: EdgeInsets.only(top: MyTheme.statusHeight + 7.w, right: 8.w),
                        color: Colors.black.withOpacity(0.75),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ReportGestureDetector(
                                  onTap: () {
                                    _homeConfigNotifier.upsertGuide(false);
                                    setState(() {
                                      _showGuide_ = false;
                                    });
                                    _scaffoldKey.currentState?.openEndDrawer();
                                  },
                                  child: MyImage.asset(MyImagePaths.appMoreBorder, fit: BoxFit.cover, width: 35.w, height: 49.w),
                                ),
                              ],
                            ),
                            SizedBox(height: 4.w),
                            Row(
                              children: [
                                const Spacer(),
                                MyImage.asset(MyImagePaths.appMoreArrow, fit: BoxFit.cover, width: 64.w, height: 64.w),
                                SizedBox(width: 20.w),
                              ],
                            ),
                            Row(
                              children: [
                                const Spacer(),
                                MyImage.asset(MyImagePaths.appMoreGuide, fit: BoxFit.cover, width: 185.w, height: 58.w),
                                SizedBox(width: 40.w),
                              ],
                            ),
                            SizedBox(height: 12.w),
                            Row(
                              children: [
                                const Spacer(),
                                ReportGestureDetector(
                                  onTap: () {
                                    _homeConfigNotifier.upsertGuide(false);
                                    setState(() {
                                      _showGuide_ = false;
                                    });
                                  },
                                  child: MyImage.asset(MyImagePaths.appMoreButton, fit: BoxFit.cover, width: 78.w, height: 25.w),
                                ),
                                SizedBox(width: 94.w),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
              ],
            );
          }),
    );
  }
}
