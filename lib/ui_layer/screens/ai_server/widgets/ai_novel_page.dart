import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jycrpj/domain/remote_domain/domains/ainovel.dart';
import 'package:jycrpj/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jycrpj/ui_layer/notifiers/user_notifier.dart';
import 'package:jycrpj/ui_layer/router/routes.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_app_bar.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/dialog/widgets/regular_dialog.dart';
import 'package:jycrpj/ui_layer/screens/theme.dart';
import 'package:jycrpj/ui_layer/utils/common_utils.dart';
import 'package:jycrpj/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';

import '../../../../report/ui_layer/report_gesture_detector.dart';

class AiNovelPage extends StatefulWidget {
  const AiNovelPage({super.key});

  @override
  State<AiNovelPage> createState() => _AiNovelPageState();
}

class _AiNovelPageState extends State<AiNovelPage> {
  String desc = "";
  String people = "";
  String addres = "";
  String detail = "";
  String txtnum = "1000";
  late final _appDomain = context.read<AINovelDomain>();
  late final TextEditingController _descController = TextEditingController();
  late final TextEditingController _peopleController = TextEditingController();
  late final TextEditingController _addresController = TextEditingController();
  late final TextEditingController _detailController = TextEditingController();
  late final TextEditingController _txtnumController = TextEditingController();
  late final userNotifier = context.read<UserNotifier>();
  int get freeNumber => userNotifier.member.aiNovelValue;
  @override
  void dispose() {
    _descController.dispose();
    _peopleController.dispose();
    _addresController.dispose();
    _detailController.dispose();
    _txtnumController.dispose();
    super.dispose();
  }

  void _resetForm() {
    if (!mounted) return;
    setState(() {
      desc = "";
      people = "";
      addres = "";
      detail = "";
      txtnum = "1000";
      _descController.clear();
      _peopleController.clear();
      _addresController.clear();
      _detailController.clear();
      _txtnumController.clear();
    });
  }

  RegularDialog _buildAlertDialog() {
    return RegularDialog(
      buttonText: 'qd'.tr(),
      title: 'wxts'.tr(),
      content: Text('qtxgsqj'.tr(),
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
      confirmOnTap: () async {
        context.pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final homeConfig = context.watch<HomeConfigNotifier>().config;
    final user = context.watch<UserNotifier>();
    final int needCoins = homeConfig.payAiNovel;
    final int coins = user.member.money;

    return Scaffold(
      appBar: MyAppBar(
        title: 'xscz'.tr(),
        rightWidget: TextButton(
          onPressed: () {
            const MineAIRecordRoute(index: 4).push(context);
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
                  SizedBox(height: 10.w),
                  Text('gsqjbt'.tr(), style: MyTheme.white16medium),
                  SizedBox(height: 10.w),
                  Container(
                    height: 80.w,
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.w),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xff1b1c2b),
                      borderRadius: BorderRadius.all(Radius.circular(5.w)),
                    ),
                    child: TextField(
                      controller: _descController,
                      style: MyTheme.white14,
                      cursorColor: Colors.white,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'gsqjbtds'.tr(),
                        hintStyle:
                            MyTheme.white14.copyWith(color: Colors.white70),
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                        border: InputBorder.none,
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        desc = value;
                      },
                    ),
                  ),
                  SizedBox(height: 20.w),
                  Text('rwsd'.tr(), style: MyTheme.white16medium),
                  SizedBox(height: 10.w),
                  Container(
                    height: 40.w,
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.w),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xff1b1c2b),
                      borderRadius: BorderRadius.all(Radius.circular(5.w)),
                    ),
                    child: TextField(
                      controller: _peopleController,
                      style: MyTheme.white14,
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        hintText: 'rwsdds'.tr(),
                        hintStyle:
                            MyTheme.white14.copyWith(color: Colors.white70),
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                        border: InputBorder.none,
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        people = value;
                      },
                    ),
                  ),
                  SizedBox(height: 20.w),
                  Text('ddcj'.tr(), style: MyTheme.white16medium),
                  SizedBox(height: 10.w),
                  Container(
                    height: 40.w,
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.w),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xff1b1c2b),
                      borderRadius: BorderRadius.all(Radius.circular(5.w)),
                    ),
                    child: TextField(
                      controller: _addresController,
                      style: MyTheme.white14,
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        hintText: 'ddcjds'.tr(),
                        hintStyle:
                            MyTheme.white14.copyWith(color: Colors.white70),
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                        border: InputBorder.none,
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        addres = value;
                      },
                    ),
                  ),
                  SizedBox(height: 20.w),
                  Text('xjsm'.tr(), style: MyTheme.white16medium),
                  SizedBox(height: 10.w),
                  Container(
                    height: 80.w,
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.w),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xff1b1c2b),
                      borderRadius: BorderRadius.all(Radius.circular(5.w)),
                    ),
                    child: TextField(
                      controller: _detailController,
                      style: MyTheme.white14,
                      cursorColor: Colors.white,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'xjsmds'.tr(),
                        hintStyle:
                            MyTheme.white14.copyWith(color: Colors.white70),
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                        border: InputBorder.none,
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        detail = value;
                      },
                    ),
                  ),
                  SizedBox(height: 20.w),
                  Text('xszs'.tr(), style: MyTheme.white16medium),
                  SizedBox(height: 10.w),
                  Container(
                    height: 40.w,
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.w),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xff1b1c2b),
                      borderRadius: BorderRadius.all(Radius.circular(5.w)),
                    ),
                    child: TextField(
                      controller: _txtnumController,
                      style: MyTheme.white14,
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        hintText: 'xszsds'.tr(),
                        hintStyle:
                            MyTheme.white14.copyWith(color: Colors.white70),
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                        border: InputBorder.none,
                      ),
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                      onChanged: (value) {
                        if (value.isEmpty) {
                          txtnum = "1000";
                        } else {
                          txtnum = value;
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20.w),
          ReportGestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              _submit(context,
                  coins: coins,
                  needCoins: needCoins,
                  aiNovelValue: userNotifier.member.aiNovelValue);
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
              height: 40.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(30.w)),
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
      required int aiNovelValue}) async {
    if (desc.isEmpty) {
      CommonUtils.showDialog(
          context: context, builder: (context) => _buildAlertDialog());
      return;
    }
    final intNum = int.tryParse(txtnum) ?? 0;
    if (intNum < 200) {
      MyToast.showText(text: '字数不能小于200字');
      return;
    }

    if (aiNovelValue <= 0 && needCoins > coins) {
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
    final result = await _appDomain.aiNovelGenerate(
      description: desc,
      characterSetting: people,
      locationScene: addres,
      details: detail,
      count: txtnum,
    );
    MyToast.closeAllLoading();
    if (result.status == 1) {
      _resetForm();
      final newAiNovelValue = aiNovelValue - 1;
      if (newAiNovelValue >= 0) {
        userNotifier.setAiNovelValue(num: newAiNovelValue);
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
