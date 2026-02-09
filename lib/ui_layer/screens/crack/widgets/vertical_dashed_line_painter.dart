import 'package:flutter/material.dart';

class VerticalDashedLinePainter extends CustomPainter {
  final Color color;
  final double dashHeight;
  final double dashGap;
  final double strokeWidth;

  VerticalDashedLinePainter({
    required this.color,
    required this.dashHeight,
    required this.dashGap,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    double startY = 0;
    final x = size.width / 2;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(x, startY),
        Offset(x, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashGap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
