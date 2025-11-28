import 'package:flutter/widgets.dart';
import 'package:jycrpj/ui_layer/screens/apps/91aw/widget/aw91_ad_card.dart';
import 'package:jycrpj/ui_layer/screens/apps/91aw/widget/aw91_ad_list_card.dart';
import 'package:jycrpj/ui_layer/screens/apps/91aw/widget/aw91_video_card.dart';
import 'package:jycrpj/ui_layer/screens/apps/91aw/widget/aw91_video_list_card.dart';

import '../../../../../domain/model/feed/feed_model.dart';

class Aw91FeedCard extends StatelessWidget {

  const Aw91FeedCard({super.key, this.isList = false, required this.feed, this.isInVideoDetail = false});
  static const aspectRatio = 170 / 125;
  final FeedModel feed;
  final bool isList;
  final bool isInVideoDetail;

  @override
  Widget build(BuildContext context) {
    return feed.map(
      video: (video) => isList ? Aw91VideoListCard(data: video, isInVideoDetail: isInVideoDetail) : Aw91VideoCard(data: video, isInVideoDetail: isInVideoDetail),
      ad: (ad) => isList ? Aw91AdListCard(ad: ad) : Aw91AdCard(ad: ad),
    );
  }
}
