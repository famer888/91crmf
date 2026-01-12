import 'package:flutter/material.dart';
import 'package:jycrpj/domain/domain.dart';
import 'package:jycrpj/domain/model/black_model.dart';
import 'package:jycrpj/ui_layer/screens/mine/visitrecord/visit_model.dart';
import 'package:provider/provider.dart';

class AppVideoVisitUtil {

  static Future<void> updateVisitRecord(BuildContext context, VideoVisitModel data) async {
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

  static Future<List<VideoVisitModel>?> getAppVisitRecord(BuildContext context) async {
    final cacheDomain = context.read<CacheDomain>();
    return await cacheDomain.readCrackAppVideoList();
  }

  static Future<List<BlackListItemModel>?> getBlackVisitRecord(BuildContext context) async {
    final cacheDomain = context.read<CacheDomain>();
    final list = await cacheDomain.readBlackVisitList();
    return list;
  }

}