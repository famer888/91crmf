import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common_widgets/my_image.dart';
import '../image_paths.dart';

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
    return GestureDetector(
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
