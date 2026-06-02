import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/domain/async_value.dart';
import 'package:jycrpj/domain/model/crack_model.dart';
import 'package:jycrpj/domain/remote_domain/domains/crack.dart';
import 'package:jycrpj/domain/remote_domain/domains/user.dart';
import 'package:jycrpj/ui_layer/notifiers/user_notifier.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/keep_alive_wrapper.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/status/loading.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/status/network_error.dart';
import 'package:jycrpj/ui_layer/screens/crack/app_util.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/91aw/screen/aw91_home_screen.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/awjq/screen/awjq_home_screen.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/clsq/screen/cl_home_screen.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/pzhan/screen/pzhan_home_screen.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/zpc/screen/zpc_home_screen.dart';
import 'package:jycrpj/ui_layer/screens/crack/crack_app_type.dart';
import 'package:jycrpj/ui_layer/screens/crack/unlock_status_notifier.dart';
import 'package:jycrpj/ui_layer/screens/crack/widgets/crack_app_drawer.dart';
import 'package:jycrpj/ui_layer/screens/crack/widgets/crack_home_title_bar.dart';
import 'package:jycrpj/ui_layer/screens/crack/widgets/lazy_indexed_stack.dart';
import 'package:jycrpj/ui_layer/screens/image_paths.dart';
import 'package:jycrpj/ui_layer/screens/theme.dart';
import 'package:jycrpj/ui_layer/utils/common_utils.dart';
import 'package:provider/provider.dart';

class CrackMainPage extends StatefulWidget {
  const CrackMainPage({super.key});

  @override
  State<CrackMainPage> createState() => _CrackMainPageState();
}

class _CrackMainPageState extends State<CrackMainPage> {
  late final _screenUtil = ScreenUtil();
  late final _crackDomain = context.read<CrackDomain>();
  late final _userDomain = context.read<UserDomain>();
  late final _userNotifier = context.read<UserNotifier>();
  late final _unlockStatusNotifier = context.read<UnlockStatusNotifier>();
  AsyncValue<List<CrackApp>> _asyncValue = const AsyncInit();
  bool _initDialog = true;

  /// 没有破解的App数据
  final ValueNotifier<List<CrackApp>> _noCrackAppsNotifier = ValueNotifier([]);

  /// 选中的App index
  final ValueNotifier<int> _crackAppIndexNotifier = ValueNotifier(0);

  /// 初始背景色
  Color _appBackgroundColor = MyTheme.clAppBgColor;

  /// 头部区域的背景色
  final ValueNotifier<Color> _topAppBackgroundColorNotifier = ValueNotifier(MyTheme.clAppBgColor);

  /// 当前的app tab类型
  final ValueNotifier<CrackAppType> _searchAppBarTypeNotifier = ValueNotifier(CrackAppType.normal);

