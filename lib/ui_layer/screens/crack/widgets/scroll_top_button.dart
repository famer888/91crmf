import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/report/ui_layer/report_gesture_detector.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jycrpj/ui_layer/screens/image_paths.dart';

class ScrollTopButton extends StatelessWidget {
  final ValueNotifier<bool> showToTopButtonNotifier;
  final VoidCallback scrollTopCallback;

  const ScrollTopButton({
    super.key,
    required this.showToTopButtonNotifier,
    required this.scrollTopCallback,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: showToTopButtonNotifier,
        builder: (_, showTopButton, __) {
          return AnimatedOpacity(
            opacity: showTopButton ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: IgnorePointer(
              ignoring: !showTopButton,
              child: ReportGestureDetector(
                onTap: () {
                  scrollTopCallback.call();
                },
                child: SizedBox(
                  width: 42.w,
                  height: 68.w,
                  child: MyImage.asset(MyImagePaths.appPzhanTop, width: 42.w, height: 68.w),
                ),
              ),
            ),
          );
        });
  }
}
