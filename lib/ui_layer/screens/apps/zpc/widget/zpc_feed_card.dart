import 'package:flutter/widgets.dart';
import 'package:jycrpj/ui_layer/screens/apps/zpc/widget/zpc_ad_card.dart';
import 'package:jycrpj/ui_layer/screens/apps/zpc/widget/zpc_ad_list_card.dart';
import 'package:jycrpj/ui_layer/screens/apps/zpc/widget/zpc_video_card.dart';
import 'package:jycrpj/ui_layer/screens/apps/zpc/widget/zpc_video_list_card.dart';

import '../../../../../domain/model/feed/feed_model.dart';


class ZpcFeedCard extends StatelessWidget {

  const ZpcFeedCard({super.key, this.isList = false, required this.feed, this.isInVideoDetail = false});

  static const aspectRatio = 170 / 125;
  final FeedModel feed;
  final bool isList;
  final bool isInVideoDetail;

  @override
  Widget build(BuildContext context) {
    return feed.map(
      video: (video) => isList ? ZpcVideoListCard(data: video, isInVideoDetail: isInVideoDetail) : ZpcVideoCard(data: video, isInVideoDetail: isInVideoDetail),
      ad: (ad) => isList ? ZpcAdListCard(ad: ad) : ZpcAdCard(ad: ad),
    );
  }
}
