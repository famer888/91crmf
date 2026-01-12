import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/ui_layer/notifiers/user_notifier.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/dialog/my_dialog.dart';
import 'package:jycrpj/ui_layer/screens/theme.dart';
import 'package:jycrpj/ui_layer/utils/my_toast.dart';

import '../../../report/ui_layer/report_gesture_detector.dart';

class AppDialog {

  static void showLineDialog(BuildContext context, UserNotifier userNotifier) {
    MyDialog.showBottomDialog(
      context: context,
      barrierDismissible: true,
      needTransition: true,
      child: Container(
        alignment: Alignment.bottomCenter,
        height: 218.w,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(16, 16, 16, 1),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(10.w), topRight: Radius.circular(10.w)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 15.w),
            Text('选择路线', style: MyTheme.white255_14.w500),
            SizedBox(height: 20.w),
            ReportGestureDetector(
              onTap: () {
                Navigator.pop(context);
                MyToast.showText(text: '线路切换成功');
              },
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 13.w),
                padding: EdgeInsets.symmetric(vertical: 14.w),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(22, 22, 22, 1),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10.w), topRight: Radius.circular(10.w)),
                ),
                child: Text('普通路线', style: MyTheme.white255_13.blueColor63),
              ),
            ),
            SizedBox(height: 1.w),
            ReportGestureDetector(
              onTap: () {
                MyToast.showText(text: '怎么判断Vip的，切换线路');
                if (userNotifier.member.vipLevel > 1) {
                } else {
                  Navigator.pop(context);
                  MyToast.showText(text: '线路切换成功');
                }
              },
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 13.w),
                padding: EdgeInsets.symmetric(vertical: 14.w),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(22, 22, 22, 1),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.w), bottomRight: Radius.circular(10.w)),
                ),
                child: Text('VIP路线', style: MyTheme.white255_13.blueColor63),
              ),
            ),
            SizedBox(height: 5.w),
            ReportGestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 13.w),
                padding: EdgeInsets.symmetric(vertical: 14.w),
                decoration: BoxDecoration(color: const Color.fromRGBO(22, 22, 22, 1), borderRadius: BorderRadius.all(Radius.circular(10.w))),
                child: Text('取消', style: MyTheme.white255_13.blueColor63),
              ),
            ),
            SizedBox(height: 15.w),
          ],
        ),
      ),
    );
  }

}