import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jycrpj/ui_layer/screens/image_paths.dart';

import '../../../../report/ui_layer/report_gesture_detector.dart';

typedef GridListCallback = void Function(bool isList);

class GridListSwitch extends StatefulWidget {
  final Color? color;
  final GridListCallback callback;

  const GridListSwitch({super.key, required this.callback, this.color});

  @override
  State<GridListSwitch> createState() => _GridListSwitchState();
}

class _GridListSwitchState extends State<GridListSwitch> {
  bool isList = false;

  void onChangeList() {
    if (context.mounted) {
      setState(() {
        isList = !isList;
        widget.callback.call(isList);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ReportGestureDetector(
      onTap: () {
        onChangeList();
      },
      child: SizedBox(
        width: 16.w,
        height: 16.h,
        child: MyImage.asset(
          isList ? MyImagePaths.appGrid : MyImagePaths.appList,
          width: 16.w,
          height: 16.h,
          color: widget.color,
        ),
      ),
    );
  }
}
