import 'package:flutter/widgets.dart';
import 'package:jycrpj/report/report_video_model.dart';
import 'package:jycrpj/report/ui_layer/report_ad_grid_card.dart';
import 'package:jycrpj/report/ui_layer/report_ad_list_card.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/pzhan/model/pzhan_model.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/pzhan/widget/pzhan_video_card.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/pzhan/widget/pzhan_video_list_card.dart';

class PZhanFeedCard extends StatelessWidget {
  const PZhanFeedCard({super.key, this.isList = false, required this.feed, this.isInVideoDetail = false});

  final PZhanVideoModel feed;
  final bool isList;
  final bool isInVideoDetail;

  @override
  Widget build(BuildContext context) {
    if (feed.url.isEmpty) {
      return isList
          ? PZhanVideoListCard(data: feed, isInVideoDetail: isInVideoDetail)
          : PZhanVideoCard(data: feed, isInVideoDetail: isInVideoDetail);
    } else {
      // 广告
      return isList
          ? ReportAdListCard(
              ad: ReportVideoModel(
                title: feed.title,
                subTitle: feed.subTitle ?? '',
                description: feed.description ?? '',
                cover: feed.coverThumbUrl,
                adSlotName: feed.adSlotName ?? '',
                adType: feed.adType ?? 0,
                advertiseCode: feed.advertiseCode ?? '',
                advertiseLocationCode: feed.advertiseLocationCode ?? '',
              ),
            )
          : ReportAdGridCard(
              ad: ReportVideoModel(
                title: feed.title,
                subTitle: feed.subTitle ?? '',
                description: feed.description ?? '',
                cover: feed.coverThumbUrl,
                adSlotName: feed.adSlotName ?? '',
                adType: feed.adType ?? 0,
                advertiseCode: feed.advertiseCode ?? '',
                advertiseLocationCode: feed.advertiseLocationCode ?? '',
              ),
            );
    }
  }
}
