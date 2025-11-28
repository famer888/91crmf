import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GradientProgressBar extends StatelessWidget {
  final double value; // 0.0 ~ 1.0
  final double height;
  final BorderRadius radius;
  final List<Color>? linearColors;
  final Widget? label; // 自定义中心文字（任意Widget）

  const GradientProgressBar({
    super.key,
    required this.value,
    this.height = 12,
    this.radius = const BorderRadius.all(Radius.circular(6)),
    this.label,
    this.linearColors,
  });

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: true,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Stack(
            alignment: Alignment.centerLeft,
            children: [
              // 背景条
              Container(
                height: height,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(255, 255, 255, 0.2),
                  borderRadius: radius,
                  border: Border.all(
                    color: const Color.fromRGBO(110, 32, 62, 1),
                    width: 0.5.w,
                  ),
                ),
              ),
              // 前景渐变进度条
              LayoutBuilder(
                builder: (_, constraints) {
                  final width = constraints.maxWidth * value.clamp(0, 1);
                  return Container(
                    width: width,
                    height: height,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: linearColors ?? [const Color.fromRGBO(217, 106, 21, 1), const Color.fromRGBO(224, 176, 20, 1)],
                      ),
                      borderRadius: radius,
                    ),
                  );
                },
              ),
            ],
          ),
          // 中心自定义文字
          IgnorePointer(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: label ??
                  Text(
                    "${(value * 100).toStringAsFixed(0)}%",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(255, 255, 255, 1),
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
