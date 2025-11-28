import '../../../domain/type_def.dart';
import 'base_service.dart';

class WithdrawService extends BaseService {
  WithdrawService(super._dio);

  @override
  final service = 'eventwithdraw';

  /// 立即提现 规则
  AsyncJson withdrawIndex() => post('/index');

  /// 提现申请
  AsyncJson createWithdraw({required int cardId, required int amount}) => post('/create_withdraw', data: {
        'card_id': cardId,
        'amount': amount,
      });
}
