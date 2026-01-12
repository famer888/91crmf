import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/ui_layer/screens/theme.dart';

import '../../../common_widgets/my_image.dart';
import '../../../image_paths.dart';

import '../../../../../report/ui_layer/report_gesture_detector.dart';

class RuleDialog extends StatelessWidget {
  final VoidCallback cancel;

  const RuleDialog({super.key, required this.cancel});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black45,
      child: ReportGestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 42.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 298.w,
                  padding: EdgeInsets.symmetric(vertical: 20.w, horizontal: 16.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8.w)),
                    image: const DecorationImage(image: AssetImage(MyImagePaths.appMineRuleBg), fit: BoxFit.cover),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('gzsm'.tr(context: context), style: MyTheme.white255_13_M.s18.w500),
                      SizedBox(height: 20.w),
                      Text(
                        'gzsmc'.tr(context: context),
                        style: TextStyle(
                          color: const Color.fromRGBO(255, 255, 255, 1),
                          letterSpacing: 0.5,
                          height: 1.8,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.none,
                        ),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.w),
                ReportGestureDetector(
                  onTap: () => cancel.call(),
                  child: SizedBox(child: MyImage.asset(MyImagePaths.appCancelWithCircle, fit: BoxFit.cover, width: 33.w, height: 33.w)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
