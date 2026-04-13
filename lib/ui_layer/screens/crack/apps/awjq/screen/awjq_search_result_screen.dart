import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/domain/domain.dart';
import 'package:jycrpj/domain/model/feed/feed_model.dart';
import 'package:jycrpj/domain/type_def.dart';
import 'package:jycrpj/report/ui_layer/report_search_click.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_app_bar.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/awjq/widget/awjq_feed_card.dart';
import 'package:jycrpj/ui_layer/screens/crack/widgets/scroll_top_button.dart';
import 'package:jycrpj/ui_layer/screens/theme.dart';
import 'package:jycrpj/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';

class AwjqSearchResultScreen extends StatefulWidget {
  final String word;
  final int type;

  const AwjqSearchResultScreen({super.key, required this.word, required this.type});

  @override
  State<AwjqSearchResultScreen> createState() => _AwjqSearchResultScreenState();
}

class _AwjqSearchResultScreenState extends State<AwjqSearchResultScreen> {
  late final _appDomain = context.read<AppDomain>();
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _showToTopButtonNotifier = ValueNotifier(false);
  double _showThreshold = 0;

  Future<List<FeedModel>?> _getData({
    required int page,
    required int pageSize,
    required int type,
  }) async {
    final result = await _appDomain.getConstructByApiLink(
      apiLink: 'mvawjq/search',
      params: {'word': widget.word, 'type': widget.type, 'page': page, 'limit': pageSize},
    );

    if (result.status == 1) {
      final feedModelList = result.data?.map<FeedModel>((x) => FeedModel.fromJson(x)).toList();
      if (feedModelList == null) {
        return [];
      }
      if (feedModelList.isEmpty) {
        return [];
      }
      return feedModelList;
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showThreshold = ScreenUtil().screenHeight * 0.40;
    });
    _scrollController.addListener(() {
      _showToTopButtonNotifier.value = (_scrollController.offset > _showThreshold);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _showToTopButtonNotifier.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    if (!_scrollController.hasClients) return;

    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        appBar: MyAppBar(title: widget.word),
        body: Stack(
          children: [
            MyListView.grid(
              scrollController: _scrollController,
              padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding, vertical: 8.w),
              childAspectRatio: MyTheme.aspectRatio,
              crossAxisSpacing: 8.w,
              itemBuilder: (context, item, index) => AwjqFeedCard(isList: false, feed: item).withSearchReport({
                "event": "keyword_click",
                "keyword": widget.word,
                "click_item_id": item.id,
                "click_item_type_key": "video",
                "click_item_type_name": "视频",
                "click_position": index,
              }),
              onFetchingMore: (currentPage, pageSize) => _getData(page: currentPage, pageSize: pageSize, type: widget.type),
            ),
            Positioned(
              bottom: 40.w,
              right: 20.w,
              child: ScrollTopButton(
                showToTopButtonNotifier: _showToTopButtonNotifier,
                scrollTopCallback: _scrollToTop,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension EventClick on Widget {
  Widget withSearchReport(Map data) {
    return ReportSearchClick(
      data: data,
      child: this,
    );
  }
}
