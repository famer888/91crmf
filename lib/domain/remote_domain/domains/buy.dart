import 'package:jycrpj/domain/model/buy_model.dart';

import '../../type_def.dart';

abstract class BuyDomain {

  /// 我的购买  类型 0 app  1 表示黑料
  AsyncResult<List<BuyItemModel>> buyList({required int page, required int limit, required int type});

}