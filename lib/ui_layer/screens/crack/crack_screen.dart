import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jycrpj/domain/domain.dart';
import 'package:jycrpj/domain/remote_domain/domains/crack.dart';
import 'package:jycrpj/ui_layer/notifiers/user_notifier.dart';
import 'package:jycrpj/ui_layer/router/routes.dart';
import 'package:jycrpj/ui_layer/screens/apps/crack_app_type.dart';
import 'package:jycrpj/ui_layer/screens/black/vip_pay_dialog.dart';
import 'package:jycrpj/ui_layer/screens/black/widget/interval_gesture_widget.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/status/loading.dart';
import 'package:jycrpj/ui_layer/screens/crack/widgets/no_crack_dialog.dart';
import 'package:jycrpj/ui_layer/screens/theme.dart';
import 'package:jycrpj/ui_layer/utils/common_utils.dart';
import 'package:jycrpj/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';

import '../../../domain/async_value.dart';
import '../../../domain/model/crack_model.dart';
import '../common_widgets/gradient_text.dart';
import '../common_widgets/my_image.dart';
import '../common_widgets/screen_background.dart';
import '../common_widgets/status/network_error.dart';
import '../image_paths.dart';

class CrackScreen extends StatefulWidget {
  const CrackScreen({super.key});

  @override
  State<CrackScreen> createState() => _CrackScreenState();
}

class _CrackScreenState extends State<CrackScreen> {
  late final _screenUtil = ScreenUtil();
  late final _userDomain = context.read<UserDomain>();
  late final _crackDomain = context.read<CrackDomain>();
  late final _userNotifier = context.read<UserNotifier>();
  AsyncValue<CrackModel> _asyncValue = const AsyncInit();
  final double _childAspectRatio = 57 / 76;

