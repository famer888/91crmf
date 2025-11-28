class AdsModel {
  int id = 0;
  String title = '';
  String description = '';
  String mvM3u8 = '';
  String imgUrl = '';
  String url = '';
  String imgUrlFull = '';
  int type = 0;
  int value = 0;

  AdsModel();

  void initialPropertys(dynamic json) {
    id = json['id'] ?? 0;
    title = json['title'] ?? '';
    description = json['description'] ?? '';
    mvM3u8 = json['mv_m3u8'] ?? '';
    imgUrl = json['img_url'] ?? '';
    imgUrlFull = json['img_url_full'] ?? '';
    url = json['url'] ?? '';
    type = json['type'] ?? 0;
    value = json['value'] ?? 0;
  }

  AdsModel.fromJson(dynamic json) {
    if (json is! Map) return;
    initialPropertys(json);
  }
}

class AdShortModel extends AdsModel {
  List hotConf = [];
  int random = 0; // 短视频专用
  AdShortModel();
  AdShortModel.fromJson(dynamic json) {
    if (json is! Map) return;
    initialPropertys(json);
    hotConf = json['hot_conf'] ?? [];
    random = json['rand_num'] ?? 0;
  }
}
class BlkAdsModel extends AdsModel {
  int random = 0; // 短视频专用
  BlkAdsModel();
  BlkAdsModel.fromJson(dynamic json) {
    if (json is! Map) return;
    initialPropertys(json);
    random = json['rand_num'] ?? 0;
  }
}
