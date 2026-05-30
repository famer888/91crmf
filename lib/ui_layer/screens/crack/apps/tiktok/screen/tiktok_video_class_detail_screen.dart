import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jycrpj/domain/type_def.dart';
import 'package:provider/provider.dart';

import '../../../../../../domain/async_value.dart';
import '../../../../../../domain/domain.dart';
import '../../../../../router/routes.dart';
import '../../../../../utils/common_utils.dart';
import '../../../../../utils/my_toast.dart';
import '../../../../common_widgets/my_image.dart';
import '../../../../common_widgets/my_list_view.dart';
import '../../../../common_widgets/my_tab_bar.dart';
import '../../../../common_widgets/screen_background.dart';
import '../../../../common_widgets/status/loading.dart';
import '../../../../common_widgets/status/network_error.dart';
import '../../../../image_paths.dart';
import '../../../../theme.dart';
import '../widget/tiktok_list_build.dart';

class TiktokVideoClassDetailScreen extends StatefulWidget {
  const TiktokVideoClassDetailScreen({super.key, required this.id});

  final int id;

  @override
  State<TiktokVideoClassDetailScreen> createState() => _TiktokVideoClassDetailScreenState();
}

class _TiktokVideoClassDetailScreenState extends State<TiktokVideoClassDetailScreen> with TickerProviderStateMixin {
  late final _appDomain = context.read<AppDomain>();
  bool gridLayout = true;

  AsyncValue<dynamic> _asyncValue = const AsyncInit();

  late final TabController _tabController;
  final int _initialIndex = 0;
  final List<String> titles = ['热门', '推荐', '最新', '随机'];
  final List<String> titlesSort = ['hot', 'recommend', 'new', 'rand'];

