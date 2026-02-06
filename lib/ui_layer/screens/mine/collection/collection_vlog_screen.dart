import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/app_global.dart';
import 'package:jycrpj/domain/api_validator.dart';
import 'package:jycrpj/domain/model/vlog_model.dart';
import 'package:jycrpj/domain/remote_domain/domains/vlog.dart';
import 'package:jycrpj/ui_layer/router/routes.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jycrpj/ui_layer/screens/theme.dart';
import 'package:jycrpj/ui_layer/screens/vlog/card/vlog_card.dart';
import 'package:jycrpj/ui_layer/utils/common_utils.dart';
import 'package:provider/provider.dart';

class CollectionVlogScreen extends StatefulWidget {
  const CollectionVlogScreen({super.key});

  @override
  State<CollectionVlogScreen> createState() => _CollectionVlogScreenState();
}

class _CollectionVlogScreenState extends State<CollectionVlogScreen> {
  late final _domain = context.read<VlogDomain>();
  List<VlogModel> array = [];

  int _page = 1;
  int _limit = 15;

  Future<List<VlogModel>?> _getData({
    required int page,
    required int pageSize,
  }) async {
    _page = page;
    _limit = pageSize;

    final result = await _domain.vlogFavoriteList(page: page, limit: pageSize);
    if (result.isValid) {
      List<VlogModel> tp = List.from(result.data ?? []);
      if (page == 1) {
        array = tp;
      } else {
        array.addAll(tp);
      }
      return tp;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.grid(
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
      crossAxisCount: 3,
      crossAxisSpacing: 10.w,
      childAspectRatio: 170 / 248,
      itemBuilder: (_, item, index) => VlogCard(
          data: item,
          maxLine: 1,
          onTapFunc: (type) {
            if (type == 1) {
              //点击短视频视频
              AppGlobal.shortVideosInfo = {
                'list': array,
                'page': _page,
                'index': index,
                'api': 'vlog/list_favorite',
                'params': {
                  'limit': _limit,
                }
              };
              const VlogSecondRoute().push(context);
            } else {
              //广告类型
              CommonUtils.openRoute(context, item.toJson());
            }
          }),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}
