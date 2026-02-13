import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jycrpj/domain/model/banner_model.dart';
import 'package:jycrpj/domain/model/category_topic_model.dart';
import 'package:jycrpj/domain/model/crack_model.dart';
import 'package:jycrpj/domain/model/home_data_model.dart';
import 'package:jycrpj/domain/model/link_model.dart';
import 'package:jycrpj/domain/remote_domain/domains/dynamic.dart';
import 'package:jycrpj/domain/remote_domain/domains/user.dart';
import 'package:jycrpj/domain/type_def.dart';
import 'package:jycrpj/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jycrpj/ui_layer/notifiers/user_notifier.dart';
import 'package:jycrpj/ui_layer/router/routes.dart';
import 'package:jycrpj/ui_layer/screens/black/vip_pay_dialog.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/pzhan/widget/pzhan_banner_topics_view.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/pzhan/widget/pzhan_sub_list_page.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/pzhan/widget/pzhan_subpage_tab_bar.dart';
import 'package:jycrpj/ui_layer/screens/crack/crack_app_type.dart';
import 'package:jycrpj/ui_layer/screens/crack/model/app_model.dart';
import 'package:jycrpj/ui_layer/screens/crack/unlock_status_notifier.dart';
import 'package:jycrpj/ui_layer/screens/crack/widgets/app_tab_bar.dart';
import 'package:jycrpj/ui_layer/screens/crack/widgets/sticky_header_delegate.dart';
import 'package:jycrpj/ui_layer/screens/crack/widgets/sticky_search_tab_bar.dart';
import 'package:jycrpj/ui_layer/screens/theme.dart';
import 'package:jycrpj/ui_layer/utils/common_utils.dart';
import 'package:jycrpj/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../../../report/ui_layer/report_gesture_detector.dart';

class PZhanHomeScreen extends StatefulWidget {
  final CrackAppType appType;
  final CrackApp crackApp;
  final VoidCallback? openEndDrawer;

  const PZhanHomeScreen({
    super.key,
    required this.appType,
    required this.crackApp,
    this.openEndDrawer,
  });

  @override
  State<PZhanHomeScreen> createState() => _PZhanHomeScreenState();
}

class _PZhanHomeScreenState extends State<PZhanHomeScreen> {
  late final _appDomain = context.read<DynamicDomain>();
  late final _userDomain = context.read<UserDomain>();
  late final _userNotifier = context.read<UserNotifier>();
  late final _homeConfig = context.read<HomeConfigNotifier>();
  final RefreshController _refreshController = RefreshController();

  /// 搜索tabBar 数据
  final ValueNotifier<List<CustomTabItem>> _topTabBarDataNotifier = ValueNotifier([]);

  /// 列表布局还是网格布局
  final ValueNotifier<bool> _isListNotifier = ValueNotifier(false);

  /// second tab bar的选中位置
  final ValueNotifier<int> _subPageBarIndexNotifier = ValueNotifier<int>(0);

  /// 列表Tab选中位置
  final ValueNotifier<int> _listBarIndexNotifier = ValueNotifier<int>(0);

  /// 一级tab的数据
  List<LinkModel> _linkModelList = [];

  /// 列表数据
  final ValueNotifier<List<AppVideoModel>> _dataListNotifier = ValueNotifier([]);

  /// 轮播数据
  final ValueNotifier<List<BannerModel>> _bannersNotifier = ValueNotifier([]);

  /// 话题数据
  final ValueNotifier<List<CategoryTopicModel>> _topicsNotifier = ValueNotifier([]);

  AppNavModel? _selectedAppNavModel;
  LinkModel? _currentLinkModel;

  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;
  final int _pageSize = 15;
  String _currentType = '';

  /// 获取一级TabBar的数据
  Future<void> _initSearchTabBarData() async {
    String apiLink = widget.appType.topNavApi;
    if (apiLink.isEmpty) return;
    // 获取一级tab数据
    final result = await _appDomain.getConstructByApiLink(apiLink: apiLink, params: {'id': 1});
    CommonUtils.log('请求SearchTabBar的结果:$result');
    try {
      if (result.status == 1) {
        final data = result['data'];
        await _resolveNavData(data);
      } else {
        CommonUtils.log('请求SearchTabBar出错: ${result.msg}');
      }
    } catch (e) {
      CommonUtils.log(e);
    }
  }

