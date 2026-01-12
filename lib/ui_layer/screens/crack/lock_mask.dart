import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jycrpj/domain/model/crack_model.dart';
import 'package:jycrpj/domain/remote_domain/domains/user.dart';
import 'package:jycrpj/report/ui_layer/report_gesture_detector.dart';
import 'package:jycrpj/ui_layer/notifiers/user_notifier.dart';
import 'package:jycrpj/ui_layer/screens/black/vip_pay_dialog.dart';
import 'package:jycrpj/ui_layer/screens/crack/crack_app_type.dart';
import 'package:jycrpj/ui_layer/screens/crack/unlock_status_notifier.dart';
import 'package:jycrpj/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';

class LockMask extends StatefulWidget {
  final CrackApp crackApp;
  final int type;
  final VoidCallback onUnlock;

  const LockMask({super.key, required this.crackApp, required this.type, required this.onUnlock});

  @override
  State<LockMask> createState() => _LockMaskState();
}

class _LockMaskState extends State<LockMask> {
  late final _userDomain = context.read<UserDomain>();
  late final _userNotifier = context.read<UserNotifier>();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: ReportGestureDetector(
          behavior: HitTestBehavior.opaque, // ⭐⭐⭐ 吞掉一切事件
          onTap: () async {
            if (widget.crackApp.isfree == 1) {
              VipPayDialog.showVipDialog(context);
              return;
            }

            if (widget.crackApp.isfree == 2) {
              VipPayDialog.showCoinsDialog(
                context: context,
                barrierDismissible: false,
                member: _userNotifier.member,
                coins: widget.crackApp.coins.toDouble(),
                onPay: () async {
                  final userNotifier = context.read<UserNotifier>();
                  final member = userNotifier.member;
                  final adequate = member.money >= widget.crackApp.coins;

                  if (!adequate) {
                    MyToast.showText(text: 'ndyebz'.tr(context: context));
                    return;
                  }

                  final result = await _userDomain.userAppBuy(
                    source: widget.crackApp.appName,
                    type: widget.type,
                  );

                  if (!context.mounted) return;

                  context.pop();

                  if (result.status == 1) {
                    final currentMoney = member.money - widget.crackApp.coins;
                    userNotifier.setMoney(money: currentMoney);
                    widget.crackApp.isPay = true;
                    if (widget.type == CrackAppType.clsq.type) {}
                    _updateUnlockStatus(true);
                    MyToast.showText(text: result.data?.message ?? '');
                    setState(() {});
                    widget.onUnlock.call();
                  } else {
                    MyToast.showText(text: result.msg ?? '');
                  }
                },
              );
            }
          },
          child: Container(color: Colors.black.withOpacity(0.15)),
        ),
      ),
    );
  }

  _updateUnlockStatus(bool status) {
    if (widget.type == CrackAppType.clsq.type) {
      context.read<UnlockStatusNotifier>().changeClsqUnlockStatus(true);
    } else if (widget.type == CrackAppType.aw91.type) {
      context.read<UnlockStatusNotifier>().changeAw91UnlockStatus(true);
    } else if (widget.type == CrackAppType.awjq.type) {
      context.read<UnlockStatusNotifier>().changeAwjqUnlockStatus(true);
    } else if (widget.type == CrackAppType.pzhan.type) {
      context.read<UnlockStatusNotifier>().changePzhanUnlockStatus(true);
    } else if (widget.type == CrackAppType.zpc.type) {
      context.read<UnlockStatusNotifier>().changeZpc91UnlockStatus(true);
    }
  }
}