  /// 获取破解App列表数据
  Future<void> _getCrackData() async {
    // 开始显示 loading（可选）
    _asyncValue = const AsyncLoading();
    if (!mounted) return;
    setState(() {});

    try {
      final resCrackRes = await _crackDomain.getCrackList(isCrack: 1);
      CommonUtils.log('刷新的结果: $resCrackRes');
      // 如果任一接口返回 status != 1 则视为错误
      if (resCrackRes.status != 1) {
        _asyncValue = const AsyncError();
      } else {
        final crackApps = resCrackRes.data?.crackApps ?? <CrackApp>[];
        final sortedApps = [...crackApps]..sort((a, b) => b.weight.compareTo(a.weight));
        // 设置初始的颜色
        if (sortedApps.isNotEmpty) {
          final appName = sortedApps.first.appName;
          _initialColor(appName);
          AppUtil.initialAppUnlockStatus(_unlockStatusNotifier, _userNotifier, sortedApps);
        }
        _asyncValue = AsyncData(sortedApps);
        // if (sortedApps.isNotEmpty) {
        //   final crackApp = sortedApps[0];
        // await _initSearchTabBarData(appName: crackApp.appName);
        // }
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

  void _initialColor(String appName) {
    if (appName == CrackAppType.clsq.appName) {
      _searchAppBarTypeNotifier.value = CrackAppType.clsq;
      if (_appBackgroundColor != MyTheme.clAppBgColor) {
        _topAppBackgroundColorNotifier.value = MyTheme.clAppBgColor;
        _appBackgroundColor = MyTheme.clAppBgColor;
        setState(() {});
      }
    } else if (appName == CrackAppType.awjq.appName) {
      _searchAppBarTypeNotifier.value = CrackAppType.awjq;
      if (_appBackgroundColor != MyTheme.awjqAppBgColor) {
        _topAppBackgroundColorNotifier.value = MyTheme.awjqAppBgColor;
        _appBackgroundColor = MyTheme.awjqAppBgColor;
        setState(() {});
      }
    } else if (appName == CrackAppType.aw91.appName) {
      _searchAppBarTypeNotifier.value = CrackAppType.aw91;
      if (_appBackgroundColor != MyTheme.aw91AppBgColor) {
        _topAppBackgroundColorNotifier.value = MyTheme.aw91AppBgColor;
        _appBackgroundColor = MyTheme.aw91AppBgColor;
        setState(() {});
      }
    } else if (appName == CrackAppType.zpc.appName) {
      _searchAppBarTypeNotifier.value = CrackAppType.zpc;
      if (_appBackgroundColor != MyTheme.zpcAppBgColor) {
        _topAppBackgroundColorNotifier.value = MyTheme.defaultAppBgColor;
        _appBackgroundColor = MyTheme.zpcAppBgColor;
        setState(() {});
      }
    } else if (appName == CrackAppType.pzhan.appName) {
      _searchAppBarTypeNotifier.value = CrackAppType.pzhan;
      if (_appBackgroundColor != MyTheme.pzhanAppBgColor) {
        _topAppBackgroundColorNotifier.value = MyTheme.defaultAppBgColor;
        _appBackgroundColor = MyTheme.pzhanAppBgColor;
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    _getNoCrackData();
    super.initState();
  }

  @override
  void dispose() {
    _noCrackAppsNotifier.dispose();
    _crackAppIndexNotifier.dispose();
    _topAppBackgroundColorNotifier.dispose();
    _searchAppBarTypeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      bgColor: _appBackgroundColor,
      appBg: ValueListenableBuilder(
        valueListenable: _topAppBackgroundColorNotifier,
        builder: (_, topAppBackgroundColor, __) {
          return Container(
            color: topAppBackgroundColor,
            child: MyImage.asset(MyImagePaths.appBg, fit: BoxFit.cover, width: _screenUtil.screenWidth, height: 148.w),
          );
        },
      ),
      child: _asyncValue.maybeWhen(
          init: () {
            _getCrackData();
            return const LoadingView();
          },
          error: (_, __) => NetworkErrorView(onTap: _getCrackData),
          orElse: () => const LoadingView(),
          data: (data) {
            _initialPrivilegeDialog(data, context);

            return Scaffold(
              endDrawer: CrackAppDrawer(
                  crackApps: data,
                  initialIndex: _crackAppIndexNotifier.value,
                  noCrackAppsNotifier: _noCrackAppsNotifier,
                  changeAppCallback: (index, crackApp) {
                    _crackAppIndexNotifier.value = index;
                    _initialColor(crackApp.appName);
                    // 检查解锁的状态
                    AppUtil.checkUnlockStatus(
                      context: context,
                      crackApp: crackApp,
                      userNotifier: _userNotifier,
                      unlockStatusNotifier: _unlockStatusNotifier,
                      userDomain: _userDomain,
                    );
                  }),
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
                            page = ClHomeScreen(
                                appType: CrackAppType.clsq,
                                crackApp: crackApp_,
                                openEndDrawer: () {
                                  Scaffold.of(scaffoldContext).openEndDrawer();
                                });
                          } else if (crackApp_.appName == CrackAppType.awjq.appName) {
                            page = AwjqHomeScreen(
                                appType: CrackAppType.awjq,
                                crackApp: crackApp_,
                                openEndDrawer: () {
                                  Scaffold.of(scaffoldContext).openEndDrawer();
                                });
                          } else if (crackApp_.appName == CrackAppType.aw91.appName) {
                            page = Aw91HomeScreen(
                                appType: CrackAppType.aw91,
                                crackApp: crackApp_,
                                openEndDrawer: () {
                                  Scaffold.of(scaffoldContext).openEndDrawer();
                                });
                          } else if (crackApp_.appName == CrackAppType.zpc.appName) {
                            page = ZpcHomeScreen(
                                appType: CrackAppType.zpc,
                                crackApp: crackApp_,
                                openEndDrawer: () {
                                  Scaffold.of(scaffoldContext).openEndDrawer();
                                });
                          } else if (crackApp_.appName == CrackAppType.pzhan.appName) {
                            page = PZhanHomeScreen(
                                appType: CrackAppType.pzhan,
                                crackApp: crackApp_,
                                openEndDrawer: () {
                                  Scaffold.of(scaffoldContext).openEndDrawer();
                                });
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
            );
          }),
    );
  }

  void _initialPrivilegeDialog(List<CrackApp> data, BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_initDialog && data.isNotEmpty) {
        _initDialog = false;
        final firstApp = data.first;
        AppUtil.checkUnlockStatus(
          context: context,
          crackApp: firstApp,
          userNotifier: _userNotifier,
          unlockStatusNotifier: _unlockStatusNotifier,
          userDomain: _userDomain,
        );
      }
    });
  }

  Widget _buildNestedScrollViewBody(BuildContext context, List<CrackApp> data) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          /// 🔥 关键：吸收外层 header 的 overlap
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  Container(color: const Color.fromRGBO(0, 0, 0, 0), height: MediaQuery.of(context).padding.top),
                  Builder(builder: (ctx) {
                    return CrackHomeTitleBar(
                      text: 'ypj'.tr(context: context),
                      gradient: const [Color.fromRGBO(255, 23, 50, 1), Color.fromRGBO(255, 71, 144, 1)],
                      indicatorColor: const Color.fromRGBO(255, 26, 53, 1),
                      backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
                      openEndDrawer: () {
                        Scaffold.of(ctx).openEndDrawer();
                      },
                    );
                  }), // 注意这里要是 Widget
                  // Container(height: 8.w, color: const Color.fromRGBO(0, 0, 0, 0)),
                  // ValueListenableBuilder(valueListenable: _topAppBackgroundColorNotifier, builder: (_, topAppBackgroundColor, __) {
                  //   return CenteredHorizontalListView(
                  //       crackApps: data,
                  //       backgroundColor: topAppBackgroundColor,
                  //       onPageChanged: (index, crackApp) {
                  //         _crackAppIndexNotifier.value = index;
                  //         _initialColor(crackApp.appName);
                  //         // 检查解锁的状态
                  //         _checkUnlockStatus(context, crackApp);
                  //       });
                  // }), // App 切换头
                ],
              ),
            ),
          ),
        ];
      },

      /// ===== 子页面（每个都有自己的吸顶）=====
      body: ValueListenableBuilder<int>(
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
                  page = ClHomeScreen(appType: CrackAppType.clsq, crackApp: crackApp_);
                } else if (crackApp_.appName == CrackAppType.awjq.appName) {
                  page = AwjqHomeScreen(appType: CrackAppType.awjq, crackApp: crackApp_);
                } else if (crackApp_.appName == CrackAppType.aw91.appName) {
                  page = Aw91HomeScreen(appType: CrackAppType.aw91, crackApp: crackApp_);
                } else if (crackApp_.appName == CrackAppType.zpc.appName) {
                  page = ZpcHomeScreen(appType: CrackAppType.zpc, crackApp: crackApp_);
                } else if (crackApp_.appName == CrackAppType.pzhan.appName) {
                  page = PZhanHomeScreen(appType: CrackAppType.pzhan, crackApp: crackApp_);
                } else {
                  page = const SizedBox.shrink();
                }
                return KeepAliveWrapper(child: page);
              },
            ),
          );
        },
      ),
    );
  }
}
