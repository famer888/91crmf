import '../../../domain/type_def.dart';
import 'base_service.dart';

class BuyService extends BaseService {

  BuyService(super.dio);

  @override
  final service = 'Appcrack';

  AsyncJson buyList({required int page, required int limit, required int type})
    => post('/list_buy', data: {
      'page': page,
      'limit': limit,
      'type': type,
    });

}