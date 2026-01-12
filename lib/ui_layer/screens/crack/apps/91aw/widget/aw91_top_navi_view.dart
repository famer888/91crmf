import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/domain/async_value.dart';
import 'package:jycrpj/domain/model/crack_model.dart';
import 'package:jycrpj/domain/model/link_model.dart';
import 'package:jycrpj/domain/remote_domain/domains/dynamic.dart';
import 'package:jycrpj/domain/type_def.dart';
import 'package:jycrpj/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/keep_alive_wrapper.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_tab_bar.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/status/loading.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/status/network_error.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/91aw/widget/aw91_api_link_view.dart';
import 'package:jycrpj/ui_layer/screens/crack/crack_app_type.dart';
import 'package:jycrpj/ui_layer/screens/crack/lock_mask.dart';
import 'package:jycrpj/ui_layer/screens/crack/unlock_status_notifier.dart';
import 'package:jycrpj/ui_layer/screens/theme.dart';
import 'package:jycrpj/ui_layer/screens/webview/screen.dart';
import 'package:provider/provider.dart';

class Aw91TopNaviView extends StatefulWidget {
  const Aw91TopNaviView({super.key, this.id, this.crackApp});

  final int? id;
  final CrackApp? crackApp;

  @override
  State<Aw91TopNaviView> createState() => _Aw91TopNaviViewState();
}

class _Aw91TopNaviViewState extends State<Aw91TopNaviView> with TickerProviderStateMixin {
  late final _appDomain = context.read<DynamicDomain>();
  AsyncValue<List<LinkModel>> _asyncValue = const AsyncInit();
  late final TabController _tabController;
  late final _homeConfig = context.read<HomeConfigNotifier>();

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

    final result = await _appDomain.getConstructByApiLink(apiLink: CrackAppType.aw91.topNavApi, params: {'id': widget.id});

    if (result.status == 1) {
      final data = result['data']['value'];
      if (data case final List data when data.isNotEmpty) {
        final linkModelList = data.map((x) => LinkModel.fromJson(x)).toList();
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
        selector: (_, notifier) => notifier.isUnlockAw91,
        builder: (context, isUnlockAw91, child) {
          return Stack(children: [
            _asyncValue.maybeWhen(
              data: (data) {
                final titles = data.map((e) => e.name).toList();
                return TabBarWithView.line(
                  tabController: _tabController,
                  initialIndex: _initialIndex,
                  linearColors: const [MyTheme.aw91AppPrimaryColor, MyTheme.aw91AppPrimaryColor],
                  labelStyle: TextStyle(color: MyTheme.aw91AppPrimaryColor, fontSize: 18.sp, fontWeight: FontWeight.w600),
                  unselectedLabelStyle: TextStyle(color: const Color.fromRGBO(255, 255, 255, 1), fontSize: 16.sp, fontWeight: FontWeight.w500),
                  titles: titles,
                  views: data.map((e) {
                    return KeepAliveWrapper(
                      child: Aw91ApiLinkView(
                        linkModel: e,
                        showRightList: true,
                        onLinkNavTap: (value) {
                          if (data.indexWhere((element) => element.linkUrl == value) case final index when index != -1) {
                            _tabController.index = index;
                          }
                        },
                      ),
                    );
                  }).toList(),
                );
              },
              error: (_, __) => NetworkErrorView(onTap: _init),
              orElse: () => const LoadingView(),
            ),

            /// ===== 蒙层（不穿透）=====
            if (!isUnlockAw91 && widget.crackApp != null)
              LockMask(
                  crackApp: widget.crackApp!,
                  type: CrackAppType.aw91.type,
                  onUnlock: () {
                    setState(() {});
                  })
          ]);
        });
  }

  Widget configNavPrependPage(LinkModel data) {
    return KeepAliveWrapper(
      child: data.redirectType == 1 ? WebViewScreen(url: data.linkUrl, needNav: false) : Container(),
    );
  }
}
