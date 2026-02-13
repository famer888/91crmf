import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/ui_layer/screens/image_paths.dart';
import 'package:provider/provider.dart';

import '../../../notifiers/user_notifier.dart';
import '../../theme.dart';
import '../my_image.dart';

import '../../../../report/ui_layer/report_gesture_detector.dart';

class CommentInput extends StatelessWidget {
  const CommentInput({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hintNotifier,
    required this.onSubmitted,
    this.showAvatar = true,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool showAvatar;
  final ValueNotifier<String> hintNotifier;
  final VoidCallback onSubmitted;

  @override
  Widget build(BuildContext context) {
    final member = context.read<UserNotifier>().member;
    return Container(
      color: const Color.fromRGBO(255, 255, 255, 0.03),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.w),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            if (showAvatar)
              SizedBox(
                height: 40.0,
                width: 40.0,
                child: MyImage.network(
                  member.thumb ?? '',
                  borderRadius: 20,
                ),
              ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: hintNotifier,
                builder: (_, hint, __) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 120),
                    curve: Curves.easeOut,
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(255, 255, 255, 0.12),
                      borderRadius: BorderRadius.circular(18.w),
                    ),
                    child: TextField(
                      controller: controller,
                      focusNode: focusNode,
                      style: MyTheme.white255_15,
                      cursorColor: const Color.fromRGBO(255, 255, 255, 1),
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: hint,
                        hintStyle: MyTheme.gray109_15,
                        contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.w),
                        border: OutlineInputBorder(
                          gapPadding: 0,
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(18.w)),
                        ),
                      ),
                      minLines: 1,
                      maxLines: 2,
                    ),
                  );
                },
              ),
            ),
            SizedBox(width: 10.w),
            ReportGestureDetector(
              onTap: onSubmitted,
              child: MyImage.asset(MyImagePaths.appCustomSend, width: 32.w, height: 32.w),
            ),
          ],
        ),
      ),
    );
  }
}
