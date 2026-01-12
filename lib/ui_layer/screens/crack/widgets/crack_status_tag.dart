import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/ui_layer/screens/theme.dart';

class CrackStatusTag extends StatelessWidget {
  final int isFree;

  const CrackStatusTag({
    super.key,
    required this.isFree,
  });

  @override
  Widget build(BuildContext context) {
    String text = '';
    LinearGradient gradient = MyTheme.gradient_90_135;

    switch (isFree) {
      case 0:
        text = 'mf'.tr(context: context);
        gradient = MyTheme.gradient_90_135;
        break;
      case 1:
        text = 'vvp'.tr(context: context);
        gradient = MyTheme.vip_gradient_90_135;
        break;
      case 2:
        text = 'jb'.tr(context: context);
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
          borderRadius: BorderRadius.only(topRight: Radius.circular(10.w), bottomLeft: Radius.circular(8.w)),
        ),
        child: Center(child: Text(text, style: MyTheme.white14.s9)),
      ),
    );
  }
}
