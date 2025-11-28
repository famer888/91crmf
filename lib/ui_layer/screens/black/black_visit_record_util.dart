import 'package:flutter/material.dart';
import 'package:jycrpj/domain/domain.dart';
import 'package:jycrpj/domain/model/black_model.dart';
import 'package:provider/provider.dart';

class BlackVisitRecordUtil {

  static Future<void> updateVisitRecord(BuildContext context, BlackListItemModel data) async {
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

  static Future<List<BlackListItemModel>?> getVisitRecord(BuildContext context) async {
    final cacheDomain = context.read<CacheDomain>();
    return await cacheDomain.readBlackVisitList();
  }
}
