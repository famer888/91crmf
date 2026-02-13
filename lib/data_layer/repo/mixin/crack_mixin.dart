part of '../repo.dart';

mixin _Crack on _BaseAppRepo implements CrackDomain {

  @override
  AsyncResult<CrackModel> getCrackList({required int isCrack})
    => _crackService
      .getCrackList(isCrack: isCrack)
      .deserializeJsonBy(CrackModel.fromJson)
      .guard;
}