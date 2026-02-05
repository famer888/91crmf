import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/domain/remote_domain/domains/dynamic.dart';
import 'package:jycrpj/domain/type_def.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/51tiktok/widget/tiktok51_feed_card.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/91aw/widget/aw91_feed_card.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/awjq/widget/awjq_feed_card.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/clsq/widget/cl_feed_card.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/hjsq/widget/hjsq_feed_card.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/pzhan/widget/pzhan_feed_card.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/zpc/widget/zpc_feed_card.dart';
import 'package:jycrpj/ui_layer/screens/crack/crack_app_type.dart';
import 'package:jycrpj/ui_layer/screens/crack/model/app_model.dart';
import 'package:provider/provider.dart';

import '../../../domain/model/feed/feed_model.dart';
import '../../../domain/remote_domain/domains/mv.dart';
import '../common_widgets/feed/feed_card.dart';
import '../common_widgets/keep_alive_wrapper.dart';
import '../common_widgets/my_app_bar.dart';
import '../common_widgets/my_list_view.dart';
import '../common_widgets/my_tab_bar.dart';
import '../common_widgets/screen_background.dart';
import '../theme.dart';

class MoreVideoScreen extends StatefulWidget {
  const MoreVideoScreen({
    super.key,
    required this.name,
    required this.id,
    required this.api,
  });

  final String name;
  final String id;
  final String api;

  @override
  State<MoreVideoScreen> createState() => _MoreVideoScreenState();
}

class _MoreVideoScreenState extends State<MoreVideoScreen> {
  int _appType = 0;

  @override
  void initState() {
    if (widget.api.contains('/')) {
      final apiPrefix = widget.api.substring(0, widget.api.indexOf('/'));
      if (apiPrefix == 'mvhjgj') {
        // 草榴
        _appType = CrackAppType.clsq.type;
      } else if (apiPrefix == 'mvzpc') {
        // 制片厂
        _appType = CrackAppType.zpc.type;
      } else if (apiPrefix == 'mvawjq') {
        // 暗网禁区
        _appType = CrackAppType.awjq.type;
      } else if (apiPrefix == 'mv91aw') {
        // 91暗网
        _appType = CrackAppType.aw91.type;
      } else if (apiPrefix == 'tabnewpzhan') {
        // pzhan
        _appType = CrackAppType.pzhan.type;
      } else if (apiPrefix == 'mvhjsq') {
        // hjsq
        _appType = CrackAppType.hjsq.type;
      } else if (apiPrefix == 'tabnew51tikok') {
        // 51tiktok
        _appType = CrackAppType.tiktok51.type;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
        child: Scaffold(
      appBar: MyAppBar(title: widget.name),
      body: TabBarWithView.line(
        labelStyle: TextStyle(
          color: const Color.fromRGBO(255, 255, 255, 1),
          fontSize: 18.sp,
          overflow: TextOverflow.visible,
          decoration: TextDecoration.none,
        ),
        unselectedLabelStyle: TextStyle(
          color: const Color.fromRGBO(255, 255, 255, 0.8),
          fontSize: 17.sp,
          overflow: TextOverflow.visible,
          decoration: TextDecoration.none,
        ),
        linearColors: const [Color.fromRGBO(0, 0, 0, 0), Color.fromRGBO(0, 0, 0, 0)],
        tabBarHeight: 40.w,
        isScrollable: true,
        titles: [
          'zxpx'.tr(context: context),
          'rdpx'.tr(context: context),
        ],
        views: [
          KeepAliveWrapper(child: _VideoView(sort: 'new', id: widget.id, api: widget.api, appType: _appType)),
          KeepAliveWrapper(child: _VideoView(sort: 'hot', id: widget.id, api: widget.api, appType: _appType)),
        ],
      ),
    ));
  }
}

class _VideoView extends StatefulWidget {
  const _VideoView({required this.sort, required this.id, required this.api, required this.appType});

  final String sort;
  final String id;
  final String api;
  final int appType;

