import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/domain/async_value.dart';
import 'package:jycrpj/domain/model/crack_model.dart';
import 'package:jycrpj/domain/model/home_data_model.dart';
import 'package:jycrpj/domain/model/link_model.dart';
import 'package:jycrpj/domain/remote_domain/domains/dynamic.dart';
import 'package:jycrpj/domain/type_def.dart';
import 'package:jycrpj/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/keep_alive_wrapper.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_tab_bar.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/status/loading.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/status/network_error.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/clsq/widget/cl_api_link_view.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/xiaolan/widget/xuaikab_api_link_view.dart';
import 'package:jycrpj/ui_layer/screens/crack/crack_app_type.dart';
import 'package:jycrpj/ui_layer/screens/crack/widgets/lock_mask.dart';
import 'package:jycrpj/ui_layer/screens/crack/unlock_status_notifier.dart';
import 'package:jycrpj/ui_layer/screens/theme.dart';
import 'package:jycrpj/ui_layer/screens/webview/screen.dart';
import 'package:provider/provider.dart';

class XiaoLanTopNaviView extends StatefulWidget {
  const XiaoLanTopNaviView({
    super.key,
    this.id,
    this.crackApp,
  });

  final int? id;
  final CrackApp? crackApp;

  @override
  State<XiaoLanTopNaviView> createState() => _XiaoLanTopNaviViewState();
}

class _XiaoLanTopNaviViewState extends State<XiaoLanTopNaviView> with TickerProviderStateMixin {
  late final _appDomain = context.read<DynamicDomain>();
  late final _homeConfig = context.read<HomeConfigNotifier>();
  AsyncValue<List<LinkModel>> _asyncValue = const AsyncInit();

  late final TabController _tabController;
  int _initialIndex = 1;

  // 17岁
  late List<AppNavModel> hjgjDiscoverSortNav = _homeConfig.config.hjgjDiscoverSortNav ?? [];

  @override
  void initState() {
    _init();
    super.initState();
  }

