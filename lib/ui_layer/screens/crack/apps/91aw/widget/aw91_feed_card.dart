import 'package:flutter/widgets.dart';
import 'package:jycrpj/domain/model/feed/feed_model.dart';
import 'package:jycrpj/report/report_video_model.dart';
import 'package:jycrpj/report/ui_layer/report_ad_grid_card.dart';
import 'package:jycrpj/report/ui_layer/report_ad_list_card.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/91aw/widget/aw91_video_card.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/91aw/widget/aw91_video_list_card.dart';

class Aw91FeedCard extends StatelessWidget {
  const Aw91FeedCard({super.key, this.isList = false, required this.feed, this.isInVideoDetail = false});

  final FeedModel feed;
  final bool isList;
  final bool isInVideoDetail;

  @override
  Widget build(BuildContext context) {
    return feed.map(
      video: (video) => isList
          ? Aw91VideoListCard(data: video, isInVideoDetail: isInVideoDetail)
          : Aw91VideoCard(data: video, isInVideoDetail: isInVideoDetail),
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