  @override
  State<_VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<_VideoView> {
  late final dynamicDomain = context.read<DynamicDomain>();
  late final mvDomain = context.read<MvDomain>();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    super.dispose();
  }

  Future<List<AppVideoModel>> _getPZhanData({
    required int page,
    required int pageSize,
  }) async {
    final result = await dynamicDomain.getConstructByApiLink(apiLink: widget.api, params: {
      'page': page,
      'limit': pageSize,
      'sort': widget.sort,
      'tab_id': widget.id,
    });
    if (result.status == 1) {
      if (result.data['list'] case final List data when data.isNotEmpty) {
        final feedModelList = data.map<AppVideoModel>((x) => AppVideoModel.fromJson(x)).toList();
        return feedModelList;
      }
      return [];
    } else {
      return [];
    }
  }

  Future<List<FeedModel>> _getData({
    required int page,
    required int pageSize,
  }) async {
    if (widget.api.isEmpty) {
      final result = await mvDomain.getListConstructWithParam(
        page: page,
        limit: pageSize,
        sort: widget.sort,
        id: widget.id,
      );
      return result.data!;
    } else {
      final result = await dynamicDomain.getConstructByApiLink(apiLink: widget.api, params: {
        'page': page,
        'limit': pageSize,
        'sort': widget.sort,
        'id': widget.id,
      });
      if (result.status == 1) {
        if (result.data['list'] case final List data when data.isNotEmpty) {
          final feedModelList = data.map<FeedModel>((x) => FeedModel.fromJson(x)).toList();
          return feedModelList;
        }
        return [];
      } else {
        return [];
      }
    }
  }

  double getAspectRatio() {
    if (widget.appType == CrackAppType.awjq.type) {
      return AwjqFeedCard.aspectRatio;
    } else if (widget.appType == CrackAppType.clsq.type || widget.appType == CrackAppType.zpc.type || widget.appType == CrackAppType.aw91.type) {
      return MyTheme.aspectRatio;
    } else {
      return FeedCard.aspectRatio;
    }
  }

  Widget buildFeedCard({required FeedModel feed}) {
    if (widget.appType == CrackAppType.clsq.type) {
      return ClFeedCard(feed: feed);
    } else if (widget.appType == CrackAppType.zpc.type) {
      return ZpcFeedCard(feed: feed, appType: widget.appType);
    } else if (widget.appType == CrackAppType.awjq.type) {
      return AwjqFeedCard(feed: feed);
    } else if (widget.appType == CrackAppType.aw91.type) {
      return Aw91FeedCard(feed: feed);
    } else if (widget.appType == CrackAppType.hjsq.type) {
      return HjsqFeedCard(feed: feed);
    } else {
      return FeedCard(feed: feed);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.appType == CrackAppType.pzhan.type) {
      return MyListView.grid(
        padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding, vertical: 5.w),
        childAspectRatio: MyTheme.aspectRatio,
        crossAxisSpacing: 8.w,
        itemBuilder: (_, item, __) => PZhanFeedCard(feed: item),
        onFetchingMore: (currentPage, pageSize) => _getPZhanData(page: currentPage, pageSize: pageSize),
      );
    } else if (widget.appType == CrackAppType.tiktok51.type) {
      return MyListView.grid(
        padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding, vertical: 5.w),
        childAspectRatio: MyTheme.aspectRatio,
        crossAxisSpacing: 8.w,
        itemBuilder: (_, item, __) => Tiktok51FeedCard(feed: item),
        onFetchingMore: (currentPage, pageSize) => _getPZhanData(page: currentPage, pageSize: pageSize),
      );
    } else {
      return MyListView.grid(
        padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding, vertical: 5.w),
        childAspectRatio: getAspectRatio(),
        crossAxisSpacing: 8.w,
        itemBuilder: (_, item, __) => buildFeedCard(feed: item),
        onFetchingMore: (currentPage, pageSize) => _getData(page: currentPage, pageSize: pageSize),
      );
    }
  }
}
