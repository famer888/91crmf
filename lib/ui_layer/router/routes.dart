import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jycrpj/domain/model/ai/ai_magic_model.dart';
import 'package:jycrpj/domain/model/soul_group_model.dart';
import 'package:jycrpj/domain/model/voice_model.dart';
import 'package:jycrpj/ui_layer/screens/ai_server/screen.dart';
import 'package:jycrpj/ui_layer/screens/ai_server/widgets/detail/ai_magic_detail.dart';
import 'package:jycrpj/ui_layer/screens/ai_server/widgets/ai_magic.dart';
import 'package:jycrpj/ui_layer/screens/ai_server/widgets/ai_art.dart';
import 'package:jycrpj/ui_layer/screens/ai_server/widgets/ai_novel_page.dart';
import 'package:jycrpj/ui_layer/screens/ai_server/widgets/ai_novel_detail_page.dart';
import 'package:jycrpj/ui_layer/screens/ai_server/widgets/ai_voice_page.dart';
import 'package:jycrpj/ui_layer/screens/ai_server/widgets/ai_kiss_page.dart';
import 'package:jycrpj/ui_layer/screens/ai_server/widgets/ai_face_swap.dart';
import 'package:jycrpj/ui_layer/screens/ai_server/widgets/ai_video_face_swap.dart';
import 'package:jycrpj/ui_layer/screens/ai_server/widgets/ai_off_derobe.dart';
import 'package:jycrpj/ui_layer/screens/anime/detail/screen.dart';
import 'package:jycrpj/ui_layer/screens/anime/more/screen.dart';
import 'package:jycrpj/ui_layer/screens/anime/screen.dart';
import 'package:jycrpj/ui_layer/screens/asmr/voice_player/local_voice_player.dart';
import 'package:jycrpj/ui_layer/screens/asmr/voice_player/voice_player_content.dart';
import 'package:jycrpj/ui_layer/screens/black/black_label_screen.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/video_player/shorttv_search_result_screen.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/video_player/shorttv_search_screen.dart';
import 'package:jycrpj/ui_layer/screens/community/ori_create_group_chat/group_chat/group_chat_detail_content.dart';
import 'package:jycrpj/ui_layer/screens/community/ori_create_group_chat/group_chat/group_chat_list_content.dart';
import 'package:jycrpj/ui_layer/screens/community/ori_create_group_chat/group_chat/group_chat_top_msg_content.dart';
import 'package:jycrpj/ui_layer/screens/community/ori_create_group_chat/group_chat/group_members_content.dart';
import 'package:jycrpj/ui_layer/screens/community/ori_create_group_chat/screen.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/51tiktok/screen/tiktok51_community_screen.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/51tiktok/screen/tiktok51_more_screen.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/51tiktok/screen/tiktok51_search_result_screen.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/51tiktok/screen/tiktok51_tag_screen.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/51tiktok/screen/tiktok51_topic_screen.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/51tiktok/screen/tiktok51_video_detail_screen.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/51tiktok/screen/tiktok51_video_search_screen.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/91aw/screen/an91_tag_screen.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/91aw/screen/aw91_search_result_screen.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/91aw/screen/aw91_video_detail_screen.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/91aw/screen/aw91_video_search_screen.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/91aw/screen/screen.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/awjq/screen/awjq_search_result_screen.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/awjq/screen/awjq_tag_screen.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/awjq/screen/awjq_video_detail_screen.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/awjq/screen/awjq_video_search_screen.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/awjq/screen/screen.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/clsq/screen/cl_search_result_screen.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/clsq/screen/cl_tag_screen.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/clsq/screen/cl_video_detail_screen.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/clsq/screen/cl_video_search_screen.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/clsq/screen/screen.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/hjsq/screen/hjsq_community_screen.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/hjsq/screen/hjsq_search_result_screen.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/hjsq/screen/hjsq_tag_screen.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/hjsq/screen/hjsq_video_detail_screen.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/hjsq/screen/hjsq_video_search_screen.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/pzhan/screen/pzhan_search_result_screen.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/pzhan/screen/pzhan_tag_screen.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/pzhan/screen/pzhan_video_detail_screen.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/pzhan/screen/pzhan_video_search_screen.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/zpc/screen/screen.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/zpc/screen/zcp_search_result_screen.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/zpc/screen/zpc_tag_screen.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/zpc/screen/zpc_video_detail_screen.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/zpc/screen/zpc_video_search_screen.dart';
import 'package:jycrpj/ui_layer/screens/crack/crack_main_page.dart';
import 'package:jycrpj/ui_layer/screens/crack/crack_screen.dart';
import 'package:jycrpj/ui_layer/screens/crack/new_crack_screen.dart';
import 'package:jycrpj/ui_layer/screens/dsp/dship_screen.dart';
import 'package:jycrpj/ui_layer/screens/game/detail/screen.dart';
import 'package:jycrpj/ui_layer/screens/game/more/screen.dart.dart';
import 'package:jycrpj/ui_layer/screens/game/nav/screen.dart.dart';
import 'package:jycrpj/ui_layer/screens/game/screen.dart';
import 'package:jycrpj/ui_layer/screens/game/tag/screen.dart';
import 'package:jycrpj/ui_layer/screens/live_video/live_detail/screen.dart';
import 'package:jycrpj/ui_layer/screens/live_video/live_nav/screen.dart';
import 'package:jycrpj/ui_layer/screens/mine/ai_record/screen.dart';
import 'package:jycrpj/ui_layer/screens/mine/bind_email/screen.dart';
import 'package:jycrpj/ui_layer/screens/mine/collection/mine_new_collection_screen.dart';
import 'package:jycrpj/ui_layer/screens/mine/message_center/customer_service/screen_net.dart';
import 'package:jycrpj/ui_layer/screens/mine/vip_center/upgrade/screen.dart';
import 'package:jycrpj/ui_layer/screens/rank/screen.dart';
import 'package:jycrpj/ui_layer/screens/vlog/screen.dart';
import 'package:jycrpj/ui_layer/screens/vlog/vlog_second_page.dart';
import 'package:jycrpj/ui_layer/screens/vlog/vlog_tag_screen.dart';
import '../../domain/model/video_detail_model.dart';
import '../screens/black/black_details_screen.dart';
import '../screens/black/black_screen.dart';
import '../screens/community/module/screen.dart';
import '../screens/bit/screen.dart';
import '../screens/bit/detail/screen.dart';
import '../screens/bottom_navi_bar.dart';
import '../screens/community/detail/screen.dart';
import '../screens/community/issue/screen.dart';
import '../screens/community/original_screen/original_screen.dart';
import '../screens/community/community_screen/screen.dart';
import '../screens/community/tag_detail/screen.dart';
import '../screens/home/new_home_screen.dart';
import '../screens/local_video/screen.dart';
import '../screens/login/screen.dart';
import '../screens/media_viewer/screen.dart';
import '../screens/mine/agent/profit/screen.dart';
import '../screens/mine/agent/promote_data/screen.dart';
import '../screens/mine/agent/screen.dart';
import '../screens/mine/buy/screen.dart';
import '../screens/mine/coin_recharge/coin_detail/screen.dart';
import '../screens/mine/coin_recharge/screen.dart';
import '../screens/mine/download/screen.dart';
import '../screens/mine/fill_code/screen.dart';
import '../screens/mine/follow/screen.dart';
import '../screens/mine/help/screen.dart';
import '../screens/mine/income_detail/screen.dart';
import '../screens/mine/message_center/chat_message/screen.dart';
import '../screens/mine/message_center/customer_service/screen.dart';
import '../screens/mine/message_center/screen.dart';
import '../screens/mine/message_center/system_message/screen.dart';
import '../screens/mine/official_group/screen.dart';
import '../screens/mine/original_enter/screen.dart';
import '../screens/mine/posts/screen.dart';
import '../screens/mine/recharge_record/screen.dart';
import '../screens/mine/screen.dart';
import '../screens/mine/setup/screen.dart';
import '../screens/mine/share_to_user/record/screen.dart';
import '../screens/mine/share_to_user/screen.dart';
import '../screens/mine/share_to_user/share_invite_screen.dart';
import '../screens/mine/vip_center/screen.dart';
import '../screens/mine/visitrecord/visitrecord_screen.dart';
import '../screens/mine/welfare/screen.dart';
import '../screens/mine/withdrawal/bank_list/screen.dart';
import '../screens/mine/withdrawal/record/screen.dart';
import '../screens/mine/withdrawal/screen.dart';
import '../screens/more_video/screen.dart';
import '../screens/restricted/screen.dart';
import '../screens/search/result/screen.dart';
import '../screens/search/screen.dart';
import '../screens/user_center/screen.dart';
import '../screens/video_detail/screen.dart';
import '../screens/webview/screen.dart';
import '../screens/welcome.dart';
import '../utils/common_utils.dart';
import 'paths.dart';
import 'router.dart';

