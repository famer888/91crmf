import 'dart:io';
import 'dart:ui' as ui;

import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:jycrpj/domain/async_value.dart';
import 'package:jycrpj/domain/model/cash_withdraw_rule_model.dart';
import 'package:jycrpj/domain/remote_domain/domains/withdraw.dart';
import 'package:jycrpj/ui_layer/router/routes.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_avatar.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/status/loading.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/status/network_error.dart';
import 'package:jycrpj/ui_layer/screens/mine/share_to_user/widgets/gradient_progress_bar.dart';
import 'package:jycrpj/ui_layer/screens/mine/share_to_user/widgets/invite_image_widget.dart';
import 'package:jycrpj/ui_layer/screens/mine/share_to_user/widgets/invite_qr_dialog.dart';
import 'package:jycrpj/ui_layer/screens/mine/share_to_user/widgets/rule_dialog.dart';
import 'package:jycrpj/ui_layer/utils/my_toast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../../domain/model/member_model.dart';
import '../../../notifiers/home_config_notifier.dart';
import '../../../notifiers/user_notifier.dart';
import '../../common_widgets/my_app_bar.dart';
import '../../common_widgets/my_image.dart';
import '../../common_widgets/screen_background.dart';
import '../../image_paths.dart';
import '../../theme.dart';

import '../../../../report/ui_layer/report_gesture_detector.dart';

class ShareInviteScreen extends StatefulWidget {
  const ShareInviteScreen({super.key});

  @override
  State<ShareInviteScreen> createState() => _ShareInviteScreenState();
}

class _ShareInviteScreenState extends State<ShareInviteScreen> {
  late final _screenUtil = ScreenUtil();
  late final _withdrawDomain = context.read<WithdrawDomain>();
  late final _homeConfigNotifier = context.read<HomeConfigNotifier>();
  late final _userNotifier = context.read<UserNotifier>();
  AsyncValue<CashWithdrawRule?> _asyncValue = const AsyncInit();
  bool _showAppBar = true;

  final _snapShotViewKey = GlobalKey();

  void _showRuleDialog() {
    BotToast.showWidget(
      toastBuilder: (cancelFunc) => RuleDialog(cancel: () {
        cancelFunc();
      }),
    );
  }

  void _showInviteDialog() {
    BotToast.showWidget(
      toastBuilder: (cancelFunc) => InviteQrDialog(
        userNotifier: _userNotifier,
        homeConfigNotifier: _homeConfigNotifier,
        cancel: () {
          cancelFunc();
        },
        onSnap: () async {
          if (_snapShotViewKey.currentContext case final context?) {
            await _saveImageToGallery(context);
          }
        },
      ),
    );
  }

  Future _saveImageToGallery(BuildContext context) async {
    if (kIsWeb) {
      MyToast.showText(text: 'zxjt'.tr());
    } else {
      final statuses = await [
        Permission.storage,
        Permission.camera,
      ].request();

      if (!context.mounted) return;

      if (statuses[Permission.storage] == PermissionStatus.granted && statuses[Permission.camera] == PermissionStatus.granted) {
        await _localStorageImage(context);
      } else {
        MyToast.showText(text: 'wfbc'.tr());
        return;
      }
    }
  }

  Future _localStorageImage(BuildContext context) async {
    if (context.findRenderObject() case final RenderRepaintBoundary boundary) {
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      if (await image.toByteData(format: ui.ImageByteFormat.png) case final byteData?) {
        final pngBytes = byteData.buffer.asUint8List();

        /// 这个是核心的保存图片的插件
        final result = await ImageGallerySaverPlus.saveImage(pngBytes);
        if (!context.mounted) return;

        if (result['isSuccess']) {
          MyToast.showText(text: 'xxcgwd'.tr(context: context));
        } else if (Platform.isAndroid) {
          if (result.length > 0) {
            MyToast.showText(text: 'xxcgwd'.tr(context: context));
          }
        }
      }
    }
  }

