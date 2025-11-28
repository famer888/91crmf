import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/ui_layer/screens/theme.dart';

import '../../image_paths.dart';

class NoCrackDialog extends StatelessWidget {
  final VoidCallback cancel;

  const NoCrackDialog({super.key, required this.cancel});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black54,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Container(
              height: 188.w,
              width: 260.w,
              padding: EdgeInsets.symmetric(vertical: 20.w, horizontal: 16.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8.w)),
                image: const DecorationImage(image: AssetImage(MyImagePaths.appMineRuleBg), fit: BoxFit.cover),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('wxts'.tr(context: context), style: MyTheme.white255_13_M.s18.w500),
                  SizedBox(height: 27.w),
                  Text(
                    'xmhznlpjz'.tr(context: context),
                    style: TextStyle(
                      color: const Color.fromRGBO(255, 255, 255, 1),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.none,
                    ),
                    softWrap: true,
                  ),
                  SizedBox(height: 40.w),
                  GestureDetector(
                    onTap: () {
                      // context.pop();
                      cancel.call();
                    },
                    child: Container(
                      width: 131.w,
                      height: 35.w,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(colors: MyTheme.gradient_90_114_colors),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Text('hd'.tr(context: context), style: MyTheme.white255_14.w500),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