part 'routes.g.dart';

@TypedGoRoute<WelcomeRoute>(path: AppRouterPaths.root)
class WelcomeRoute extends GoRouteData {
  const WelcomeRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: const WelcomeScreen());
  }
}

@TypedStatefulShellRoute<StatefulShellRoute>(
  branches: [
    // TypedStatefulShellBranch(
    //   routes: [
    //     TypedGoRoute<CrackRoute>(path: AppRouterPaths.crack),
    //   ],
    // ),
    TypedStatefulShellBranch(
      routes: [
        TypedGoRoute<CrackRoute1>(path: AppRouterPaths.crack1),
      ],
    ),
    TypedStatefulShellBranch(
      routes: [
        TypedGoRoute<HomeRoute>(path: AppRouterPaths.home),
      ],
    ),
    // TypedStatefulShellBranch(
    //   routes: [
    //     TypedGoRoute<YchRoute>(path: AppRouterPaths.ych),
    //   ],
    // ),
    TypedStatefulShellBranch(
      routes: [
        TypedGoRoute<BlackRoute>(path: AppRouterPaths.heiLiao),
      ],
    ),
    // TypedStatefulShellBranch(
    //   routes: [
    //     TypedGoRoute<DShipRoute>(path: AppRouterPaths.dShip),
    //   ],
    // ),
    TypedStatefulShellBranch(
      routes: [
        TypedGoRoute<VlogRoute>(path: AppRouterPaths.vlog),
      ],
    ),
    TypedStatefulShellBranch(
      routes: [
        TypedGoRoute<AIServerRoute>(path: AppRouterPaths.aiServer),
      ],
    ),
    // TypedStatefulShellBranch(
    //   routes: [
    //     TypedGoRoute<RestrictedRoute>(
    //       path: AppRouterPaths.anWang,
    //     ),
    //   ],
    // ),
    // TypedStatefulShellBranch(
    //   routes: [
    //     TypedGoRoute<LiveBroadcastRoute>(
    //       path: AppRouterPaths.zhiBo,
    //     ),
    //   ],
    // ),
    TypedStatefulShellBranch(
      routes: [
        TypedGoRoute<MineRoute>(path: AppRouterPaths.mine),
      ],
    ),
  ],
)
class StatefulShellRoute extends StatefulShellRouteData {
  const StatefulShellRoute();

