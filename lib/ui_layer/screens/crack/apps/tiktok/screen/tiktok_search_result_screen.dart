import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jycrpj/domain/type_def.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jycrpj/data_layer/repo/repo.dart';
import 'package:jycrpj/ui_layer/notifiers/home_config_notifier.dart';
import 'package:provider/provider.dart';

import '../../../../../../domain/async_value.dart';
import '../../../../../../domain/domain.dart';
import '../../../../../../domain/model/feed/feed_model.dart';
import '../../../../../router/routes.dart';
import '../../../../../utils/my_toast.dart';
import '../../../../common_widgets/my_app_bar.dart';
import '../../../../common_widgets/screen_background.dart';
import '../../../../common_widgets/status/loading.dart';
import '../../../../common_widgets/status/network_error.dart';
import '../../../../theme.dart';
import '../widget/tiktok_list_build.dart';

class TiktokSearchResultScreen extends StatefulWidget {
  const TiktokSearchResultScreen({super.key, required this.kwy});

  final String kwy;

  @override
  State<TiktokSearchResultScreen> createState() => _TiktokSearchResultScreenState();
}

class _TiktokSearchResultScreenState extends State<TiktokSearchResultScreen> {
  late final _appDomain = context.read<AppDomain>();
  late final _homeConfigNotifier = context.read<HomeConfigNotifier>();

  @override
  void initState() {
    _homeConfigNotifier.upsertSearchHistory(key: tiktokSearchHistoryKey, searchWord: widget.kwy);
    super.initState();
  }

  // sort hot/new
  Future<List> _getData({
    required int page,
    required int pageSize,
  }) async {
    bool isInit = false;

    final result = await _appDomain.getConstructByApiLink(apiLink: "/api/searchttav/mv", params: {
      "kwy": widget.kwy,
      "page": page,
      "limit": pageSize,
    });

    if (!isInit) {
      setState(() {
        isInit = true;
      });
    }

    if (result.status == 1) {
      return result.data['list'];
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
        bgColor: Color(0xFF181A25),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: MyAppBar(
                title: "${widget.kwy}",
                backIconColor: Colors.white,
                titleColor: Colors.white,
                backgroundColor: Colors.transparent),
            body: MyListView.grid(
              padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding, vertical: 8.w),
              crossAxisCount: 2,
              mainAxisSpacing: 10.h,
              crossAxisSpacing: 8.w,
              childAspectRatio: 344 / 240,
              itemBuilder: (context, item, index) => TiktokItem.build(TiktokItemType.video, item, onTap: () {
                TiktokVideoDetailRoute(id: item['id']).push(context);
              }),
              onFetchingMore: (currentPage, pageSize) {
                final res = _getData(page: currentPage, pageSize: pageSize);
                return res;
              },
            )));
  }
}
