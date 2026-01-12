import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/domain/model/feed/feed_model.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/91aw/widget/aw91_feed_card.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/awjq/widget/awjq_feed_card.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/clsq/widget/cl_feed_card.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/zpc/widget/zpc_feed_card.dart';
import 'package:jycrpj/ui_layer/screens/crack/crack_app_type.dart';
import 'package:jycrpj/ui_layer/screens/theme.dart';
import 'package:jycrpj/ui_layer/utils/common_utils.dart';

class SubListPage extends StatefulWidget {
  final ValueNotifier<bool> isListNotifier;
  final ValueNotifier<List<FeedModel>> dataListNotifier;
  final CrackAppType searchAppBarType;

  const SubListPage({
    super.key,
    required this.isListNotifier,
    required this.dataListNotifier,
    required this.searchAppBarType,
  });

  @override
  State<SubListPage> createState() => _SubListPageState();
}

class _SubListPageState extends State<SubListPage> {
  SliverList _buildSliverList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final feed = widget.dataListNotifier.value[index];

          if(widget.searchAppBarType == CrackAppType.clsq) {
            return ClFeedCard(isList: true, feed: feed);
          } else if (widget.searchAppBarType == CrackAppType.awjq) {
            return AwjqFeedCard(isList: true, feed: feed);
          } else if (widget.searchAppBarType == CrackAppType.aw91) {
            return Aw91FeedCard(isList: true, feed: feed);
          } else if (widget.searchAppBarType == CrackAppType.zpc) {
            return ZpcFeedCard(isList: true, feed: feed);
          } else if (widget.searchAppBarType == CrackAppType.pzhan) {
            // return PZhanFeedCard(isList: true, feed: feed);
          }
          return const SizedBox.shrink();
        },
        childCount: widget.dataListNotifier.value.length,
      ),
    );
  }

  SliverGrid _buildSliverGrid() {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.w,
        mainAxisSpacing: 8.w,
        childAspectRatio: MyTheme.aspectRatio,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final feed = widget.dataListNotifier.value[index];
          if(widget.searchAppBarType == CrackAppType.clsq) {
            return ClFeedCard(isList: true, feed: feed);
          } else if (widget.searchAppBarType == CrackAppType.awjq) {
            return AwjqFeedCard(isList: true, feed: feed);
          } else if (widget.searchAppBarType == CrackAppType.aw91) {
            return Aw91FeedCard(isList: true, feed: feed);
          } else if (widget.searchAppBarType == CrackAppType.zpc) {
            return ZpcFeedCard(isList: true, feed: feed);
          } else if (widget.searchAppBarType == CrackAppType.pzhan) {
            // return PZhanFeedCard(isList: true, feed: feed);
          }
          return const SizedBox.shrink();
        },
        childCount: widget.dataListNotifier.value.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<FeedModel>>(
        valueListenable: widget.dataListNotifier,
        builder: (_, list, __) {
          CommonUtils.log('数据量:${list.length}');
          return ValueListenableBuilder<bool>(
              valueListenable: widget.isListNotifier,
              builder: (_, isList, __) {
                return isList ? _buildSliverList() : _buildSliverGrid();
              });
        });
  }
}