  @override
  Widget builder(BuildContext context, GoRouterState state, StatefulNavigationShell navigationShell) {
    return BottomNaviBar(navigationShell: navigationShell);
  }
}

class HomeRoute extends GoRouteData {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const NewHomeScreen();
// HomeScreen();
}

class CrackRoute extends GoRouteData {
  const CrackRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const CrackMainPage();
}

class CrackRoute1 extends GoRouteData {
  const CrackRoute1();

  @override
  Widget build(BuildContext context, GoRouterState state) => const NewCrackScreen();
}

class RestrictedRoute extends GoRouteData {
  const RestrictedRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const RestrictedScreen();
}

class LiveBroadcastRoute extends GoRouteData {
  const LiveBroadcastRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const LiveBroadcastScreen();
}

class AIServerRoute extends GoRouteData {
  const AIServerRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const AiServerScreen();
}

class DShipRoute extends GoRouteData {
  const DShipRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const DshipScreen();
}

class BlackRoute extends GoRouteData {
  const BlackRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const BlackScreen();
}

class VlogRoute extends GoRouteData {
  const VlogRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const VlogScreen();
}

@TypedGoRoute<BlockDetailsRoute>(path: AppRouterPaths.heiLiaoDetails)
class BlockDetailsRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const BlockDetailsRoute({required this.id});

  final int id;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: BlackDetailsScreen(id: id));
  }
}

@TypedGoRoute<BlockTagListRoute>(path: AppRouterPaths.heiLiaoTagList)
class BlockTagListRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const BlockTagListRoute({required this.tag});

  final String tag;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: BlackLabelScreen(tag: tag));
  }
}

@TypedGoRoute<VlogSecondRoute>(path: AppRouterPaths.vlogSecond)
class VlogSecondRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const VlogSecondRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: const VlogSecondPage());
  }
}

@TypedGoRoute<VlogTagRoute>(path: AppRouterPaths.vlogTag)
class VlogTagRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const VlogTagRoute({
    required this.tag,
  });

  final String tag;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: VlogTagScreen(tag: tag));
  }
}

@TypedGoRoute<GroupChatListContentRoute>(path: AppRouterPaths.soulGroupChatList)
class GroupChatListContentRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const GroupChatListContentRoute(this.$extra);

  final GroupsModel $extra;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: GroupChatListContent(data: $extra));
  }
}

@TypedGoRoute<GroupChatTopMsgContentRoute>(path: AppRouterPaths.soulGroupChatTopMsg)
class GroupChatTopMsgContentRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const GroupChatTopMsgContentRoute(this.$extra);

  final GroupsMessageModel $extra;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: GroupChatTopMsgContent(data: $extra));
  }
}

@TypedGoRoute<GroupChatDetailContentRoute>(path: AppRouterPaths.soulGroupDetailChatList)
class GroupChatDetailContentRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const GroupChatDetailContentRoute({
    required this.id,
    required this.ms,
  });

  final int id;
  final int ms;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: GroupChatDetailContent(id: id, ms: ms));
  }
}

@TypedGoRoute<GroupMembersContentRoute>(path: AppRouterPaths.soulGroupMembersList)
class GroupMembersContentRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const GroupMembersContentRoute({
    required this.id,
  });

  final int id;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: GroupMembersContent(id: id));
  }
}

class OriginAndGroupChatRoute extends GoRouteData {
  const OriginAndGroupChatRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const OriginAndGroupChatScreen();
}

@TypedGoRoute<CartoonRoute>(path: AppRouterPaths.cartoon)
class CartoonRoute extends GoRouteData {
  const CartoonRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: const AnimationVideo());
  }
}

@TypedGoRoute<CartoonMoreRoute>(path: AppRouterPaths.cartoonMore)
class CartoonMoreRoute extends GoRouteData {
  const CartoonMoreRoute(this.sort, this.title);

  final String sort;
  final String title;
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state,
        child: CartoonMoreScreen(
          sort: sort,
          title: title,
        ));
  }
}

@TypedGoRoute<CartoonDetailRoute>(path: AppRouterPaths.cartoonDetail)
class CartoonDetailRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const CartoonDetailRoute(this.$extra);

  final String $extra;

  Future<T?> push<T>(BuildContext context) => context.removeDuplicatePush(location, extra: $extra);

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: CartoonDetailScreen(id: $extra));
  }
}

@TypedGoRoute<GameRoute>(path: AppRouterPaths.game)
class GameRoute extends GoRouteData {
  const GameRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: const YellowGameScreen());
  }
}

@TypedGoRoute<GameMoreRoute>(path: AppRouterPaths.gameMore)
class GameMoreRoute extends GoRouteData {
  const GameMoreRoute(this.sort, this.title);

  final String sort;
  final String title;
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state,
        child: GameMoreScreen(
          sort: sort,
          title: title,
        ));
  }
}

