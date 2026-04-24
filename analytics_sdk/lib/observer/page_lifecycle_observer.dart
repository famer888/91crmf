// lib/observer/page_lifecycle_observer.dart

import 'dart:async';

import 'package:analytics_sdk/config/sdk_config.dart';
import 'package:analytics_sdk/entity/app_page_view_event.dart';
import 'package:analytics_sdk/utils/logger.dart';
import 'package:analytics_sdk/manager/page_name_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// 路由页面生命周期观察者，自动追踪路由级别的页面展示事件。
///
/// **职责**
/// - 监听 [Navigator] 的 push / pop / remove / replace，在渲染完成后自动上报 [AppPageViewEvent]
/// - 维护 [currentPageKey]，供 [GlobalClickWrapper] 进行 page_click 点击归属
/// - 通过 [_PageInfo.effectivePageKey] 支持子页面精准归属：
///   Tab / PageView 切换时更新栈顶的 effectivePageKey，pop 返回时自动恢复正确 key
///
/// **接入**：在 [MaterialApp.navigatorObservers] 注册 [AnalyticsSdk.instance.pageObserver]，
/// 无需手动实例化。
///
/// **限制**：仅追踪带名称的 [PageRoute]（[RouteSettings.name] 非空）；
/// Dialog、BottomSheet 等非 PageRoute 不会触发上报。
class PageLifecycleObserver extends NavigatorObserver {
  /// 全局路由堆栈（静态，确保 [recordNavigation] 等静态方法可直接访问）。
  ///
  /// 每个 [_PageInfo] 元素记录路由 key、来路、进入时间以及当前有效子页面 key。
  static final List<_PageInfo> _pageStack = [];

  /// 当前活跃的 observer 实例数量。
  /// 正常情况下应始终为 1；若超过 1，说明多个 Navigator 共享同一静态堆栈，
  /// 可能导致 currentPageKey 及 referrer 归因混乱。
  static int _activeInstanceCount = 0;

  /// 事件上报回调（由 AnalyticsSdk 在组合根注入，避免循环依赖）
  final void Function(dynamic event) _track;

  /// 用户类型提供者（由 AnalyticsSdk 在组合根注入）
  final String Function() _getUserType;

  /// 页面退出回调，传出退出页面的 pageKey（用于清除页面级广告去重状态）
  final void Function(String pageKey)? _onPageExit;

  /// 页面堆栈最大容量限制，防止内存无限增长
  static int get _maxPageStackSize => SdkConfig.maxPageStackSize;

  /// 当前有效页面 key，供 [GlobalClickWrapper] 及业务方读取。
  ///
  /// 更新时机：
  ///   - 路由 push → 更新为新路由 key
  ///   - 路由 pop  → 恢复为目标路由的 [_PageInfo.effectivePageKey]（含子页面状态）
  ///   - [recordNavigation] → Tab 切换或 PageView 翻页时手动更新
  static String currentPageKey = 'main';

  /// 记录非路由导航（Tab 切换、PageView 翻页），同时更新栈顶路由的
  /// [_PageInfo.effectivePageKey]，使 pop 返回时能恢复到正确的子页面 key。
  ///
  /// **调用场景**
  ///   - 由 [AnalyticsSdk.trackNavigation] 和 [AnalyticsSdk.updateCurrentPage] 统一调用；
  ///     [BottomNavigationBar.withAnalytics] / [TabBar.withAnalytics] 内部已处理，
  ///     接入方通常不需要直接调用此方法。
  ///
  /// 若堆栈为空（纯 Tab 导航、无路由层级），则只更新 [currentPageKey]。
  static void recordNavigation(String pageKey) {
    currentPageKey = pageKey;
    if (_pageStack.isNotEmpty) {
      _pageStack.last.effectivePageKey = pageKey;
    }
  }

  static String _stripLeadingSlash(String name) =>
      PageNameMapper.normalizeKey(name);

  // 跟踪活动的 Timer，防止内存泄漏
  final Map<Route, Timer> _activeTimers = <Route, Timer>{};

  /// 本 observer 管辖的路由集合，用于 dispose 时精准清理，
  /// 避免多 Navigator 场景下影响其他 observer 的堆栈条目。
  final Set<Route> _ownedRoutes = {};

