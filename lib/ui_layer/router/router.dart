import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:jycrpj/report/ui_layer/report_timing_observer.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/xiaolan/screen/xiaolan_block_screen.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/xiaolan/screen/xiaolan_category_detail_screen.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/xiaolan/screen/xiaolan_creator_screen.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/xiaolan/screen/xiaolan_discover_screen.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/xiaolan/screen/xiaolan_search_screen.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/xiaolan/screen/xiaolan_user_works_screen.dart';
import 'package:jycrpj/ui_layer/router/approute_observer.dart';
import 'paths.dart';
import 'routes.dart';

class AppRouter {
  static final rootNavigatorKey = GlobalKey<NavigatorState>();
  static final GoRouter router = GoRouter(
    navigatorKey: AppRouter.rootNavigatorKey,
    initialLocation: AppRouterPaths.root,
    routes: [
      ...$appRoutes,
      GoRoute(
        path: AppRouterPaths.xiaolanBlockDetail,
        builder: (context, state) {
          final title = state.pathParameters['title'] ?? '';
          return XiaoLanBlockScreen(videoTag: title);
        },
      ),
      GoRoute(
        path: AppRouterPaths.xiaolanCreator,
        builder: (context, state) => const XiaolanCreatorScreen(),
      ),
      GoRoute(
        path: AppRouterPaths.xiaolanUserWorks,
        builder: (context, state) {
          final userName = state.uri.queryParameters['userName'] ?? '';
          return XiaolanUserWorksScreen(userName: userName);
        },
      ),
      GoRoute(
        path: AppRouterPaths.xiaolanDiscover,
        builder: (context, state) => const XiaolanDiscoverScreen(),
      ),
      GoRoute(
        path: AppRouterPaths.xiaolanCategoryDetail,
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
          final title = state.pathParameters['title'] ?? '';
          return XiaolanCategoryDetailScreen(categoryId: id, title: title);
        },
      ),
      GoRoute(
        path: AppRouterPaths.xiaolanSearch,
        builder: (context, state) => const XiaolanSearchScreen(),
      ),
    ],
    observers: [
      BotToastNavigatorObserver(),
      AppRouteObserver().routeObserver,
      ReportTimingObserver(),
    ],
  );
}
