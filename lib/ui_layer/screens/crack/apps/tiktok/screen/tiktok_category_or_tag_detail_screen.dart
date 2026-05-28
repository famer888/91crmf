import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jycrpj/domain/type_def.dart';
import 'package:jycrpj/ui_layer/router/routes.dart';
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
import '../widget/tiktok_list_build.dart';

class TiktokCategoryOrTagDetailScreen extends StatefulWidget {
  const TiktokCategoryOrTagDetailScreen(
      {super.key, required this.id, required this.title, required this.type, required this.hasSort});

  final bool hasSort;
  final int id;
  final String title;
  final String type;

  @override
  State<TiktokCategoryOrTagDetailScreen> createState() => _TiktokCategoryOrTagDetailScreenState();
}

class _TiktokCategoryOrTagDetailScreenState extends State<TiktokCategoryOrTagDetailScreen>
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

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<List> _getVideoData({
    required int page,
    required int pageSize,
    required String sort,
  }) async {
    final param = Map.from({
      'page': page,
      'limit': pageSize,
    });
    if (widget.hasSort) {
      param['sort'] = sort;
    }
    if (widget.type == 'tag') {
      param['tag'] = widget.title;
    } else {
      param['construct_id'] = widget.id;
    }

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
        bgColor: Color(0xFF181A25),
        child: Scaffold(
          backgroundColor: Color(0xFF181A25),
          appBar: MyAppBar(
            title: widget.title,
            backIconColor: Color(0xFFFFFFFF),
            titleColor: Color(0xFFFFFFFF),
            backgroundColor: Color(0xFF181A25),
          ),
          body: LayoutBuilder(builder: (context, constraints) {
            return SizedBox(
              height: constraints.maxHeight, // 使用父级约束的高度
              child: widget.hasSort
                  ? TabBarWithView.line(
                      tabBarRightWidget: Row(
                        children: [
                          GestureDetector(
                            child: Row(
                              children: [
                                Text(
                                  "切换",
                                  style: TextStyle(color: Colors.white, fontSize: 13.sp),
                                ),
                                SizedBox(width: 6.w),
                                Image.asset("assets/images/tiktok_switch_layout.png", width: 16.w),
                              ],
                            ),
                          ),
                          SizedBox(width: 13.w,)
                        ],
                      ),
                      tabController: _tabController,
                      initialIndex: _initialIndex,
                      tabBarHeight: 30.h,
                      tabBarPadding: EdgeInsets.only(top: 11.w),
                      linearColors: [Colors.transparent, Colors.transparent],
                      labelStyle:
                          TextStyle(color: const Color(0xFFFF2E59), fontSize: 16.sp, fontWeight: FontWeight.w600),
                      unselectedLabelStyle: TextStyle(
                        color: const Color(0xB3FFFFFF),
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
                              TiktokItem.build(TiktokItemType.video, item, onTap: () {
                            TiktokVideoDetailRoute(
                              id: item['id'],
                            ).push(context);
                          }),
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
                      itemBuilder: (context, item, index) => TiktokItem.build(TiktokItemType.video, item, onTap: () {
                        TiktokVideoDetailRoute(
                          id: item['id'],
                        ).push(context);
                      }),
                      onFetchingMore: (currentPage, pageSize) {
                        final res = _getVideoData(page: currentPage, pageSize: pageSize, sort: titlesSort[0]);
                        return res;
                      },
                    ),
            );
          }),
        ));
  }
}
