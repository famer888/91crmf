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
import 'package:jycrpj/ui_layer/screens/image_paths.dart';
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
import '../../../widgets/grid_list_switch.dart';
import '../../clsq/widget/cl_feed_card.dart';

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
  late final _homeConfig = context.read<HomeConfigNotifier>();
  final ValueNotifier<List<BannerModel>> bannersNotifier = ValueNotifier([]);
  final ValueNotifier<List<NavModel>> topicsNotifier = ValueNotifier([]);
  final ValueNotifier<List<PartModel>> partNotifier = ValueNotifier([]);
  final ValueNotifier<bool> isListNotifier = ValueNotifier(false);

  // 当前tab选中的位置
  int initialIndex = 0;
  bool isInit = false;
  bool initSetIndex = false;

  final ScrollController _nestedController = ScrollController();
  final ValueNotifier<bool> _showToTopBtn = ValueNotifier(false);
  double _showThreshold = 0; // 一屏高度

  late final TabController _tabController;
  List<String> titles = ['正在看', '最热', '推荐', '最新', '畅销', '随机'];
  List<String> titlesSort = ['see', 'hot', 'recommend', 'new', 'sale', 'rand'];
  AsyncValue<List> _asyncValue = const AsyncInit();

  // 普通列表中间类被
  List? mid_style_category;

  // 普通列表中间标签
  dynamic? tags_mv;

  // 今日热点
  List? bot_style_one;

  // 普通列表数据
  List? bot_style_two;

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
      apiLink: widget.linkModel.api,
      params: param,
    );

    if (result.status == 1) {
      if (result.data['banner'] case final List data when data.isNotEmpty && bannersNotifier.value.isEmpty) {
        final banner = data.map((x) => BannerModel.fromJson(x)).toList();
        bannersNotifier.value = banner;
      }
      if (result.data['nav'] case final List data when data.isNotEmpty && topicsNotifier.value.isEmpty) {
        final nav = data.map((x) => NavModel.fromJson(x)).toList();
        topicsNotifier.value = nav;
      }
      mid_style_category = result.data['mid_style_category'];
      if (result.data['body'] != null && result.data['body'] is Map && result.data['body']['type'] == "tags-mv") {
        tags_mv = result.data['body'];
      }
      bot_style_one = result.data['bot_style_one'];
      bot_style_two = result.data['bot_style_two'];

      _asyncValue = AsyncData([]);
      if (mounted) {
        setState(() {});
      }
      return bot_style_one;
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
    final param = Map.from(widget.linkModel.params)
      ..['page'] = page
      ..['limit'] = pageSize
      ..['tabId'] = widget.linkModel.id
      ..['sort'] = sort;

    final result = await _appDomain.getConstructByApiLink(
      apiLink: "/api/mvxiaolan/listOfTab",
      params: param,
    );

    if (!isInit) {
      setState(() {
        isInit = true;
      });
    }

    if (result.status == 1) {
      return result.data['list'] ?? [];
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
    return [];
  }

  @override
  void initState() {
    _getData(page: 1, pageSize: 20);
    isListNotifier.value = false;
    _tabController = TabController(length: titles.length, vsync: this, initialIndex: initialIndex);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showThreshold = ScreenUtil().screenHeight * 0.40;
    });
  }

  @override
  void dispose() {
    bannersNotifier.dispose();
    topicsNotifier.dispose();
    partNotifier.dispose();
    isListNotifier.dispose();
    _nestedController.dispose();
    _showToTopBtn.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    if (!_nestedController.hasClients) return;

    _nestedController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _asyncValue.maybeWhen(
          data: (data) {
            return LayoutBuilder(builder: (context, constraints) {
              return SizedBox(
                  height: constraints.maxHeight, // 使用父级约束的高度
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification notification) {
                      return false;
                    },
                    child: NestedScrollView(
                      controller: _nestedController,
                      headerSliverBuilder: (_, __) => [
                        SliverToBoxAdapter(
                          child: _Header(
                            bannersNotifier: bannersNotifier,
                            topicsNotifier: topicsNotifier,
                            partNotifier: partNotifier,
                            onLinkNavTap: widget.onLinkNavTap,
                          ),
                        ),
                        if (mid_style_category != null && mid_style_category!.isNotEmpty)
                          SliverToBoxAdapter(
                            child: XiaoLanListBuild(
                                type: XiaoLanListBuildType.categoryScroll,
                                linkModel: widget.linkModel,
                                model: mid_style_category),
                          ),
                        if (tags_mv != null)
                          SliverToBoxAdapter(
                            child: XiaoLanListBuild(
                                type: XiaoLanListBuildType.tag, linkModel: widget.linkModel, model: tags_mv),
                          ),
                        // if(bot_style_one != null && bot_style_one!.isNotEmpty)
                        //   for(var item in bot_style_one!)
                        //     SliverToBoxAdapter(
                        //       child: XiaoLanListBuild(
                        //           type: XiaoLanListBuildType.fourGrid, linkModel: widget.linkModel, model: item),
                        //     ),
                        // if(bot_style_two != null && bot_style_two!.isNotEmpty)
                        //   SliverToBoxAdapter(
                        //     child: XiaoLanListBuild(
                        //         type: XiaoLanListBuildType.oneBigFourGrid, linkModel: widget.linkModel, model: bot_style_one),
                        //   )
                      ],
                      body: bot_style_one != null || bot_style_two != null
                          ? (MyListView.list(
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, item, index) {
                                return XiaoLanListBuild(
                                    type: [
                                      XiaoLanListBuildType.fourGrid,
                                      XiaoLanListBuildType.oneBigSecondScroll,
                                      XiaoLanListBuildType.oneBigFourGrid,
                                      XiaoLanListBuildType.sixGrid,
                                      XiaoLanListBuildType.oneLineScroll,
                                      XiaoLanListBuildType.fourGrid,
                                    ][item['show_style']],
                                    linkModel: widget.linkModel,
                                    model: item);
                              },
                              onFetchingMore: (currentPage, pageSize) async {
                                return _getData(page: currentPage, pageSize: pageSize);
                              }))
                          : TabBarWithView.line(
                              tabController: _tabController,
                              initialIndex: initialIndex,
                              tabBarHeight: 27.h,
                              tabBarPadding: EdgeInsets.only(top: 11.w),
                              linearColors: [Colors.transparent, Colors.transparent],
                              labelStyle: TextStyle(
                                  color: const Color(0xFF333333), fontSize: 16.sp, fontWeight: FontWeight.w600),
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
                                  itemBuilder: (context, item, index) => XiaoLanItem.build(XiaoLanItemType.video, item),
                                  onFetchingMore: (currentPage, pageSize) {
                                    final res = _getVideoData(
                                        page: currentPage, pageSize: pageSize, sort: titlesSort[titles.indexOf(e)]);
                                    return res;
                                  },
                                ));
                              }).toList()),
                    ),
                  ));
            });
          },
          error: (_, __) => NetworkErrorView(onTap: () {
            _getData(page: 1, pageSize: 20);
          }),
          orElse: () => const LoadingView(),
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

