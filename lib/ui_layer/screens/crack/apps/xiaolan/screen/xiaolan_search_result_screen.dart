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
import '../../../../../utils/my_toast.dart';
import '../../../../common_widgets/my_app_bar.dart';
import '../../../../common_widgets/screen_background.dart';
import '../../../../common_widgets/status/loading.dart';
import '../../../../common_widgets/status/network_error.dart';
import '../../../../theme.dart';
import '../widget/xiaolan_list_build.dart';

class XiaoLanSearchResultScreen extends StatefulWidget {
  const XiaoLanSearchResultScreen({super.key, required this.kwy});

  final String kwy;

  @override
  State<XiaoLanSearchResultScreen> createState() => _XiaoLanSearchResultScreenState();
}

class _XiaoLanSearchResultScreenState extends State<XiaoLanSearchResultScreen> {
  // AsyncValue<List> _asyncValue = const AsyncInit();
  // late final _appDomain = context.read<AppDomain>();
  //
  // @override
  // void initState() {
  //   // _initTagList();
  //   super.initState();
  // }
  //
  // // sort hot/new
  // Future<List> _getData(int pageIndex,int pageSize) async {
  //   if (_asyncValue.isLoading) return;
  //   setState(() {
  //     _asyncValue = const AsyncLoading();
  //   });
  //   final result = await _appDomain.getConstructByApiLink(
  //       apiLink:
  //           "${{"tag": "/api/tabnewxiaolan/list_tags", "category": "/api/tabnewxiaolan/construct_list"}[widget.type]}",
  //       params: {
  //         "nag_id": widget.nagId,
  //       });
  //   if (result.status == 1) {
  //     if (result.data['list'] case final list when list.isNotEmpty) {
  //       List list = result.data['list'];
  //       _asyncValue = AsyncData(list);
  //     } else {
  //       _asyncValue = AsyncData([]);
  //     }
  //   } else {
  //     MyToast.showText(text: result.msg ?? '');
  //     _asyncValue = const AsyncError();
  //   }
  //
  //   if (mounted) {
  //     setState(() {});
  //   }
  // }

  late final _appDomain = context.read<AppDomain>();
  late final _homeConfigNotifier = context.read<HomeConfigNotifier>();

  @override
  void initState() {
    _homeConfigNotifier.upsertSearchHistory(key: xiaolanSearchHistoryKey, searchWord: widget.kwy);
    super.initState();
  }

  // sort hot/new
  Future<List> _getData({
    required int page,
    required int pageSize,
  }) async {
    bool isInit = false;

    final result = await _appDomain.getConstructByApiLink(apiLink: "/api/searchxiaolan/mv", params: {
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
      bgColor: Colors.white,
      child: Stack(
        children: [
          Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: Image.asset('assets/images/xiaolan_top_navi_bg.png', width: double.infinity, fit: BoxFit.cover)),
          Scaffold(
              backgroundColor: Colors.transparent,
              appBar: MyAppBar(
                  title: "${widget.kwy}",
                  backIconColor: Color(0xFF151515),
                  titleColor: Color(0xFF151515),
                  backgroundColor: Colors.transparent),
              body: MyListView.grid(
                padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding, vertical: 8.w),
                crossAxisCount: 2,
                mainAxisSpacing: 10.h,
                crossAxisSpacing: 8.w,
                childAspectRatio: 344 / 240,
                itemBuilder: (context, item, index) => XiaoLanItem.build(XiaoLanItemType.video, item, onTap: () {}),
                onFetchingMore: (currentPage, pageSize) {
                  final res = _getData(page: currentPage, pageSize: pageSize);
                  return res;
                },
              ))
        ],
      ),
    );
  }
}