  // 获取破解App列表数据
  Future<void> _getCrackData() async {
    // 开始显示 loading（可选）
    _asyncValue = const AsyncLoading();
    if (!mounted) return;
    setState(() {});

    try {
      final results = await Future.wait([
        _crackDomain.getCrackList(isCrack: 1),
        _crackDomain.getCrackList(isCrack: 0),
      ]);

      final resCrack = results[0];
      final resNoCrack = results[1];
      CommonUtils.log('刷新的结果: $resCrack  -  :$resNoCrack');
      // 如果任一接口返回 status != 1 则视为错误
      if (resCrack.status != 1 || resNoCrack.status != 1) {
        _asyncValue = const AsyncError();
      } else {
        final crackApps = resCrack.data?.crackApps ?? <CrackApp>[];
        final noCrackApps = resNoCrack.data?.noCrackApps ?? <CrackApp>[];
        final crackModel = CrackModel(crackApps: crackApps, noCrackApps: noCrackApps);
        _asyncValue = AsyncData(crackModel);
      }
    } catch (e, st) {
      CommonUtils.log('出错: $e\n$st');
      _asyncValue = const AsyncError();
    }

    if (!mounted) return;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double itemWidth = (_screenUtil.screenWidth - (5 - 1) * 10.w - MyTheme.pagePadding * 2) / 5;
    return ScreenBackground(
      appBg: MyImage.asset(MyImagePaths.appBg, width: ScreenUtil().screenWidth, height: 148.w),
      child: _asyncValue.maybeWhen(
          init: () {
            _getCrackData();
            return const LoadingView();
          },
          error: (_, __) => NetworkErrorView(onTap: _getCrackData),
          orElse: () => const LoadingView(),
          data: (data) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
              child: RefreshIndicator(
                displacement: 50.0.w,
                edgeOffset: 25.0.w,
                color: MyTheme.blueColor64,
                backgroundColor: Colors.transparent,
                strokeWidth: 2,
                onRefresh: _getCrackData,
                child: CustomScrollView(
                  slivers: [
                    // 第一个网格部分
                    _buildGridTitle(
                      'ypj'.tr(context: context),
                      35.w,
                      [const Color.fromRGBO(255, 23, 50, 1), const Color.fromRGBO(255, 71, 144, 1)],
                      const Color.fromRGBO(255, 26, 53, 1),
                    ),
                    SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        crossAxisSpacing: 6.w,
                        mainAxisSpacing: 15.w,
                        childAspectRatio: _childAspectRatio,
                      ),
                      delegate: SliverChildBuilderDelegate((context, index) => _buildGridItem(context, data.crackApps[index], itemWidth, true),
                          childCount: data.crackApps.length),
                    ),
                    // 第二个网格部分
                    _buildGridTitle(
                      'pjz'.tr(context: context),
                      20.w,
                      [const Color.fromRGBO(90, 232, 161, 1), const Color.fromRGBO(90, 194, 232, 1)],
                      const Color.fromRGBO(90, 230, 166, 1),
                    ),
                    SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        crossAxisSpacing: 6.w,
                        mainAxisSpacing: 15.w,
                        childAspectRatio: _childAspectRatio,
                      ),
                      delegate: SliverChildBuilderDelegate(
                          (context, index) => _buildGridItem(context, data.noCrackApps[index], itemWidth, false),
                          childCount: data.noCrackApps.length),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget _buildGridItem(BuildContext context, CrackApp appData, double itemWidth, bool isCrack) {
    return IntervalGestureWidget(
      interval: 2,
      onTap: () {
        if (isCrack) {
          if (appData.isfree == 0) {
            // 免费
            _routeAppDetails(context, appData);
          } else if (appData.isfree == 1) {
            // vip解锁
            if ((_userNotifier.member.vipAppPrivilege ?? 0) > 0) {
              // 已经获得vip权限
              _routeAppDetails(context, appData);
            } else {
              // vip弹窗
              VipPayDialog.showVipDialog(context);
            }
          } else if (appData.isfree == 2) {
            // 金币解锁
            if ((_userNotifier.member.coinsAppPrivilege ?? 0) > 0) {
              // 已经获得金币权限
              _routeAppDetails(context, appData);
            } else {
              if (appData.isPay) {
                // 已经购买过
                _routeAppDetails(context, appData);
              } else {
                // 金币弹窗
                VipPayDialog.showCoinsDialog(context, _userNotifier.member, appData.coins.toDouble(), () async {
                  // 支付
                  int type = 0;
                  if (appData.appName == 'hjgj') {
                    type = CrackAppType.clsq.type;
                  } else if (appData.appName == 'awjq') {
                    type = CrackAppType.awjq.type;
                  } else if (appData.appName == '91aw') {
                    type = CrackAppType.aw91.type;
                  } else if (appData.appName == 'zpc') {
                    type = CrackAppType.zpc.type;
                  }
                  final result = await _userDomain.userAppBuy(source: appData.appName, type: type);
                  if (result.status == 1) {
                    appData.isPay = true;
                    MyToast.showText(text: result.data?.message ?? '');
                    if (context.mounted) {
                      context.pop();
                      _routeAppDetails(context, appData);
                    }
                  } else {
                    if (context.mounted) {
                      context.pop();
                    }
                    MyToast.showText(text: result.msg ?? '');
                  }
                });
              }
            }
          }
        } else {
          _showRuleDialog();
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: itemWidth,
            height: itemWidth,
            child: Stack(children: [AspectRatio(aspectRatio: 1, child: MyImage.network(appData.logo, fit: BoxFit.cover, borderRadius: 8.w)),
            if(isCrack)_buildCrackTag(appData.isfree),
              ]),
          ),
          SizedBox(height: 8.w),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Text(appData.title, style: MyTheme.white255_13_M.s12.w400.white25507),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildCrackTag(int isfree) {
    String text = '';
    LinearGradient gradient = MyTheme.gradient_90_135;

    switch (isfree) {
      case 0:
        text = '免费';
        gradient = MyTheme.gradient_90_135;
        break;
      case 1:
        text = 'VIP';
        gradient = MyTheme.vip_gradient_90_135;
        break;
      case 2:
        text = '金币';
        gradient = MyTheme.gradient_90_114;
        break;
    }
    return Positioned(
      top: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.w),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.only(topRight: Radius.circular(8.w), bottomLeft: Radius.circular(8.w)),
        ),
        child: Center(child: Text(text, style: MyTheme.white14.s9)),
      ),
    );
  }

  void _showRuleDialog() {
    BotToast.showWidget(
      toastBuilder: (cancelFunc) => NoCrackDialog(cancel: () {
        cancelFunc();
      }),
    );
  }

  Widget _buildGridTitle(String title, double marginTop, List<Color> gradient, Color indicatorColor) {
    return SliverToBoxAdapter(
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: marginTop),
            GradientText(
              title,
              style: MyTheme.white255_13_M.s18,
              gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: gradient),
            ),
            SizedBox(height: 3.w),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 5.w,
                  height: 3.w,
                  decoration: BoxDecoration(color: indicatorColor, borderRadius: const BorderRadius.all(Radius.circular(2))),
                ),
                SizedBox(width: 2.w),
                Container(
                  width: 15.w,
                  height: 3.w,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(2)),
                    gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: gradient),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _routeAppDetails(BuildContext context, CrackApp appData) {
    if (appData.appName == 'hjgj') {
      // 草榴社区
      const ClCommunityRoute(id: 1).push(context);
    } else if (appData.appName == 'awjq') {
      // 暗网禁区
      const AnWangRestrictedRoute(id: 1).push(context);
    } else if (appData.appName == '91aw') {
      // 91暗网
      const DarkWeb91Route(id: 1).push(context);
    } else if (appData.appName == 'zpc') {
      // 91制片厂
      const ZpcCommunityRoute(id: 1).push(context);
    }
  }
}
