import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:jycrpj/report/ui_layer/report_timing_observer.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/xiaolan/screen/xiaolan_search_result_screen.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/xiaolan/screen/xiaolan_category_or_tag_detail_screen.dart';
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
        path: AppRouterPaths.xiaoLanSearchResult,
        builder: (context, state) {
          final kwy = state.pathParameters['kwy'] ?? '';
          return XiaoLanSearchResultScreen(kwy: kwy);
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
        builder: (context, state) {
          final type = state.uri.queryParameters['type'] ?? '';
          final nagId = state.uri.queryParameters['nagId'] ?? '';
          return XiaolanDiscoverScreen(
            type: type,
            nagId: nagId,
          );
        },
      ),
      GoRoute(
        path: AppRouterPaths.xiaolanCategoryOrTagDetail,
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
          final title = state.pathParameters['title'] ?? '';
          final type = state.pathParameters['type'] ?? '';
          final hasSort = state.pathParameters['has_sort'];
          return XiaolanCategoryOrTagDetailScreen(
            id: id,
            title: title,
            type: type,
            hasSort: hasSort == '1',
          );
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
