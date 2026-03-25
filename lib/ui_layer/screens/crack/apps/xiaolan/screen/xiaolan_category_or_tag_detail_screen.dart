import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jycrpj/domain/type_def.dart';
import 'package:provider/provider.dart';

import '../../../../../../domain/async_value.dart';
import '../../../../../../domain/domain.dart';
import '../../../../../../domain/model/feed/feed_model.dart';
import '../../../../../utils/my_toast.dart';
import '../../../../common_widgets/keep_alive_wrapper.dart';
import '../../../../common_widgets/my_app_bar.dart';
import '../../../../common_widgets/my_list_view.dart';
import '../../../../common_widgets/my_tab_bar.dart';
import '../../../../common_widgets/screen_background.dart';
import '../../../../common_widgets/status/loading.dart';
import '../../../../common_widgets/status/network_error.dart';
import '../../../../theme.dart';
import '../widget/xiaolan_list_build.dart';

class XiaolanCategoryOrTagDetailScreen extends StatefulWidget {
  const XiaolanCategoryOrTagDetailScreen(
      {super.key, required this.id, required this.title, required this.type, required this.hasSort});

  final bool hasSort;
  final int id;
  final String title;
  final String type;

  @override
  State<XiaolanCategoryOrTagDetailScreen> createState() => _XiaolanCategoryOrTagDetailScreenState();
}

class _XiaolanCategoryOrTagDetailScreenState extends State<XiaolanCategoryOrTagDetailScreen>
    with TickerProviderStateMixin {
  AsyncValue<List<FeedModel>> _asyncValue = const AsyncInit();
  late final _appDomain = context.read<AppDomain>();

  late final TabController _tabController;
  int _initialIndex = 0;
  List<String> titles = ['正在看', '最热', '推荐', '最新', '畅销', '随机'];
  List<String> titlesSort = ['see', 'hot', 'recommend', 'new', 'sale', 'rand'];

  @override
  void initState() {
    _tabController = TabController(length: titles.length, vsync: this, initialIndex: _initialIndex);
    super.initState();
  }

  Future<List> _getVideoData({
    required int page,
    required int pageSize,
    required String sort,
  }) async {
    final param = Map.from({
      'page': page,
      'limit': pageSize,
      'sort': sort,
      'construct_id': widget.id,
      'tag': widget.id,
    });

    final result = await _appDomain.getConstructByApiLink(
      apiLink: widget.type == 'tag' ? "/api/tabnewxiaolan/listOfTag" : "/api/tabnewxiaolan/list_tab_mv",
      params: param,
    );

    if (result.status == 1) {
      return result.data['list'] ?? [];
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
                title: widget.title,
                backIconColor: Color(0xFF151515),
                titleColor: Color(0xFF151515),
                backgroundColor: Colors.transparent),
            body: LayoutBuilder(builder: (context, constraints) {
              return SizedBox(
                height: constraints.maxHeight, // 使用父级约束的高度
                child: widget.hasSort
                    ? TabBarWithView.line(
                        tabController: _tabController,
                        initialIndex: _initialIndex,
                        tabBarHeight: 27.h,
                        tabBarPadding: EdgeInsets.only(top: 11.w),
                        linearColors: [Colors.transparent, Colors.transparent],
                        labelStyle:
                            TextStyle(color: const Color(0xFF333333), fontSize: 16.sp, fontWeight: FontWeight.w600),
                        unselectedLabelStyle: TextStyle(
                          color: const Color(0xFF646C85),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        titles: titles,
                        views: titles.map((e) {
                          return KeepAliveWrapper(
                              child: MyListView.grid(
                            padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding, vertical: 8.w),
                            crossAxisCount: 2,
                            mainAxisSpacing: 10.h,
                            crossAxisSpacing: 8.w,
                            childAspectRatio: 344 / 240,
                            itemBuilder: (context, item, index) =>
                                XiaoLanItem.build(XiaoLanItemType.video, item, onTap: () {}),
                            onFetchingMore: (currentPage, pageSize) {
                              final res = _getVideoData(
                                  page: currentPage, pageSize: pageSize, sort: titlesSort[titles.indexOf(e)]);
                              return res;
                            },
                          ));
                        }).toList(),
                      )
                    : MyListView.grid(
                        padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding, vertical: 8.w),
                        crossAxisCount: 2,
                        mainAxisSpacing: 10.h,
                        crossAxisSpacing: 8.w,
                        childAspectRatio: 344 / 240,
                        itemBuilder: (context, item, index) =>
                            XiaoLanItem.build(XiaoLanItemType.video, item, onTap: () {}),
                        onFetchingMore: (currentPage, pageSize) {
                          final res = _getVideoData(page: currentPage, pageSize: pageSize, sort: titlesSort[0]);
                          return res;
                        },
                      ),
              );
            }),
          )
        ],
      ),
    );
  }
}