@TypedGoRoute<GameNavRoute>(path: AppRouterPaths.gameNav)
class GameNavRoute extends GoRouteData {
  const GameNavRoute(this.type, this.title);

  final String type;
  final String title;
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state,
        child: GameNavScreen(
          type: type,
          title: title,
        ));
  }
}

@TypedGoRoute<GameDetailRoute>(path: AppRouterPaths.gameDetail)
class GameDetailRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const GameDetailRoute(this.$extra);

  final String $extra;

  Future<T?> push<T>(BuildContext context) => context.removeDuplicatePush(location, extra: $extra);

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: GameDetailScreen(id: $extra));
  }
}

@TypedGoRoute<GameTagRoute>(path: AppRouterPaths.gameTag)
class GameTagRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const GameTagRoute(this.tag);

  final String tag;

  Future<T?> push<T>(BuildContext context) => context.removeDuplicatePush(location, extra: tag);

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: GameTagScreen(tag: tag));
  }
}

class BitRoute extends GoRouteData {
  const BitRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const BitScreen();
}

class YchRoute extends GoRouteData {
  const YchRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const OriginalCommunityScreen();
}

class CommunityRoute extends GoRouteData {
  const CommunityRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const CommunityScreen();
}

class MineRoute extends GoRouteData {
  const MineRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const MineScreen();
}

@TypedGoRoute<WebViewRoute>(path: AppRouterPaths.webView)
class WebViewRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const WebViewRoute(this.url);

  final String url;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return WebViewScreen(url: url);
  }
}

@TypedGoRoute<BitPostDetailRoute>(path: AppRouterPaths.bitPostDetail)
class BitPostDetailRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const BitPostDetailRoute(this.id);

  final String id;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: BitPostDetailScreen(id: id));
  }
}

@TypedGoRoute<VipCenterRoute>(path: AppRouterPaths.mineVipCenter)
class VipCenterRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  final int pageIndex;

  const VipCenterRoute({this.pageIndex = 0});

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: VipCenterScreen(pageIndex: pageIndex));
  }
}

@TypedGoRoute<VipUpgradeRoute>(path: AppRouterPaths.mineVipUpgrade)
class VipUpgradeRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const VipUpgradeRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: const VipUpgradeScreen());
  }
}

@TypedGoRoute<CoinRechargeRoute>(path: AppRouterPaths.mineCoinRecharge)
class CoinRechargeRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const CoinRechargeRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: const CoinRechargeScreen());
  }
}

@TypedGoRoute<CoinDetailRoute>(path: AppRouterPaths.mineCoinDetail)
class CoinDetailRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const CoinDetailRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: const CoinDetailScreen());
  }
}

@TypedGoRoute<RankRoute>(path: AppRouterPaths.rankList)
class RankRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const RankRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: const RankScreen());
  }
}

@TypedGoRoute<RechargeRecordRoute>(path: AppRouterPaths.mineRechargeRecord)
class RechargeRecordRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const RechargeRecordRoute(this.type);

  final String type;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: RechargeRecordScreen(type: type));
  }
}

@TypedGoRoute<CommunityIssueRoute>(path: AppRouterPaths.communityIssue)
class CommunityIssueRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const CommunityIssueRoute({
    required this.type,
    required this.org,
  });

  final CommunityIssueType type;
  final bool org;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: CommunityIssueScreen(type: type, org: org));
  }
}

@TypedGoRoute<CommunityModuleRoute>(path: AppRouterPaths.communityModule)
class CommunityModuleRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const CommunityModuleRoute({
    required this.id,
    required this.type,
  });

  final int id;
  final String type;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: CommunityModuleScreen(id: id, type: type));
  }
}

@TypedGoRoute<CommunityPostDetailRoute>(path: AppRouterPaths.communityTieztDetail)
class CommunityPostDetailRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const CommunityPostDetailRoute(this.id);

  final String id;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: CommunityPostDetailScreen(id: id));
  }
}

@TypedGoRoute<LoginRoute>(path: AppRouterPaths.login)
class LoginRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const LoginRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: const LoginScreen());
  }
}

@TypedGoRoute<MineSetupRoute>(path: AppRouterPaths.mineSetup)
class MineSetupRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const MineSetupRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: const MineSetupScreen());
  }
}

@TypedGoRoute<MineShareToUserRoute>(path: AppRouterPaths.mineShareToUser)
class MineShareToUserRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const MineShareToUserRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: const MineShareToUserScreen());
  }
}

@TypedGoRoute<ShareInviteRoute>(path: AppRouterPaths.mineShareInvite)
class ShareInviteRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const ShareInviteRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: const ShareInviteScreen());
  }
}

@TypedGoRoute<MineShareToUserRecordRoute>(path: AppRouterPaths.mineShareToUserRecord)
class MineShareToUserRecordRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const MineShareToUserRecordRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: const MineShareToUserRecordScreen());
  }
}

@TypedGoRoute<MineAgentRoute>(path: AppRouterPaths.mineAgent)
class MineAgentRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const MineAgentRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: const MineAgentScreen());
  }
}

@TypedGoRoute<MineAgentProfitRoute>(path: AppRouterPaths.mineAgentProfit)
class MineAgentProfitRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const MineAgentProfitRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: const MineAgentProfitScreen());
  }
}

