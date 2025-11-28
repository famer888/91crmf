import 'package:flutter/widgets.dart';
import 'package:jycrpj/ui_layer/screens/apps/awjq/widget/awjq_ad_card.dart';
import 'package:jycrpj/ui_layer/screens/apps/awjq/widget/awjq_ad_list_card.dart';
import 'package:jycrpj/ui_layer/screens/apps/awjq/widget/awjq_video_card.dart';
import 'package:jycrpj/ui_layer/screens/apps/awjq/widget/awjq_video_list_card.dart';

import '../../../../../domain/model/feed/feed_model.dart';


class AwjqFeedCard extends StatelessWidget {

  const AwjqFeedCard({super.key, this.isList = false, this.isInVideoDetail = false, required this.feed});
  static const aspectRatio = 170 / 125;
  final FeedModel feed;
  final bool isList;
  final bool isInVideoDetail;

  @override
  Widget build(BuildContext context) {
    return feed.map(
      video: (video) => isList ? AwjqVideoListCard(data: video, isInVideoDetail: isInVideoDetail) : AwjqVideoCard(data: video, isInVideoDetail: isInVideoDetail),
      ad: (ad) => isList ? AwjqAdListCard(ad: ad) : AwjqAdCard(ad: ad),
    );
  }
}
