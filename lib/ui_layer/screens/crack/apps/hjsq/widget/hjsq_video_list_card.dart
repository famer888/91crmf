import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jycrpj/domain/model/feed/feed_model.dart';
import 'package:jycrpj/ui_layer/router/routes.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jycrpj/ui_layer/screens/crack/app_video_visit_util.dart';
import 'package:jycrpj/ui_layer/screens/crack/crack_app_type.dart';
import 'package:jycrpj/ui_layer/screens/mine/visitrecord/visit_model.dart';
import 'package:jycrpj/ui_layer/screens/theme.dart';
import 'package:jycrpj/ui_layer/utils/common_utils.dart';

import '../../../../../../report/ui_layer/report_gesture_detector.dart';

class HjsqVideoListCard extends StatelessWidget {
  const HjsqVideoListCard({super.key, required this.data, this.isInVideoDetail = false});

  final FeedVideoModel data;
  final bool isInVideoDetail;

  String get imageUrl => CommonUtils.getThumb(data.toJson());

  @override
  Widget build(BuildContext context) {
    return ReportGestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        AppVisitUtil.updateCrackAppVisitRecord(
          context,
          VideoVisitModel(
            title: data.title,
            duration: data.duration,
            playCount: data.playCt,
            id: data.id,
            crackAppType: CrackAppType.hjsq.type,
            imgUrl: data.coverHorizontal,
          ),
        );
        if (isInVideoDetail) {
          context.pop();
        }
        HjsqVideoDetailRoute(data.id).push(context);
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
                  height: 99.w,
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
                SizedBox(height: 3.w),
                Text(data.title, style: MyTheme.white255_14.w400, maxLines: 1),
                SizedBox(height: 10.w),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
