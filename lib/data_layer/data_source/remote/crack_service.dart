import '../../../domain/type_def.dart';
import 'base_service.dart';

class CrackService extends BaseService {
  CrackService(super._dio);

  @override
  final service = 'crack';

  AsyncJson getCrackList({required int isCrack}) => post('/list', data: {'is_crack': isCrack});

}
