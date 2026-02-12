import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jycrpj/domain/api_validator.dart';
import 'package:jycrpj/domain/async_value.dart';
import 'package:jycrpj/domain/model/home_data_model.dart';
import 'package:jycrpj/domain/remote_domain/domains/dynamic.dart';
import 'package:jycrpj/domain/type_def.dart';
import 'package:jycrpj/report/ui_layer/report_gesture_detector.dart';
import 'package:jycrpj/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/status/loading.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/status/network_error.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/pzhan/widget/pzhan_feed_card.dart';
import 'package:jycrpj/ui_layer/screens/crack/model/app_model.dart';
import 'package:jycrpj/ui_layer/screens/crack/model/tab_info_model.dart';
import 'package:jycrpj/ui_layer/screens/crack/widgets/grid_list_switch.dart';
import 'package:jycrpj/ui_layer/screens/crack/widgets/scroll_top_button.dart';
import 'package:jycrpj/ui_layer/screens/image_paths.dart';
import 'package:jycrpj/ui_layer/screens/theme.dart';
import 'package:jycrpj/ui_layer/utils/common_utils.dart';
import 'package:provider/provider.dart';

class PZhanTopicScreen extends StatefulWidget {
  const PZhanTopicScreen({
    super.key,
    required this.name,
    required this.id,
    required this.api,
  });

  final String name;
  final String id;
  final String api;

  @override
  State<PZhanTopicScreen> createState() => _PZhanTopicScreenState();
}

class _PZhanTopicScreenState extends State<PZhanTopicScreen> with SingleTickerProviderStateMixin {
  late final _homeConfig = context.read<HomeConfigNotifier>();
  late final dynamicDomain = context.read<DynamicDomain>();
  AsyncValue<TabInfoModel> _asyncValue = const AsyncInit();
  final ValueNotifier<bool> isListNotifier = ValueNotifier(false);
  late final TabController _tabController;

  List<AppNavModel> get _titles => _homeConfig.config.pzhanSortNav ?? [];

  // 当前tab选中的位置
  int initialIndex = 0;
  String _initSort = '';
  bool isInit = false;
  bool initSetIndex = false;

  final ScrollController _nestedController = ScrollController();
  final ValueNotifier<bool> _showToTopBtn = ValueNotifier(false);
  double _showThreshold = 0; // 一屏高度

  Future<void> _getTabDetail() async {
    if (_asyncValue.isLoading) return;

    setState(() {
      _asyncValue = const AsyncLoading();
    });

    final result = await dynamicDomain.getConstructByApiLink(apiLink: 'tabnewpzhan/tab_detail', params: {'tab_id': widget.id});
    if (result.isValid) {
      if (result.data['tab_info'] != null) {
        final map = result.data['tab_info'];
        final tabInfoModel = TabInfoModel.fromJson(map);
        _asyncValue = AsyncData(tabInfoModel);
      }
    } else {
      _asyncValue = const AsyncError();
    }

    if (context.mounted) {
      if (!isInit) {
        setState(() {
          _tabController = TabController(length: _titles.length, vsync: this);
          isInit = true;
        });
      }
    }
  }