  void _getWithdrawData() async {
    _asyncValue = const AsyncLoading();
    if (!mounted) return;
    setState(() {});

    final withdrawData = await _withdrawDomain.withdrawIndex();
    if (withdrawData.status == 1) {
      final withdrawData_ = withdrawData.data;
      if (withdrawData_ != null) {
        _showAppBar = false;
        _asyncValue = AsyncData(withdrawData_);
      } else {
        _showAppBar = false;
        _asyncValue = const AsyncData(null);
      }
    } else {
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
    return Scaffold(
      backgroundColor: MyTheme.blackColor22,
      appBar: _showAppBar ? MyAppBar(title: 'yqfx'.tr(context: context)) : null,
      body: _asyncValue.maybeWhen(
          init: () {
            _getWithdrawData();
            return const LoadingView();
          },
          error: (_, __) => NetworkErrorView(onTap: _getWithdrawData),
          orElse: () => const LoadingView(),
          data: (data) {
            return Stack(
              children: [
                InviteImageWidget(userNotifier: _userNotifier, homeConfigNotifier: _homeConfigNotifier, snapShotViewKey: _snapShotViewKey),
                ScreenBackground(
                  appBg: MyImage.asset(MyImagePaths.appBg, width: _screenUtil.screenWidth, height: 148.w),
                  child: Stack(
                    children: [
                      Scaffold(
                        appBar: MyAppBar(title: 'yqfx'.tr(context: context)),
                        body: SafeArea(
                          child: CustomScrollView(
                            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                            slivers: [
                              SliverToBoxAdapter(
                                child: Column(
                                  children: [
                                    SizedBox(height: 30.w),
                                    Center(child: MyImage.asset(MyImagePaths.appShareTitle, width: 288.w, height: 23.w)),
                                    SizedBox(height: 20.w),
                                    Stack(
                                      children: [
                                        _MyWithDrawlView(cashWithdrawRule: data, screenUtil: _screenUtil),
                                        Container(
                                          margin: EdgeInsets.only(top: 130.w),
                                          child: ClipRect(
                                            child: Align(
                                              alignment: Alignment.topCenter,
                                              heightFactor: ((_screenUtil.screenHeight - 280.w) / (_screenUtil.screenHeight)),
                                              child: MyImage.asset(
                                                MyImagePaths.appShareListBg,
                                                width: _screenUtil.screenWidth,
                                                height: _screenUtil.screenHeight,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          left: 0,
                                          right: 0,
                                          top: 180.w,
                                          child: Row(
                                            children: [
                                              SizedBox(width: 30.w),
                                              _buildButton(
                                                () {
                                                  const MineWithdrawalRoute(false).push(context);
                                                },
                                                width: 162.w,
                                                height: 35.w,
                                                linearColors: MyTheme.gradient_90_135_colors,
                                                text: 'lltx'.tr(context: context).replaceAll('00', data?.withdrawAmount ?? '0.00'),
                                              ),
                                              const Spacer(),
                                              _buildButton(
                                                () {
                                                  _showInviteDialog();
                                                },
                                                width: 123.w,
                                                height: 35.w,
                                                linearColors: MyTheme.gradient_90_114_colors,
                                                text: 'ljyqt'.tr(context: context),
                                              ),
                                              SizedBox(width: 30.w),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          left: 0,
                                          right: 0,
                                          top: 240.w,
                                          child: MyImage.asset(MyImagePaths.appMineTxTitle, width: 179.w, height: 18.w),
                                        ),
                                        Positioned(
                                          top: 270.w,
                                          left: 0,
                                          right: 0,
                                          bottom: 0,
                                          child: ListView.builder(
                                            physics: const AlwaysScrollableScrollPhysics(),
                                            itemCount: data?.orderList?.length ?? 0,
                                            itemBuilder: (context, index) {
                                              final order = data?.orderList?[index];
                                              return _buildRewardItem(order);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(top: 45.w, right: 0, child: _buildRuleWidget(context)),
                      Positioned(top: 75.w, right: 0, child: _buildInviteRecordWidget(context)),
                    ],
                  ),
                )
              ],
            );
          }),
    );
  }

  Widget _buildButton(
    Function() onTap, {
    required double width,
    required double height,
    required List<Color> linearColors,
    required String text,
  }) {
    return ReportGestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(18.w)), gradient: LinearGradient(colors: linearColors)),
        child: Text(text, style: MyTheme.white255_11.s14.w500),
      ),
    );
  }

  Widget _buildRewardItem(OrderModel? order) {
    if (order == null) return const SizedBox.shrink();

    return Stack(
      children: [
        Container(
          height: 66.4.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5.w)),
            gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color.fromRGBO(105, 60, 164, 0.8), Color.fromRGBO(74, 9, 9, 0.8)]),
          ),
        ),
        Container(
          height: 65.w,
          margin: EdgeInsets.only(left: 0.6.w, right: 0.6.w, top: 0.6.w, bottom: 10.0.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5.w)),
            gradient: const LinearGradient(colors: [Color.fromRGBO(29, 4, 7, 0.8), Color.fromRGBO(29, 4, 7, 0.9)]),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: 15.w),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.w),
                child: MyAvatar(
                  margin: 1,
                  size: 40.w,
                  isAssets: false,
                  thumb: order.avatar,
                  gradient: const LinearGradient(colors: [Colors.white, Colors.white]),
                ),
              ),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.w),
                  Text(order.name, style: MyTheme.white255_13.s14.w600),
                  SizedBox(height: 2.w),
                  Text(order.tip, style: MyTheme.white255_12.s14.w400),
                  SizedBox(height: 10.w),
                ],
              ),
              const Spacer(),
              Container(
                width: 62.w,
                height: 52.w,
                padding: EdgeInsets.only(right: 4.w),
                decoration: const BoxDecoration(image: DecorationImage(fit: BoxFit.fitHeight, image: AssetImage(MyImagePaths.appRecordLabel))),
                child: Column(
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: [
                        TextSpan(text: order.price.toString(), style: MyTheme.white255_12.w500.color250_255_115),
                        TextSpan(text: 'y'.tr(context: context), style: MyTheme.white255_12.w500),
                      ]),
                    ),
                    SizedBox(height: 2.w),
                    Text('ytx'.tr(context: context), style: MyTheme.white255_13.s11.w400),
                  ],
                ),
              ),
              SizedBox(width: 13.w),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRuleWidget(BuildContext context) {
    return ReportGestureDetector(
      onTap: () {
        _showRuleDialog();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.w),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: MyTheme.gradient_90_135_colors),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(10.w), bottomLeft: Radius.circular(10.w)),
        ),
        child: Text('gzsm'.tr(context: context), style: MyTheme.white14.w500.s10),
      ),
    );
  }

  Widget _buildInviteRecordWidget(BuildContext context) {
    return ReportGestureDetector(
      onTap: () {
        const MineShareToUserRecordRoute().push(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.w),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: MyTheme.gradient_90_114_colors),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(10.w), bottomLeft: Radius.circular(10.w)),
        ),
        child: Text('yqjl'.tr(context: context), style: MyTheme.white14.w500.s10),
      ),
    );
  }
}

