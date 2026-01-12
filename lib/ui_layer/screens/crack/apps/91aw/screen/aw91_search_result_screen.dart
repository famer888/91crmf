import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/domain/domain.dart';
import 'package:jycrpj/domain/model/feed/feed_model.dart';
import 'package:jycrpj/domain/type_def.dart';
import 'package:jycrpj/report/ui_layer/report_search_click.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_app_bar.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/91aw/widget/aw91_feed_card.dart';
import 'package:jycrpj/ui_layer/screens/theme.dart';
import 'package:jycrpj/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';

class Aw91SearchResultScreen extends StatefulWidget {
  final String word;
  final int type;

  const Aw91SearchResultScreen({super.key, required this.word, required this.type});

  @override
  State<Aw91SearchResultScreen> createState() => _Aw91SearchResultScreenState();
}

class _Aw91SearchResultScreenState extends State<Aw91SearchResultScreen> {
  late final _appDomain = context.read<AppDomain>();

  Future<List<FeedModel>?> _getData({
    required int page,
    required int pageSize,
    required int type,
  }) async {
    final result = await _appDomain.getConstructByApiLink(
      apiLink: 'mv91aw/search',
      params: {'word': widget.word, 'type': widget.type, 'page': page, 'limit': pageSize},
    );

    if (result.status == 1) {
      final feedModelList = result.data?.map<FeedModel>((x) => FeedModel.fromJson(x)).toList();
      return feedModelList;
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        appBar: MyAppBar(title: 'ssjg'.tr(context: context)),
        body: MyListView.grid(
          padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding, vertical: 8.w),
          childAspectRatio: MyTheme.aspectRatio,
          crossAxisSpacing: 8.w,
          itemBuilder: (context, item, index) => Aw91FeedCard(isList: false, feed: item).withSearchReport({
            "event": "keyword_click",
            "keyword": widget.word,
            "click_item_id": item.id,
            "click_item_type_key": "video",
            "click_item_type_name": "视频",
            "click_ position": index,
          }),
          onFetchingMore: (currentPage, pageSize) => _getData(page: currentPage, pageSize: pageSize, type: widget.type),
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
