part of '../repo.dart';

mixin _Crack on _BaseAppRepo implements CrackDomain {

  @override
  AsyncResult<CrackModel> getCrackList({String token = '', required int isCrack})
    => _crackService
      .getCrackList(token: token, isCrack: isCrack)
      .deserializeJsonBy(CrackModel.fromJson)
      .guard;
}