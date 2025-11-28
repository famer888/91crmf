import 'package:flutter/material.dart';

import '../image_paths.dart';
import 'my_image.dart';

class MyAvatar extends StatelessWidget {
  const MyAvatar({
    super.key,
    required this.size,
    this.gradient,
    required this.thumb,
    this.margin = 0,
    this.isAssets = false,
  });

  final String? thumb;
  final double size;
  final double margin;
  final bool isAssets;
  final LinearGradient? gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: gradient,
        color: gradient != null ? null : Colors.white.withAlpha(30),
        shape: BoxShape.circle,
      ),
      padding: EdgeInsets.all(margin),
      child: isAssets
          ? MyImage.asset(
              thumb ?? MyImagePaths.appLogoIcon,
              width: double.infinity,
              fit: BoxFit.fitHeight,
              borderRadius: (size - margin) / 2,
            )
          : switch (thumb) {
              final url? when url.isNotEmpty => MyImage.network(
                  url,
                  fit: BoxFit.cover,
                  borderRadius: (size - margin) / 2,
                ),
              _ => MyImage.asset(
                  MyImagePaths.appLogoIcon,
                  width: double.infinity,
                  fit: BoxFit.fitHeight,
                  borderRadius: (size - margin) / 2,
                ),
            },
    );
  }
}
