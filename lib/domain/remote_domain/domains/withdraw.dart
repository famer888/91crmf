import '../../model/cash_withdraw_rule_model.dart';
import '../../type_def.dart';

abstract class WithdrawDomain {
  /// 立即提现 规则
  AsyncResult<CashWithdrawRule> withdrawIndex();

  /// 提现申请
  AsyncResult createWithdraw({required int cardId, required int amount});

}
