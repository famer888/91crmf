import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:jycrpj/data_layer/repo/repo.dart';

import '../../domain/domain.dart';
import '../../domain/model/home_data_model.dart';
import '../../domain/type_def.dart';

class HomeConfigNotifier extends ChangeNotifier {
  HomeConfigNotifier(this._domain);

  final AppDomain _domain;

  HomeData get homeData => _homeData;
  late HomeData _homeData;

  Config get config => _config;
  late Config _config;

  List<String> getSearchHistory({required String key}) {
    return (_searchHistoryMap[key] ?? []).reversed.take(10).toList();
  }

  final Map<String, List<String>> _searchHistoryMap = {};

  Future<bool> init() async {
    final result = await _domain.getHomeConfig();
    if (result.data case final data?) {
      _homeData = data;
      _config = _homeData.config;
      await _initSearchHistory();
      return true;
    } else if (result.msg == 'token无效') {
      return init(); //重复调一次，防止用户在未启动app时已被挤下线后无法获取数据
    } else {
      return false;
    }
  }

  Future _initSearchHistory() async {
    _searchHistoryMap.clear();

    final clSearchHistory = await _domain.cache.readSearchHistory(key: clSearchHistoryKey);
    final awjqSearchHistory = await _domain.cache.readSearchHistory(key: awjqSearchHistoryKey);
    final aw91SearchHistory = await _domain.cache.readSearchHistory(key: aw91SearchHistoryKey);
    final zpcSearchHistory = await _domain.cache.readSearchHistory(key: zpcSearchHistoryKey);
    final pzhanSearchHistory = await _domain.cache.readSearchHistory(key: pzhanSearchHistoryKey);
    final hjsqSearchHistory = await _domain.cache.readSearchHistory(key: hjsqSearchHistoryKey);
    final tiktokSearchHistory = await _domain.cache.readSearchHistory(key: tiktok51SearchHistoryKey);
    final dspSearchHistory = await _domain.cache.readSearchHistory(key: dspSearchHistoryKey);
    _searchHistoryMap[clSearchHistoryKey] = clSearchHistory;
    _searchHistoryMap[awjqSearchHistoryKey] = awjqSearchHistory;
    _searchHistoryMap[aw91SearchHistoryKey] = aw91SearchHistory;
    _searchHistoryMap[zpcSearchHistoryKey] = zpcSearchHistory;
    _searchHistoryMap[pzhanSearchHistoryKey] = pzhanSearchHistory;
    _searchHistoryMap[hjsqSearchHistoryKey] = hjsqSearchHistory;
    _searchHistoryMap[tiktok51SearchHistoryKey] = tiktokSearchHistory;
    _searchHistoryMap[dspSearchHistoryKey] = dspSearchHistory;
  }

  Future<Json?> uploadImage(XFile xFile) async {
    try {
      final result = await _domain.uploadImage(
        baseUrl: _config.imgUploadUrl,
        key: _config.uploadImgKey,
        xFile: xFile,
        position: 'upload',
      );
      return result;
    } catch (_) {
      return null;
    }
  }

  Future<Json?> uploadImageByte({
    required Uint8List bytes,
    required CancelToken? cancelToken,
  }) async {
    try {
      final result = await _domain.uploadImageBytes(
        baseUrl: _config.imgUploadUrl,
        key: _config.uploadImgKey,
        bytes: bytes,
        position: 'upload',
        cancelToken: cancelToken,
      );
      return result;
    } catch (_) {
      return null;
    }
  }

  Future<Json?> uploadVideo({
    required BuildContext context,
    required XFile xFile,
    required void Function(int count, int total) progressCallback,
    required CancelToken cancelToken,
  }) async {
    try {
      final result = await _domain.uploadVideo(
        context: context,
        xFile: xFile,
        progressCallback: progressCallback,
        cancelToken: cancelToken,
      );
      return result;
    } catch (_) {
      return null;
    }
  }

  /// 更新搜索记录
  Future<void> upsertSearchHistory({required String key, required List<String> searchHistory}) async {
    await _domain.cache.upsertSearchHistory(key: key, searchHistory: searchHistory);
    _searchHistoryMap[key]?.clear();
    _searchHistoryMap[key]?.addAll(searchHistory);
    notifyListeners();
  }

  /// 更新搜索记录
  Future<void> clearSearchHistory({required String key}) async {
    await _domain.cache.clearSearchHistory(key: key, );
    _searchHistoryMap[key]?.clear();
    notifyListeners();
  }

  /// 获取引导
  Future<bool> readGuide() async {
    final readGuide = await _domain.cache.readGuide();
    return readGuide;
  }

  /// 更新引导
  Future<void> upsertGuide(bool guide) async {
    await _domain.cache.upsertGuide(guide);
  }
}
