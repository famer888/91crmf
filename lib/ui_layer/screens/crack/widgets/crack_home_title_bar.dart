import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/gradient_text.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jycrpj/ui_layer/screens/image_paths.dart';
import 'package:jycrpj/ui_layer/screens/theme.dart';

import '../../../../report/ui_layer/report_gesture_detector.dart';

class CrackHomeTitleBar extends StatelessWidget {
  final String text;
  final double marginTop;
  final List<Color> gradient;
  final Color indicatorColor;
  final Color backgroundColor;
  final VoidCallback? openEndDrawer;

  const CrackHomeTitleBar({
    super.key,
    required this.text,
    this.marginTop = 0.0,
    required this.gradient,
    required this.indicatorColor,
    required this.backgroundColor,
    this.openEndDrawer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      color: backgroundColor,
      padding: EdgeInsets.all(3.w),
      child: Row(
        children: [
          SizedBox(width: 2.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: marginTop),
              GradientText(
                text,
                style: MyTheme.white255_13_M.s16,
                gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: gradient),
              ),
              SizedBox(height: 3.w),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 5.w,
                    height: 3.w,
                    decoration: BoxDecoration(color: indicatorColor, borderRadius: const BorderRadius.all(Radius.circular(2))),
                  ),
                  SizedBox(width: 2.w),
                  Container(
                    width: 15.w,
                    height: 3.w,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(2)),
                      gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: gradient),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          ReportGestureDetector(
            onTap: () {
              openEndDrawer?.call();
            },
            child: Container(
              margin: EdgeInsets.only(top: 10.w + marginTop, bottom: 10.w, right: 2.w),
              child: SizedBox.square(
                dimension: 23.w,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.w),
                  child: const MyImage.asset(MyImagePaths.appMore, fit: BoxFit.cover),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
