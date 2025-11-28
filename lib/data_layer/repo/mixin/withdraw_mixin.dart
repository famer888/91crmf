part of '../repo.dart';

mixin _Withdraw on _BaseAppRepo implements WithdrawDomain {
  @override
  AsyncResult<CashWithdrawRule> withdrawIndex()
    => _withdrawService
      .withdrawIndex()
      .deserializeJsonBy(CashWithdrawRule.fromJson)
      .guard;

  @override
  AsyncResult createWithdraw({required int cardId, required int amount})
    => _withdrawService
      .createWithdraw(cardId: cardId, amount: amount)
      .deserializeJsonBy((e) => e)
      .guard;
}
