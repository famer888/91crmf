import 'package:flutter/widgets.dart';

import '../../../../../domain/model/feed/feed_model.dart';
import 'cl_ad_card.dart';
import 'cl_ad_list_card.dart';
import 'cl_video_card.dart';
import 'cl_video_list_card.dart';


class ClFeedCard extends StatelessWidget {

  const ClFeedCard({super.key, this.isList = false, required this.feed, this.isInVideoDetail = false});
  static const aspectRatio = 170 / 125;
  final FeedModel feed;
  final bool isList;
  final bool isInVideoDetail;

  @override
  Widget build(BuildContext context) {
    return feed.map(
      video: (video) => isList ? ClVideoListCard(data: video, isInVideoDetail: isInVideoDetail) : ClVideoCard(data: video, isInVideoDetail: isInVideoDetail),
      ad: (ad) => isList ? ClAdListCard(ad: ad) : ClAdCard(ad: ad),
    );
  }
}
