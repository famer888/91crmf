import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jycrpj/ui_layer/router/routes.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jycrpj/ui_layer/screens/crack/app_video_visit_util.dart';
import 'package:jycrpj/ui_layer/screens/crack/crack_app_type.dart';
import 'package:jycrpj/ui_layer/screens/crack/model/app_model.dart';
import 'package:jycrpj/ui_layer/screens/mine/visitrecord/visit_model.dart';
import 'package:jycrpj/ui_layer/screens/theme.dart';
import 'package:jycrpj/ui_layer/utils/common_utils.dart';

import '../../../../../../report/ui_layer/report_gesture_detector.dart';

class PZhanVideoCard extends StatelessWidget {
  const PZhanVideoCard({super.key, required this.data, this.isInVideoDetail = false});

  final AppVideoModel data;
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
            playCount: data.playNum,
            id: data.id,
            crackAppType: CrackAppType.pzhan.type,
            imgUrl: data.coverThumbUrl,
          ),
        );
        if (isInVideoDetail) {
          context.pop();
        }
        PZhanVideoDetailRoute(id: data.id).push(context);
      },
      child: LayoutBuilder(builder: (context, cons) {
        return Column(
          children: [
            SizedBox(
              height: 97.w,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  MyImage.network(imageUrl, fit: BoxFit.cover, backgroundColor: MyTheme.imageBgColor, borderRadius: 5.w),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 22.w,
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.w),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.fromRGBO(16, 16, 16, 0.05),
                            Color.fromRGBO(16, 16, 16, 0.9),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${CommonUtils.renderFixedNumber(data.playNum)}${'bf'.tr()}', style: MyTheme.white12medium),
                          Text(RelativeDateFormat.getHMTime(time: data.duration), style: MyTheme.white12medium),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.5.w),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(data.title, style: MyTheme.white244_14, maxLines: 1),
            ),
          ],
        );
      }),
    );
  }
}
