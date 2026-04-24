import 'package:analytics_sdk/analytics_sdk.dart';
import 'package:analytics_sdk/entity/ad_click_event.dart';
import 'package:analytics_sdk/entity/advertising_event.dart';
import 'package:analytics_sdk/entity/app_install_event.dart';
import 'package:analytics_sdk/entity/keyword_click_event.dart';
import 'package:analytics_sdk/entity/keyword_search_event.dart';
import 'package:analytics_sdk/entity/video_event.dart';
import 'package:analytics_sdk/enum/click_item_type_enum.dart';
import 'package:analytics_sdk/enum/user_type_enum.dart';
import 'package:analytics_sdk/enum/video_content_type_enum.dart';
import 'package:analytics_sdk/enum/video_event_enum.dart';
import 'package:analytics_sdk/manager/page_name_manager.dart';
import 'package:analytics_sdk/observer/page_lifecycle_observer.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jycrpj/app_global.dart';
import 'package:jycrpj/data_layer/repo/repo.dart';
import 'package:jycrpj/domain/model/feed/feed_model.dart';
import 'package:jycrpj/domain/model/home_data_model.dart';
import 'package:jycrpj/domain/model/video_detail_model.dart';
import 'package:jycrpj/domain/model/vlog_model.dart';
import 'package:jycrpj/report/analytics/analytics_page_sync.dart';
import 'package:jycrpj/report/analytics/report_search_event.dart';
import 'package:jycrpj/ui_layer/utils/common_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

/// 与 a_hjsq 对齐：远程加密配置刷新。本仓库未接 ReportDomain 时仅占位。
Future<void> fetchAndApplyConfig() async {
  try {
    CommonUtils.log('fetchAndApplyConfig: 未配置 ReportDomain，跳过 SDK 远程配置刷新');
  } catch (e) {
    CommonUtils.log('获取加密config失败: $e');
  }
}

Future<void> initAnalyticsSdk(BuildContext? context,
    {String oauthId = ''}) async {
  final pkg = await PackageInfo.fromPlatform();
  final appId =
      AppGlobal.reportAppId.isNotEmpty ? AppGlobal.reportAppId : 'DX-105';
  await AnalyticsSdk.instance.init(
    appId: appId,
    encryptedConfig: null,
    deviceId: oauthId,
    enableDebugBanner: kDebugMode,
    appVersion:"26.0424.2215",
  );
}

void analyticsReportInstall(BuildContext context, String traceID) {
  if (AppGlobal.installFlag.isEmpty) {
    AnalyticsSdk.instance.track(AppInstallEvent(traceId: traceID));
    context.read<AppRepo>().setInstallFlag('1');
  }
}

void analyticsUserLogin(int vipLevel) {
  AnalyticsSdk.setUserIdAndType(
    userId: (AppGlobal.aff > 0) ? AppGlobal.aff.toString() : '',
    userTypeEnum: vipLevel > 0 ? UserTypeEnum.vip : UserTypeEnum.normal,
  );
}

void analyticsSetUid(String uid) {
  AnalyticsSdk.setUid(uid);
}

void analyticsSetChannel(String channel) {
  AnalyticsSdk.setChannel(
    channel == 'self' ? '' : channel,
  );
}

void analyticsLogout() {
  AnalyticsSdk.logoutUser();
}

void analyticsNavigationChange() {
  final key = PageLifecycleObserver.currentPageKey;
  final pageName = PageNameMapper.getPageName(key);
  AnalyticsSdk.instance.updateCurrentPage(pageKey: key, pageName: pageName);
  AnalyticsSdk.instance.trackNavigation(
    pageKey: key,
    pageName: pageName,
  );
}

