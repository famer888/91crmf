import 'package:flutter/material.dart';
import 'package:jycrpj/domain/domain.dart';
import 'package:jycrpj/domain/model/black_model.dart';
import 'package:jycrpj/domain/model/vlog_model.dart';
import 'package:jycrpj/ui_layer/screens/mine/visitrecord/visit_model.dart';
import 'package:provider/provider.dart';

class AppVisitUtil {

  static Future<void> updateCrackAppVisitRecord(BuildContext context, VideoVisitModel data) async {
    final cacheDomain = context.read<CacheDomain>();
    final crackAppVideoList = await cacheDomain.readCrackAppVideoList();
    // 初始化
    final List<VideoVisitModel> list = crackAppVideoList ?? [];
    // ⭐ 关键：先移除旧的
    list.removeWhere((e) => e.id == data.id);
    // ⭐ 插入到最后
    list.add(data);
    await cacheDomain.upsertCrackAppVideoList(feedModels: list);
  }

  static Future<void> updateBlackVisitRecord(BuildContext context, BlackListItemModel data) async {
    final cacheDomain = context.read<CacheDomain>();
    final blackVisitList = await cacheDomain.readBlackVisitList();
    // 初始化
    final List<BlackListItemModel> list = blackVisitList ?? [];
    // ⭐ 关键：先移除旧的
    list.removeWhere((e) => e.id == data.id);
    // ⭐ 插入到最后
    list.add(data);
    await cacheDomain.upsertBlackVisitList(blackVisitModels: list);
  }

  static Future<void> updateVlogVisitRecord(BuildContext context, VlogModel data) async {
    final cacheDomain = context.read<CacheDomain>();
    final vlogVisitList = await cacheDomain.readVlogVisitList();
    // 初始化
    final List<VlogModel> list = vlogVisitList ?? [];
    // ⭐ 关键：先移除旧的
    list.removeWhere((e) => e.id == data.id);
    // ⭐ 插入到最后
    list.add(data);
    await cacheDomain.upsertVlogVisitList(vlogVisitModels: list);
  }

  static Future<List<VideoVisitModel>?> getAppVisitRecord(BuildContext context) async {
    final cacheDomain = context.read<CacheDomain>();
    return await cacheDomain.readCrackAppVideoList();
  }

  static Future<List<BlackListItemModel>?> getBlackVisitRecord(BuildContext context) async {
    final cacheDomain = context.read<CacheDomain>();
    final list = await cacheDomain.readBlackVisitList();
    return list;
  }

  static Future<List<VlogModel>?> getVlogVisitRecord(BuildContext context) async {
    final cacheDomain = context.read<CacheDomain>();
    final list = await cacheDomain.readVlogVisitList();
    return list;
  }
}
