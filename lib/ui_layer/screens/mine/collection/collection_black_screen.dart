import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/domain/domain.dart';
import 'package:jycrpj/domain/model/black_model.dart';
import 'package:jycrpj/domain/type_def.dart';
import 'package:jycrpj/ui_layer/screens/black/widget/black_item_widget.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jycrpj/ui_layer/screens/theme.dart';
import 'package:provider/provider.dart';

class CollectionBlackScreen extends StatefulWidget {
  const CollectionBlackScreen({super.key});

  @override
  State<CollectionBlackScreen> createState() => _CollectionBlackScreenState();
}

class _CollectionBlackScreenState extends State<CollectionBlackScreen> {
  late final _screenUtils = ScreenUtil();
  late final _dynamicDomain = context.read<DynamicDomain>();
  String _lastIx = '';

  Future<List<BlackListItemModel>> _init({int page = 1, int limit = 15}) async {
    final result = await _dynamicDomain.getConstructByApiLink(
        apiLink: 'contents/list_my_favorite',
        params: {'page': page, 'limit': limit, 'lastIx': _lastIx});
    if (result.status == 1) {
      final resData = result.data;
      final lastIx = resData['last_ix'];
      if (lastIx == _lastIx) {
        return [];
      } else {
        _lastIx = lastIx;
        if (result.data['list'] case final List data when data.isNotEmpty) {
          final curBlackListItemModelList = data
              .map<BlackListItemModel>((e) => BlackListItemModel.fromJson(e))
              .toList();
          return curBlackListItemModelList;
        } else {
          return [];
        }
      }
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.list(
      padding:
          EdgeInsets.symmetric(horizontal: MyTheme.pagePadding, vertical: 8.w),
      itemBuilder: (context, item, index) => BlackItemWidget(
          item: item,
          itemWidth: (_screenUtils.screenWidth - MyTheme.pagePadding * 2)),
      isNeedMore: true,
      onFetchingMore: (currentPage, pageSize) {
        if (currentPage == 1) {
          _lastIx = '';
        }
        final res = _init(page: currentPage, limit: pageSize);
        return res;
      },
    );
  }
}
