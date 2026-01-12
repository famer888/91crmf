import 'package:flutter/widgets.dart';
import 'package:jycrpj/domain/model/feed/feed_model.dart';
import 'package:jycrpj/report/report_video_model.dart';
import 'package:jycrpj/report/ui_layer/report_ad_grid_card.dart';
import 'package:jycrpj/report/ui_layer/report_ad_list_card.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/zpc/widget/zpc_video_card.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/zpc/widget/zpc_video_list_card.dart';

class ZpcFeedCard extends StatelessWidget {
  const ZpcFeedCard({
    super.key,
    this.isList = false,
    required this.feed,
    this.isInVideoDetail = false,
    this.appType = 0,
  });

  final FeedModel feed;
  final bool isList;
  final bool isInVideoDetail;
  final int appType;
  
  @override
  Widget build(BuildContext context) {
    return feed.map(
      video: (video) => isList
          ? ZpcVideoListCard(data: video, isInVideoDetail: isInVideoDetail)
          : ZpcVideoCard(
              data: video,
              isInVideoDetail: isInVideoDetail,
              appType: appType,
            ),
      ad: (ad) => isList
          ? ReportAdListCard(
              ad: ReportVideoModel(
                title: ad.title,
                subTitle: ad.subTitle ?? '',
                description: ad.description ?? '',
                cover: ad.imgUrl ?? '',
                adSlotName: ad.adSlotName ?? '',
                adType: ad.adType ?? 0,
                advertiseCode: ad.advertiseCode ?? '',
                advertiseLocationCode: ad.advertiseLocationCode ?? '',
              ),
            )
          : ReportAdGridCard(
              ad: ReportVideoModel(
                title: ad.title,
                subTitle: ad.subTitle ?? '',
                description: ad.description ?? '',
                cover: ad.imgUrl ?? '',
                adSlotName: ad.adSlotName ?? '',
                adType: ad.adType ?? 0,
                advertiseCode: ad.advertiseCode ?? '',
                advertiseLocationCode: ad.advertiseLocationCode ?? '',
              ),
            ),
    );
  }
}
