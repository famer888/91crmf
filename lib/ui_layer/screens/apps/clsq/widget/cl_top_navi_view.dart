import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/domain/model/home_data_model.dart';
import 'package:jycrpj/domain/type_def.dart';
import 'package:jycrpj/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jycrpj/ui_layer/screens/apps/clsq/widget/cl_api_link_view.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/keep_alive_wrapper.dart';
import 'package:jycrpj/ui_layer/screens/theme.dart';
import 'package:jycrpj/ui_layer/screens/webview/screen.dart';
import 'package:provider/provider.dart';

import '../../../../../domain/async_value.dart';
import '../../../../../domain/domain.dart';
import '../../../../../domain/model/link_model.dart';
import '../../../common_widgets/my_tab_bar.dart';
import '../../../common_widgets/status/loading.dart';
import '../../../common_widgets/status/network_error.dart';

class ClTopNaviView extends StatefulWidget {
  const ClTopNaviView({super.key, this.id});

  final int? id;

  @override
  State<ClTopNaviView> createState() => _ClTopNaviViewState();
}

class _ClTopNaviViewState extends State<ClTopNaviView> with TickerProviderStateMixin {
  late final _appDomain = context.read<DynamicDomain>();
  AsyncValue<List<LinkModel>> _asyncValue = const AsyncInit();
  late final TabController _tabController;

  late final _homeConfig = context.read<HomeConfigNotifier>();

  // 17岁
  late List<AppNavModel> hjgjDiscoverSortNav = _homeConfig.config.hjgjDiscoverSortNav ?? [];

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

    final result = await _appDomain.getConstructByApiLink(apiLink: 'elementhjgj/getElementById', params: {'id': widget.id});

    if (result.status == 1) {
      final data = result['data']['value'];
      if (data case final List data when data.isNotEmpty) {
        final linkModelList = data.map((x) => LinkModel.fromJson(x)).toList();
        if (hjgjDiscoverSortNav.isNotEmpty) {
          LinkModel item = LinkModel(
            is_nav_prepend: true,
            id: 0,
            linkUrl: '',
            resourceUrl: '',
            redirectType: 0,
            name: '17岁',
            type: '',
            desc: '',
            api: 'mvhjgj/discover2',
            params: {},
          );
          linkModelList.insert(0, item); //插入到对应位置
        }

        _initialIndex = (_homeConfig.config.nav_default ?? 0);

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
    return _asyncValue.maybeWhen(
      data: (data) {
        final titles = data.map((e) => e.name).toList();
        return TabBarWithView.line(
          tabController: _tabController,
          initialIndex: _initialIndex,
          linearColors: const [MyTheme.clAppPrimaryColor, MyTheme.clAppPrimaryColor],
          labelStyle: TextStyle(color: MyTheme.clAppPrimaryColor, fontSize: 18.sp, fontWeight: FontWeight.w600),
          unselectedLabelStyle: TextStyle(color: const Color.fromRGBO(255, 255, 255, 1), fontSize: 16.sp, fontWeight: FontWeight.w500),
          titles: titles,
          views: data.map((e) {
            return
                // (e.is_nav_prepend ?? false)
                //   ? configNavPrependPage(e)
                //   :
                KeepAliveWrapper(
              child: ClApiLinkView(
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
    );
  }

  Widget configNavPrependPage(LinkModel data) {
    return KeepAliveWrapper(
      child: data.redirectType == 1 ? WebViewScreen(url: data.linkUrl, needNav: false) : Container(),
    );
  }
}
