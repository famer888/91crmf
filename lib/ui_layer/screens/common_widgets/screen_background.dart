import 'package:flutter/material.dart';

class ScreenBackground extends StatelessWidget {
  const ScreenBackground({
    super.key,
    required this.child,
    this.appBg,
    this.bgColor,
  });

  final Widget child;
  final Widget? appBg;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: bgColor ?? Theme.of(context).scaffoldBackgroundColor,
      child: Stack(
        fit: StackFit.expand,
        children: [
          appBg == null ? const SizedBox.shrink() : Positioned(left: 0, top: 0, child: appBg!),
          Theme(data: Theme.of(context).copyWith(scaffoldBackgroundColor: Colors.transparent), child: child),
        ],
      ),
    );
  }
}