@TypedGoRoute<MineAgentPromoteDataRoute>(path: AppRouterPaths.mineAgentPromoteData)
class MineAgentPromoteDataRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const MineAgentPromoteDataRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: const MineAgentPromoteDataScreen());
  }
}

@TypedGoRoute<MineCustomerServiceRoute>(path: AppRouterPaths.customerService)
class MineCustomerServiceRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const MineCustomerServiceRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: const MineCustomerServiceWebScreen() /*const MineCustomerServiceScreen()*/);
  }
}

@TypedGoRoute<MineWithdrawalRoute>(path: AppRouterPaths.mineWithdrawal)
class MineWithdrawalRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const MineWithdrawalRoute(this.isAgent);

  final bool isAgent;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: MineWithdrawalScreen(isAgent: isAgent));
  }
}

@TypedGoRoute<MineWithdrawalRecordRoute>(path: AppRouterPaths.mineWithdrawalRecord)
class MineWithdrawalRecordRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const MineWithdrawalRecordRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: const MineWithdrawalRecordScreen());
  }
}

@TypedGoRoute<MineWithdrawalBankListRoute>(path: AppRouterPaths.mineWithdrawalBankList)
class MineWithdrawalBankListRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const MineWithdrawalBankListRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: const MineWithdrawalBankListScreen());
  }
}

@TypedGoRoute<MineWelfareRoute>(path: AppRouterPaths.mineWelfare)
class MineWelfareRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const MineWelfareRoute({this.index = 0});

  final int index;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: MineWelfareScreen(index: index));
  }
}

@TypedGoRoute<AIMagicRoute>(path: AppRouterPaths.aiMagic)
class AIMagicRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const AIMagicRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: const AIMagic());
  }
}

@TypedGoRoute<AIArtRoute>(path: AppRouterPaths.aiArt)
class AIArtRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const AIArtRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: const AIArtScreen());
  }
}

@TypedGoRoute<AiNovelRoute>(path: AppRouterPaths.aiNovel)
class AiNovelRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const AiNovelRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: const AiNovelPage());
  }
}

@TypedGoRoute<AiAudioRoute>(path: AppRouterPaths.aiAudio)
class AiAudioRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const AiAudioRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: const AiVoicePage());
  }
}

@TypedGoRoute<AiNovelDetailRoute>(path: AppRouterPaths.aiNovelDetail)
class AiNovelDetailRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const AiNovelDetailRoute(this.id, this.generateTime);

  final String id;
  final String generateTime;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: AiNovelDetailPage(id: id, generateTime: generateTime));
  }
}

@TypedGoRoute<AIFaceSwapRoute>(path: AppRouterPaths.aiFaceSwap)
class AIFaceSwapRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const AIFaceSwapRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: const AIFaceSwap());
  }
}

@TypedGoRoute<AIVideoFaceSwapRoute>(path: AppRouterPaths.aiVideoFaceSwap)
class AIVideoFaceSwapRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const AIVideoFaceSwapRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: const AiVideoFaceSwap());
  }
}

@TypedGoRoute<AIOffDeRobeRoute>(path: AppRouterPaths.aiOffDeRobe)
class AIOffDeRobeRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const AIOffDeRobeRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: const AIOffDeRobe());
  }
}

@TypedGoRoute<AIKissRoute>(path: AppRouterPaths.aiKiss)
class AIKissRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const AIKissRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: const AIKissPage());
  }
}

@TypedGoRoute<MinePostRoute>(path: AppRouterPaths.minePost)
class MinePostRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const MinePostRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: const MinePostScreen());
  }
}

@TypedGoRoute<MineIncomeDetailRoute>(path: AppRouterPaths.mineIncomeDetail)
class MineIncomeDetailRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const MineIncomeDetailRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: const MineIncomeDetailScreen());
  }
}

@TypedGoRoute<MineCollectionRoute>(path: AppRouterPaths.mineCollection)
class MineCollectionRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const MineCollectionRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    // return CommonUtils.buildSlideTransitionPage(state: state, child: const MineCollectionScreen());
    return CommonUtils.buildSlideTransitionPage(state: state, child: const MineNewCollectionScreen());
  }
}

@TypedGoRoute<UserCenterRoute>(path: AppRouterPaths.userCenter)
class UserCenterRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const UserCenterRoute(this.aff);

  final String aff;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: UserCenterScreen(aff: aff));
  }
}

@TypedGoRoute<VlogSearchRoute>(path: AppRouterPaths.vlogSearch)
class VlogSearchRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const VlogSearchRoute({required this.word});

  final String word;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: ShorttvSearchScreen(args: word));
  }
}

@TypedGoRoute<VlogSearchResultRoute>(path: AppRouterPaths.vlogSearchResult)
class VlogSearchResultRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const VlogSearchResultRoute({required this.word});

  final String word;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: ShorttvSearchResultScreen(word: word));
  }
}

@TypedGoRoute<ChatMessageRoute>(path: AppRouterPaths.chatMessage)
class ChatMessageRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const ChatMessageRoute({required this.nickName, required this.toUuid, required this.thumb});

  final String nickName;
  final String toUuid;
  final String thumb;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state,
        child: ChatMessageScreen(
          toUuid: toUuid,
          nickName: nickName,
          thumb: thumb,
        ));
  }
}

@TypedGoRoute<MineFollowingRoute>(path: AppRouterPaths.mineFollowing)
class MineFollowingRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const MineFollowingRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: const MineFollowingScreen());
  }
}

