import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/domain/domain.dart';
import 'package:jycrpj/domain/model/banner_model.dart';
import 'package:jycrpj/domain/model/category_topic_model.dart';
import 'package:jycrpj/domain/model/home_data_model.dart';
import 'package:jycrpj/domain/model/link_model.dart';
import 'package:jycrpj/domain/model/part_nav_model.dart';
import 'package:jycrpj/domain/type_def.dart';
import 'package:jycrpj/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jycrpj/ui_layer/router/routes.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/event_bus/event_bus.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_tab_bar.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/51tiktok/widget/tiktok51_feed_card.dart';
import 'package:jycrpj/ui_layer/screens/crack/model/app_model.dart';
import 'package:jycrpj/ui_layer/screens/crack/widgets/scroll_top_button.dart';
import 'package:jycrpj/ui_layer/screens/image_paths.dart';
import 'package:jycrpj/ui_layer/screens/theme.dart';
import 'package:jycrpj/ui_layer/utils/common_utils.dart';
import 'package:jycrpj/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';

import '../../../../../../report/ui_layer/report_general_banner.dart';
import '../../../../../../report/ui_layer/report_gesture_detector.dart';
import '../../../widgets/grid_list_switch.dart';

class Tiktok51ApiLinkView extends StatefulWidget {
  const Tiktok51ApiLinkView({
    super.key,
    this.showRightList = false,
    required this.linkModel,
    required this.onLinkNavTap,
  });

  final LinkModel linkModel;
  final ValueChanged<String> onLinkNavTap;
  final bool showRightList;

  @override
  State<Tiktok51ApiLinkView> createState() => _Tiktok51ApiLinkViewState();
}

class _Tiktok51ApiLinkViewState extends State<Tiktok51ApiLinkView> {
  late final _appDomain = context.read<AppDomain>();
  late final _homeConfig = context.read<HomeConfigNotifier>();
  final ValueNotifier<List<BannerModel>> bannersNotifier = ValueNotifier([]);
  final ValueNotifier<List<CategoryTopicModel>> topicsNotifier = ValueNotifier([]);
  final ValueNotifier<List<PartModel>> partNotifier = ValueNotifier([]);
  final ValueNotifier<bool> isListNotifier = ValueNotifier(false);

  bool get _isDiscovery => widget.linkModel.api == '/api/tabnew51tikok/list_discovery';

  List<AppNavModel> get _titles => _isDiscovery ? (_homeConfig.config.tikok51FindSortNav ?? []) : (_homeConfig.config.tikok51SortNav ?? []);

  // 当前tab选中的位置
  int initialIndex = 0;
  bool isInit = false;
  bool initSetIndex = false;

  final ScrollController _nestedController = ScrollController();
  final ValueNotifier<bool> _showToTopBtn = ValueNotifier(false);
  double _showThreshold = 0; // 一屏高度

  Future<List<AppVideoModel>?> _getData({
    required int page,
    required int pageSize,
    required String type,
  }) async {
    final param = Map.from(widget.linkModel.params)
      ..['nag_id'] = widget.linkModel.id
      ..['page'] = page
      ..['limit'] = pageSize
      ..['sort'] = type;

    final result = await _appDomain.getConstructByApiLink(
      apiLink: widget.linkModel.api,
      params: param,
    );

    if (!isInit) {
      setState(() {
        isInit = true;
      });
    }

    if (result.status == 1) {
      if (result.data['banner'] case final List data when data.isNotEmpty && bannersNotifier.value.isEmpty) {
        bannersNotifier.value = data.map((e) => BannerModel.fromJson(e)).toList();
      }

      if (result.data['mid_style_category'] case final List data when data.isNotEmpty && topicsNotifier.value.isEmpty) {
        topicsNotifier.value = data.map<CategoryTopicModel>((e) => CategoryTopicModel.fromJson(e)).toList();
      }

      if (result.data['list'] case final List data when data.isNotEmpty) {
        return data.map<AppVideoModel>((e) => AppVideoModel.fromJson(e)).toList();
      }

      return [];
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
    return null;
  }

  @override
  void initState() {
    isListNotifier.value = false;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showThreshold = ScreenUtil().screenHeight * 0.40;
    });
    if (!initSetIndex) {
      if (_isDiscovery) {
        final index = (_homeConfig.config.tikok51FindSortNav ?? []).indexWhere((item) => item.type == 'hot');
        if (index == -1) {
          // 不存在 hot
          initialIndex = 0;
        } else {
          initialIndex = index;
        }
      } else {
        final index = (_homeConfig.config.tikok51SortNav ?? []).indexWhere((item) => item.type == 'new');
        if (index == -1) {
          // 不存在 new
          initialIndex = 0;
        } else {
          initialIndex = index;
        }
      }
      initSetIndex = true;
    }
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
        NotificationListener<ScrollNotification>(
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
                  linkModel: widget.linkModel,
                ),
              ),
            ],
            body: TabBarWithView.fillColor(
              initialIndex: initialIndex,
              tabBarHeight: 32.w,
              labelPadding: 5.w,
              tabInterMargin: 6.w,
              isScrollable: true,
              linearColors: const [Colors.transparent, Colors.transparent],
              tabBarPadding: EdgeInsets.symmetric(vertical: 6.w, horizontal: MyTheme.pagePadding),
              labelStyle: TextStyle(color: MyTheme.tiktok51AppPrimaryColor, fontSize: 16.sp, fontWeight: FontWeight.w600),
              unselectedLabelStyle: TextStyle(color: const Color.fromRGBO(255, 255, 255, 1), fontSize: 16.sp, fontWeight: FontWeight.w500),
              titles: isInit ? _titles.map<String>((e) => e.title).toList() : [],
              tabBarRightWidget: widget.showRightList
                  ? GridListSwitch(
                      color: MyTheme.tiktok51AppPrimaryColor,
                      callback: (isList) {
                        isListNotifier.value = isList;
                      })
                  : null,
              views: [
                for (final AppNavModel nav in _titles)
                  ValueListenableBuilder(
                      valueListenable: isListNotifier,
                      builder: (context, isList, child) {
                        return isList
                            ? NotificationListener<ScrollNotification>(
                                // 添加在这里
                                onNotification: (ScrollNotification notification) {
                                  if (notification is ScrollUpdateNotification) {
                                    // 获取当前标签页的滚动位置
                                    final double tabPixels = notification.metrics.pixels;
                                    // 获取 NestedScrollView header 的滚动位置
                                    final double headerPixels = _nestedController.hasClients ? _nestedController.offset : 0;
                                    // 计算总滚动量
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
                                  itemBuilder: (context, item, index) => Tiktok51FeedCard(isList: true, feed: item),
                                  onFetchingMore: (currentPage, pageSize) => _getData(page: currentPage, pageSize: pageSize, type: nav.type),
                                ),
                              )
                            : NotificationListener<ScrollNotification>(
                                // 同样的调试代码也添加在这里
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
                                  itemBuilder: (context, item, index) => Tiktok51FeedCard(isList: false, feed: item),
                                  onFetchingMore: (currentPage, pageSize) => _getData(page: currentPage, pageSize: pageSize, type: nav.type),
                                ),
                              );
                      }),
              ],
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
    );
  }
}