  @override
  void initState() {
    super.initState();
    _init();
    _tabController = TabController(length: titles.length, vsync: this, initialIndex: _initialIndex);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    if (_asyncValue.isLoading) return;

    setState(() {
      _asyncValue = const AsyncLoading();
    });
    final result =
        await _appDomain.getConstructByApiLink(apiLink: "/api/tabnewttav/tab_detail", params: {'tab_id': widget.id});
    if (result.status == 1) {
      final tab_info = result.data['tab_info'];
      _asyncValue = AsyncData(tab_info);
    } else {
      _asyncValue = const AsyncError();
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future<List> _getVideoData({
    required int page,
    required int pageSize,
    required String sort,
  }) async {
    final param = {'tab_id': widget.id, 'page': page, 'limit': pageSize, 'sort': sort};
    final result = await _appDomain.getConstructByApiLink(
      apiLink: "/api/tabnewttav/list_tab_mv",
      params: param,
    );

    if (result.status == 1) {
      return result.data['list'] ?? [];
    }
    MyToast.showText(text: result.msg ?? '');
    return [];
  }

  double get _headerBannerHeight => 150.w;

  double get _toolbarHeight => MyTheme.navbarHegiht;

  Widget _buildBackButton(Color iconColor) {
    return GestureDetector(
      onTap: () => context.pop(),
      child: Image.asset(
        MyImagePaths.appBackIcon,
        width: 20.w,
        height: 20.w,
        color: iconColor,
      ),
    );
  }

  List<Widget> _buildHeaderSlivers(BuildContext context, dynamic data, bool innerBoxIsScrolled) {
    final topPadding = MediaQuery.paddingOf(context).top;
    final title = "${data['tab_name'] ?? ''}";
    final expandedHeight = topPadding + _headerBannerHeight;

    return [
      SliverAppBar(
        pinned: true,
        expandedHeight: expandedHeight,
        toolbarHeight: _toolbarHeight,
        backgroundColor: const Color(0xFF181A25),
        surfaceTintColor: Colors.transparent,
        elevation: innerBoxIsScrolled ? 0.5 : 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: innerBoxIsScrolled && title.isNotEmpty
            ? Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: MyTheme.white255_18_B,
              )
            : null,
        leading: Padding(
          padding: EdgeInsets.only(left: MyTheme.pagePadding - 4.w),
          child: _buildBackButton(Colors.white),
        ),
        leadingWidth: 20.w + MyTheme.pagePadding,
        flexibleSpace: FlexibleSpaceBar(
          collapseMode: CollapseMode.pin,
          background: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                    child: Stack(
                  fit: StackFit.expand,
                  children: [
                    MyImage.network("${data['bg_thumb']}", fit: BoxFit.cover),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black.withOpacity(.5)],
                        ),
                      ),
                    ),
                    Positioned(
                        top: 50.w,
                        left: 12.w,
                        right: 12.w,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "$title",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                              ),
                            ),
                            SizedBox(
                              height: 10.w,
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  "assets/images/tiktok_icon_num.png",
                                  width: 16.w,
                                ),
                                SizedBox(
                                  width: 6.w,
                                ),
                                Text(
                                  "${CommonUtils.formatNumber(data['work_num'])}",
                                  style: TextStyle(color: Colors.white, fontSize: 13.sp),
                                ),
                                SizedBox(
                                  width: 28.w,
                                ),
                                GestureDetector(
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        "assets/images/tiktok_icon_collection.png",
                                        width: 13.w,
                                      ),
                                      SizedBox(
                                        width: 6.w,
                                      ),
                                      Text(
                                        "${CommonUtils.formatNumber(data['favorites_num'])}",
                                        style: TextStyle(color: Colors.white, fontSize: 13.sp),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10.w,
                            ),
                            RichText(
                              text: TextSpan(children: [
                                TextSpan(text: "分类简介：", style: TextStyle(color: Colors.white.withOpacity(.6))),
                                TextSpan(text: "${data['intro'] ?? ""}", style: TextStyle(color: Colors.white))
                              ], style: TextStyle(fontSize: 13.sp)),
                            )
                          ],
                        ))
                  ],
                ))
              ],
            ),
          ),
        ),
      ),
    ];
  }

  Widget _buildTabBody(TabController tc) {
    return TabBarWithView.line(
      tabBarPadding: EdgeInsets.zero,
      tabBarRightWidget: Row(
        children: [
          GestureDetector(
            onTap: () => setState(() => gridLayout = !gridLayout),
            child: Row(
              children: [
                Text("切换", style: TextStyle(color: Colors.white, fontSize: 13.sp)),
                SizedBox(width: 6.w),
                Image.asset(
                  gridLayout ? "assets/images/tiktok_switch_layout.png" : "assets/images/tiktok_switch_layout2.png",
                  width: 16.w,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 13.w,
          )
        ],
      ),
      tabController: tc,
      initialIndex: _initialIndex,
      tabBarHeight: 54.w,
      linearColors: const [Color(0xFFFF2E59), Color(0xFFFF2E59)],
      labelStyle: TextStyle(color: const Color(0xFFFF2E59), fontSize: 16.sp, fontWeight: FontWeight.w600),
      unselectedLabelStyle: TextStyle(
        color: const Color(0xFFFFFFFF),
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
      ),
      titles: titles,
      views: titles.map((_) {
        return MyListView.grid(
          padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding, vertical: 8.w),
          crossAxisCount: gridLayout ? 2 : 1,
          mainAxisSpacing: 10.w,
          crossAxisSpacing: gridLayout ? 8.w : 10.w,
          childAspectRatio: gridLayout ? 344 / 240 : 704 / 439,
          itemBuilder: (context, item, index) => TiktokItem.build(TiktokItemType.video, item, onTap: () {
            TiktokVideoDetailRoute(id: item['id']).push(context);
          }),
          onFetchingMore: (currentPage, pageSize) => _getVideoData(
            page: currentPage,
            pageSize: pageSize,
            sort: titlesSort[_tabController.index],
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      bgColor: const Color(0xFF181A25),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: _asyncValue.maybeWhen(
          data: (data) {
            return NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) =>
                  _buildHeaderSlivers(context, data, innerBoxIsScrolled),
              body: _buildTabBody(_tabController),
            );
          },
          error: (_, __) => Column(
            children: [
              SafeArea(
                bottom: false,
                child: SizedBox(
                  height: _toolbarHeight,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: _buildBackButton(Colors.white),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: NetworkErrorView(onTap: _init),
              ),
            ],
          ),
          orElse: () => const SafeArea(child: LoadingView()),
        ),
      ),
    );
  }
}
