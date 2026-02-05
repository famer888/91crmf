import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/pzhan/widget/pzhan_feed_card.dart';
import 'package:jycrpj/ui_layer/screens/crack/model/app_model.dart';
import 'package:jycrpj/ui_layer/screens/theme.dart';

class PZhanSubListPage extends StatefulWidget {
  final ValueNotifier<bool> isListNotifier;
  final ValueNotifier<List<AppVideoModel>> dataListNotifier;

  const PZhanSubListPage({
    super.key,
    required this.isListNotifier,
    required this.dataListNotifier,
  });

  @override
  State<PZhanSubListPage> createState() => _PZhanSubListPageState();
}

class _PZhanSubListPageState extends State<PZhanSubListPage> {
  SliverList _buildSliverList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final feed = widget.dataListNotifier.value[index];
          return PZhanFeedCard(isList: true, feed: feed);
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
          return PZhanFeedCard(isList: false, feed: feed);
        },
        childCount: widget.dataListNotifier.value.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<AppVideoModel>>(
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