class _MyWithDrawlView extends StatelessWidget {
  final CashWithdrawRule? cashWithdrawRule;
  final ScreenUtil screenUtil;

  const _MyWithDrawlView({required this.cashWithdrawRule, required this.screenUtil});

  @override
  Widget build(BuildContext context) {
    final withdrawAmount = cashWithdrawRule?.withdrawAmount ?? '0.00';
    final eventMoney = cashWithdrawRule?.eventMoney ?? '0.00';
    // 转为 double
    final withdrawValue = double.tryParse(withdrawAmount) ?? 0.0;
    final eventMoneyValue = double.tryParse(eventMoney) ?? 0.0;
    // 差值（withdraw - eventMoney）
    final diff = withdrawValue - eventMoneyValue;
    String diffStr = '';
    if (diff > 0) {
      diffStr = diff.toStringAsFixed(2);
    } else {
      diffStr = '0';
    }

    final progress = withdrawValue <= 0 ? 0.0 : (eventMoneyValue / withdrawValue).clamp(0.0, 1.0);

    return Stack(
      children: [
        Center(
          child: SizedBox(
            width: screenUtil.screenWidth - 2 * MyTheme.pagePadding,
            height: 173.w,
            child: MyImage.asset(
              MyImagePaths.appShareInviteBg,
              width: screenUtil.screenWidth - 2 * MyTheme.pagePadding,
              height: 173.w,
              fit: BoxFit.fill,
            ),
          ),
        ),
        Center(
          child: SizedBox(
            width: screenUtil.screenWidth - 2 * MyTheme.pagePadding,
            height: 173.w,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(width: 20.w),
                    Selector<UserNotifier, Member>(
                      selector: (_, config) => config.member,
                      builder: (context, member, child) => Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          MyAvatar(
                            thumb: member.thumb,
                            margin: 1,
                            size: 60.w,
                            gradient: const LinearGradient(colors: [Colors.white, Colors.white]),
                          ),
                          SizedBox(height: 10.w),
                          Text(member.nickname, style: MyTheme.white14),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(height: 10.w),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 4.5.w),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(69, 36, 16, 1),
                            borderRadius: BorderRadius.circular(45.w),
                            border: Border.all(color: const Color.fromRGBO(122, 80, 14, 1), width: 0.5.w),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              MyImage.asset(MyImagePaths.appShareInviteDaizi, width: 30.w, height: 30.w),
                              SizedBox(width: 5.w),
                              Text(eventMoney,
                                  style: TextStyle(color: const Color.fromRGBO(250, 255, 115, 1), fontSize: 25.sp, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.w),
                        Row(
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(text: '${'ltxjc'.tr(context: context)} ', style: MyTheme.white06_18.white.w500),
                                  TextSpan(
                                      text: diffStr,
                                      style: TextStyle(color: MyTheme.color250_255_115, fontSize: 18.sp, fontWeight: FontWeight.w500)),
                                  TextSpan(text: 'y'.tr(context: context), style: MyTheme.white06_18.white.w500),
                                ],
                              ),
                            ),
                            SizedBox(width: 15.w)
                          ],
                        ),
                      ],
                    ),
                    SizedBox(width: 20.w),
                  ],
                ),
                SizedBox(height: 15.w),
                SizedBox(
                  width: screenUtil.screenWidth - 5 * MyTheme.pagePadding,
                  child: GradientProgressBar(
                    value: progress,
                    height: 17,
                    linearColors: const [Color.fromRGBO(217, 106, 21, 0.8), Color.fromRGBO(224, 176, 20, 0.8)],
                    radius: const BorderRadius.all(Radius.circular(9)),
                    label: Text('dqedjd'.tr(context: context).replaceAll('00', eventMoney), style: MyTheme.white255_13.s12.w400),
                  ),
                ),
                SizedBox(height: 15.w),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
