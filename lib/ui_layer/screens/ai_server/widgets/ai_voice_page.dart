import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jycrpj/domain/remote_domain/domains/aiaudio.dart';
import 'package:jycrpj/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jycrpj/ui_layer/notifiers/user_notifier.dart';
import 'package:jycrpj/ui_layer/router/routes.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/dialog/widgets/regular_dialog.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_app_bar.dart';
import 'package:jycrpj/ui_layer/screens/theme.dart';
import 'package:jycrpj/ui_layer/utils/common_utils.dart';
import 'package:jycrpj/ui_layer/utils/my_toast.dart';
// import 'package:jycrpj/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';

import '../../../../report/ui_layer/report_gesture_detector.dart';

class AiVoicePage extends StatefulWidget {
  const AiVoicePage({super.key});

  @override
  State<AiVoicePage> createState() => _AiVoicePageState();
}

class _AiVoicePageState extends State<AiVoicePage> {
  String content = '';
  final TextEditingController contentcontroller = TextEditingController();
  late final _domain = context.read<AIAudioDomain>();
  late final userNotifier = context.read<UserNotifier>();
  int get freeNumber => userNotifier.member.aiAudioValue;

  RegularDialog _buildAlertDialog() {
    return RegularDialog(
      buttonText: 'qd'.tr(),
      title: 'wxts'.tr(),
      content: Text('请填写内容',
          style: MyTheme.white255_15, textAlign: TextAlign.center),
    );
  }

  RegularDialog _buildBalanceInsufficientDialog({
    required int coins,
    required int needCoins,
  }) {
    return RegularDialog(
      buttonText: 'qwcz'.tr(),
      cancelText: 'qx'.tr(),
      title: 'gmjb'.tr(),
      content: Column(children: [
        Row(children: [
          Text('jbye'.tr() + ': $coins', style: MyTheme.white255_15),
          const Spacer(),
          ReportGestureDetector(
              onTap: () {
                context.pop();
                const CoinRechargeRoute().push(context);
              },
              child: Text('ljcz'.tr(),
                  style: const TextStyle(
                      color: MyTheme.jellyCyanColor103224185,
                      decoration: TextDecoration.underline,
                      decorationColor: MyTheme
                          .jellyCyanColor103224185))),
        ]),
        SizedBox(height: 10.w),
        Row(
          children: [
            Text('zfje'.tr(), style: MyTheme.white255_15),
            const Spacer(),
            RichText(
                text: TextSpan(children: [
              TextSpan(text: '$needCoins', style: MyTheme.orange247_15),
              TextSpan(text: 'jb'.tr(), style: MyTheme.white255_15),
            ]))
          ],
        )
      ]),
      confirmOnTap: () {
        context.pop();
        const CoinRechargeRoute().push(context);
      },
      cancelOnTap: () => context.pop(),
    );
  }

  RegularDialog _buildSuccessDialog() {
    return RegularDialog(
      buttonText: 'gb'.tr(),
      title: 'zfcg'.tr(),
      content: Text('提交成功，稍后前往\n【AI记录】中查看',
          style: MyTheme.white255_15, textAlign: TextAlign.center),
      confirmOnTap: () => context.pop(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = context.watch<HomeConfigNotifier>().config;
    final user = context.watch<UserNotifier>();
    final int needCoins = config.payAiAudio;
    final int coins = user.member.money;
    final int aiAudioFontCt = config.aiAudioFontCt;

    return Scaffold(
      appBar: MyAppBar(
        title: 'AI语音',
        rightWidget: TextButton(
          onPressed: () {
            const MineAIRecordRoute(index: 5).push(context);
          },
          child: Center(
            child: Text('wdai'.tr(), style: MyTheme.white255_13),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.w),
                  Text('内容（必填）', style: MyTheme.white16medium),
                  SizedBox(height: 10.w),
                  Container(
                    height: 100.w,
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.w),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xff1b1c2b),
                      borderRadius: BorderRadius.all(Radius.circular(5.w)),
                    ),
                    child: TextField(
                      style: MyTheme.white14,
                      cursorColor: Colors.white,
                      maxLines: 6,
                      controller: contentcontroller,
                      maxLength: aiAudioFontCt,
                      decoration: InputDecoration(
                        hintText: '请输入内容',
                        hintStyle:
                            MyTheme.white14.copyWith(color: Colors.white70),
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                        border: InputBorder.none,
                        counterStyle:
                            MyTheme.white12.copyWith(color: Colors.white70),
                      ),
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.text,
                      onChanged: (value) => content = value,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20.w),
          ReportGestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => _submit(context,
                coins: coins,
                needCoins: needCoins,
                aiAudioValue: user.member.aiAudioValue),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
              height: 40.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(3.w)),
                gradient: MyTheme.gradient_90_114,
              ),
              child: Text(
                freeNumber > 0
                    ? '免费生成（剩余 $freeNumber 次）'
                    : '需消耗 $needCoins 金币【余额 $coins】生成',
                style: MyTheme.white16medium,
              ),
            ),
          ),
          SizedBox(height: 20.w),
        ],
      ),
    );
  }

  void _submit(BuildContext context,
      {required int coins,
      required int needCoins,
      required int aiAudioValue}) async {
    if (content.isEmpty) {
      CommonUtils.showDialog(
          context: context, builder: (context) => _buildAlertDialog());
      return;
    }

    if (aiAudioValue <= 0 && needCoins > coins) {
      CommonUtils.showDialog(
        context: context,
        builder: (context) => _buildBalanceInsufficientDialog(
          coins: coins,
          needCoins: needCoins,
        ),
      );
      return;
    }
    MyToast.showLoading();
    final result =
        await _domain.aiAudioGenerate(text: content, spkId: 'yellow1');
    MyToast.closeAllLoading();
    if (result.status == 1) {
      setState(() {
        content = '';
        contentcontroller.clear();
      });
      final newAiAudioValue = aiAudioValue - 1;
      if (newAiAudioValue >= 0) {
        userNotifier.setAiAudioValue(num: newAiAudioValue);
      } else {
        userNotifier.setMoney(money: coins - needCoins);
      }
      CommonUtils.showDialog(
        context: context,
        builder: (context) => _buildSuccessDialog(),
      );
    } else {
      MyToast.showText(text: result.msg ?? '提交失败');
    }
  }
}
