import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/domain/model/feed/feed_model.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/awjq/widget/awjq_feed_card.dart';
import 'package:jycrpj/ui_layer/screens/theme.dart';

class AwjqSubListPage extends StatefulWidget {
  final ValueNotifier<bool> isListNotifier;
  final ValueNotifier<List<FeedModel>> dataListNotifier;

  const AwjqSubListPage({
    super.key,
    required this.isListNotifier,
    required this.dataListNotifier,
  });

  @override
  State<AwjqSubListPage> createState() => _AwjqSubListPageState();
}

class _AwjqSubListPageState extends State<AwjqSubListPage> {
  SliverList _buildSliverList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final feed = widget.dataListNotifier.value[index];
          return AwjqFeedCard(isList: true, feed: feed);
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
          return AwjqFeedCard(isList: false, feed: feed);
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
          return ValueListenableBuilder<bool>(
              valueListenable: widget.isListNotifier,
              builder: (_, isList, __) {
                return isList ? _buildSliverList() : _buildSliverGrid();
              });
        });
  }
}
