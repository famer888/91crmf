import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/domain/model/banner_model.dart';
import 'package:jycrpj/domain/model/feed/feed_model.dart';
import 'package:jycrpj/domain/model/home_data_model.dart';
import 'package:jycrpj/domain/model/link_model.dart';
import 'package:jycrpj/domain/model/nav_model.dart';
import 'package:jycrpj/domain/remote_domain/domains/dynamic.dart';
import 'package:jycrpj/domain/type_def.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/clsq/widget/cl_feed_card.dart';
import 'package:jycrpj/ui_layer/screens/theme.dart';
import 'package:jycrpj/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AppListScreen extends StatefulWidget {
  final LinkModel linkModel;
  final AppNavModel appNav;
  final ValueNotifier<List<BannerModel>> bannersNotifier;
  final ValueNotifier<List<NavModel>> topicsNotifier;
  final ValueNotifier<bool> isListNotifier;

  const AppListScreen({
    super.key,
    required this.linkModel,
    required this.bannersNotifier,
    required this.topicsNotifier,
    required this.appNav,
    required this.isListNotifier,
  });

  @override
  State<AppListScreen> createState() => _AppListScreenState();
}

class _AppListScreenState extends State<AppListScreen>
    with AutomaticKeepAliveClientMixin {
  late final _appDomain = context.read<DynamicDomain>();

  final List<FeedModel> _dataList = [];
  final RefreshController _refreshController = RefreshController();

  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;
  final int _pageSize = 15;

  String get _currentType => widget.appNav.type;

  @override
  bool get wantKeepAlive => true;

  // ================== data ==================

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

    if (result.status == 1) {
      if (result.data['banner'] case final List data
      when data.isNotEmpty && widget.bannersNotifier.value.isEmpty) {
        widget.bannersNotifier.value =
            data.map((e) => BannerModel.fromJson(e)).toList();
      }

      if (result.data['nav'] case final List data
      when data.isNotEmpty && widget.topicsNotifier.value.isEmpty) {
        widget.topicsNotifier.value =
            data.map((e) => NavModel.fromJson(e)).toList();
      }

      return result.data['list']
          ?.map<FeedModel>((e) => FeedModel.fromJson(e))
          .toList();
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
    return null;
  }

  Future<void> _loadData({bool refresh = false}) async {
    if (_isLoading) return;
    _isLoading = true;

    try {
      final page = refresh ? 1 : _currentPage;
      final data = await _getData(
        page: page,
        pageSize: _pageSize,
        type: _currentType,
      );

      if (data != null) {
        setState(() {
          if (refresh) {
            _dataList
              ..clear()
              ..addAll(data);
            _currentPage = 2;
          } else {
            _dataList.addAll(data);
            _currentPage++;
          }
          _hasMore = data.length >= _pageSize;
        });
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

  // ================== lifecycle ==================

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _onRefresh();
    });
  }

  @override
  void didUpdateWidget(covariant AppListScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.appNav != widget.appNav ||
        oldWidget.linkModel != widget.linkModel) {
      _dataList.clear();
      _currentPage = 1;
      _hasMore = true;
      _onRefresh();
    }
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  // ================== UI ==================

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ValueListenableBuilder<bool>(
      valueListenable: widget.isListNotifier,
      builder: (_, isList, __) {
        return SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          enablePullUp: true,
          physics: const ClampingScrollPhysics(),
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: MyTheme.pagePadding,
                  vertical: 10.w,
                ),
                sliver: isList ? _buildSliverList() : _buildSliverGrid(),
              ),
            ],
          ),
        );
      },
    );
  }

  SliverList _buildSliverList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          final feed = _dataList[index];
          return ClFeedCard(isList: true, feed: feed);
        },
        childCount: _dataList.length,
      ),
    );
  }

  SliverGrid _buildSliverGrid() {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.w,
        childAspectRatio: 0.8,
      ),
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          final feed = _dataList[index];
          return ClFeedCard(isList: false, feed: feed);
        },
        childCount: _dataList.length,
      ),
    );
  }
}
