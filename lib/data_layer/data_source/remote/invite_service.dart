import 'package:jycrpj/domain/type_def.dart';

import 'base_service.dart';

class InviteService extends BaseService {
  InviteService(super._dio);

  @override
  final service = 'invite';

  /// 邀请列表
  /// @param page 页码 选传
  /// @param limit 每页数量 选传
  AsyncJson getInviteRecord({required int page, required int limit})
    => post('/listInviteRecord',
        data: {
          'page': page,
          'limit': limit,
        });

  /// 提现记录
  /// @param page 页码 选传
  /// @param limit 每页数量 选传
  AsyncJson getWithdrawRecord({required int page, required int limit})
    => post('/listInviteWithdraw',
        data: {
          'page': page,
          'limit': limit,
        });

}
