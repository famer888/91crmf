import 'package:flutter/material.dart';
import '../image_paths.dart';
import 'my_image.dart';

class ScreenBackground extends StatelessWidget {
  const ScreenBackground({
    super.key,
    required this.child,
    this.appBg,
  });

  final Widget child;
  final Widget? appBg;

  @override
  Widget build(BuildContext context) {
    // return child;
    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
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
