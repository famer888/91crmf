import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jycrpj/app_global.dart';
import 'package:jycrpj/domain/model/crack_model.dart';
import 'package:jycrpj/domain/model/member_model.dart';
import 'package:jycrpj/domain/remote_domain/domains/crack.dart';
import 'package:jycrpj/domain/remote_domain/domains/user.dart';
import 'package:jycrpj/ui_layer/notifiers/user_notifier.dart';
import 'package:jycrpj/ui_layer/screens/black/vip_pay_dialog.dart';
import 'package:jycrpj/ui_layer/screens/crack/crack_app_type.dart';
import 'package:jycrpj/ui_layer/screens/crack/unlock_status_notifier.dart';
import 'package:jycrpj/ui_layer/utils/common_utils.dart';
import 'package:jycrpj/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';

class AppUtil {
  // 判断app是否需要解锁
  static bool isUnlockApp(CrackApp crackApp, Member member) {
    if (crackApp.isfree == 1) {
      // vip解锁
      if ((member.vipAppPrivilege ?? 0) > 0) {
        return true;
      }
      if (crackApp.isPay) {
        return true;
      }
      return false;
    } else if (crackApp.isfree == 2) {
      // 金币解锁
      if ((member.coinsAppPrivilege ?? 0) > 0) {
        return true;
      }
      if (crackApp.isPay) {
        return true;
      }
      return false;
    } else {
      // 免费
      return true;
    }
  }

  static Future<void> initCheckAppUnlockStatus() async {
    final context = AppGlobal.context;
    if (context == null) return;

    final crackDomain = context.read<CrackDomain>();
    final resCrackRes = await crackDomain.getCrackList(isCrack: 1);
    if (resCrackRes.status == 1) {
      if (context.mounted) {
        final userNotifier = context.read<UserNotifier>();
        final unlockStatusNotifier = context.read<UnlockStatusNotifier>();
        final crackApps = resCrackRes.data?.crackApps ?? <CrackApp>[];
        initialAppUnlockStatus(unlockStatusNotifier, userNotifier, crackApps);
      }
    } else {
      CommonUtils.log('刷新破解列表失败 - ${resCrackRes.msg}');
    }
  }

  static void initialAppUnlockStatus(UnlockStatusNotifier unlockStatusNotifier, UserNotifier userNotifier, List<CrackApp> sortedApps) {
    for (var app in sortedApps) {
      final isUnlockApp = AppUtil.isUnlockApp(app, userNotifier.member);
      changeAppUnlockStatus(unlockStatusNotifier, app, isUnlockApp);
    }
  }

  static void changeAppUnlockStatus(UnlockStatusNotifier unlockStatusNotifier, CrackApp app, bool status) {
    if (app.appName == CrackAppType.clsq.appName) {
      unlockStatusNotifier.changeClsqUnlockStatus(status);
    } else if (app.appName == CrackAppType.pzhan.appName) {
      unlockStatusNotifier.changePzhanUnlockStatus(status);
    } else if (app.appName == CrackAppType.zpc.appName) {
      unlockStatusNotifier.changeZpc91UnlockStatus(status);
    } else if (app.appName == CrackAppType.awjq.appName) {
      unlockStatusNotifier.changeAwjqUnlockStatus(status);
    } else if (app.appName == CrackAppType.aw91.appName) {
      unlockStatusNotifier.changeAw91UnlockStatus(status);
    } else if (app.appName == CrackAppType.hjsq.appName) {
      unlockStatusNotifier.changeHjsqUnlockStatus(status);
    } else if (app.appName == CrackAppType.tiktok51.appName) {
      unlockStatusNotifier.changeTiktok51UnlockStatus(status);
    } else if (app.appName == CrackAppType.gd.appName) {
      unlockStatusNotifier.changeGdcmUnlockStatus(status);
    } else if (app.appName == CrackAppType.xiaolan.appName) {
      unlockStatusNotifier.changeXiaolanUnlockStatus(status);
    }
  }

  static void checkUnlockStatus({
    required BuildContext context,
    required CrackApp crackApp,
    required UserNotifier userNotifier,
    required UnlockStatusNotifier unlockStatusNotifier,
    required UserDomain userDomain,
  }) {
    final isUnlockApp_ = isUnlockApp(crackApp, userNotifier.member);
    changeAppUnlockStatus(unlockStatusNotifier, crackApp, isUnlockApp_);
    if (isUnlockApp_) return;

    if (crackApp.isfree == 1) {
      VipPayDialog.showVipDialog(context);
      return;
    }

    if (crackApp.isfree == 2) {
      int type = CrackAppType.normal.type;
      if (crackApp.appName == CrackAppType.clsq.appName) {
        type = CrackAppType.clsq.type;
      } else if (crackApp.appName == CrackAppType.awjq.appName) {
        type = CrackAppType.awjq.type;
      } else if (crackApp.appName == CrackAppType.aw91.appName) {
        type = CrackAppType.aw91.type;
      } else if (crackApp.appName == CrackAppType.zpc.appName) {
        type = CrackAppType.zpc.type;
      } else if (crackApp.appName == CrackAppType.pzhan.appName) {
        type = CrackAppType.pzhan.type;
      } else if (crackApp.appName == CrackAppType.hjsq.appName) {
        type = CrackAppType.hjsq.type;
      } else if (crackApp.appName == CrackAppType.tiktok51.appName) {
        type = CrackAppType.tiktok51.type;
      } else if (crackApp.appName == CrackAppType.gd.appName) {
        type = CrackAppType.gd.type;
      } else if (crackApp.appName == CrackAppType.xiaolan.appName) {
        type = CrackAppType.xiaolan.type;
      }
      VipPayDialog.showCoinsDialog(
        context: context,
        barrierDismissible: false,
        member: userNotifier.member,
        coins: crackApp.coins.toDouble(),
        onPay: () async {
          final userNotifier = context.read<UserNotifier>();
          final member = userNotifier.member;
          final coins = crackApp.coins;
          final memberMoney = member.money;
          final adequate = memberMoney >= coins;

          if (!adequate) {
            MyToast.showText(text: 'ndyebz'.tr(context: context));
            return;
          }

          final result = await userDomain.userAppBuy(
            source: crackApp.appName,
            type: type,
          );

          if (!context.mounted) return;

          if (result.status == 1) {
            final currentMoney = memberMoney - coins;
            userNotifier.setMoney(money: currentMoney);
            crackApp.isPay = true;
            MyToast.showText(text: result.data?.message ?? '');

            AppUtil.changeAppUnlockStatus(unlockStatusNotifier, crackApp, crackApp.isPay);
          } else {
            MyToast.showText(text: result.msg ?? '');
          }

          final router = GoRouter.of(context);
          if (context.mounted && router.canPop()) {
            context.pop();
          }
        },
      );
    }
  }
}
