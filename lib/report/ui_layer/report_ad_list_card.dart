import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/report/report_video_model.dart';

import '../../../../../report/ui_layer/report_gesture_detector.dart';
import '../../ui_layer/screens/common_widgets/my_image.dart';
import '../../ui_layer/screens/theme.dart';
import '../../ui_layer/utils/common_utils.dart';
import '../event_tracking.dart';
import 'report_timing_observer.dart';

class ReportAdListCard extends StatefulWidget {
  const ReportAdListCard({super.key, required this.ad});

  final ReportVideoModel ad;

  @override
  State<ReportAdListCard> createState() => _ReportAdGridCardState();
}

class _ReportAdGridCardState extends State<ReportAdListCard> {
  String get description => widget.ad.description ?? widget.ad.subTitle ?? '';

  String get imgUrl => CommonUtils.getThumb(widget.ad.toJson());

  //上传广告行为
  void postActionReport(ReportVideoModel tp, String action) {
    EventTracking().reportSingle({
      "event": "advertising",
      "event_type": action,
      "advertising_key": tp.advertiseLocationCode,
      "advertising_name": tp.adSlotName,
      "advertising_id": tp.advertiseCode,
    });
  }

  //点击广告上报
  void postClickReport(ReportVideoModel tp) {
    postActionReport(tp, "click");

    EventTracking().reportSingle({
      "event": "ad_click",
      "page_key": RouteStore.currentPageKey,
      "page_name": RouteStore.currentPageName,
      "ad_slot_key": tp.advertiseLocationCode,
      "ad_slot_name": tp.adSlotName,
      "ad_id": tp.advertiseCode,
      "creative_id": "",
      "ad_type": tp.adType,
    }).then((value) {
      // CommonUtils.log(value);
    });
  }

  @override
  void initState() {
    super.initState();
    postActionReport(widget.ad, 'show');
  }

  @override
  Widget build(BuildContext context) {
    return ReportGestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        postClickReport(widget.ad);
        CommonUtils.openRoute(context, widget.ad.toJson());
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 98.w,
            child: Stack(
              fit: StackFit.expand,
              children: [
                MyImage.network(imgUrl, borderRadius: 5.w, fit: BoxFit.cover),
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    width: 38.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(252, 231, 80, 1),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(3.w), bottomRight: Radius.circular(3.w)),
                    ),
                    child: Center(child: Text('gg'.tr(), style: MyTheme.black12_M)),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 4.w),
          Text(widget.ad.title, style: MyTheme.white13, maxLines: 1),
          if (description.isNotEmpty) Text(description, style: MyTheme.graya3a2a2_11, maxLines: 1),
          SizedBox(height: 10.w),
        ],
      ),
    );
  }
}
