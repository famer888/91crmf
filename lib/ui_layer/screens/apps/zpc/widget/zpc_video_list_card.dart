import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jycrpj/ui_layer/screens/apps/app_video_visit_util.dart';
import 'package:jycrpj/ui_layer/screens/apps/crack_app_type.dart';
import '../../../../router/routes.dart';
import '../../../../../domain/model/feed/feed_model.dart';
import '../../../../utils/common_utils.dart';
import '../../../common_widgets/my_image.dart';
import '../../../theme.dart';

class ZpcVideoListCard extends StatelessWidget {
  const ZpcVideoListCard({super.key, required this.data, this.isInVideoDetail = false});

  final FeedVideoModel data;
  final bool isInVideoDetail;

  String get imageUrl => CommonUtils.getThumb(data.toJson());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        final updateDeedModel = data.copyWith(crackAppType: CrackAppType.zpc.type);
        AppVideoVisitUtil.updateVisitRecord(context, updateDeedModel);
        if (isInVideoDetail) {
          context.pop();
        }
        ZpcVideoDetailRoute(data.id).push(context);
      },
      child: SizedBox(
        height: 134.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 97.w,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      MyImage.network(imageUrl, fit: BoxFit.cover, backgroundColor: MyTheme.imageBgColor, borderRadius: 5.w),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${CommonUtils.renderFixedNumber(data.playCt)}${'bf'.tr()}', style: MyTheme.white11medium),
                              Text(RelativeDateFormat.getHMTime(time: data.duration), style: MyTheme.white11medium),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5.w),
                Text(data.title, style: MyTheme.black13.w400, maxLines: 1),
                SizedBox(height: 10.w),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