  Future<List<AppVideoModel>> _getMvList({
    int page = 1,
    int pageSize = 16,
    String sort = '',
  }) async {
    final result = await dynamicDomain.getConstructByApiLink(apiLink: widget.api, params: {
      'page': page,
      'limit': pageSize,
      'tab_id': widget.id,
      'sort': sort.isEmpty ? _initSort : sort,
    });
    if (result.isValid) {
      if (result.data['list'] case final List data when data.isNotEmpty) {
        final feedModelList = data.map<AppVideoModel>((x) => AppVideoModel.fromJson(x)).toList();
        return feedModelList;
      }
      return [];
    } else {
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    isListNotifier.value = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showThreshold = ScreenUtil().screenHeight * 0.40;
    });
    if (!initSetIndex) {
      final index = (_homeConfig.config.pzhanSortNav ?? []).indexWhere((item) => item.type == 'new');
      if (index == -1) {
        // 不存在 new
        _initSort = _homeConfig.config.pzhanSortNav?.first.type ?? '';
        initialIndex = 0;
      } else {
        _initSort = _homeConfig.config.pzhanSortNav?[index].type ?? '';
        initialIndex = index;
      }
      initSetIndex = true;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    isListNotifier.dispose();
    _nestedController.dispose();
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
    return _asyncValue.maybeWhen(
      init: () {
        _getTabDetail();
        return const LoadingView();
      },
      data: (data) {
        return Material(
          child: Stack(
            children: [
              NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification notification) {
                  return false;
                },
                child: NestedScrollView(
                  controller: _nestedController,
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        pinned: true,
                        elevation: 0,
                        leadingWidth: 34.w,
                        expandedHeight: 190.w,
                        backgroundColor: Colors.black,
                        leading: _FadeLeading(),
                        title: _FadeTitle(title: data.tabName),
                        centerTitle: false,
                        flexibleSpace: FlexibleSpaceBar(
                          collapseMode: CollapseMode.parallax,
                          background: _Header(tabInfo: data),
                        ),
                        // TabBar 吸顶
                        bottom: PreferredSize(
                          preferredSize: Size(ScreenUtil().screenWidth, 32.w),
                          child: Row(
                            children: [
                              Expanded(
                                child: TabBar(
                                  isScrollable: true,
                                  padding: EdgeInsets.zero,
                                  controller: _tabController,
                                  tabAlignment: TabAlignment.start,
                                  indicator: UnderlineTabIndicator(
                                    borderRadius: BorderRadius.circular(3.5.w),
                                    insets: EdgeInsets.symmetric(horizontal: 6.w),
                                    borderSide: BorderSide(width: 4.w, color: MyTheme.pzhanAppPrimaryColor),
                                  ),
                                  indicatorSize: TabBarIndicatorSize.label,
                                  labelStyle: MyTheme.white255_13_M.s16.copyWith(color: MyTheme.pzhanAppPrimaryColor),
                                  unselectedLabelStyle: MyTheme.white255_13_M.s16.w500,
                                  tabs: _titles
                                      .map<Widget>(
                                        (e) => Tab(
                                          height: 32.w,
                                          child: Padding(padding: EdgeInsets.zero, child: Text(e.title)),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
                                child: GridListSwitch(
                                  color: MyTheme.pzhanAppPrimaryColor,
                                  callback: (isList) {
                                    isListNotifier.value = isList;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ];
                  },
                  body: TabBarView(
                    controller: _tabController,
                    children: _titles.map<Widget>((e) {
                      return Center(
                        child: ValueListenableBuilder(
                            valueListenable: isListNotifier,
                            builder: (context, isList, child) {
                              return isList
                                  ? NotificationListener<ScrollNotification>(
                                      onNotification: (ScrollNotification notification) {
                                        if (notification is ScrollUpdateNotification) {
                                          final double tabPixels = notification.metrics.pixels;
                                          final double headerPixels = _nestedController.hasClients ? _nestedController.offset : 0;
                                          final double totalPixels = headerPixels + tabPixels;
                                          final bool shouldShow = totalPixels > _showThreshold;
                                          if (shouldShow != _showToTopBtn.value) {
                                            _showToTopBtn.value = shouldShow;
                                          }
                                        }
                                        return false;
                                      },
                                      child: MyListView.list(
                                        scrollController: PrimaryScrollController.of(context),
                                        itemBuilder: (context, item, index) => PZhanFeedCard(isList: true, feed: item),
                                        onFetchingMore: (currentPage, pageSize) => _getMvList(
                                          page: currentPage,
                                          pageSize: pageSize,
                                          sort: e.type,
                                        ),
                                      ),
                                    )
                                  : NotificationListener<ScrollNotification>(
                                      onNotification: (ScrollNotification notification) {
                                        if (notification is ScrollUpdateNotification) {
                                          final double tabPixels = notification.metrics.pixels;
                                          final double headerPixels = _nestedController.hasClients ? _nestedController.offset : 0;
                                          final double totalPixels = headerPixels + tabPixels;
                                          final bool shouldShow = totalPixels > _showThreshold;
                                          if (shouldShow != _showToTopBtn.value) {
                                            _showToTopBtn.value = shouldShow;
                                          }
                                        }
                                        return false;
                                      },
                                      child: MyListView.grid(
                                        scrollController: PrimaryScrollController.of(context),
                                        padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding, vertical: 8.w),
                                        childAspectRatio: MyTheme.aspectRatio,
                                        crossAxisSpacing: 8.w,
                                        mainAxisSpacing: 10.w,
                                        itemBuilder: (context, item, index) => PZhanFeedCard(isList: false, feed: item),
                                        onFetchingMore: (currentPage, pageSize) => _getMvList(
                                          page: currentPage,
                                          pageSize: pageSize,
                                          sort: e.type,
                                        ),
                                      ),
                                    );
                            }),
                      );
                    }).toList(),
                  ),
                ),
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
          ),
        );
      },
      error: (_, __) => NetworkErrorView(onTap: _getTabDetail),
      orElse: () => const LoadingView(),
    );
  }
}

class _Header extends StatefulWidget {
  final TabInfoModel tabInfo;

  const _Header({required this.tabInfo});

  @override
  State<_Header> createState() => _HeaderState();
}

class _HeaderState extends State<_Header> {
  late final dynamicDomain = context.read<DynamicDomain>();

  bool isFollowed = false;

  @override
  void initState() {
    super.initState();
    isFollowed = widget.tabInfo.isFollow;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 196.w,
      width: ScreenUtil().screenWidth,
      child: Stack(
        children: [
          MyImage.network(
            widget.tabInfo.bgThumb,
            height: 196.w,
            width: ScreenUtil().screenWidth,
            fit: BoxFit.cover,
            backgroundColor: MyTheme.imageBgColor,
            borderRadius: 0.w,
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 90.w,
              width: ScreenUtil().screenWidth,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(1.0),
                  ],
                ),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ReportGestureDetector(
                onTap: () {
                  if (context.canPop()) {
                    context.pop();
                  }
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 32.w, left: 13.w),
                  child: MyImage.asset(
                    MyImagePaths.appBackIcon,
                    width: 24.w,
                    height: 24.w,
                    color: const Color.fromRGBO(255, 255, 255, 1),
                  ),
                ),
              ),
              SizedBox(height: 12.w),
              Row(
                children: [
                  SizedBox(width: MyTheme.pagePadding),
                  Text(widget.tabInfo.tabName, style: MyTheme.white255_16_M.w600),
                  SizedBox(width: MyTheme.pagePadding),
                ],
              ),
              SizedBox(height: 10.w),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(width: MyTheme.pagePadding),
                  Text('${'zps'.tr(context: context)} ${CommonUtils.renderEnFixedNumber(widget.tabInfo.workNum)}',
                      style: MyTheme.white13medium.s14),
                  SizedBox(width: 28.w),
                  Text('${'sc'.tr(context: context)} ${CommonUtils.renderEnFixedNumber(widget.tabInfo.favoritesNum)}',
                      style: MyTheme.white13medium.s14),
                  const Spacer(),
                  // SizedBox(width: 10.w),
                  // ReportGestureDetector(
                  //   onTap: () async {
                  //     final result = await dynamicDomain.getConstructByApiLink(
                  //       apiLink: 'tabnewpzhan/follow_tab',
                  //       params: {'tab_id': widget.tabInfo.tabId},
                  //     );
                  //     if (result.isValid) {
                  //       widget.tabInfo.isFollow = true;
                  //       setState(() {
                  //         isFollowed = !isFollowed;
                  //       });
                  //     }
                  //   },
                  //   behavior: HitTestBehavior.translucent,
                  //   child: Container(
                  //     height: 28.w,
                  //     padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 4.5.w),
                  //     alignment: Alignment.center,
                  //     decoration: BoxDecoration(
                  //       color: isFollowed ? MyTheme.pzhanAppSearchBarBackgroundColor : MyTheme.pzhanAppPrimaryColor,
                  //       borderRadius: BorderRadius.circular(16.w),
                  //       // border: Border.all(
                  //       //   color: isFollowed ? MyTheme.pzhanAppPrimaryColor : MyTheme.pzhanAppSearchBarBackgroundColor,
                  //       //   width: 1.5.w,
                  //       // ),
                  //     ),
                  //     child: Text(
                  //       isFollowed ? 'ygz'.tr(context: context) : 'jgz'.tr(context: context),
                  //       style: isFollowed
                  //           ? MyTheme.blue80_12.copyWith(color: MyTheme.whiteColor, fontWeight: FontWeight.w600)
                  //           : MyTheme.white12.copyWith(fontWeight: FontWeight.w600, color: MyTheme.blackColor),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(width: MyTheme.pagePadding),
                ],
              ),
              SizedBox(height: 10.w),
              Row(
                children: [
                  SizedBox(width: MyTheme.pagePadding),
                  Text(widget.tabInfo.subTitle, style: MyTheme.white255_14_M.w500),
                  SizedBox(width: MyTheme.pagePadding),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FadeLeading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settings = context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
    if (settings == null) return const SizedBox();

    final double delta = settings.maxExtent - settings.minExtent;
    final double t = (1.0 - (settings.currentExtent - settings.minExtent) / delta).clamp(0.0, 1.0);

    return Opacity(
      opacity: t,
      child: Center(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.of(context).maybePop();
          },
          child: Container(
            width: 24.w,
            height: 24.w,
            margin: EdgeInsets.only(left: 13.w),
            child: MyImage.asset(
              MyImagePaths.appBackIcon,
              width: 24.w,
              height: 24.w,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _FadeTitle extends StatelessWidget {
  final String title;

  const _FadeTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final settings = context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
    if (settings == null) return const SizedBox();
    final double delta = settings.maxExtent - settings.minExtent;
    final double t = (1.0 - (settings.currentExtent - settings.minExtent) / delta).clamp(0.0, 1.0);
    return Opacity(
      opacity: t,
      child: Text(title, style: MyTheme.white255_16_M.w600.s17),
    );
  }
}