@TypedGoRoute<OriginalEnterRoute>(path: AppRouterPaths.originalEnter)
class OriginalEnterRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const OriginalEnterRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: const OriginalEnterScreen());
  }
}

@TypedGoRoute<CommunityTagDetailRoute>(path: AppRouterPaths.communityTagDetail)
class CommunityTagDetailRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const CommunityTagDetailRoute(this.id);

  final String id;

  Future<T?> push<T>(BuildContext context) => context.removeDuplicatePush(location);

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: CommunityTagDetailScreen(id: id));
  }
}

@TypedGoRoute<MineBuyRoute>(path: AppRouterPaths.mineBuy)
class MineBuyRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const MineBuyRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: const MineBuyScreen());
  }
}

@TypedGoRoute<VisitRecordScreenRoute>(path: AppRouterPaths.mineBrowseRecord)
class VisitRecordScreenRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const VisitRecordScreenRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: const VisitRecordScreen());
  }
}

@TypedGoRoute<MineAIRecordRoute>(path: AppRouterPaths.mineAIRecord)
class MineAIRecordRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const MineAIRecordRoute({this.index = 0});

  final int index;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: MineAIRecordScreen(index: index));
  }
}

@TypedGoRoute<VideoDetailRoute>(path: AppRouterPaths.videoDetail)
class VideoDetailRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const VideoDetailRoute(this.$extra);

  final String $extra;

  Future<T?> push<T>(BuildContext context) => context.removeDuplicatePush(location, extra: $extra);

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: VideoDetailScreen(id: $extra));
  }
}

@TypedGoRoute<AnWangRestrictedRoute>(path: AppRouterPaths.awjq)
class AnWangRestrictedRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const AnWangRestrictedRoute({required this.id});

  final int id;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: AwRestrictedAreaScreen(id: id));
  }
}

@TypedGoRoute<AnWangRestrictedDetailRoute>(path: AppRouterPaths.awjqVideoDetail)
class AnWangRestrictedDetailRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const AnWangRestrictedDetailRoute({required this.id});

  final int id;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: AwjqVideoDetailScreen(id: id));
  }
}

@TypedGoRoute<PZhanVideoDetailRoute>(path: AppRouterPaths.pzhanVideoDetail)
class PZhanVideoDetailRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const PZhanVideoDetailRoute({required this.id});

  final int id;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: PZhanVideoDetailScreen(id: id));
  }
}

@TypedGoRoute<AwjqVideoTagRoute>(path: AppRouterPaths.awjqVideoTag)
class AwjqVideoTagRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const AwjqVideoTagRoute({required this.videoTag});

  final String videoTag;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: AwjqTagScreen(videoTag: videoTag));
  }
}

@TypedGoRoute<AwjqVideoSearchRoute>(path: AppRouterPaths.awjqVideoSearch)
class AwjqVideoSearchRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const AwjqVideoSearchRoute({required this.args});

  final String args;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: AwjqVideoSearchScreen(args: args));
  }
}

@TypedGoRoute<PZhanVideoSearchRoute>(path: AppRouterPaths.pzhanVideoSearch)
class PZhanVideoSearchRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const PZhanVideoSearchRoute({required this.args});

  final String args;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: PZhanVideoSearchScreen(args: args));
  }
}

@TypedGoRoute<HjsqCommunityRoute>(path: AppRouterPaths.hjsqApp)
class HjsqCommunityRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const HjsqCommunityRoute({required this.id});

  final int id;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: HjsqCommunityScreen(id: id));
  }
}

@TypedGoRoute<HjsqVideoSearchRoute>(path: AppRouterPaths.hjsqVideoSearch)
class HjsqVideoSearchRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const HjsqVideoSearchRoute({required this.args});

  final String args;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: HjsqVideoSearchScreen(args: args));
  }
}

@TypedGoRoute<HjsqVideoTagRoute>(path: AppRouterPaths.hjsqVideoTag)
class HjsqVideoTagRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const HjsqVideoTagRoute(this.$extra);

  final String $extra;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: HjsqTagScreen(videoTag: $extra));
  }
}

@TypedGoRoute<HjsqSearchResultRoute>(path: AppRouterPaths.hjsqVideoSearchResult)
class HjsqSearchResultRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const HjsqSearchResultRoute({required this.word, required this.type});

  final String word;
  final int type;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: HjsqSearchResultScreen(word: word, type: type));
  }
}

@TypedGoRoute<HjsqVideoDetailRoute>(path: AppRouterPaths.hjsqVideoDetail)
class HjsqVideoDetailRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const HjsqVideoDetailRoute(this.$extra);

  final int $extra;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: HjsqVideoDetailScreen(id: $extra));
  }
}

@TypedGoRoute<Tiktok51CommunityRoute>(path: AppRouterPaths.tiktok51App)
class Tiktok51CommunityRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const Tiktok51CommunityRoute({required this.id});

  final int id;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: Tiktok51CommunityScreen(id: id));
  }
}

@TypedGoRoute<Tiktok51VideoSearchRoute>(path: AppRouterPaths.tiktok51VideoSearch)
class Tiktok51VideoSearchRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const Tiktok51VideoSearchRoute({required this.args});

  final String args;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: Tiktok51VideoSearchScreen(args: args));
  }
}

