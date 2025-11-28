import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/domain/model/black_model.dart';
import 'package:jycrpj/ui_layer/screens/apps/app_video_visit_util.dart';
import 'package:jycrpj/ui_layer/screens/black/widget/black_item_widget.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jycrpj/ui_layer/screens/theme.dart';

class VisitBlackScreen extends StatefulWidget {
  final int type;

  const VisitBlackScreen({super.key, required this.type});

  @override
  State<VisitBlackScreen> createState() => _VisitBlackScreenState();
}

class _VisitBlackScreenState extends State<VisitBlackScreen> {
  late final _screenUtils = ScreenUtil();

  Future<List<BlackListItemModel>> _getVisitBlackData({int page = 1, int limit = 15}) async {
    final List<BlackListItemModel>? visitBlackModels = await AppVideoVisitUtil.getBlackVisitRecord(context);
    if (visitBlackModels == null) {
      return [];
    } else {
      if (visitBlackModels.isEmpty) {
        return [];
      } else {
        return visitBlackModels.reversed.toList();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.list(
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding, vertical: 8.w),
      itemBuilder: (context, item, index) => Container(
        padding: EdgeInsets.only(bottom: 12.w),
        child: BlackItemWidget(item: item, itemWidth: (_screenUtils.screenWidth - MyTheme.pagePadding * 2)),
      ),
      isNeedMore: false,
      onFetchingMore: (currentPage, pageSize) {
        final res = _getVisitBlackData(page: currentPage, limit: pageSize);
        return res;
      },
    );
  }
}
