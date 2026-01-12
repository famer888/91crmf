import 'package:jycrpj/domain/model/black_model.dart';
import 'package:jycrpj/domain/type_def.dart';
import 'package:jycrpj/ui_layer/screens/mine/visitrecord/visit_model.dart';

import 'model/feed/feed_model.dart';
import 'remote_domain/domain.dart';
import 'model/home_data_model.dart';
export 'remote_domain/domains/account.dart';
export 'remote_domain/domains/community.dart';
export 'remote_domain/domains/dynamic.dart';
export 'remote_domain/domains/element.dart';
export 'remote_domain/domains/home.dart';
export 'remote_domain/domains/order.dart';
export 'remote_domain/domains/proxy.dart';
export 'remote_domain/domains/seed.dart';
export 'remote_domain/domains/sign.dart';
export 'remote_domain/domains/user.dart';
export 'remote_domain/domains/withdraw.dart';
export 'remote_domain/domains/message.dart';
export 'remote_domain/domains/mv.dart';
export 'remote_domain/domains/vlog.dart';
export 'remote_domain/domains/privilege.dart';
export 'remote_domain/domains/search.dart';

abstract class AppDomain implements LocaleDomain, RemoteDomain {}

abstract class LocaleDomain {
  CacheDomain get cache;
  Json get info;
}

abstract class CacheDomain
    implements VideoDownloadCacheDomain, ChatCacheDomain {
  /// 大于500M清理磁盘
  Future<void> clearImageCacheIfNeed({bool force = false});

  /// 获取广告缓存
  Future<AdModel?> readAds();

  /// 获取广告缓存
  Future<List<AdModel>?> readStartScreenAds();

  Future<bool> readIsBarrage();

  ///获取直播弹幕开关，默认true：开
  Future<void> upsertIsBarrage(bool isBarrage);

  /// 获取官网链结缓存
  Future<String?> readOfficeWeb();

  /// 获取展示引导页标识
  Future<bool> readGuide();

  /// 更新引导页标识
  Future<void> upsertGuide(bool guide);

  /// 取得搜索记录
  Future<List<String>> readSearchHistory({required String key});

  /// 更新搜索记录
  Future<void> upsertSearchHistory({required String key, required List<String> searchHistory});

  /// 清除搜索记录
  Future<void> clearSearchHistory({required String key});

  /// 读取破解App浏览视频记录
  Future<List<VideoVisitModel>?> readCrackAppVideoList();

  /// 更新破解App浏览视频记录
  Future<void> upsertCrackAppVideoList({required List<VideoVisitModel> feedModels});

  /// 读取黑料帖子浏览记录
  Future<List<BlackListItemModel>?> readBlackVisitList();

  /// 更新黑料帖子浏览记录
  Future<void> upsertBlackVisitList({required List<BlackListItemModel> blackVisitModels});

}

abstract class VideoDownloadCacheDomain {
  Future<List> readDownloadVideoTasks();

  Future<void> upsertDownloadVideoTasks({required List tasks});
}

abstract class ChatCacheDomain {
  Future<String> readChats();

  Future<void> upsertChats({required String chats});
}