@TypedGoRoute<Tiktok51SearchResultRoute>(path: AppRouterPaths.tiktok51VideoSearchResult)
class Tiktok51SearchResultRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const Tiktok51SearchResultRoute({required this.word, required this.type});

  final String word;
  final int type;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: Tiktok51SearchResultScreen(word: word, type: type));
  }
}

@TypedGoRoute<Tiktok51TopicRoute>(path: AppRouterPaths.tiktok51Topic)
class Tiktok51TopicRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const Tiktok51TopicRoute({
    required this.name,
    required this.id,
    required this.api,
  });

  final String name;
  final String id;
  final String api;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: Tiktok51TopicScreen(name: name, id: id, api: api));
  }
}

@TypedGoRoute<Tiktok51MoreRoute>(path: AppRouterPaths.tiktok51More)
class Tiktok51MoreRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const Tiktok51MoreRoute({required this.name, required this.id, required this.api});

  final String name;
  final String id;
  final String api;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: Tiktok51MoreScreen(name: name, id: id, api: api));
  }
}

@TypedGoRoute<Tiktok51VideoDetailRoute>(path: AppRouterPaths.tiktok51VideoDetail)
class Tiktok51VideoDetailRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const Tiktok51VideoDetailRoute({required this.id});

  final int id;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: Tiktok51VideoDetailScreen(id: id));
  }
}

@TypedGoRoute<Tiktok51TagRoute>(path: AppRouterPaths.tiktok51VideoTag)
class Tiktok51TagRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const Tiktok51TagRoute({required this.videoTag});

  final String videoTag;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: Tiktok51TagScreen(videoTag: videoTag));
  }
}

@TypedGoRoute<DarkWeb91Route>(path: AppRouterPaths.aw91)
class DarkWeb91Route extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const DarkWeb91Route({required this.id});

  final int id;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: Aw91CommunityScreen(id: id));
  }
}

@TypedGoRoute<Aw91VideoDetailRoute>(path: AppRouterPaths.aw91VideoDetail)
class Aw91VideoDetailRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const Aw91VideoDetailRoute({required this.id});

  final int id;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: Aw91VideoDetailScreen(id: id));
  }
}

@TypedGoRoute<Aw91TagRoute>(path: AppRouterPaths.aw91VideoTag)
class Aw91TagRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const Aw91TagRoute({required this.videoTag});

  final String videoTag;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: Aw91TagScreen(videoTag: videoTag));
  }
}

@TypedGoRoute<Aw91VideoSearchRoute>(path: AppRouterPaths.aw91VideoSearch)
class Aw91VideoSearchRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const Aw91VideoSearchRoute({required this.args});

  final String args;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: Aw91VideoSearchScreen(args: args));
  }
}

@TypedGoRoute<ZpcCommunityRoute>(path: AppRouterPaths.zpcApp)
class ZpcCommunityRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const ZpcCommunityRoute({required this.id});

  final int id;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: ZpcCommunityScreen(id: id));
  }
}

@TypedGoRoute<ZpcVideoDetailRoute>(path: AppRouterPaths.zpcVideoDetail)
class ZpcVideoDetailRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const ZpcVideoDetailRoute(this.$extra);

  final int $extra;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: ZpcVideoDetailScreen(id: $extra));
  }
}

@TypedGoRoute<ZpcVideoTagRoute>(path: AppRouterPaths.zpcVideoTag)
class ZpcVideoTagRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const ZpcVideoTagRoute(this.$extra);

  final String $extra;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: ZpcTagScreen(videoTag: $extra));
  }
}

@TypedGoRoute<ZpcVideoSearchRoute>(path: AppRouterPaths.zpcVideoSearch)
class ZpcVideoSearchRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const ZpcVideoSearchRoute(this.$extra);

  final String $extra;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: ZpcVideoSearchScreen(args: $extra));
  }
}

@TypedGoRoute<ClCommunityRoute>(path: AppRouterPaths.caoliu)
class ClCommunityRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const ClCommunityRoute({required this.id});

  final int id;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: ClCommunityScreen(id: id));
  }
}

@TypedGoRoute<ClVideoDetailRoute>(path: AppRouterPaths.clVideoDetail)
class ClVideoDetailRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const ClVideoDetailRoute(this.$extra);

  final int $extra;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: ClVideoDetailScreen(id: $extra));
  }
}

@TypedGoRoute<ClVideoTagRoute>(path: AppRouterPaths.clVideoTag)
class ClVideoTagRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const ClVideoTagRoute(this.$extra);

  final String $extra;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: ClTagScreen(videoTag: $extra));
  }
}

@TypedGoRoute<PZhanVideoTagRoute>(path: AppRouterPaths.pzhanVideoTag)
class PZhanVideoTagRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const PZhanVideoTagRoute(this.$extra);

  final String $extra;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: PZhanTagScreen(videoTag: $extra));
  }
}

@TypedGoRoute<ClVideoSearchRoute>(path: AppRouterPaths.clVideoSearch)
class ClVideoSearchRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const ClVideoSearchRoute(this.$extra);

  final String $extra;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: ClVideoSearchScreen(args: $extra));
  }
}

@TypedGoRoute<ClSearchResultRoute>(path: AppRouterPaths.clVideoSearchResult)
class ClSearchResultRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const ClSearchResultRoute({required this.word, required this.type});

  final String word;
  final int type;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: ClSearchResultScreen(word: word, type: type));
  }
}

