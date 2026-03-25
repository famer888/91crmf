import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jycrpj/domain/type_def.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_list_view.dart';
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

class XiaolanDiscoverScreen extends StatefulWidget {
  const XiaolanDiscoverScreen({super.key, required this.type, required this.nagId});

  final String type;
  final String nagId;

  @override
  State<XiaolanDiscoverScreen> createState() => _XiaolanDiscoverScreenState();
}

class _XiaolanDiscoverScreenState extends State<XiaolanDiscoverScreen> {
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

  @override
  void initState() {
    // _initTagList();
    super.initState();
  }

  // sort hot/new
  Future<List> _getData({
    required int page,
    required int pageSize,
  }) async {
    bool isInit = false;

    final result = await _appDomain.getConstructByApiLink(
        apiLink:
            "${{"tag": "/api/tabnewxiaolan/list_tags", "category": "/api/tabnewxiaolan/construct_list"}[widget.type]}",
        params: {
          "nag_id": widget.nagId,
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
                  title: "发现精彩",
                  backIconColor: Color(0xFF151515),
                  titleColor: Color(0xFF151515),
                  backgroundColor: Colors.transparent),
              body: MyListView.grid(
                padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding, vertical: 8.w),
                crossAxisCount: 3,
                mainAxisSpacing: 7.h,
                crossAxisSpacing: 7.w,
                childAspectRatio: 225 / 224,
                itemBuilder: (context, item, index) => XiaoLanItem.build(
                    widget.type == "tag" ? XiaoLanItemType.tag : XiaoLanItemType.category, item,
                    onTap: () {
                      context.push('/xiaolanCategoryOrTagDetail/${item['id']}/${widget.type}/${Uri.encodeComponent(item['name']??item['title'] ?? '')}');

                    }),
                onFetchingMore: (currentPage, pageSize) {
                  final res = _getData(page: currentPage, pageSize: pageSize);
                  return res;
                },
              )
              // _asyncValue.maybeWhen(
              //     orElse: () => const LoadingView(),
              //     error: (_, __) => NetworkErrorView(onTap: _initTagList),
              //     data: (data) {
              //       return SingleChildScrollView(
              //         child: Column(
              //           children: [
              //             XiaoLanListBuild(
              //                 type: widget.type == "tag" ? XiaoLanListBuildType.tag : XiaoLanListBuildType.category,
              //                 model: data,
              //                 showHandle: false,
              //                 showHead: false),
              //             SizedBox(
              //               height: 10.w,
              //             )
              //           ],
              //         ),
              //       );
              //     }),
              )
        ],
      ),
    );
  }
}