  Future<void> _init() async {
    if (_asyncValue.isLoading) return;

    setState(() {
      _asyncValue = const AsyncLoading();
    });

    final result =
        await _appDomain.getConstructByApiLink(apiLink: CrackAppType.clsq.topNavApi, params: {'id': widget.id});

    // MOCK数据
    // await Future.delayed(const Duration(seconds: 1));
    // Map<String, dynamic> result = {
    //   'status': 1,
    //   'data': {
    //     'value': [
    //       {
    //         "current": false,
    //         "id": -1,
    //         "name": "关注",
    //         "type": 1,
    //         "mid_style": 0,
    //         "bot_style": 0,
    //         "api": "/api/mv/listOfFollow",
    //         "params": {"id": 0}
    //       },
    //       {
    //         "current": true,
    //         "id": 9,
    //         "name": "推荐",
    //         "type": 0,
    //         "h5_url": "",
    //         "api": "/api/tabnew/list_construct",
    //         "params": {"nag_id": 9},
    //         "mid_style": 1,
    //         "bot_style": 1
    //       },
    //       {
    //         "current": false,
    //         "id": 13,
    //         "name": "独家",
    //         "type": 3,
    //         "h5_url":
    //             "https://28b.nmngoxp.cc/act/zt.html?token=0888996996D83AD9942D32B2BCD5F19EC69319A25D6A0D1730A7063289924469",
    //         "api": "/api/tabnew/list_construct",
    //         "params": {"nag_id": 13},
    //         "mid_style": 0,
    //         "bot_style": 0
    //       },
    //       {
    //         "current": false,
    //         "id": 11,
    //         "name": "原创",
    //         "type": 4,
    //         "h5_url": "",
    //         "api": "/api/tabnew/hotRank",
    //         "params": {"nag_id": 11},
    //         "mid_style": 2,
    //         "bot_style": 2
    //       },
    //       {
    //         "current": false,
    //         "id": 10,
    //         "name": "发现",
    //         "type": 2,
    //         "h5_url": "",
    //         "api": "/api/tabnew/discovery",
    //         "params": {"nag_id": 10},
    //         "mid_style": 0,
    //         "bot_style": 0
    //       },
    //       {
    //         "current": false,
    //         "id": 1,
    //         "name": "角色",
    //         "type": 0,
    //         "h5_url": "",
    //         "api": "/api/tabnew/list_construct",
    //         "params": {"nag_id": 1},
    //         "mid_style": 2,
    //         "bot_style": 2
    //       },
    //       {
    //         "current": false,
    //         "id": 2,
    //         "name": "体型",
    //         "type": 0,
    //         "h5_url": "",
    //         "api": "/api/tabnew/list_construct",
    //         "params": {"nag_id": 2},
    //         "mid_style": 2,
    //         "bot_style": 2
    //       },
    //       {
    //         "current": false,
    //         "id": 3,
    //         "name": "玩法",
    //         "type": 0,
    //         "h5_url": "",
    //         "api": "/api/tabnew/list_construct",
    //         "params": {"nag_id": 3},
    //         "mid_style": 2,
    //         "bot_style": 2
    //       },
    //       {
    //         "current": false,
    //         "id": 4,
    //         "name": "网红泄露",
    //         "type": 0,
    //         "h5_url": "",
    //         "api": "/api/tabnew/list_construct",
    //         "params": {"nag_id": 4},
    //         "mid_style": 2,
    //         "bot_style": 2
    //       },
    //       {
    //         "current": false,
    //         "id": 5,
    //         "name": "其他",
    //         "type": 0,
    //         "h5_url": "",
    //         "api": "/api/tabnew/list_construct",
    //         "params": {"nag_id": 5},
    //         "mid_style": 2,
    //         "bot_style": 2
    //       },
    //       {
    //         "current": false,
    //         "id": 8,
    //         "name": "经典日本GV",
    //         "type": 0,
    //         "h5_url": "",
    //         "api": "/api/tabnew/list_construct",
    //         "params": {"nag_id": 8},
    //         "mid_style": 2,
    //         "bot_style": 2
    //       },
    //       {
    //         "current": false,
    //         "id": 7,
    //         "name": "二次元CG",
    //         "type": 0,
    //         "h5_url": "",
    //         "api": "/api/tabnew/list_construct",
    //         "params": {"nag_id": 7},
    //         "mid_style": 2,
    //         "bot_style": 2
    //       },
    //       {
    //         "current": false,
    //         "id": 6,
    //         "name": "精品专区",
    //         "type": 0,
    //         "h5_url": "",
    //         "api": "/api/tabnew/list_construct",
    //         "params": {"nag_id": 6},
    //         "mid_style": 2,
    //         "bot_style": 2
    //       },
    //       {
    //         "current": false,
    //         "id": 12,
    //         "name": "综艺",
    //         "type": 0,
    //         "h5_url": "",
    //         "api": "/api/tabnew/list_construct",
    //         "params": {"nag_id": 12},
    //         "mid_style": 2,
    //         "bot_style": 2
    //       }
    //     ],
    //   },
    // };
    if (result.status == 1) {
      final data = result['data']['value'];
      if (data case final List data when data.isNotEmpty) {
        final linkModelList = data.map((x) => LinkModel.fromJson(x)).toList();
        if (hjgjDiscoverSortNav.isNotEmpty) {
          LinkModel item = LinkModel(
            isNavPrepend: true,
            id: 0,
            linkUrl: '',
            resourceUrl: '',
            redirectType: 0,
            name: '精品',
            type: 0,
            desc: '',
            api: 'mvhjgj/discover2',
            params: {},
          );
          linkModelList.insert(0, item); //插入到对应位置
        }

        _initialIndex = (_homeConfig.config.navDefault ?? 0);

        _tabController = TabController(length: linkModelList.length, vsync: this, initialIndex: _initialIndex);

        _asyncValue = AsyncData(linkModelList);
      }
    } else {
      _asyncValue = const AsyncError();
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Selector<UnlockStatusNotifier, bool>(
        selector: (_, notifier) => notifier.isUnlockClsq,
        builder: (context, isUnlockClsq, child) {
          return Stack(
            children: [
              _asyncValue.maybeWhen(
                data: (data) {
                  final titles = data.map((e) => e.name).toList();
                  return LayoutBuilder(builder: (context, constraints) {
                    return SizedBox(
                      height: constraints.maxHeight, // 使用父级约束的高度
                      child: TabBarWithView.line(
                        tabController: _tabController,
                        initialIndex: _initialIndex,
                        tabBarHeight: 27.h,
                        tabBarPadding: EdgeInsets.only(top: 11.w),
                        tabItemBuilder: (context, index, isSelected, child) {
                          return Stack(
                            children: [
                              if (isSelected)
                                Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Image.asset('assets/images/xiaolan_tab_icon.png',
                                        width: 18.w, fit: BoxFit.cover)),
                              child
                            ],
                          );
                        },
                        linearColors: [Colors.transparent, Colors.transparent],
                        labelStyle:
                            TextStyle(color: const Color(0xFF333333), fontSize: 16.sp, fontWeight: FontWeight.w600),
                        unselectedLabelStyle: TextStyle(
                          color: const Color(0xFF646C85),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        titles: titles,
                        views: data.map((e) {
                          return XiaoLanApiLinkView(
                            linkModel: e,
                            showRightList: true,
                            onLinkNavTap: (value) {
                              if (data.indexWhere((element) => element.linkUrl == value) case final index
                              when index != -1) {
                                _tabController.index = index;
                              }
                            },
                          );
                          return KeepAliveWrapper(
                            child: XiaoLanApiLinkView(
                              linkModel: e,
                              showRightList: true,
                              onLinkNavTap: (value) {
                                if (data.indexWhere((element) => element.linkUrl == value) case final index
                                    when index != -1) {
                                  _tabController.index = index;
                                }
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  });
                },
                error: (_, __) => NetworkErrorView(onTap: _init),
                orElse: () => const LoadingView(),
              ),

              /// ===== 蒙层（不穿透）=====
              if (!isUnlockClsq && widget.crackApp != null)
                LockMask(
                    crackApp: widget.crackApp!,
                    type: CrackAppType.clsq.type,
                    onUnlock: () {
                      setState(() {});
                    })
            ],
          );
        });
  }

  Widget configNavPrependPage(LinkModel data) {
    return KeepAliveWrapper(
      child: data.redirectType == 1 ? WebViewScreen(url: data.linkUrl, needNav: false) : Container(),
    );
  }
}
