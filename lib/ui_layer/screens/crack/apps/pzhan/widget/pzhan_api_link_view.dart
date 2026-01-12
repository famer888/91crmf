import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/domain/domain.dart';
import 'package:jycrpj/domain/model/banner_model.dart';
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
import 'package:jycrpj/ui_layer/screens/crack/apps/pzhan/model/pzhan_model.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/pzhan/widget/pzhan_feed_card.dart';
import 'package:jycrpj/ui_layer/screens/image_paths.dart';
import 'package:jycrpj/ui_layer/screens/theme.dart';
import 'package:jycrpj/ui_layer/utils/common_utils.dart';
import 'package:jycrpj/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';

import '../../../../../../report/ui_layer/report_general_banner.dart';
import '../../../../../../report/ui_layer/report_gesture_detector.dart';
import '../../../widgets/grid_list_switch.dart';

class PZhanApiLinkView extends StatefulWidget {
  const PZhanApiLinkView({
    super.key,
    this.showRightList = false,
    required this.linkModel,
    required this.onLinkNavTap,
  });

  final LinkModel linkModel;
  final ValueChanged<String> onLinkNavTap;
  final bool showRightList;

  @override
  State<PZhanApiLinkView> createState() => _PZhanApiLinkViewState();
}

class _PZhanApiLinkViewState extends State<PZhanApiLinkView> {
  late final _appDomain = context.read<AppDomain>();
  late final _homeConfig = context.read<HomeConfigNotifier>();
  final ValueNotifier<List<BannerModel>> bannersNotifier = ValueNotifier([]);
  final ValueNotifier<List<PZhanCategoryTopicModel>> topicsNotifier = ValueNotifier([]);
  final ValueNotifier<List<PartModel>> partNotifier = ValueNotifier([]);
  final ValueNotifier<bool> isListNotifier = ValueNotifier(false);

  bool get _isDiscovery => widget.linkModel.api == '/api/tabnewpzhan/list_discovery';

  List<AppNavModel> get _titles => _isDiscovery ? (_homeConfig.config.pzhanFindSortNav ?? []) : (_homeConfig.config.pzhanSortNav ?? []);

  // 当前tab选中的位置
  int initialIndex = 0;
  bool isInit = false;
  bool initSetIndex = false;

  Future<List<PZhanVideoModel>?> _getData({
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
      if (result.data['banner'] case final List data when data.isNotEmpty) {
        bannersNotifier.value = data.map((e) => BannerModel.fromJson(e)).toList();
      }

      if (result.data['mid_style_category'] case final List data when data.isNotEmpty) {
        topicsNotifier.value = data.map<PZhanCategoryTopicModel>((e) => PZhanCategoryTopicModel.fromJson(e)).toList();
      }

      if (result.data['list'] case final List data when data.isNotEmpty) {
        return data.map<PZhanVideoModel>((e) => PZhanVideoModel.fromJson(e)).toList();
      }
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
    if (!initSetIndex) {
      if (_isDiscovery) {
        final index = (_homeConfig.config.pzhanFindSortNav ?? []).indexWhere((item) => item.type == 'hot');
        if (index == -1) {
          // 不存在 hot
          initialIndex = 0;
        } else {
          initialIndex = index;
        }
      } else {
        final index = (_homeConfig.config.pzhanSortNav ?? []).indexWhere((item) => item.type == 'new');
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
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
        labelStyle: TextStyle(color: MyTheme.pzhanAppPrimaryColor, fontSize: 16.sp, fontWeight: FontWeight.w500),
        unselectedLabelStyle: TextStyle(color: const Color.fromRGBO(255, 255, 255, 0.8), fontSize: 16.sp, fontWeight: FontWeight.w400),
        titles: isInit ? _titles.map<String>((e) => e.title).toList() : [],
        tabBarRightWidget: widget.showRightList
            ? GridListSwitch(
                color: MyTheme.pzhanAppPrimaryColor,
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
                      ? MyListView.list(
                          itemBuilder: (context, item, index) => PZhanFeedCard(isList: true, feed: item),
                          onFetchingMore: (currentPage, pageSize) => _getData(page: currentPage, pageSize: pageSize, type: nav.type),
                        )
                      : MyListView.grid(
                          padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding, vertical: 8.w),
                          childAspectRatio: MyTheme.aspectRatio,
                          crossAxisSpacing: 8.w,
                          mainAxisSpacing: 10.w,
                          itemBuilder: (context, item, index) => PZhanFeedCard(isList: false, feed: item),
                          onFetchingMore: (currentPage, pageSize) => _getData(page: currentPage, pageSize: pageSize, type: nav.type),
                        );
                }),
        ],
      ),
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
  final ValueNotifier<List<PZhanCategoryTopicModel>> topicsNotifier;
  final ValueNotifier<List<PartModel>> partNotifier;
  final ValueChanged<String> onLinkNavTap;

  @override
  State<_Header> createState() => _HeaderState();
}

class _HeaderState extends State<_Header> {
  late final _screenUtil = ScreenUtil();
  List<PZhanCategoryTopicModel> contentTopics = [];
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
                          MoreVideoRoute(name: partsItem.title, id: linkUrl, api: 'mvpzhan/list_construct').push(context);
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
                                MoreVideoRoute(name: topic.tabName, id: topic.tabId.toString(), api: 'tabnewpzhan/list_tab_mv').push(context);
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