@TypedGoRoute<ZpcSearchResultRoute>(path: AppRouterPaths.zpcVideoSearchResult)
class ZpcSearchResultRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const ZpcSearchResultRoute({required this.word, required this.type});

  final String word;
  final int type;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: ZpcSearchResultScreen(word: word, type: type));
  }
}

@TypedGoRoute<AwjqSearchResultRoute>(path: AppRouterPaths.awjqVideoSearchResult)
class AwjqSearchResultRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const AwjqSearchResultRoute({required this.word, required this.type});

  final String word;
  final int type;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: AwjqSearchResultScreen(word: word, type: type));
  }
}

@TypedGoRoute<PZhanSearchResultRoute>(path: AppRouterPaths.pzhanVideoSearchResult)
class PZhanSearchResultRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const PZhanSearchResultRoute({required this.word, required this.type});

  final String word;
  final int type;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: PZhanSearchResultScreen(word: word, type: type));
  }
}

@TypedGoRoute<Aw91SearchResultRoute>(path: AppRouterPaths.aw91VideoSearchResult)
class Aw91SearchResultRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const Aw91SearchResultRoute({required this.word, required this.type});

  final String word;
  final int type;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: Aw91SearchResultScreen(word: word, type: type));
  }
}

@TypedGoRoute<VoicePalyerContentRoute>(path: AppRouterPaths.voicePlayerContent)
class VoicePalyerContentRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const VoicePalyerContentRoute(this.$extra);

  final VoiceModel $extra;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: VioicPlayerContentView(data: $extra));
  }
}

@TypedGoRoute<LivesDetailRoute>(path: AppRouterPaths.livesDetail)
class LivesDetailRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const LivesDetailRoute(this.$extra);

  final String $extra;

  Future<T?> push<T>(BuildContext context) => context.removeDuplicatePush(location, extra: $extra);

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: LiveVideoDetailScreen(id: $extra));
  }
}

@TypedGoRoute<MineDownloadRoute>(path: AppRouterPaths.mineDownload)
class MineDownloadRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const MineDownloadRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: const MineDownloadScreen());
  }
}

@TypedGoRoute<MineFillCodeRoute>(path: AppRouterPaths.mineFillCode)
class MineFillCodeRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const MineFillCodeRoute(this.title);

  final String title;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: MineFillCodeScreen(title: title));
  }
}

@TypedGoRoute<MineBindEmailRoute>(path: AppRouterPaths.mineBindEmail)
class MineBindEmailRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const MineBindEmailRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: const MineBindEmailScreen());
  }
}

@TypedGoRoute<MineHelpRoute>(path: AppRouterPaths.mineHelp)
class MineHelpRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const MineHelpRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: const MineHelpScreen());
  }
}

@TypedGoRoute<MineOfficialGroupRoute>(path: AppRouterPaths.mineOfficialGroup)
class MineOfficialGroupRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const MineOfficialGroupRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: const MineOfficialGroupScreen());
  }
}

@TypedGoRoute<SearchRoute>(path: AppRouterPaths.search)
class SearchRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const SearchRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: const SearchScreen());
  }
}

@TypedGoRoute<SearchResultRoute>(path: AppRouterPaths.searchResult)
class SearchResultRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const SearchResultRoute(this.title);

  final String title;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: SearchResultScreen(title: title));
  }
}

@TypedGoRoute<MoreVideoRoute>(path: AppRouterPaths.moreVideo)
class MoreVideoRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const MoreVideoRoute({
    required this.name,
    required this.id,
    required this.api,
  });

  final String name;
  final String id;
  final String api;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: MoreVideoScreen(name: name, id: id, api: api));
  }
}

@TypedGoRoute<MessageCenterRoute>(path: AppRouterPaths.mineMessageCenter)
class MessageCenterRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const MessageCenterRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: const MessageCenterScreen());
  }
}

@TypedGoRoute<SystemMessageRoute>(path: AppRouterPaths.mineSystemMessage)
class SystemMessageRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const SystemMessageRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: const SystemMessageScreen());
  }
}

@TypedGoRoute<MediaViewerRoute>(path: AppRouterPaths.mediaViewer)
class MediaViewerRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const MediaViewerRoute(this.$extra);

  final Map $extra;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: MediaViewerScreen(pramas: $extra));
  }
}

@TypedGoRoute<LocalVideoRoute>(path: AppRouterPaths.localVideo)
class LocalVideoRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const LocalVideoRoute(this.$extra);

  final VideoData $extra;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: LocalVideoScreen(data: $extra));
  }
}

@TypedGoRoute<LocalVoiceRoute>(path: AppRouterPaths.localVoice)
class LocalVoiceRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const LocalVoiceRoute(this.$extra);

  final VoiceModel $extra;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: LocalVoicePlayer(data: $extra));
  }
}

extension _MyPushHelper on BuildContext {
  Future<T?> removeDuplicatePush<T>(String location, {Object? extra}) async {
    final router = GoRouter.of(this);

    final matchList = router.routerDelegate.currentConfiguration.matches;
    final newMatchList = matchList.where((element) => element.matchedLocation != location).toList();
    matchList.clear();
    matchList.addAll(newMatchList);

    return push<T>(location, extra: extra);
  }
}

@TypedGoRoute<AIMagicDetailRoute>(path: AppRouterPaths.aiMagicDetail)
class AIMagicDetailRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  const AIMagicDetailRoute(this.$extra);

  final AIMagicModel $extra;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child: AIMagicDetail(data: $extra));
  }
}
