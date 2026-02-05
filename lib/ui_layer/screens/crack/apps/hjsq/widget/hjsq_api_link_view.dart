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
import 'package:jycrpj/ui_layer/screens/crack/apps/hjsq/widget/hjsq_feed_card.dart';
import 'package:jycrpj/ui_layer/screens/crack/widgets/scroll_top_button.dart';
import 'package:jycrpj/ui_layer/screens/image_paths.dart';
import 'package:jycrpj/ui_layer/screens/theme.dart';
import 'package:jycrpj/ui_layer/utils/common_utils.dart';
import 'package:jycrpj/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';

import '../../../../../../report/ui_layer/report_general_banner.dart';
import '../../../../../../report/ui_layer/report_gesture_detector.dart';
import '../../../widgets/grid_list_switch.dart';

class HjsqApiLinkView extends StatefulWidget {
  const HjsqApiLinkView({
    super.key,
    this.showRightList = false,
    required this.linkModel,
    required this.onLinkNavTap,
  });

  final LinkModel linkModel;
  final ValueChanged<String> onLinkNavTap;
  final bool showRightList;

  @override
  State<HjsqApiLinkView> createState() => _HjsqApiLinkViewState();
}

class _HjsqApiLinkViewState extends State<HjsqApiLinkView> {
  late final _appDomain = context.read<AppDomain>();
  late final _homeConfig = context.read<HomeConfigNotifier>();
  final ValueNotifier<List<BannerModel>> bannersNotifier = ValueNotifier([]);
  final ValueNotifier<List<NavModel>> topicsNotifier = ValueNotifier([]);
  final ValueNotifier<List<PartModel>> partNotifier = ValueNotifier([]);
  final ValueNotifier<bool> isListNotifier = ValueNotifier(false);

  List<AppNavModel> get _titles => _homeConfig.config.hjsqSortNav ?? [];

  // 当前tab选中的位置
  int initialIndex = 0;
  bool isInit = false;
  bool initSetIndex = false;

  final ScrollController _nestedController = ScrollController();
  final ValueNotifier<bool> _showToTopBtn = ValueNotifier(false);
  double _showThreshold = 0; // 一屏高度

  Future<List<FeedModel>?> _getData({
    required int page,
    required int pageSize,
    required String type,
  }) async {
    final param = Map.from(widget.linkModel.params)
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
        final banner = data.map((x) => BannerModel.fromJson(x)).toList();
        bannersNotifier.value = banner;
      }
      if (result.data['nav'] case final List data when data.isNotEmpty && topicsNotifier.value.isEmpty) {
        final nav = data.map((x) => NavModel.fromJson(x)).toList();
        topicsNotifier.value = nav;
      }
      final list = result.data['list']?.map<FeedModel>((x) => FeedModel.fromJson(x)).toList();
      return list;
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
      final index = (_homeConfig.config.hjsqSortNav ?? []).indexWhere((item) => item.type == 'new');
      if (index == -1) {
        // 不存在 new
        initialIndex = 0;
      } else {
        initialIndex = index;
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
              labelStyle: TextStyle(color: MyTheme.hjsqAppPrimaryColor, fontSize: 16.sp, fontWeight: FontWeight.w500),
              unselectedLabelStyle: TextStyle(color: const Color.fromRGBO(255, 255, 255, 0.8), fontSize: 16.sp, fontWeight: FontWeight.w400),
              titles: isInit ? _titles.map<String>((e) => e.title).toList() : [],
              tabBarRightWidget: widget.showRightList
                  ? GridListSwitch(
                      color: MyTheme.hjsqAppPrimaryColor,
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
                                      CommonUtils.log('标签页滚动: header=$headerPixels, tab=$tabPixels, total=$totalPixels');
                                      _showToTopBtn.value = shouldShow;
                                    }
                                  }
                                  return false;
                                },
                                child: MyListView.list(
                                  scrollController: PrimaryScrollController.of(context),
                                  itemBuilder: (context, item, index) => HjsqFeedCard(isList: true, feed: item),
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
                                      CommonUtils.log('网格页滚动: header=$headerPixels, tab=$tabPixels, total=$totalPixels');
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
                                  itemBuilder: (context, item, index) => HjsqFeedCard(isList: false, feed: item),
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
        SizedBox(height: 10.w),
        ValueListenableBuilder(
          valueListenable: widget.partNotifier,
          builder: (context, parts, child) {
            if (parts.isEmpty) return const SizedBox.shrink();
            // parts = parts.sublist(0, 3);
            // parts.add(PartModel.fromJson(parts.first.toJson()));
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
                          MoreVideoRoute(name: partsItem.title, id: linkUrl, api: 'mvhjgj/list_construct').push(context);
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
                          Center(child: Text(partsItem.title, style: MyTheme.white13)),
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

            bool isGirlTopic = topics.first.resourceUrl.isNotEmpty; //如果配置了图片则横行展示上图下文布局

            if (isGirlTopic) {
              contentTopics = topics;
            } else {
              if (topics.length > 8 && !isShowAllTopics) {
                contentTopics = topics.sublist(0, 8);
              } else {
                contentTopics = topics;
              }
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isGirlTopic
                    ? girdTopicView(contentTopics)
                    : Padding(
                  padding: EdgeInsets.only(bottom: 5.w),
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2.w),
                            ),
                            color: const Color(0xff262631),
                          ),
                          child: Center(
                            child: ReportGestureDetector(
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
                              child: Text(topic.name, style: MyTheme.white13),
                            ),
                          ),
                        );
                      }),
                ),
                isGirlTopic ? Container() : SizedBox(height: 5.w),
                isGirlTopic
                    ? Container()
                    : Offstage(
                  offstage: widget.topicsNotifier.value.length <= 8 || isShowAllTopics,
                  child: InkWell(
                    onTap: () {
                      isShowAllTopics = true;
                      if (mounted) {
                        setState(() {});
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10.w),
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
