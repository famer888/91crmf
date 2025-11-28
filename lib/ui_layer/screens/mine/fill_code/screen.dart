import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../domain/domain.dart';
import '../../../notifiers/user_notifier.dart';
import '../../../utils/my_toast.dart';
import '../../common_widgets/my_app_bar.dart';
import '../../common_widgets/screen_background.dart';
import '../../theme.dart';

class MineFillCodeScreen extends StatefulWidget {
  const MineFillCodeScreen({super.key, required this.title});

  final String title;

  @override
  State<MineFillCodeScreen> createState() => _MineFillCodeScreenState();
}

class _MineFillCodeScreenState extends State<MineFillCodeScreen> {
  late final accountDomain = context.read<AccountDomain>();
  late final homeDomain = context.read<HomeDomain>();
  late final userDomain = context.read<UserDomain>();

  late final userNotifier = context.read<UserNotifier>();

  final myController = TextEditingController();

  final focusNode = FocusNode();

  String get title => widget.title;

  void onSubmit() async {
    MyToast.showLoading();
    if (myController.text.isEmpty) {
      MyToast.closeAllLoading();
      MyToast.showText(text: '${'qing'.tr(context: context)}${'txi'.tr(context: context)}$title');
    } else {
      final value = myController.text;

      if (title == tr('txi') + tr('nc')) {
        final resultVi = await accountDomain.validateUsername(username: value);
        if (resultVi.status != 1) {
          MyToast.showText(text: '${resultVi.msg}');
        } else {
          final result = await userDomain.updateUserInfo(nickName: value);
          // userNotifier.setNickName(nickName: value);
          MyToast.showText(text: (result.msg ?? '').isNotEmpty ? result.msg.toString() : result.data.toString());
        }
        MyToast.closeAllLoading();
      } else if (title == tr('yqm')) {
        var result = await userDomain.toInvitation(affCode: value);
        if (result.status == 1) {
          userNotifier.setInviteBy(inviteBy: value);
        }
        showText(status: result.status, msg: result.msg, word: tr('txi'));
        MyToast.closeAllLoading();
      } else if (title == tr('dhm')) {
        var result = await homeDomain.onExchange(cdk: value);
        showText(status: result.status, msg: result.msg, word: tr('dh'));
        MyToast.closeAllLoading();
      } else {
        MyToast.closeAllLoading();
      }
    }
  }

  void showText({status, msg, word = 'xg'}) {
    if (word == 'xg') {
      word = tr('xga');
    }
    if (status == 1) {
      MyToast.showText(text: '$word${tr('cg')} $msg');
      Future.delayed(const Duration(seconds: 2), () {
        context.pop();
      });
    } else {
      MyToast.showText(text: '$word${tr('sb')} $msg');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        appBar: MyAppBar(
          title: widget.title,
          // rightWidget: GestureDetector(
          //   onTap: onSubmit,
          //   child: Text('bc'.tr(context: context), style: MyTheme.white255_13_M),
          // ),
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            focusNode.unfocus();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.w),
              // Center(child: Text('szfffh'.tr(context: context), style: MyTheme.white04_12.s12.w400)),
              Expanded(
                  child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 25.5.w, vertical: 21.5.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    title == 'txyqm'.tr(context: context)
                        ? SizedBox(
                            height: 21.5.w,
                            child: Align(alignment: Alignment.topLeft, child: Text('*填写邀请你下载用户的推广码', style: MyTheme.hexa3a2a2_11)),
                          )
                        : SizedBox(height: 21.5.w),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      height: 50.w,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(35, 30, 32, 0.8),
                        borderRadius: BorderRadius.circular(5.w),
                      ),
                      child: Center(
                        child: TextField(
                          focusNode: focusNode,
                          autofocus: kIsWeb ? false : true,
                          controller: myController,
                          style: MyTheme.white255_15_M,
                          cursorColor: const Color.fromRGBO(255, 255, 255, 1),
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            hoverColor: Colors.white,
                            hintText: '${'qing'.tr(context: context)}${'txi'.tr(context: context)}$title',
                            hintStyle: TextStyle(color: const Color(0xff999999), fontWeight: FontWeight.w500, fontSize: 15.sp),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 54.w),
                    GestureDetector(
                      onTap: onSubmit,
                      child: Container(
                        height: 40.w,
                        alignment: Alignment.center,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(gradient: MyTheme.gradient_90_114, borderRadius: BorderRadius.all(Radius.circular(20.w))),
                        child: Text('qr'.tr(context: context), style: MyTheme.white255_15_semibold.w500),
                      ),
                    ),
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