  PageLifecycleObserver({
    required void Function(dynamic event) track,
    required String Function() getUserType,
    void Function(String pageKey)? onPageExit,
  })  : _track = track,
        _getUserType = getUserType,
        _onPageExit = onPageExit {
    _activeInstanceCount++;
    if (_activeInstanceCount > 1) {
      Logger.pageLifecycleObserver(
        '检测到多个 PageLifecycleObserver 实例同时活跃（当前 $_activeInstanceCount 个）。'
        '多个 Navigator 共享同一静态 _pageStack，可能导致 currentPageKey 归因混乱，'
        '请确认是否需要为每个 Navigator 单独管理页面状态。',
        level: LogLevel.warn,
      );
    }
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    try {
      if (route is PageRoute && route.settings.name != null) {
        _handlePageEnter(route);
      }
    } catch (e) {
      Logger.pageLifecycleObserver(' didPush() 异常，已安全处理: $e');
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    try {
      if (_pageStack.isNotEmpty && _pageStack.last.route == route) {
        // 在出栈前先读取 prevEffectiveKey（push 时捕获的来路有效 key），
        // 避免依赖 _pageStack.last.effectivePageKey 在 pop 时仍正确——
        // 后者可能因 recordNavigation 在 main 未入栈时调用而未被更新。
        final restoreKey = _pageStack.last.prevEffectiveKey;
        _handlePageExit(route);

        currentPageKey = restoreKey.isNotEmpty
            ? restoreKey
            : _stripLeadingSlash(previousRoute?.settings.name ?? 'main');
      }
    } catch (e) {
      Logger.pageLifecycleObserver(' didPop() 异常，已安全处理: $e');
    }
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    try {
      // pushAndRemoveUntil / removeRoute 走这里，需主动清理被移除路由
      final timer = _activeTimers.remove(route);
      timer?.cancel();
      final removed = _pageStack.where((info) => info.route == route).toList();
      _pageStack.removeWhere((info) => info.route == route);
      _ownedRoutes.remove(route);
      for (final info in removed) {
        try {
          _onPageExit?.call(info.pageKey);
        } catch (e) {
          Logger.pageLifecycleObserver('onPageExit 回调异常 (didRemove): $e');
        }
      }
    } catch (e) {
      Logger.pageLifecycleObserver(' didRemove() 异常，已安全处理: $e');
    }
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    try {
      // 旧页面 hide
      if (oldRoute is PageRoute && _pageStack.isNotEmpty) {
        if (_pageStack.last.route == oldRoute) {
          _handlePageExit(oldRoute);
          // 旧路由出栈后，将 currentPageKey 同步为新栈顶的 effectivePageKey。
          // 不更新的话，_handlePageEnter 捕获的 prevEffectiveKey 会是旧路由的
          // key，导致新路由被 pop 时恢复到已不存在的旧路由，而非下层真实页面。
          currentPageKey = _pageStack.isNotEmpty
              ? _pageStack.last.effectivePageKey
              : 'main';
        }
      }
      // 新页面 show + 曝光
      if (newRoute is PageRoute && newRoute.settings.name != null) {
        _handlePageEnter(newRoute);
      }
    } catch (e) {
      Logger.pageLifecycleObserver(' didReplace() 异常，已安全处理: $e');
    }
  }

  /// 处理新路由进入：
  ///   1. 更新 [currentPageKey] 为新路由 key
  ///   2. 从栈顶 [_PageInfo.effectivePageKey] 读取来路（支持子页面精准来路）
  ///   3. 注册 [SchedulerBinding.addPostFrameCallback]，渲染完成后上报 [AppPageViewEvent]
  ///   4. 启动超时保护 Timer（[SdkConfig.pageLoadTimeout]），防止帧回调丢失时仍能上报
  ///   5. 容量检查后入栈
  void _handlePageEnter(PageRoute route) {
    final rawKey = _stripLeadingSlash(route.settings.name!);
    final pageInfo = PageNameMapper.resolvePageInfo(rawKey);
    final pageKey = pageInfo.key;
    final pageName = pageInfo.name;
    // 在 currentPageKey 被覆盖前捕获：这是 pop 返回时应恢复的目标 key。
    // 必须在 currentPageKey = pageKey 之前读取，否则读到的是新页面自身的 key。
    final prevEffectiveKey = currentPageKey;
    currentPageKey = pageKey;

    final referrerKey = _pageStack.isEmpty ? '' : _pageStack.last.effectivePageKey;
    final referrerName = _pageStack.isEmpty ? '' : PageNameMapper.getPageName(_pageStack.last.effectivePageKey);
    final enterTime = DateTime.now();

    bool callbackExecuted = false;
    Timer? loadTimer;

    void frameCallback(Duration timestamp) {
      if (callbackExecuted) return;
      // 页面可能在帧回调等待期间被 pop，检查是否仍在栈中
      final stillOnStack = _pageStack.any((info) => info.route == route);
      if (!stillOnStack) {
        callbackExecuted = true;
        loadTimer?.cancel();
        _activeTimers.remove(route);
        return;
      }
      callbackExecuted = true;

      final pageLoadTime = DateTime.now().difference(enterTime).inMilliseconds;
      loadTimer?.cancel();
      _activeTimers.remove(route);

      String userType;
      try {
        userType = _getUserType();
      } catch (e) {
        Logger.pageLifecycleObserver(' 获取用户类型失败，使用默认值: $e');
        userType = 'normal';
      }

      try {
        _track(AppPageViewEvent(
          userType: userType,
          pageKey: pageKey,
          pageName: pageName,
          referrerPageKey: referrerKey,
          referrerPageName: referrerName,
          currentPageKey: pageKey,
          currentPageName: pageName,
          pageLoadTime: pageLoadTime,
        ));
      } catch (e) {
        Logger.pageLifecycleObserver(' AppPageViewEvent 上报失败: $e');
      }
    }

    // 超时保护：如果第一帧回调未在规定时间内执行，重新注册
    loadTimer = Timer(SdkConfig.pageLoadTimeout, () {
      if (!callbackExecuted && _pageStack.isNotEmpty && _pageStack.last.route == route) {
        SchedulerBinding.instance.addPostFrameCallback(frameCallback);
      }
    });
    _activeTimers[route] = loadTimer;
    SchedulerBinding.instance.addPostFrameCallback(frameCallback);

    // 页面堆栈容量检查
    if (_pageStack.length >= _maxPageStackSize) {
      final evicted = _pageStack.removeAt(0);
      final evictedTimer = _activeTimers.remove(evicted.route);
      evictedTimer?.cancel();
    }

    _pageStack.add(_PageInfo(
      pageKey: pageKey,
      pageName: pageName,
      enterTime: enterTime,
      route: route,
      prevEffectiveKey: prevEffectiveKey,
    ));
    _ownedRoutes.add(route);
  }

  /// 释放所有待触发的 Timer，防止 dispose 后继续触发幽灵上报。
  /// 只移除本 observer 管辖的路由条目，避免多 Navigator 场景下清空其他 observer 的堆栈。
  void dispose() {
    for (final timer in _activeTimers.values) {
      timer.cancel();
    }
    _pageStack.removeWhere((info) => _ownedRoutes.contains(info.route));
    _activeTimers.clear();
    _ownedRoutes.clear();
    _activeInstanceCount--;
  }

  /// 处理页面退出：出栈、取消对应 Timer、触发 [_onPageExit] 回调。
  void _handlePageExit(Route route) {
    if (_pageStack.isEmpty || _pageStack.last.route != route) return;

    final exitingPageKey = _pageStack.last.pageKey;
    _pageStack.removeLast();
    _ownedRoutes.remove(route);

    // 清理该路由的 Timer，防止内存泄漏
    final timer = _activeTimers.remove(route);
    timer?.cancel();

    try {
      _onPageExit?.call(exitingPageKey);
    } catch (e) {
      Logger.pageLifecycleObserver('onPageExit 回调异常: $e');
    }
  }
}

/// 路由页面快照，记录页面进入时的状态。
///
/// [effectivePageKey] 是唯一可变字段：初始值与 [pageKey] 相同，
/// 当该路由位于栈顶时，内部 Tab / PageView 切换会通过
/// [PageLifecycleObserver.recordNavigation] 将其更新为子页面 key；
/// 新路由 push 的 referrer 均能精准反映子页面位置。
///
/// [prevEffectiveKey] 在 push 时捕获彼时的 [PageLifecycleObserver.currentPageKey]，
/// pop 返回时用于恢复 [PageLifecycleObserver.currentPageKey]。
/// 与 [effectivePageKey] 的区别：前者存储在被 push 的新页面里，
/// 后者存储在上一层页面里——当上层页面是"容器路由"时，
/// effectivePageKey 可能因时序问题未能同步 tab 状态，
/// 而 prevEffectiveKey 在 push 时即时捕获，始终准确。
class _PageInfo {
  /// 路由自身的页面 key（由路由名称规范化而来，不可变）。
  final String pageKey;

  /// 路由自身的展示名称（由 [PageNameMapper] 解析，不可变）。
  final String pageName;

  /// 该路由当前的有效页面 key。
  ///
  /// 初始等于 [pageKey]；路由处于栈顶时，内部子页面切换会将其更新为子页面 key，
  /// 从而使新路由 push 的 referrer 能精准反映子页面位置。
  String effectivePageKey;

  /// push 此路由时捕获的前一页有效 key，pop 时用于恢复 [PageLifecycleObserver.currentPageKey]。
  ///
  /// 在 [PageLifecycleObserver._handlePageEnter] 的第一行读取
  /// [PageLifecycleObserver.currentPageKey]（早于 `currentPageKey = pageKey`），
  /// 保证容器路由 + tab 场景下返回时能恢复到正确的子页面 key 而非容器路由 key。
  final String prevEffectiveKey;

  /// 路由进入时刻，用于计算 pageLoadTime。
  final DateTime enterTime;

  /// 对应的 Flutter 路由对象，用于 Timer / 堆栈查找时的精确匹配。
  final Route route;

  _PageInfo({
    required this.pageKey,
    required this.pageName,
    required this.enterTime,
    required this.route,
    required this.prevEffectiveKey,
  }) : effectivePageKey = pageKey;
}
