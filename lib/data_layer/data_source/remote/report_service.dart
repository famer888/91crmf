import 'package:jycrpj/data_layer/data_source/remote/base_service.dart';
import 'package:jycrpj/domain/type_def.dart';

class ReportService extends BaseService {
  ReportService(super._dio);

  @override
  final service = 'sdk';

  /// 获取全局config接口
  AsyncJson getEncryptedConfig() => post('/event');
}
