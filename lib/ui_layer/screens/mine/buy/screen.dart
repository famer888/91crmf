import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/app_global.dart';
import 'package:jycrpj/domain/api_validator.dart';
import 'package:jycrpj/domain/model/cartoon/cartoon_model.dart';
import 'package:jycrpj/domain/model/collection_model.dart';
import 'package:jycrpj/domain/model/game/game_model.dart';
import 'package:jycrpj/domain/model/live_model.dart';
import 'package:jycrpj/domain/model/post_model.dart';
import 'package:jycrpj/domain/model/vlog_model.dart';
import 'package:jycrpj/domain/model/voice_model.dart';
import 'package:jycrpj/domain/remote_domain/domains/asmr.dart';
import 'package:jycrpj/domain/remote_domain/domains/live.dart';
import 'package:jycrpj/domain/remote_domain/domains/seed.dart';
import 'package:jycrpj/domain/remote_domain/domains/user.dart';
import 'package:jycrpj/domain/remote_domain/domains/cartoon.dart';
import 'package:jycrpj/domain/remote_domain/domains/game.dart';
import 'package:jycrpj/domain/remote_domain/domains/vlog.dart';
import 'package:jycrpj/domain/result.dart';
import 'package:jycrpj/ui_layer/const.dart';
import 'package:jycrpj/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jycrpj/ui_layer/router/routes.dart';
import 'package:jycrpj/ui_layer/screens/asmr/card/voice_gird_card.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/cartoon/card/video_card.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/game/card/game_card.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/keep_alive_wrapper.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_app_bar.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_tab_bar.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/post/card/card.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:jycrpj/ui_layer/screens/live_video/live_card/live_video_card.dart';
import 'package:jycrpj/ui_layer/screens/mine/common_widgets/video_tile.dart';
import 'package:jycrpj/ui_layer/screens/theme.dart';
import 'package:jycrpj/ui_layer/screens/vlog/card/vlog_card.dart';
import 'package:jycrpj/ui_layer/utils/common_utils.dart';
import 'package:provider/provider.dart';

import 'buy_child_screen.dart';

class BuyTabModel {

  final String title;
  final int type;

  BuyTabModel({required this.title, required this.type});

}

class MineBuyScreen extends StatefulWidget {
  const MineBuyScreen({super.key});

  @override
  State<MineBuyScreen> createState() => _MineBuyScreenState();
}

// todo 我的购买 和 购买App 界面
class _MineBuyScreenState extends State<MineBuyScreen> {
  late final homeConfigNotifier = context.read<HomeConfigNotifier>();
  final _tabTitles = [
    BuyTabModel(title: tr('app'), type: 0),
    BuyTabModel(title: tr('home_hl'), type: 1),
  ];

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        appBar: MyAppBar(title: 'wdgm'.tr(context: context)),
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
          titles: _tabTitles.map((e) => e.title).toList(),
          views: const [
            KeepAliveWrapper(child: BuyChildScreen(type: 0, isList: false)),
            KeepAliveWrapper(child: BuyChildScreen(type: 1, isList: true)),
          ],
        ),
      ),
    );
  }
}

class _VideoView extends StatefulWidget {
  const _VideoView();

