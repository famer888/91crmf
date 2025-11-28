import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_image.dart';

class MemberVipWidget extends StatelessWidget {
  const MemberVipWidget({
    super.key,
    this.height = 16,
    this.width,
    this.margin = 0,
    this.vipImage,
  });
  final double height;
  final double? width;
  final double margin;
  final String? vipImage;

  @override
  Widget build(BuildContext context) {
    if (vipImage == null || vipImage!.isEmpty) {
      return const SizedBox.shrink();
    }
   //根据UI提供的图片得来
    final resolvedWidth = width ?? height / 36 * 161;

    return Container(
      margin: EdgeInsets.only(right: margin.w),
      child: SizedBox(
        width: resolvedWidth,
        height: height,
        child: Align(
          alignment: Alignment.centerLeft,
          child: MyImage.network(
            vipImage!,
            width: resolvedWidth,
            height: height,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
