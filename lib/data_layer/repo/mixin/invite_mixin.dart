part of '../repo.dart';

mixin _Invite on _BaseAppRepo implements InviteDomain {

  @override
  AsyncResult getInviteRecord({required int page, required int limit})
    => _inviteService
      .getInviteRecord(page: page, limit: limit)
      .deserializeJsonBy((e) => e)
      .guard;

  @override
  AsyncResult getWithdrawRecord({required int page, required int limit})
    => _inviteService
      .getWithdrawRecord(page: page, limit: limit)
      .deserializeJsonBy((e) => e)
      .guard;
}