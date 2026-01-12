import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/domain/model/banner_model.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/dialog/my_dialog.dart';
import 'package:jycrpj/ui_layer/screens/mine/bind_email/screen.dart';
import 'package:jycrpj/ui_layer/utils/common_utils.dart';
import 'package:provider/provider.dart';

import '../../../domain/enum.dart';
import '../../../domain/model/member_model.dart';
import '../../../domain/type_def.dart';
import '../../../report/ui_layer/report_general_banner.dart';
import '../../../report/ui_layer/report_gesture_detector.dart';
import '../../notifiers/home_config_notifier.dart';
import '../../notifiers/user_notifier.dart';
import '../../router/routes.dart';
import '../common_widgets/member_vip.dart';
import '../common_widgets/my_avatar.dart';
import '../common_widgets/my_image.dart';
import '../common_widgets/my_list_view.dart';
import '../common_widgets/screen_background.dart';
import '../image_paths.dart';
import '../theme.dart';

class MineScreen extends StatefulWidget {
  const MineScreen({super.key});

  @override
  State<MineScreen> createState() => _MineScreenState();
}

class _MineScreenState extends State<MineScreen> {
  late final _homeConfigNotifier = context.watch<HomeConfigNotifier>();

  _judgeIfBindEmail() {
    late final userNotifier = context.read<UserNotifier>();
    if (userNotifier.member.bindEmail != 1) {
      _showBindEmailPop();
    }
  }

  _showBindEmailPop() {
    MyDialog.showDialog(
      context: context,
      child: Dialog(
        // title: tr('ts'),
        backgroundColor: MyTheme.bgColor,
        //前往充值 - 立即购买
        // buttonText: tr('fxdv'),
        // //做任务得VIP
        // confirmOnTap: () {
        //   const MineWelfareRoute(index: 1).push(context);
        // },
        // cancelOnTap: () {
        //   if (isInsufficient) {
        //     const CoinRechargeRoute().push(context);
        //   } else {
        //     byVideoRes(member.money - widget.info.coins!);
        //   }
        // },
        child: Container(
          width: 305.w,
          height: 410.w,
          padding: EdgeInsets.symmetric(vertical: 10.w),
          child: const MineBindEmailScreen(
            isForPop: true,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 300), () {
      _judgeIfBindEmail();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      appBg: MyImage.asset(MyImagePaths.appBg, fit: BoxFit.cover, width: ScreenUtil().screenWidth, height: 148.w),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const _FixedTopArea(),
              Expanded(
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  slivers: [
                    MyIndicator(onRefresh: () async {
                      await context.read<UserNotifier>().init();
                    }),
                    SliverToBoxAdapter(child: _Body(homeConfigNotifier: _homeConfigNotifier)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FixedTopArea extends StatelessWidget {
  const _FixedTopArea();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, right: 13, bottom: 11),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const _SystemNoticeIcon(),
          const SizedBox(width: 20),
          ReportGestureDetector(
            onTap: () => const MineSetupRoute().push(context),
            child: const MyImage.asset(MyImagePaths.appMineSetting, width: 25, fit: BoxFit.fitWidth),
          )
        ],
      ),
    );
  }
}

class _SystemNoticeIcon extends StatelessWidget {
  const _SystemNoticeIcon();

  @override
  Widget build(BuildContext context) {
    return ReportGestureDetector(
      onTap: () {
        const MessageCenterRoute().push(context);
      },
      child: Selector<UserNotifier, bool>(
          selector: (_, notifier) =>
              (notifier.systemNotice != null && (notifier.systemNotice?.systemNoticeCount != 0 || notifier.systemNotice?.feedCount != 0)),
          builder: (context, value, _) {
            return Stack(
              children: [
                const MyImage.asset(MyImagePaths.appMineMessage, width: 25, fit: BoxFit.fitWidth),
                value
                    ? Positioned(
                        right: 0,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(width: 0.5, color: Colors.white.withOpacity(0.4))),
                        ),
                      )
                    : Container()
              ],
            );
          }),
    );
  }
}

class _Body extends StatelessWidget {
  final HomeConfigNotifier homeConfigNotifier;

  const _Body({required this.homeConfigNotifier});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _HeaderInfo(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
          child: Column(
            children: [
              SizedBox(height: 20.w),
              const _VIPCenter(),
              SizedBox(height: 15.w),
              const _CenterMenu(),
              SizedBox(height: 15.w),
              const _SecondMenu(),
              _AdBanner(banners: homeConfigNotifier.config.personAds),
              SizedBox(height: 20.w),
              const _ThirdMenu(),
              SizedBox(height: 15.w),
            ],
          ),
        ),
      ],
    );
  }
}

