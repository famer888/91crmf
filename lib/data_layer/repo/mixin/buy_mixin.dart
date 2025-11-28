part of '../repo.dart';

mixin _Buy on _BaseAppRepo implements BuyDomain {
  @override
  AsyncResult<List<BuyItemModel>> buyList({required int page, required int limit, required int type}) =>
      _buyService
          .buyList(page: page, limit: limit, type: type)
          .deserializeJsonListBy((e) => e.map<BuyItemModel>(BuyItemModel.fromJson).toList())
          .guard;


}