void analyticsVideo({
  FlickManager? flickManager,
  dynamic data,
  required VideoEventEnum videoEvent,
  required VideoContentTypeEnum videoContentType,
}) {
  if (data == null) return;
  if (data is! VideoData && data is! VlogModel) return;

  final value = flickManager?.flickVideoManager?.videoPlayerValue;
  if (value == null || !value.isInitialized) return;

  final playDuration = value.position.inSeconds;
  final videoDuration = value.duration.inSeconds;

  var percent = videoDuration > 0 ? playDuration / videoDuration : 0.0;
  if (percent.isNaN || percent.isInfinite) {
    percent = 0;
  }

  String videoId = '';
  String videoTitle = '';
  String videoTypeId = '';
  String videoTypeName = '';
  String videoTagKey = '';
  String videoTagName = '';
  String recommendTraceId = '';
  String mediaId = '';
  if (data is VideoData) {
    videoId = data.id?.toString() ?? '';
    videoTitle = data.title ?? '';
    videoTypeId = data.mvType?.toString() ?? '';
    videoTypeName = '';
    videoTagKey = 'video_detail';
    videoTagName = data.tags ?? '';
    recommendTraceId = '';
    mediaId = data.id?.toString() ?? '';
  } else if (data is VlogModel) {
    videoId = data.id?.toString() ?? '';
    videoTitle = data.title ?? '';
    videoTypeId = data.mvType?.toString() ?? '';
    videoTypeName = '';
    videoTagKey = 'vlog';
    videoTagName = data.tags ?? '';
    recommendTraceId = '';
    mediaId = data.id?.toString() ?? '';
  }

  final progress = (percent * 100).clamp(0, 100).round();
  AnalyticsSdk.instance.track(
    VideoEvent(
      videoId: videoId,
      videoTitle: videoTitle,
      videoTypeId: videoTypeId,
      videoTypeName: videoTypeName,
      videoTagKey: videoTagKey,
      videoTagName: videoTagName,
      videoDuration: videoDuration,
      playDuration: playDuration,
      playProgress: progress,
      videoBehavior: videoEvent,
      videoContentType: videoContentType,
      recommendTraceId: recommendTraceId,
      mediaId: mediaId,
    ),
  );
}

void analyticsAdClick(BuildContext context, dynamic data) {
  if (data is! FeedAdModel && data is! AdModel) return;

  String adSlotKey = '';
  String adSlotName = '';
  String adId = '';
  String adType = '';
  if (data is FeedAdModel) {
    adSlotKey = data.advertiseLocationCode ?? '';
    adSlotName = data.adSlotName ?? '';
    adId = data.advertiseCode ?? '';
    adType = data.adType?.toString() ?? '';
  }

  if (data is AdModel) {
    adSlotKey = data.advertiseLocationCode ?? '';
    adSlotName = data.adSlotName ?? '';
    adId = data.advertiseCode ?? '';
    adType = data.adType.toString();
  }

  final pageInfo = syncAnalyticsPageFromContext(context);
  AnalyticsSdk.instance.track(
    AdClickEvent(
      pageKey: pageInfo.pageKey,
      pageName: pageInfo.pageName,
      adSlotKey: adSlotKey,
      adSlotName: adSlotName,
      adId: adId,
      creativeId: '',
      adType: adType,
    ),
  );
}

void analyticsAdvertising({required dynamic data, required String action}) {
  if (data is! FeedAdModel && data is! AdModel) return;

  String adSlotKey = '';
  String adSlotName = '';
  String adId = '';
  if (data is FeedAdModel) {
    adSlotKey = data.advertiseLocationCode ?? '';
    adSlotName = data.adSlotName ?? '';
    adId = data.advertiseCode ?? '';
  }

  if (data is AdModel) {
    adSlotKey = data.advertiseLocationCode ?? '';
    adSlotName = data.adSlotName ?? '';
    adId = data.advertiseCode ?? '';
  }

  AnalyticsSdk.instance.track(
    AdvertisingEvent(
      eventType: action,
      advertisingKey: adSlotKey,
      advertisingName: adSlotName,
      advertisingId: adId,
    ),
  );
}

void analyticsKeywordClick({
  required String keyword,
  required String clickItemId,
  required SearchTypeEvent contentType,
  required int clickPosition,
  required String searchTraceId,
}) {
  final cType = ClickItemTypeEnum(
    contentType.key,
    contentType.name,
  );

  AnalyticsSdk.instance.track(
    KeywordClickEvent(
      keyword: keyword,
      clickItemId: clickItemId,
      clickItemType: cType,
      clickPosition: clickPosition,
      searchTraceId: searchTraceId,
    ),
  );
}

void analyticsKeywordSearch({
  required String keyword,
  required int searchResultCount,
  required String searchId,
  required String searchTraceId,
  required String searchContentType,
}) {
  AnalyticsSdk.instance.track(
    KeywordSearchEvent(
      keyword: keyword,
      searchResultCount: searchResultCount,
      searchTraceId: searchTraceId,
      searchId: searchId,
      searchContentType: searchContentType,
    ),
  );
}
