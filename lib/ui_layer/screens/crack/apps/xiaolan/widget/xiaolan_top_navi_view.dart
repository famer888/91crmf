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
import 'package:jycrpj/ui_layer/screens/crack/apps/xiaolan/widget/xiaolan_api_link_view.dart';
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
  AsyncValue<List<LinkModel>> _asyncValue = const AsyncInit();

  late final TabController _tabController;
  int _initialIndex = 0;

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
        await _appDomain.getConstructByApiLink(apiLink: CrackAppType.xiaolan.topNavApi, params: {'id': widget.id});
    if (result.status == 1) {
      final data = result['data'];
      if (data case final List data when data.isNotEmpty) {
        final linkModelList = data.map((x) => LinkModel.fromJson(x)).toList();
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
        selector: (_, notifier) => notifier.isUnlockXiaolan,
        builder: (context, isUnlockXiaolan, child) {
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
                        tabBarHeight: 54.w,
                        tabBarPadding: EdgeInsets.only(top: 0.w),
                        tabItemBuilder: (context, index, isSelected, child) {
                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              if (isSelected)
                                Positioned(
                                    top: 10.w,
                                    right: -5.w,
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
              if (!isUnlockXiaolan && widget.crackApp != null)
                LockMask(
                    crackApp: widget.crackApp!,
                    type: CrackAppType.xiaolan.type,
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
