import '../../type_def.dart';

abstract class InviteDomain {

  /// 邀请记录
  AsyncResult getInviteRecord({required int page, required int limit});

  /// 提现记录
  AsyncResult getWithdrawRecord({required int page, required int limit});

}