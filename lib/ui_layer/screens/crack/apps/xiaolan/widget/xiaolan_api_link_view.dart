import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/domain/domain.dart';
import 'package:jycrpj/domain/model/banner_model.dart';
import 'package:jycrpj/domain/model/feed/feed_model.dart';
import 'package:jycrpj/domain/model/home_data_model.dart';
import 'package:jycrpj/domain/model/link_model.dart';
import 'package:jycrpj/domain/model/nav_model.dart';
import 'package:jycrpj/domain/model/part_nav_model.dart';
import 'package:jycrpj/domain/type_def.dart';
import 'package:jycrpj/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jycrpj/ui_layer/router/routes.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/event_bus/event_bus.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_tab_bar.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/xiaolan/widget/xiaolan_list_build.dart';
import 'package:jycrpj/ui_layer/screens/crack/widgets/scroll_top_button.dart';
import 'package:jycrpj/ui_layer/screens/theme.dart';
import 'package:jycrpj/ui_layer/utils/common_utils.dart';
import 'package:jycrpj/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';

import '../../../../../../domain/async_value.dart';
import '../../../../../../report/ui_layer/report_general_banner.dart';
import '../../../../../../report/ui_layer/report_gesture_detector.dart';
import '../../../../common_widgets/keep_alive_wrapper.dart';
import '../../../../common_widgets/status/loading.dart';
import '../../../../common_widgets/status/network_error.dart';
import 'xiaolan_ads_header.dart';

class XiaoLanApiLinkView extends StatefulWidget {
  const XiaoLanApiLinkView(
      {super.key, this.showRightList = false, required this.linkModel, required this.onLinkNavTap});

  final LinkModel linkModel;
  final ValueChanged<String> onLinkNavTap;
  final bool showRightList;

  @override
  State<XiaoLanApiLinkView> createState() => _XiaoLanApiLinkViewState();
}

class _XiaoLanApiLinkViewState extends State<XiaoLanApiLinkView> with TickerProviderStateMixin {
  late final _appDomain = context.read<AppDomain>();
  final ValueNotifier<List<BannerModel>> bannersNotifier = ValueNotifier([]);

  // 当前tab选中的位置
  int initialIndex = 0;
  bool isInit = false;
  bool initSetIndex = false;

  final ScrollController _nestedController = ScrollController();
  final ValueNotifier<bool> _showToTopBtn = ValueNotifier(false);

  late final TabController _tabController;
  List<String> titles = ['正在看', '最热', '推荐', '最新', '畅销', '随机'];
  List<String> titlesSort = ['see', 'hot', 'recommend', 'new', 'sale', 'rand'];
  AsyncValue<List> _asyncValue = const AsyncInit();

  // 普通列表中间类被
  List? mid_style_category;

  dynamic? rank;

  // 普通列表中间标签
  dynamic? tags_mv;

  final GlobalKey<MyListViewState<dynamic>> _listKey = GlobalKey<MyListViewState<dynamic>>();

  // 今日热点
  // List? bot_style_one;

  // 普通列表数据
  // List? bot_style_two;

