import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/domain/model/crack_model.dart';
import 'package:jycrpj/report/ui_layer/report_gesture_detector.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/gradient_text.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jycrpj/ui_layer/screens/crack/widgets/crack_status_tag.dart';
import 'package:jycrpj/ui_layer/screens/crack/widgets/no_crack_dialog.dart';
import 'package:jycrpj/ui_layer/screens/image_paths.dart';
import 'package:jycrpj/ui_layer/screens/theme.dart';

typedef ChangeAppCallback = Function(int index, CrackApp crackApp);

class CrackAppDrawer extends StatefulWidget {
  final ValueNotifier<List<CrackApp>> noCrackAppsNotifier;
  final List<CrackApp> crackApps;
  final int initialIndex;
  final ChangeAppCallback changeAppCallback;

  const CrackAppDrawer({
    super.key,
    required this.noCrackAppsNotifier,
    required this.crackApps,
    required this.changeAppCallback,
    required this.initialIndex,
  });

  @override
  State<CrackAppDrawer> createState() => _CrackAppDrawerState();
}

class _CrackAppDrawerState extends State<CrackAppDrawer> {
  final double _childAspectRatio = 57 / 67;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 4,
      shadowColor: const Color.fromRGBO(3, 1, 2, 1),
      backgroundColor: const Color.fromRGBO(9, 7, 11, 1),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Padding(
        padding: EdgeInsets.only(top: MyTheme.pagePadding, left: 12.w, right: 12.w),
        child: LayoutBuilder(builder: (context, constraints) {
          double itemWidth = (constraints.maxWidth - (4 - 1) * 6.w - 12.w * 2) / 4;
          return CustomScrollView(
            slivers: [
              // 第一个网格部分
              SliverToBoxAdapter(child: SizedBox(height: 25.w)),
              SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GradientText(
                      'ypj'.tr(context: context),
                      style: MyTheme.white255_13_M.s18,
                      gradient: const LinearGradient(
                        colors: [Color.fromRGBO(255, 23, 50, 1), Color.fromRGBO(255, 71, 144, 1)],
                      ),
                    ),
                    ReportGestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: MyImage.asset(MyImagePaths.appClose, color: MyTheme.whiteColor, width: 16.w, height: 16.w),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 15.w)),
              SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 6.w,
                  mainAxisSpacing: 15.w,
                  childAspectRatio: _childAspectRatio,
                ),
                delegate: SliverChildBuilderDelegate(
                  childCount: widget.crackApps.length,
                  (context, index) => _buildGridItem(
                      context: context,
                      index: index,
                      appData: widget.crackApps[index],
                      itemWidth: itemWidth,
                      isCrack: true,
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                        });
                        widget.changeAppCallback.call(index, widget.crackApps[index]);
                        Navigator.pop(context);
                      }),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 28.w)),
              SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GradientText(
                      'pjz'.tr(context: context),
                      style: MyTheme.white255_13_M.s18,
                      gradient: const LinearGradient(
                        colors: [Color.fromRGBO(90, 232, 161, 1), Color.fromRGBO(90, 194, 232, 1)],
                      ),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 15.w)),
              ValueListenableBuilder(
                  valueListenable: widget.noCrackAppsNotifier,
                  builder: (_, noCrackApps, __) {
                    return SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 6.w,
                        mainAxisSpacing: 15.w,
                        childAspectRatio: _childAspectRatio,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        childCount: noCrackApps.length,
                        (context, index) => _buildGridItem(
                            context: context,
                            index: index,
                            appData: noCrackApps[index],
                            itemWidth: itemWidth,
                            isCrack: false,
                            onTap: () {
                              BotToast.showWidget(
                                toastBuilder: (cancelFunc) => NoCrackDialog(cancel: () {
                                  cancelFunc();
                                }),
                              );
                            }),
                      ),
                    );
                  }),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildGridItem({
    required BuildContext context,
    required int index,
    required CrackApp appData,
    required double itemWidth,
    required bool isCrack,
    VoidCallback? onTap,
  }) {
    return ReportGestureDetector(
      onTap: onTap,
      // () {
      // if (isCrack) {
      //   // _routeAppDetails(context, appData);
      //
      //   if (appData.isfree == 0) {
      //     // 免费
      //     _routeAppDetails(context, appData);
      //   } else if (appData.isfree == 1) {
      //     // vip解锁
      //     if ((_userNotifier.member.vipAppPrivilege ?? 0) > 0) {
      //       // 已经获得vip权限
      //       _routeAppDetails(context, appData);
      //     } else {
      //       // vip弹窗
      //       VipPayDialog.showVipDialog(context);
      //     }
      //   } else if (appData.isfree == 2) {
      //     // 金币解锁
      //     if ((_userNotifier.member.coinsAppPrivilege ?? 0) > 0) {
      //       // 已经获得金币权限
      //       _routeAppDetails(context, appData);
      //     } else {
      //       if (appData.isPay) {
      //         // 已经购买过
      //         _routeAppDetails(context, appData);
      //       } else {
      //         // 金币弹窗
      //         VipPayDialog.showCoinsDialog(
      //           context: context,
      //           barrierDismissible: false,
      //           member: _userNotifier.member,
      //           coins: appData.coins.toDouble(),
      //           onPay: () async {
      //             // 支付
      //             int type = 0;
      //             if (appData.appName == 'hjgj') {
      //               type = CrackAppType.clsq.type;
      //             } else if (appData.appName == 'awjq') {
      //               type = CrackAppType.awjq.type;
      //             } else if (appData.appName == '91aw') {
      //               type = CrackAppType.aw91.type;
      //             } else if (appData.appName == 'zpc') {
      //               type = CrackAppType.zpc.type;
      //             }
      //             final result = await _userDomain.userAppBuy(source: appData.appName, type: type);
      //             if (result.status == 1) {
      //               appData.isPay = true;
      //               MyToast.showText(text: result.data?.message ?? '');
      //               if (context.mounted) {
      //                 context.pop();
      //                 _routeAppDetails(context, appData);
      //               }
      //             } else {
      //               if (context.mounted) {
      //                 context.pop();
      //               }
      //               MyToast.showText(text: result.msg ?? '');
      //             }
      //           },
      //         );
      //       }
      //     }
      //   }
      // } else {
      //   _showRuleDialog();
      // }
      // },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(11.w)),
              border: Border.all(
                width: 1.0,
                color: isCrack
                    ? (_selectedIndex == index ? MyTheme.blueColor64 : const Color.fromRGBO(0, 0, 0, 0))
                    : const Color.fromRGBO(0, 0, 0, 0),
              ),
            ),
            width: itemWidth,
            height: itemWidth,
            child: Stack(children: [
              MyImage.network(appData.logo, fit: BoxFit.cover, borderRadius: 10.w, width: itemWidth, height: itemWidth),
              if (isCrack) CrackStatusTag(isFree: appData.isfree),
            ]),
          ),
          SizedBox(height: 3.w),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Text(
                appData.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isCrack ? (_selectedIndex == index ? MyTheme.blueColor64 : Colors.white) : Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 12.sp,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
