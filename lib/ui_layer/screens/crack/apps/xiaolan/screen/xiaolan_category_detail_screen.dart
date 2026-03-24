import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../domain/async_value.dart';
import '../../../../../../domain/domain.dart';
import '../../../../../../domain/model/feed/feed_model.dart';
import '../../../../common_widgets/my_app_bar.dart';
import '../../../../common_widgets/my_tab_bar.dart';
import '../../../../common_widgets/screen_background.dart';
import '../../../../common_widgets/status/loading.dart';
import '../../../../common_widgets/status/network_error.dart';
import '../widget/xiaolan_list_build.dart';

class XiaolanCategoryDetailScreen extends StatefulWidget {
  const XiaolanCategoryDetailScreen({super.key, required this.categoryId, required this.title});

  final int categoryId;
  final String title;

  @override
  State<XiaolanCategoryDetailScreen> createState() => _XiaolanCategoryDetailScreenState();
}

class _XiaolanCategoryDetailScreenState extends State<XiaolanCategoryDetailScreen> with TickerProviderStateMixin {
  AsyncValue<List<FeedModel>> _asyncValue = const AsyncInit();
  late final _appDomain = context.read<AppDomain>();

  late final TabController _tabController;
  int _initialIndex = 0;
  List<String> titles = ['正在看', '最热', '推荐', '最新', '畅销', '随机'];

  @override
  void initState() {
    _tabController = TabController(length: titles.length, vsync: this, initialIndex: _initialIndex);

    _initTagList();

    super.initState();
  }

  // sort hot/new
  Future<void> _initTagList() async {
    if (_asyncValue.isLoading) return;
    setState(() {
      _asyncValue = const AsyncLoading();
    });

    _asyncValue = AsyncData([]);
    //
    //
    // final result = await _appDomain.getConstructByApiLink(
    //     apiLink: 'mvhjgj/list_tag_mvs',
    //     params: {'tag': widget.videoTag, 'sort': 'hot'});
    // if (result.status == 1) {
    //   if (result.data case final list when list.isNotEmpty) {
    //     final feedModelList =
    //         list?.map<FeedModel>((x) => FeedModel.fromJson(x)).toList();
    //     _asyncValue = AsyncData(feedModelList);
    //   }
    // } else {
    //   MyToast.showText(text: result.msg ?? '');
    //   _asyncValue = const AsyncError();
    // }

    if (mounted) {
      setState(() {});
    }
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
            body: _asyncValue.maybeWhen(
                orElse: () => const LoadingView(),
                error: (_, __) => NetworkErrorView(onTap: _initTagList),
                data: (data) {
                  // return XiaoLanListBuild(type: XiaoLanListBuildType.classify, showHandle: false, showHead: false);
                  return LayoutBuilder(builder: (context, constraints) {
                    return SizedBox(
                      height: constraints.maxHeight, // 使用父级约束的高度
                      child: TabBarWithView.line(
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
                          return XiaoLanListBuild(
                              type: XiaoLanListBuildType.fourGrid, showHandle: false, showHead: false);
                        }).toList(),
                      ),
                    );
                  });
                }),
          )
        ],
      ),
    );
  }
}
