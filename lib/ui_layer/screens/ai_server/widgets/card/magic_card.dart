import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/domain/model/ai/ai_magic_model.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_image.dart';
import '../../../../router/routes.dart';
import '../../../../utils/common_utils.dart';
import '../../../theme.dart';

class MagicCard extends StatelessWidget {
  const MagicCard({super.key, required this.data, required this.coins});
  final AIMagicModel data;
  final int coins;
  static const aspectRatio = 9/16  ;

  String get imageUrl => CommonUtils.getThumb(data.toJson());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        AIMagicDetailRoute(data).push(context);
      },
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(5.w),
                ),
                width: double.infinity,
                child: Stack(
                  // fit: StackFit.expand,
                  children: [
                    Positioned.fill(
                      child: MyImage.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        backgroundColor: MyTheme.imageBgColor,
                        borderRadius: 5.w,
                      ),
                    ),
                    Positioned(
                      top: 5.w,
                      left: 5.w,
                      child: Container(
                      decoration: BoxDecoration(
                        gradient: MyTheme.gradient_90_114,
                        borderRadius: BorderRadius.circular(5.w),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3.w,vertical: 2.w),
                        child: Text('需$coins金币', style: MyTheme.white12),
                      ),
                    )),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8.w),
            Text(
              data.title,
              style: MyTheme.white244_20.copyWith(
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.7),
                    offset: Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
