import 'package:flutter/material.dart';

import '../../../../report/ui_layer/report_gesture_detector.dart';

class IntervalGestureWidget extends StatefulWidget {
  final Widget? child;
  final int interval;
  final void Function()? onTap;

  /// [interval] click response interval, defalut 0
  const IntervalGestureWidget({super.key, this.child, this.onTap, this.interval = 1});

  @override
  State<IntervalGestureWidget> createState() => _IntervalGestureWidgetState();
}

class _IntervalGestureWidgetState extends State<IntervalGestureWidget> {
  DateTime? _lastTime;
 //上次点击时间
  @override
  Widget build(BuildContext context) {
    return ReportGestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _onClickAction,
      child: widget.child,
    );
  }

  void _onClickAction() {
    // 1
    if (widget.interval == 0 || _lastTime == null) {
      return widget.onTap?.call();
    }
    // 2
    var last = DateTime.now().difference(_lastTime!).inSeconds;
    if (last > widget.interval) {
      _lastTime = DateTime.now();
      return widget.onTap?.call();
    }
  }
}
