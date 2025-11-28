import 'package:jycrpj/domain/model/feed/feed_model.dart';
import 'package:jycrpj/domain/type_def.dart';

abstract class RankDomain {
  /// 视频搜索
  AsyncResult<List<FeedVideoModel>?> rankMVList({
    required String type,
    required String cycle,
  });

}
