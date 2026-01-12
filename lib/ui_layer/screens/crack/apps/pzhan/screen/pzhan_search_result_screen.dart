import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/domain/domain.dart';
import 'package:jycrpj/domain/type_def.dart';
import 'package:jycrpj/report/ui_layer/report_search_click.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/pzhan/model/pzhan_model.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/pzhan/widget/pzhan_feed_card.dart';
import 'package:jycrpj/ui_layer/screens/image_paths.dart';
import 'package:jycrpj/ui_layer/screens/theme.dart';
import 'package:jycrpj/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';

class PZhanSearchResultScreen extends StatefulWidget {
  final String word;
  final int type;

  const PZhanSearchResultScreen({super.key, required this.word, required this.type});

  @override
  State<PZhanSearchResultScreen> createState() => _PZhanSearchResultScreenState();
}

class _PZhanSearchResultScreenState extends State<PZhanSearchResultScreen> {
  late final _appDomain = context.read<AppDomain>();

  Future<List<PZhanVideoModel>?> _getData({
    required int page,
    required int pageSize,
    required int type,
  }) async {
    final result = await _appDomain.getConstructByApiLink(
      apiLink: 'searchpzhan/mv',
      params: {'kwy': widget.word, 'type': widget.type, 'page': page, 'limit': pageSize},
    );

    if (result.status == 1) {
      final data = result.data;
      if (data != null) {
        if (data['list'] case final List data when data.isNotEmpty) {
          final feedModelList = data.map<PZhanVideoModel>((x) => PZhanVideoModel.fromJson(x)).toList();
          return feedModelList;
        }
      }
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
    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Stack(fit: StackFit.expand, children: [
        Theme(
          data: Theme.of(context).copyWith(scaffoldBackgroundColor: Colors.black),
          child: Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.black,
                title: Text(
                  'ssjg'.tr(context: context),
                  style: TextStyle(color: MyTheme.whiteColor, fontSize: 16.sp, fontWeight: FontWeight.w500),
                ),
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Image.asset(
                    MyImagePaths.appBackIcon,
                    width: 20.w,
                    height: 20.w,
                    color: const Color.fromRGBO(255, 255, 255, 1),
                  ),
                ),
                centerTitle: true),
            body: MyListView.grid(
              padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding, vertical: 8.w),
              childAspectRatio: MyTheme.aspectRatio,
              crossAxisSpacing: 8.w,
              itemBuilder: (context, item, index) => PZhanFeedCard(isList: false, feed: item).withSearchReport({
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
        ),
      ]),
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