  Future<void> _resolveNavData(data) async {
    if (data case final List data when data.isNotEmpty) {
      final linkModelList = data.map((x) => LinkModel.fromJson(x)).toList();
      _linkModelList = linkModelList;

      _topTabBarDataNotifier.value = linkModelList
          .map((e) => CustomTabItem(
                title: e.name,
                activeTextSize: 18.sp,
                inactiveTextSize: 16.sp,
                activeTextColor: MyTheme.pzhanAppPrimaryColor,
                inactiveTextColor: MyTheme.whiteColor,
                indicatorGradient: const LinearGradient(colors: [MyTheme.pzhanAppPrimaryColor, MyTheme.pzhanAppPrimaryColor]),
              ))
          .toList();

      // 初始化选中的tab linkModel
      final initialIndex = _homeConfig.config.navDefault ?? 0;
      _currentLinkModel = _linkModelList[initialIndex];

      /// 加载子页面的数据
      await _initialRefreshSubPageData();
    }
  }

  Future<void> _initialRefreshSubPageData() async {
    // 初始化子页面tab的选中位置
    int initialIndex = 0;
    if (_currentLinkModel == null) {
      initialIndex = 0;
    } else {
      if (_isDiscovery) {
        final index = (_homeConfig.config.pzhanFindSortNav ?? []).indexWhere((item) => item.type == 'hot');
        if (index == -1) {
          // 不存在 rank
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
    }
    List<AppNavModel> appNavList = _isDiscovery ? (_homeConfig.config.pzhanFindSortNav ?? []) : (_homeConfig.config.pzhanSortNav ?? []);
    if (appNavList.isEmpty) return;

    if (initialIndex < 0 || initialIndex >= appNavList.length) {
      initialIndex = 0;
    }

    if (initialIndex >= appNavList.length) return;

    _listBarIndexNotifier.value = initialIndex;
    _selectedAppNavModel = appNavList[initialIndex];
    await _refreshSubPageData();
  }

  Future<void> _loadData({bool refresh = false}) async {
    if (_isLoading) return;
    _isLoading = true;

    try {
      final page = refresh ? 1 : _currentPage;
      final data = await _getData(page: page, pageSize: _pageSize, type: _currentType, refresh: refresh);

      if (data != null) {
        if (refresh) {
          final list = List<AppVideoModel>.of(data);
          CommonUtils.log('刷新的数据 :${list.hashCode}');
          _dataListNotifier.value = list;
          _currentPage = 2;
        } else {
          final list = List<AppVideoModel>.of(_dataListNotifier.value)..addAll(data);
          CommonUtils.log('加载更多的数据 :${list.hashCode}');
          _dataListNotifier.value = list;
          _currentPage++;
        }
        _hasMore = data.length >= _pageSize;
      }
    } finally {
      _isLoading = false;
      refresh
          ? _refreshController.refreshCompleted()
          : _hasMore
              ? _refreshController.loadComplete()
              : _refreshController.loadNoData();
    }
  }

  Future<void> _onRefresh() => _loadData(refresh: true);

  Future<void> _onLoading() => _loadData();

  Future<List<AppVideoModel>?> _getData({
    required int page,
    required int pageSize,
    required String type,
    bool refresh = false,
  }) async {
    if (_currentLinkModel == null) return null;

    final param = Map.from(_currentLinkModel!.params)
      ..['page'] = page
      ..['limit'] = pageSize
      ..['sort'] = type;

    final result = await _appDomain.getConstructByApiLink(
      apiLink: _currentLinkModel!.api,
      params: param,
    );

    if (result.status == 1) {
      if (result.data['banner'] case final List data when data.isNotEmpty && refresh) {
        _bannersNotifier.value = data.map((e) => BannerModel.fromJson(e)).toList();
      }

      if (result.data['mid_style_category'] case final List data when data.isNotEmpty && refresh) {
        _topicsNotifier.value = data.map<CategoryTopicModel>((e) => CategoryTopicModel.fromJson(e)).toList();
      }

      if (result.data['list'] case final List data when data.isNotEmpty) {
        return data.map<AppVideoModel>((e) => AppVideoModel.fromJson(e)).toList();
      }
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
    return null;
  }

  Future<void> _refreshSubPageData() async {
    if (_selectedAppNavModel == null) return;
    _currentType = _selectedAppNavModel!.type;
    // 加载子页面的数据
    await _onRefresh();
  }

  @override
  void initState() {
    _initSearchTabBarData();
    super.initState();
  }

  @override
  void dispose() {
    _topTabBarDataNotifier.dispose();
    _isListNotifier.dispose();
    _subPageBarIndexNotifier.dispose();
    _listBarIndexNotifier.dispose();
    _dataListNotifier.dispose();
    _bannersNotifier.dispose();
    _topicsNotifier.dispose();
    super.dispose();
  }

  bool get _isDiscovery => _currentLinkModel == null ? false : (_currentLinkModel!.api == '/api/tabnewpzhan/list_discovery');

  Widget _buildStickySliver() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: StickyHeaderDelegate(
        height: 120.w,
        child: StickySearchTabBar(
          searchTabBarDataNotifier: _topTabBarDataNotifier,
          searchTabBarIndexNotifier: _subPageBarIndexNotifier,
          searchAppBarType: CrackAppType.pzhan,
          backgroundColor: MyTheme.pzhanAppBgColor,
          searchAppBackgroundColor: MyTheme.pzhanAppSearchBarBackgroundColor,
          openEndDrawer: widget.openEndDrawer,
          isCrackApp: true,
          onTap: () {
            const PZhanVideoSearchRoute(args: '').push(context);
          },
          onChangeTab: (index) async {
            // 切换searchTab，加载新的数据
            _currentLinkModel = _linkModelList[index];
            await _refreshSubPageData();
          },
        ),
      ),
    );
  }

  /// ③ 中间内容（可滑走）
  Widget _buildScrollSliver() {
    return SliverToBoxAdapter(
      child: PZhanBannerTopicsView(
        bannersNotifier: _bannersNotifier,
        topicsNotifier: _topicsNotifier,
        titleColor: MyTheme.whiteColor,
        topicBackgroundColor: const Color.fromRGBO(32, 32, 32, 1),
        zkTextColor: const Color.fromRGBO(51, 51, 51, 1),
        moreVideoApi: 'tabnewpzhan/list_tab_mv',
        onLinkNavTap: (topicTitle) {
          CommonUtils.log('选中的话题 :$topicTitle');
        },
      ),
    );
  }

  /// ④ 第二段吸顶（推荐 / 最新 / 最热）
  Widget _buildSubTabSliver() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: StickyHeaderDelegate(
        height: 48.w,
        child: PZhanSubPageTabBar(
          isListNotifier: _isListNotifier,
          subPageBarIndexNotifier: _listBarIndexNotifier,
          isDiscovery: _isDiscovery,
          onChangeTab: (appNavModel) async {
            _selectedAppNavModel = appNavModel;
            await _refreshSubPageData();
          },
        ),
      ),
    );
  }

  /// ⑤ 第三段内容 列表
  Widget _buildListSliver() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding, vertical: 5.w),
      sliver: PZhanSubListPage(
        isListNotifier: _isListNotifier,
        dataListNotifier: _dataListNotifier,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Selector<UnlockStatusNotifier, bool>(
        selector: (_, notifier) => notifier.isUnlockPzhan,
        builder: (context, isUnlockPzhan, child) {
          return Stack(
            children: [
              SmartRefresher(
                controller: _refreshController,
                enablePullDown: isUnlockPzhan,
                enablePullUp: isUnlockPzhan,
                physics: const ClampingScrollPhysics(),
                onRefresh: () {
                  _onRefresh();
                },
                onLoading: () {
                  _onLoading();
                },
                child: CustomScrollView(
                  controller: PrimaryScrollController.of(context), // ⭐⭐⭐ 必须
                  physics: const ClampingScrollPhysics(),
                  slivers: [
                    /// ===== 吸顶 ① searchTab =====
                    _buildStickySliver(),

                    /// banner + topics（正常滚）
                    _buildScrollSliver(),

                    /// ===== 吸顶 ② secondTab =====
                    _buildSubTabSliver(),

                    /// ===== 列表 =====
                    _buildListSliver(),
                  ],
                ),
              ),

              /// ===== 蒙层（不穿透）=====
              if (!isUnlockPzhan)
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: ReportGestureDetector(
                      behavior: HitTestBehavior.opaque, // ⭐⭐⭐ 吞掉一切事件
                      onTap: () async {
                        if (widget.crackApp.isfree == 1) {
                          VipPayDialog.showVipDialog(context);
                          return;
                        }

                        if (widget.crackApp.isfree == 2) {
                          VipPayDialog.showCoinsDialog(
                            context: context,
                            barrierDismissible: false,
                            member: _userNotifier.member,
                            coins: widget.crackApp.coins.toDouble(),
                            onPay: () async {
                              final userNotifier = context.read<UserNotifier>();
                              final member = userNotifier.member;
                              final adequate = member.money >= widget.crackApp.coins;

                              if (!adequate) {
                                MyToast.showText(text: 'ndyebz'.tr(context: context));
                                return;
                              }

                              final result = await _userDomain.userAppBuy(
                                source: widget.crackApp.appName,
                                type: CrackAppType.pzhan.type,
                              );

                              if (!context.mounted) return;

                              context.pop();

                              if (result.status == 1) {
                                final currentMoney = member.money - widget.crackApp.coins;
                                userNotifier.setMoney(money: currentMoney);
                                widget.crackApp.isPay = true;
                                context.read<UnlockStatusNotifier>().changePzhanUnlockStatus(true);
                                MyToast.showText(text: result.data?.message ?? '');
                                setState(() {});
                              } else {
                                MyToast.showText(text: result.msg ?? '');
                              }
                            },
                          );
                        }
                      },
                      child: Container(color: Colors.black.withOpacity(0.15)),
                    ),
                  ),
                ),
            ],
          );
        });
  }
}