class _Header extends StatefulWidget {
  const _Header({
    required this.bannersNotifier,
    required this.topicsNotifier,
    required this.partNotifier,
    required this.onLinkNavTap,
    required this.linkModel,
  });

  final ValueNotifier<List<BannerModel>> bannersNotifier;
  final ValueNotifier<List<CategoryTopicModel>> topicsNotifier;
  final ValueNotifier<List<PartModel>> partNotifier;
  final ValueChanged<String> onLinkNavTap;
  final LinkModel linkModel;

  @override
  State<_Header> createState() => _HeaderState();
}

class _HeaderState extends State<_Header> {
  late final _screenUtil = ScreenUtil();
  List<CategoryTopicModel> contentTopics = [];
  bool isShowAllTopics = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 6.w),
        ValueListenableBuilder(
          valueListenable: widget.bannersNotifier,
          builder: (context, banners, child) {
            if (banners.isEmpty) return const SizedBox.shrink();

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
              child: ReportGeneralAppsListVidget(data: banners),
            );
          },
        ),
        ValueListenableBuilder(
          valueListenable: widget.partNotifier,
          builder: (context, parts, child) {
            if (parts.isEmpty) return const SizedBox.shrink();
            return Container(
              margin: EdgeInsets.only(top: 10.w, bottom: 5.w),
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
                          MoreVideoRoute(name: partsItem.title, id: linkUrl, api: 'tabnew51tikok/list_tab_mv').push(context);
                        }
                      }
                    },
                    child: SizedBox(
                      width: _screenUtil.screenWidth / (parts.length > 5 ? 5.5 : max(3, min(parts.length, 5))),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 45.w,
                            child: MyImage.network(partsItem.icon, fit: BoxFit.contain),
                          ),
                          Center(
                            child: Text(partsItem.title, style: MyTheme.white13),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
        SizedBox(height: 10.w),
        ValueListenableBuilder(
          valueListenable: widget.topicsNotifier,
          builder: (context, topics, child) {
            if (topics.isEmpty) return const SizedBox.shrink();

            if (topics.length > 8 && !isShowAllTopics) {
              contentTopics = topics.sublist(0, 8);
            } else {
              contentTopics = topics;
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 3.w),
                  child: GridView.builder(
                      shrinkWrap: true,
                      addRepaintBoundaries: false,
                      addAutomaticKeepAlives: false,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: contentTopics.length,
                      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 80.w / 35.w,
                        mainAxisSpacing: 10.w,
                        crossAxisSpacing: 10.w,
                      ),
                      itemBuilder: (context, index) {
                        final topic = topics[index];
                        return DecoratedBox(
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.w)),
                            color: MyTheme.blackColor32,
                          ),
                          child: Center(
                            child: ReportGestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                if (topic.id == -1) {
                                  // 特有
                                  final id = widget.linkModel.id;
                                  Tiktok51MoreRoute(
                                    name: topic.tabName,
                                    id: '$id',
                                    api: 'tabnew51tikok/tab_list',
                                  ).push(context);
                                } else {
                                  // tiktok 特有的页面
                                  Tiktok51TopicRoute(
                                    name: topic.tabName,
                                    id: topic.tabId.toString(),
                                    api: 'tabnew51tikok/list_tab_mv',
                                  ).push(context);
                                }
                                // MoreVideoRoute(name: topic.tabName, id: topic.tabId.toString(), api: 'tabnew51tikok/list_tab_mv').push(context);
                              },
                              child: Text(topic.tabName, style: MyTheme.white13),
                            ),
                          ),
                        );
                      }),
                ),
                SizedBox(height: 5.w),
                Offstage(
                  offstage: topics.length <= 8 || isShowAllTopics,
                  child: InkWell(
                    onTap: () {
                      isShowAllTopics = true;
                      if (mounted) {
                        setState(() {});
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 6.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('zkckgd'.tr(context: context), style: MyTheme.white08_12),
                          SizedBox(width: 3.w),
                          MyImage.asset(MyImagePaths.appDownGray, width: 10.w, height: 10.w)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