  Future<List<dynamic>?> _getData({
    required int page,
    required int pageSize,
  }) async {
    if (isInit) {
      if (_asyncValue.isLoading) return [];
      setState(() {
        _asyncValue = const AsyncLoading();
        isInit = false;
      });
    }

    CommonUtils.log('getData: ${widget.linkModel.api} - titles:$titles');
    final param = Map.from(widget.linkModel.params)
      ..['page'] = page
      ..['limit'] = pageSize;

    CommonUtils.log('getData: ${widget.linkModel.api}  param:$param');
    final result = await _appDomain.getConstructByApiLink(
      apiLink: widget.linkModel.type == 4 ? "/api/tabnewxiaolan/hotRank" : widget.linkModel.api,
      params: param,
    );

    if (result.status == 1) {
      if (result.data['banner'] case final List data when data.isNotEmpty && bannersNotifier.value.isEmpty) {
        final banner = data.map((x) => BannerModel.fromJson(x)).toList();
        bannersNotifier.value = banner;
      }

      setState(() {
        if (page == 1) rank = result.data['rank'];

        mid_style_category = result.data['mid_style_category'];
        if (result.data['body'] != null && result.data['body'] is Map && result.data['body']['type'] == "tags-mv") {
          tags_mv = result.data['body'];
        }
      });
      // bot_style_one = result.data['bot_style_one'];
      // bot_style_two = result.data['bot_style_two'];

      _asyncValue = AsyncData([]);
      if (mounted) {
        setState(() {});
      }
      return widget.linkModel.type == 4
          ? result.data['list'] as List
          : widget.linkModel.name == "推荐"
              ? result.data['bot_style_one']
              : result.data['bot_style_two'];
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
    _asyncValue = const AsyncError();
    if (mounted) {
      setState(() {});
    }
    return [];
  }

  Future<List> _getVideoData({
    required int page,
    required int pageSize,
    required String sort,
  }) async {
    if (isInit) {
      if (_asyncValue.isLoading) return [];
      setState(() {
        _asyncValue = const AsyncLoading();
        isInit = false;
      });
    }

    final param = Map.from(widget.linkModel.params)
      ..['page'] = page
      ..['limit'] = pageSize
      ..['tabId'] = widget.linkModel.id
      ..['sort'] = sort;
    final result = await _appDomain.getConstructByApiLink(
      apiLink: widget.linkModel.api,
      params: param,
    );

    if (result.status == 1) {
      if (result.data['banner'] case final List data when data.isNotEmpty && bannersNotifier.value.isEmpty) {
        final banner = data.map((x) => BannerModel.fromJson(x)).toList();
        bannersNotifier.value = banner;
      }

      setState(() {
        if (page == 1) rank = result.data['rank'];

        mid_style_category = result.data['mid_style_category'];
        if (result.data['body'] != null && result.data['body'] is Map && result.data['body']['type'] == "tags-mv") {
          tags_mv = result.data['body'];
        }
      });

      _asyncValue = AsyncData([]);
      if (mounted) {
        setState(() {});
      }

      if (widget.linkModel.type == 2) {
        return result.data['list'] ?? [];
      } else {
        return result.data['bot_style_two'] ?? [];
      }
    } else {
      MyToast.showText(text: result.msg ?? '');
    }

    _asyncValue = const AsyncError();
    if (mounted) {
      setState(() {});
    }

    return [];
  }

  @override
  void initState() {
    // if (widget.linkModel.name != "推荐" && widget.linkModel.type != 4)
    //   _getData(page: 1, pageSize: 20);
    // else
    // _asyncValue = const AsyncData([]);

    _tabController = TabController(length: titles.length, vsync: this, initialIndex: initialIndex);
    _tabController.addListener(() {
      if (initialIndex == _tabController.index) return;
      _listKey.currentState?.reloadPage();
      initialIndex = _tabController.index;
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    bannersNotifier.dispose();
    _nestedController.dispose();
    _showToTopBtn.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    if (!_nestedController.hasClients) return;

    _showToTopBtn.value = false;
    _nestedController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Future<String> onRefresh(dynamic model) async {
    // _getData(page: 1, pageSize: 20);
    DateTime now = DateTime.now();
    final year = now.year.toString();
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');

    final result = await _appDomain.getConstructByApiLink(
      apiLink: model['type'] == 5 ? "/api/dailyvideoxiaolan/list" : "/api/tabnewxiaolan/list_tab_mv",
      params: {
        "date": "$year-$month-$day",
        'page': 1,
        'limit': 20,
        'sort': 'rand',
        'construct_id': model['id'],
      },
    );
    if (result.status == 1) {
      setState(() {
        model['list'] = result.data['list'] ?? [];
      });
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notification) {
              if (!_nestedController.hasClients) return false;
              final pos = _nestedController.position;
              final viewportHeight = pos.viewportDimension * 0.4; // NestedScrollView可视高度
              final offset = pos.pixels;

              final overOnePage = offset >= viewportHeight;
              _showToTopBtn.value = overOnePage;
              return false;
            },
            child: widget.linkModel.name == "推荐" || widget.linkModel.type == 4
                ? (MyListView.list(
                    padding: EdgeInsets.zero,
                    header: Column(
                      children: [
                        XiaoLanAdsHeader(
                          bannersNotifier: bannersNotifier,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                    itemBuilder: (context, item, index) {
                      return Column(
                        children: [
                          SizedBox(
                            height: 10.w,
                          ),
                          if (widget.linkModel.type == 4 && index == 0) ...[
                            XiaoLanListBuild(
                                type: XiaoLanListBuildType.creator, linkModel: widget.linkModel, model: rank),
                            SizedBox(
                              height: 10.w,
                            )
                          ],
                          XiaoLanListBuild(
                            type: widget.linkModel.type == 4
                                ? XiaoLanListBuildType.userScroll
                                : [
                                    XiaoLanListBuildType.fourGrid,
                                    XiaoLanListBuildType.oneBigSecondScroll,
                                    XiaoLanListBuildType.oneBigFourGrid,
                                    XiaoLanListBuildType.sixGrid,
                                    XiaoLanListBuildType.oneLineScroll,
                                    XiaoLanListBuildType.fourGrid,
                                  ][item['show_style']],
                            linkModel: widget.linkModel,
                            model: item,
                            onRefresh: () async {
                              final res = await onRefresh(item);
                              return res;
                            },
                          ),
                          SizedBox(
                            height: 20.w,
                          )
                        ],
                      );
                    },
                    onFetchingMore: (currentPage, pageSize) async {
                      return _getData(page: currentPage, pageSize: pageSize);
                    }))
                : MyListView.grid(
                    key: _listKey,
                    header: Column(
                      children: [
                        XiaoLanAdsHeader(
                          bannersNotifier: bannersNotifier,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        if (mid_style_category != null && mid_style_category!.isNotEmpty) ...[
                          XiaoLanListBuild(
                              type: XiaoLanListBuildType.categoryScroll,
                              linkModel: widget.linkModel,
                              model: mid_style_category),
                          SizedBox(
                            height: 10.w,
                          ),
                        ],
                        if (tags_mv != null)
                          XiaoLanListBuild(type: XiaoLanListBuildType.tag, linkModel: widget.linkModel, model: tags_mv),
                        SizedBox(
                          height: 10.w,
                        ),
                      ],
                    ),
                    persistentHeader: StickyHeaderDelegate(
                      height: 30.w,
                      child: Container(
                        color: Colors.white,
                        child: TabBarWithView.line(
                          tabBarPadding: EdgeInsets.symmetric(horizontal: 5.w),
                          tabController: _tabController,
                          initialIndex: initialIndex,
                          tabBarHeight: 30.w,
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
                            return SizedBox.shrink();
                          }).toList(),
                        ),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding, vertical: 8.w),
                    crossAxisCount: 2,
                    mainAxisSpacing: 10.h,
                    crossAxisSpacing: 8.w,
                    childAspectRatio: 344 / 240,
                    itemBuilder: (context, item, index) => XiaoLanItem.build(XiaoLanItemType.video, item, onTap: () {
                      XiaolanVideoDetailRoute(id: item['id']).push(context);
                    }),
                    onFetchingMore: (currentPage, pageSize) {
                      final res =
                          _getVideoData(page: currentPage, pageSize: pageSize, sort: titlesSort[_tabController.index]);
                      return res;
                    },
                  )),
        if (!(widget.linkModel.name == "推荐" || widget.linkModel.type == 4))
          Positioned.fill(
            child: _asyncValue.maybeWhen(
                error: (_, __) => NetworkErrorView(onTap: () {
                      _getData(page: 1, pageSize: 20);
                    }),
                orElse: () => Container(color: Colors.white, child: const LoadingView()),
                data: (data) {
                  return SizedBox.shrink();
                }),
          ),
        Positioned(
          right: 20.w,
          bottom: 42.w,
          child: ScrollTopButton(
            showToTopButtonNotifier: _showToTopBtn,
            scrollTopCallback: _scrollToTop,
          ),
        ),
      ],
    );
  }
}