class _AdBanner extends StatelessWidget {
  final dynamic banners;

  const _AdBanner({required this.banners});

  @override
  Widget build(BuildContext context) {
    if (banners == null) {
      return const SizedBox.shrink();
    }

    if (banners is List) {
      try {
        final bannerList = banners.map<BannerModel>((e) {
          final bannerModel = BannerModel.fromJson(e);
          return bannerModel;
        }).toList();
        return Padding(
          padding: EdgeInsets.only(top: 20.w),
          child: ReportGeneralAppsListVidget(data: bannerList),
        );
      } catch (e) {
        CommonUtils.log('banners转换出错:$e');
        return const SizedBox.shrink();
      }
    } else {
      return const SizedBox.shrink();
    }
  }
}

class _HeaderInfo extends StatelessWidget {
  const _HeaderInfo();

  @override
  Widget build(BuildContext context) {
    return Selector<UserNotifier, Member>(
      selector: (_, config) => config.member,
      builder: (context, member, child) => Padding(
        padding: const EdgeInsets.only(left: 13),
        child: Row(
          children: [
            MyAvatar(
              thumb: member.thumb,
              margin: 1,
              size: 60.w,
              gradient: const LinearGradient(colors: [Colors.white, Colors.white]),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      constraints: BoxConstraints(maxWidth: 150.w),
                      child: Text(
                        member.nickname,
                        style: MyTheme.white18bold,
                      ),
                    ),
                    if (member.agent == 1)
                      Container(
                        margin: EdgeInsets.only(left: 5.w),
                        child: const Icon(
                          Icons.verified_sharp,
                          size: 17,
                          color: Color.fromRGBO(247, 208, 93, 1),
                        ),
                      ),
                    if (member.vipUpgrade == 1)
                      ReportGestureDetector(
                        onTap: () => const VipUpgradeRoute().push(context),
                        child: Container(
                          margin: EdgeInsets.only(left: 5.w),
                          child: MyImage.asset(
                            MyImagePaths.appMineVipUpgrade,
                            width: 70.w,
                            height: 22.w,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    if (member.vipLevel.isVip())
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: MemberVipWidget(
                          height: 20,
                          vipImage: member.vipImg,
                        ),
                      ),
                    Text(
                      'ID: ${member.aff ?? '0000000'}',
                      style: MyTheme.white255_14.white25507,
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            Selector<UserNotifier, MyTokenStatus?>(
              selector: (_, userNotifier) => userNotifier.tokenStatus,
              builder: (context, tokenStatus, child) => tokenStatus == MyTokenStatus.valid
                  ? const SizedBox.shrink()
                  : ReportGestureDetector(
                      onTap: () => const LoginRoute().push(context),
                      child: Container(
                        width: 70,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(35, 38, 46, 1),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                          ),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                tr('dl'),
                                style: const TextStyle(
                                  color: Color.fromRGBO(250, 207, 135, 1),
                                  fontSize: 14,
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 14,
                                color: Color.fromRGBO(250, 207, 135, 1),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}

class _VIPCenter extends StatefulWidget {
  const _VIPCenter();

  @override
  State<_VIPCenter> createState() => _VIPCenterState();
}

class _VIPCenterState extends State<_VIPCenter> {
  late final config = context.read<HomeConfigNotifier>().config;

  /// 当前日期
  String time = DateFormat('yyyy-MM-dd').format(DateTime.now());

  /// 取得副标题
  String getSubTitle({String? expiredAt, required bool isVIP}) {
    if (isVIP) {
      String expiredDate = expiredAt?.split(' ')[0] ?? '';
      if (expiredDate.isEmpty) {
        return tr('fhy');
      } else {
        return (expiredDate == time) ? tr('fhy') : expiredDate + tr('dq');
      }
    } else {
      return tr('fhy');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75.w,
      child: ReportGestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => const VipCenterRoute().push(context),
        child: Stack(
          children: [
            Positioned.fill(
              child: MyImage.asset(MyImagePaths.appMineVip, height: 77.5.w, fit: BoxFit.fill),
            ),
            Positioned(
              bottom: 10.w,
              right: 58.w,
              child: MyImage.asset(MyImagePaths.appMineVipOpen, width: 76.w, height: 26.w, fit: BoxFit.fill),
            ),
          ],
        ),
      ),
    );
  }
}

class _CenterMenu extends StatelessWidget {
  const _CenterMenu();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Selector<UserNotifier, int>(
              selector: (_, config) => config.member.money,
              builder: (context, money, child) {
                return SizedBox(
                  width: 170.w,
                  height: 77.5.w,
                  child: ReportGestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => const CoinRechargeRoute().push(context),
                    child: Stack(
                      children: [
                        const MyImage.asset(MyImagePaths.appMineRecharge, width: double.infinity, height: double.infinity, fit: BoxFit.fill),
                        Align(
                          alignment: const FractionalOffset(0.1, 0.25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('jbcz'.tr(context: context), style: MyTheme.white255_18.s16.white25509.w500),
                              const SizedBox(height: 5),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(text: "${'yee'.tr(context: context)} : ", style: MyTheme.white255_14.color247_93_96),
                                    TextSpan(text: "$money", style: MyTheme.white255_14.color247_93_96),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ),
        SizedBox(width: 5.5.w),
        Expanded(
          child: SizedBox(
            width: 170.w,
            height: 77.5.w,
            child: ReportGestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => const ShareInviteRoute().push(context),
              child: Stack(
                children: [
                  const MyImage.asset(MyImagePaths.appMineShare, width: double.infinity, height: double.infinity, fit: BoxFit.fill),
                  Align(
                    alignment: const FractionalOffset(0.1, 0.25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('fxyq'.tr(context: context), style: MyTheme.white255_18.s16.white25509.w500),
                        const SizedBox(height: 5),
                        Text('yqhydvp'.tr(context: context), style: MyTheme.white255_14.color247_93_96),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        // SizedBox(width: 5.5.w),
        // Expanded(
        //   child: SizedBox(
        //     width: 170.w,
        //     height: 77.5.w,
        //     child: ReportGestureDetector(
        //       behavior: HitTestBehavior.translucent,
        //       onTap: () => const MineAgentRoute().push(context),
        //       child: Stack(
        //         children: [
        //           const MyImage.asset(MyImagePaths.appAgentBg, width: double.infinity, height: double.infinity, fit: BoxFit.fill),
        //           Align(
        //             alignment: const FractionalOffset(0.1, 0.25),
        //             child: Column(
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               mainAxisSize: MainAxisSize.min,
        //               children: [
        //                 Text('dltg'.tr(context: context), style: MyTheme.white255_18.s16.white25509.w500),
        //                 const SizedBox(height: 5),
        //                 Text('qwzgfc'.tr(context: context), style: MyTheme.white255_14.color247_93_96),
        //               ],
        //             ),
        //           )
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}

class _SecondMenu extends StatelessWidget {
  const _SecondMenu();

  @override
  Widget build(BuildContext context) {
    final menu = [
      (
        title: 'wdgm'.tr(context: context),
        iconName: MyImagePaths.appMineBuy,
        onTap: () => const MineBuyRoute().push(context),
      ),
      (
        title: 'lljl'.tr(context: context),
        iconName: MyImagePaths.appMineLook,
        onTap: () {
          const VisitRecordScreenRoute().push(context);
        },
      ),
      // (
      //   title: 'tzfb'.tr(context: context),
      //   iconName: MyImagePaths.appMinePost,
      //   onTap: () => const MinePostRoute().push(context),
      // ),
      (
        title: 'zxhc'.tr(context: context),
        iconName: MyImagePaths.appMineDownload,
        onTap: () => const MineDownloadRoute().push(context),
      ),
      (
        title: 'wdsc'.tr(context: context),
        iconName: MyImagePaths.appMineCollection,
        onTap: () => const MineCollectionRoute().push(context),
      ),
      // (
      //   title: 'wdgz'.tr(context: context),
      //   iconName: MyImagePaths.appMineFollow,
      //   onTap: () => const MineFollowingRoute().push(context),
      // ),
      // (
      //   title: 'ycrz'.tr(context: context),
      //   iconName: MyImagePaths.appMineBlogger,
      //   onTap: () => const OriginalEnterRoute().push(context),
      // ),
    ];

    return Container(
      decoration: const BoxDecoration(color: Color.fromRGBO(28, 18, 22, 1), borderRadius: BorderRadius.all(Radius.circular(8))),
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Column(
        children: [
          Row(children: [Text('cygn'.tr(context: context), style: MyTheme.white255_14.s16.w500)]),
          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
            children: [
              for (final data in menu)
                ReportGestureDetector(
                  onTap: data.onTap,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      MyImage.asset(data.iconName, width: 30, height: 30),
                      const SizedBox(height: 10),
                      Text(data.title, style: const TextStyle(fontSize: 12, color: Color.fromRGBO(255, 255, 255, 1.0)))
                    ],
                  ),
                )
            ],
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}

class _ThirdMenu extends StatelessWidget {
  const _ThirdMenu();

  @override
  Widget build(BuildContext context) {
    final menu = [
      // (
      //   title: 'wdgm'.tr(context: context),
      //   iconName: MyImagePaths.appMineBuy,
      //   onTap: () => const MineBuyRoute().push(context),
      // ),
      (
        title: 'wdai'.tr(context: context),
        iconName: MyImagePaths.appMineAi,
        onTap: () => const MineAIRecordRoute().push(context),
      ),
      // (
      //   title: 'zxhc'.tr(context: context),
      //   iconName: MyImagePaths.appMineDownload,
      //   onTap: () => const MineDownloadRoute().push(context),
      // ),
      (
        title: 'gfkf'.tr(context: context),
        iconName: MyImagePaths.appMineService,
        onTap: () => const MineCustomerServiceRoute().push(context),
      ),
      (
        title: 'gfjlq'.tr(context: context),
        iconName: MyImagePaths.appMineGroups,
        onTap: () => const MineOfficialGroupRoute().push(context),
      ),
      (
        title: 'txyqm'.tr(context: context),
        iconName: MyImagePaths.appMineInviteCode,
        onTap: () => MineFillCodeRoute('yqm'.tr(context: context)).push(context),
      ),
      // (
      //   title: 'txdhm'.tr(context: context),
      //   iconName: MyImagePaths.appMineRedeem,
      //   onTap: () => MineFillCodeRoute('dhm'.tr(context: context)).push(context),
      // ),
      // (
      //   title: 'cjwt'.tr(context: context),
      //   iconName: MyImagePaths.appMineHelp,
      //   onTap: () => const MineHelpRoute().push(context),
      // ),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Color.fromRGBO(28, 18, 22, 1),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13 / 2),
      child: Column(children: [
        Row(children: [Text('yhfw'.tr(context: context), style: MyTheme.white255_14.s16.w500)]),
        GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
          children: [
            for (final data in menu)
              ReportGestureDetector(
                onTap: data.onTap,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MyImage.asset(data.iconName, width: 30, height: 30),
                    const SizedBox(height: 10),
                    Text(data.title, style: const TextStyle(fontSize: 12, color: Color.fromRGBO(255, 255, 255, 1.0))),
                  ],
                ),
              )
          ],
        ),
      ]),
    );

    // return Container(
    //     padding: const EdgeInsets.symmetric(horizontal: 27.5, vertical: 10),
    //     decoration: BoxDecoration(
    //       gradient: const LinearGradient(
    //         colors: [
    //           Color.fromRGBO(21, 21, 42, 1),
    //           Color.fromRGBO(11, 11, 33, 1),
    //         ],
    //         begin: Alignment.topCenter,
    //         end: Alignment.bottomCenter,
    //       ),
    //       borderRadius: BorderRadius.circular(5),
    //     ),
    //     child: ListView(
    //       shrinkWrap: true,
    //       physics: const NeverScrollableScrollPhysics(),
    //       addAutomaticKeepAlives: false,
    //       addRepaintBoundaries: false,
    //       children: [
    //         for (final data in menu)
    //           ReportGestureDetector(
    //             behavior: HitTestBehavior.translucent,
    //             onTap: data.onTap,
    //             child: SizedBox(
    //               height: 44,
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 crossAxisAlignment: CrossAxisAlignment.center,
    //                 children: [
    //                   Row(
    //                     mainAxisSize: MainAxisSize.min,
    //                     children: [
    //                       MyImage.asset(
    //                         data.iconName,
    //                         width: 20,
    //                         height: 20,
    //                       ),
    //                       const SizedBox(width: 9.5),
    //                       Text(
    //                         data.title,
    //                         overflow: TextOverflow.ellipsis,
    //                         style: MyTheme.white14w400,
    //                       ),
    //                     ],
    //                   ),
    //                   const MyImage.asset(
    //                     MyImagePaths.appMineRightArrow,
    //                     width: 10,
    //                     height: 10,
    //                   )
    //                 ],
    //               ),
    //             ),
    //           )
    //       ],
    //     ));
  }
}
