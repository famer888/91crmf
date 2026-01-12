import 'package:flutter/widgets.dart';
import 'package:jycrpj/domain/model/feed/feed_model.dart';
import 'package:jycrpj/report/report_video_model.dart';
import 'package:jycrpj/report/ui_layer/report_ad_grid_card.dart';
import 'package:jycrpj/report/ui_layer/report_ad_list_card.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/awjq/widget/awjq_video_card.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/awjq/widget/awjq_video_list_card.dart';

class AwjqFeedCard extends StatelessWidget {
  const AwjqFeedCard({super.key, this.isList = false, this.isInVideoDetail = false, required this.feed});

  static const aspectRatio = 170 / 125;
  final FeedModel feed;
  final bool isList;
  final bool isInVideoDetail;

  @override
  Widget build(BuildContext context) {
    return feed.map(
      video: (video) => isList
          ? AwjqVideoListCard(data: video, isInVideoDetail: isInVideoDetail)
          : AwjqVideoCard(data: video, isInVideoDetail: isInVideoDetail),
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
