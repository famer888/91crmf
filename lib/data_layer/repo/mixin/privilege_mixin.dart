part of '../repo.dart';

mixin _Privilege on _BaseAppRepo implements PrivilegeDomain {
  @override
  AsyncResult downNum({required String id, required int type}) =>
      _privilegeService.downNum(id: id, type: type).deserialize().guard;
}
