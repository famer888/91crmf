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
    if (crackAppVideoList == null) {
      final List<VideoVisitModel> feedModelList = [];
      feedModelList.add(data);
      await cacheDomain.upsertCrackAppVideoList(feedModels: feedModelList);
    } else {
      // 滤重
      final exists = crackAppVideoList.any((e) => e.id == data.id);
      if (!exists) {
        crackAppVideoList.add(data);
        await cacheDomain.upsertCrackAppVideoList(feedModels: crackAppVideoList);
      }
    }
  }

  static Future<void> updateBlackVisitRecord(BuildContext context, BlackListItemModel data) async {
    final cacheDomain = context.read<CacheDomain>();

    final blackVisitList = await cacheDomain.readBlackVisitList();
    if (blackVisitList == null) {
      final List<BlackListItemModel> feedModelList = [];
      feedModelList.add(data);
      await cacheDomain.upsertBlackVisitList(blackVisitModels: feedModelList);
    } else {
      final exists = blackVisitList.any((e) => e.id == data.id);
      if (!exists) {
        blackVisitList.add(data);
        await cacheDomain.upsertBlackVisitList(blackVisitModels: blackVisitList);
      }
    }
  }

  static Future<void> updateVlogVisitRecord(BuildContext context, VlogModel data) async {
    final cacheDomain = context.read<CacheDomain>();

    final vlogVisitList = await cacheDomain.readVlogVisitList();
    if (vlogVisitList == null) {
      final List<VlogModel> feedModelList = [];
      feedModelList.add(data);
      await cacheDomain.upsertVlogVisitList(vlogVisitModels: feedModelList);
    } else {
      final exists = vlogVisitList.any((e) => e.id == data.id);
      if (!exists) {
        vlogVisitList.add(data);
        await cacheDomain.upsertVlogVisitList(vlogVisitModels: vlogVisitList);
      }
    }
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