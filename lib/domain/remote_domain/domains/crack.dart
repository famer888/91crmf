import 'package:jycrpj/domain/model/crack_model.dart';

import '../../type_def.dart';

abstract class CrackDomain {

  /// 破解 & 未破解列表
  AsyncResult<CrackModel> getCrackList({required int isCrack});

}