class _Header extends StatefulWidget {
  const _Header({
    required this.bannersNotifier,
    required this.topicsNotifier,
    required this.partNotifier,
    required this.onLinkNavTap,
  });

  final ValueNotifier<List<BannerModel>> bannersNotifier;
  final ValueNotifier<List<NavModel>> topicsNotifier;
  final ValueNotifier<List<PartModel>> partNotifier;
  final ValueChanged<String> onLinkNavTap;

  @override
  State<_Header> createState() => _HeaderState();
}

class _HeaderState extends State<_Header> {
  List<NavModel> contentTopics = [];
  bool isShowAllTopics = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ValueListenableBuilder(
          valueListenable: widget.bannersNotifier,
          builder: (context, banners, child) {
            if (banners.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
              child: ReportGeneralAppsListVidget(data: banners, titleColor: Colors.black.withValues(alpha: .7)),
            );
          },
        ),
        ValueListenableBuilder(
          valueListenable: widget.partNotifier,
          builder: (context, parts, child) {
            if (parts.isEmpty) return const SizedBox.shrink();
            // parts = parts.sublist(0, 3);
            // parts.add(PartModel.fromJson(parts.first.toJson()));
            return Container(
              margin: EdgeInsets.only(top: 10.w, bottom: 3.w),
              height: 70.w,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: parts.length,
                itemBuilder: (context, index) {
                  final partsItem = parts[index];
                  return ReportGestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      final linkUrl = partsItem.urlStr;
                      final redirectType = partsItem.redirectType;
                      if (linkUrl.isEmpty) {
                        return;
                      }
                      if (redirectType < 3) {
                        if (partsItem.router == 'asmr' || partsItem.router == 'torrentDownload') {
                          eventBus.fire(MyEvent(partsItem.router));
                          return;
                        } else if (partsItem.router == 'rankList') {
                          const RankRoute().push(context);
                          return;
                        }
                        CommonUtils.openRoute(context, partsItem.toJson());
                      } else {
                        if (partsItem.type == '0') {
                          widget.onLinkNavTap(linkUrl);
                        } else if (partsItem.type == '1') {
                          MoreVideoRoute(name: partsItem.title, id: linkUrl, api: 'mvhjgj/list_construct')
                              .push(context);
                        }
                      }
                    },
                    child: SizedBox(
                      width: ScreenUtil().screenWidth / (parts.length > 5 ? 5.5 : max(3, min(parts.length, 5))),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 45.w,
                            child: MyImage.network(partsItem.icon, fit: BoxFit.contain),
                          ),
                          Center(
                              child: Text(partsItem.title,
                                  style: MyTheme.white13.copyWith(color: Colors.black.withValues(alpha: .7)))),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget girdTopicView(List<NavModel> contentTopics) {
    return SizedBox(
      height: 75.w,
      child: GridView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: contentTopics.length,
          padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 1 / 0.7,
            mainAxisSpacing: 10.w,
            crossAxisSpacing: 10.w,
          ),
          itemBuilder: (context, index) {
            final topic = contentTopics[index];
            return ReportGestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                final linkUrl = topic.linkUrl;
                final redirectType = topic.redirectType;
                if (linkUrl.isEmpty) {
                  return;
                }

                if (redirectType < 3) {
                  CommonUtils.openRoute(context, topic.toJson());
                } else {
                  if (topic.openType == 0) {
                    widget.onLinkNavTap(topic.linkUrl);
                  } else if (topic.openType == 1) {
                    MoreVideoRoute(name: topic.name, id: topic.linkUrl, api: 'mvhjgj/list_construct').push(context);
                  }
                }
              },
              child: Column(
                children: [
                  MyImage.network(topic.resourceUrl, width: 50.w, height: 50.w, borderRadius: 5.w),
                  SizedBox(height: 3.w),
                  Text(topic.name, style: MyTheme.white11),
                ],
              ),
            );
          }),
    );
  }
}