  @override
  State<_VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<_VideoView> {
  late final userDomain = context.read<UserDomain>();

  Future<List<MineVideoCardData>> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await userDomain.getUserBuy(
      page: page,
      limit: pageSize,
      type: 1,
    ) as Result<MineVideoListModel>;

    return result.data!.list!;
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.grid(
      childAspectRatio: 1,
      itemBuilder: (_, item, __) => MineVideoTile(data: item),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}

enum _TieztType {
  community,
  bit;

  int get id => switch (this) {
        _TieztType.community => 14,
        _TieztType.bit => 19,
      };
}

class _TieztView extends StatefulWidget {
  const _TieztView({required this.type});

  final _TieztType type;

  @override
  State<_TieztView> createState() => _TieztViewState();
}

class _TieztViewState extends State<_TieztView> {
  late final userDomain = context.read<UserDomain>();

  Future<List<PostModel>> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await userDomain.getUserBuy(
      page: page,
      limit: pageSize,
      type: widget.type.id,
    ) as Result<MineTieztListModel>;

    return result.data!.list!;
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.list(
      contentPadding: 15.w,
      itemBuilder: (context, item, index) => switch (widget.type) {
        _TieztType.community => PostCard.community(data: item),
        _TieztType.bit => PostCard.bit(data: item),
      },
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}

class _LiveView extends StatefulWidget {
  const _LiveView();

  @override
  State<_LiveView> createState() => _LiveViewState();
}

class _LiveViewState extends State<_LiveView> {
  late final liveDomain = context.read<LiveDomain>();

  Future<List<LiveModel>?> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await liveDomain.getLiveListBuy(
      page: page,
      limit: pageSize,
    );
    return result.data;
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.grid(
      childAspectRatio: UILayerConst.videoRatio,
      contentPadding: 15.w,
      padding: EdgeInsets.symmetric(vertical: 5.w, horizontal: MyTheme.pagePadding),
      itemBuilder: (context, item, index) => LiveVideoCard(data: item),
      onFetchingMore: (currentPage, pageSize) => _getData(page: currentPage, pageSize: pageSize),
    );
  }
}

class _ZhozView extends StatefulWidget {
  const _ZhozView();

  @override
  State<_ZhozView> createState() => _ZhozViewState();
}

class _ZhozViewState extends State<_ZhozView> {
  late final seedDomain = context.read<SeedDomain>();

  Future<List<PostModel>> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await seedDomain.buyBitList(
      page: page,
      limit: pageSize,
    );

    return result.data!;
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.list(
      contentPadding: 15.w,
      itemBuilder: (context, item, index) => PostCard.bit(data: item),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}

class _ASMRView extends StatefulWidget {
  const _ASMRView();

  @override
  State<_ASMRView> createState() => _ASMRViewState();
}

class _ASMRViewState extends State<_ASMRView> {
  late final domain = context.read<ASMRDomain>();

  Future<List<VoiceModel>?> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await domain.voiceBuyList(
      page: page,
      limit: pageSize,
    );

    return result.data!;
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.grid(
      contentPadding: 15.w,
      itemBuilder: (context, item, index) => VoiceGirdCard(data: item),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}

class _VlogVideoView extends StatefulWidget {
  const _VlogVideoView();

  @override
  State<_VlogVideoView> createState() => _VlogVideoViewState();
}

class _VlogVideoViewState extends State<_VlogVideoView> {
  late final _domain = context.read<VlogDomain>();
  List<VlogModel> array = [];

  int _page = 1;
  int _limit = 15;

  Future<List<VlogModel>?> _getData({
    required int page,
    required int pageSize,
  }) async {
    _page = page;
    _limit = pageSize;

    final result = await _domain.vlogBuyList(page: page, limit: pageSize);
    if (result.isValid) {
      List<VlogModel> tp = List.from(result.data ?? []);
      if (page == 1) {
        array = tp;
      } else {
        array.addAll(tp);
      }
      return tp;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.grid(
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
      childAspectRatio: UILayerConst.vlogVideoRatio,
      crossAxisSpacing: 10.w,
      itemBuilder: (_, item, index) => VlogCard(
          data: item,
          onTapFunc: (type) {
            if (type == 1) {
              //点击短视频视频
              AppGlobal.shortVideosInfo = {
                'list': array,
                'page': _page,
                'index': index,
                'api': 'vlog/list_buy',
                'params': {
                  'limit': _limit,
                }
              };
              const VlogSecondRoute().push(context);
            } else {
              //广告类型
              CommonUtils.openRoute(context, item.toJson());
            }
          }),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}

class _CartoonView extends StatefulWidget {
  const _CartoonView();

  @override
  State<_CartoonView> createState() => _CartoonViewState();
}

class _CartoonViewState extends State<_CartoonView> {
  late final _domain = context.read<CartoonDomain>();

  Future<List<CartoonModel>?> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await _domain.cartoonBuyList(page: page, limit: pageSize);
    if (result.isValid) {
      List<CartoonModel> tp = List.from(result.data ?? []);
      return tp;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.grid(
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding, vertical: 8.w),
      childAspectRatio: CartoonVideoCard.aspectRatio,
      crossAxisSpacing: 8.w,
      itemBuilder: (context, item, index) => CartoonVideoCard(data: item),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}

class _GameView extends StatefulWidget {
  const _GameView();

  @override
  State<_GameView> createState() => _GameViewState();
}

class _GameViewState extends State<_GameView> {
  late final _domain = context.read<GameDomain>();

  Future<List<GameModel>?> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await _domain.gameBuyList(page: page, limit: pageSize);
    if (result.isValid) {
      List<GameModel> tp = List.from(result.data ?? []);
      return tp;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.grid(
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding, vertical: 8.w),
      childAspectRatio: GameCard.aspectRatio,
      crossAxisSpacing: 8.w,
      itemBuilder: (context, item, index) => GameCard(data: item),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}
