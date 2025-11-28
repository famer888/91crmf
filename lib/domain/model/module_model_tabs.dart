///
/// 导航
class TabClassModel {
  bool current = false;
  dynamic id;
  String name = '';
  String type = '';
  String apiList = '';
  Map<String, dynamic> paramsList = {};
  String api = '';
  Map<String, dynamic> params = {};

  bool showIcon = false;

  String? origin; // video comic
  String midStyle = '';
  String botStyle = '';
}

///
class BlkClassModel extends TabClassModel {
  BlkClassModel.fromJson(dynamic json) {
    if (json is! Map) return;
    current = json['current'];
    id = json['mid'];
    name = json['name'] ?? '';
    apiList = json['api_list'] ?? '';
    paramsList = json['params_list'] is! Map
        ? {}
        : (json['params_list'] as Map).map((key, value) {
            return MapEntry('$key', value);
          });
  }
}

///
class PostTabModel {
  bool current = false;
  dynamic id;
  String name = '';
  String type = '';
  String api = '';
  String tApi = '';
  Map<String, dynamic> params = {};
  Map<String, dynamic> tParams = {};

  PostTabModel();
  PostTabModel.fromJson(dynamic json) {
    if (json is! Map) return;
    current = json['current'] ?? false;
    id = json['id'] ?? 0;
    name = json['name'] ?? '';
    type = json['type'] ?? '';
    api = json['api_list'] ?? '';
    params = json['params_list'] is! Map
        ? {}
        : (json['params_list'] as Map)
            .map((key, value) => MapEntry('$key', value));
    tApi = json['api_topic'] ?? '';
    tParams = json['params_topic'] is! Map
        ? {}
        : (json['params_topic'] as Map)
            .map((key, value) => MapEntry('$key', value));
  }
}

// 小说
class NovelTabModel extends TabClassModel {
  NovelTabModel.fromJson(dynamic json) {
    if (json is! Map) return;
    current = json['current'];
    id = json['id'];
    name = json['name'] ?? '';
    type = json['type'] ?? '';
    apiList = json['api_list'] ?? '';
    paramsList = json['params_list'] is! Map
        ? {}
        : (json['params_list'] as Map).map((key, value) {
            return MapEntry('$key', value);
          });
  }
}

// 色图
class GraphTabModel extends TabClassModel {
  GraphTabModel.fromJson(dynamic json) {
    if (json is! Map) return;
    current = json['current'];
    id = json['id'];
    name = json['name'] ?? '';
    type = json['type'] ?? '';
    apiList = json['api_list'] ?? '';
    paramsList = json['params_list'] is! Map
        ? {}
        : (json['params_list'] as Map).map((key, value) {
            return MapEntry('$key', value);
          });
  }
}

// Ai 素材
class AiTabModel extends TabClassModel {
  AiTabModel();
  AiTabModel.fromJson(dynamic json) {
    if (json is! Map) return;
    id = json['id'];
    name = json['name'] ?? '';
  }
}

// 种子
class SeedTabModel extends TabClassModel {
  int count = 0;
  SeedTabModel.fromJson(dynamic json) {
    if (json is! Map) return;
    current = json['current'] ?? false;
    id = json['id'];
    type = json['type'] ?? '';
    name = json['name'] ?? '';
    count = json['post_ct'] ?? 0;
  }
}

// 游戏
class GameTabModel extends TabClassModel {
  GameTabModel.fromJson(dynamic json) {
    if (json is! Map) return;
    current = json['current'] ?? false;
    id = json['id'];
    name = json['title'] ?? '';
    type = json['type'] ?? '';
    apiList = json['api_list'] ?? '';
    paramsList = json['params_list'] is! Map
        ? {}
        : (json['params_list'] as Map).map((key, value) {
            return MapEntry('$key', value);
          });
  }
}

class NaviClsModel {
  dynamic id;
  String title = '';
  bool current = false;
  dynamic sort;
  dynamic type;
  int constructId = 0;
  int style = 3;
  int isNovel = 0; // 漫画-小说
  NaviClsModel();
  NaviClsModel.fromJson(dynamic json) {
    if (json is! Map) return;
    id = json['id'];
    // display_title 显示 title 变更为 display_title
    title = json['display_title'];
    sort = json['sort'];
    constructId = json['construct_id'] ?? 0;
    style = json['style'] ?? 3;
    type = json['construct_id']; // > 0 推荐
    current = (json['default'] ?? 0) == 1;
    isNovel = json['is_novel'] ?? 0;
  }
}

///
/// 导航 - 视频
class VideoClsModel extends TabClassModel {
  VideoClsModel();
  VideoClsModel.fromJson(dynamic json) {
    if (json is! Map) return;
    current = json['current'] ?? false;
    id = json['id'];
    name = json['name'] ?? '';
    type = '${json['type']}';
    apiList = json['api_list'] ?? '';
    params = json['params_list'] is! Map
        ? {}
        : (json['params_list'] as Map)
            .map((key, value) => MapEntry('$key', value));
    api = json['api'] ?? '';
    params = json['params'] is! Map
        ? {}
        : (json['params'] as Map).map((key, value) => MapEntry('$key', value));

    showIcon = json['show_icon'] ?? false;
    midStyle = '${json['mid_style']}';
    botStyle = '${json['bot_style']}';
  }
}

class GirlClsModel extends TabClassModel {
  GirlClsModel();
  GirlClsModel.fromJson(dynamic json) {
    if (json is! Map) return;
    current = json['current'] ?? false;
    name = json['name'] ?? '';
    api = json['value'] ?? '';
    type = '${json['cate']}';
  }
}

///
/// 导航 - 漫画
class ComicClsModel extends TabClassModel {
  ComicClsModel();
  ComicClsModel.fromJson(dynamic json) {
    if (json is! Map) return;
    current = json['current'] ?? false;
    id = json['id'];
    name = json['name'] ?? '';
    type = json['type'] ?? '';
    api = json['api'] ?? '';
    showIcon = json['show_icon'] ?? false;
  }
}

///
/// 黑料
class BlackClsModel extends TabClassModel {
  BlackClsModel();
  BlackClsModel.fromJson(dynamic json) {
    if (json is! Map) return;
    current = json['current'] ?? false;
    id = json['id'];
    name = json['name'] ?? '';
    type = json['type'] ?? '';
    apiList = json['api_list'] ?? '';
    paramsList = json['params_list'] is! Map
        ? {}
        : (json['params_list'] as Map).map((key, value) {
            return MapEntry('$key', value);
          });
  }
}

class ClassItemModel {
  int? id;
  String? tabName;
  String? tagsStr;
  String? icon;
  String? subTitle;
  int? workNum;
  int? favoritesNum;
  String? bgThumb;
  String? intro;
  int? isFollow;

  ClassItemModel();

  ClassItemModel.fromJson(dynamic json) {
    if (json is! Map) return;
    id = json['id'];
    if (json['tab_id'] != null) {
      id = json['tab_id'];
    }
    tabName = json['tab_name'];
    tagsStr = json['tags_str'];
    icon = json['icon'];
    subTitle = json['sub_title'];
    workNum = json['work_num'];
    favoritesNum = json['favorites_num'];
    bgThumb = json['bg_thumb'];
    intro = json['intro'];
    isFollow = json['is_follow'];
  }
}

///
/// 样式
class StyleBaseModel<T> {
  dynamic id;
  String icon = '';
  String title = '';
  String subTitle = '';
  dynamic showStyle;
  int showMax = 0;
  bool showMore = true;
  int type = 0; // 更多【视频】
  List<T> value = [];
  void initialPropertys(dynamic json) {
    id = json['id'];
    icon = json['icon'] ?? '';
    title = json['title'] ?? '';
    subTitle = json['sub_title'] ?? '';
    showStyle = json['show_style'] ?? 0;
    showMax = json['show_max'] ?? 0;
  }
}

class VideoStyleModel<T> extends StyleBaseModel {
  int hasHyh = 0;
  VideoStyleModel();
  VideoStyleModel.fromJson(dynamic json, T Function(dynamic) fromJson) {
    if (json is! Map) return;
    id = json['id'];
    icon = json['icon'] ?? '';
    title = json['title'] ?? '';
    subTitle = json['sub_title'] ?? '';
    // showStyle = json['show_style'] ?? 0;
    showMax = json['show_max'] ?? 0;
    hasHyh = json['has_hyh'] ?? 0;
    type = json['type'] ?? 0; // 猜你喜欢 - 更多
    if (json['list'] is List) {
      value = json['list'].map<T>((i) => fromJson(i)).toList();
    }
    switch (json['show_style']) {
      case 0: // 垂直滑动 横版 - 2 * row
        showStyle = 2;
        break;
      case 1: // 水平滑动 竖版 n * 1
        showStyle = 7;
        break;
      case 2: // 垂直滑动 品字-横版
        showStyle = 5;
        break;
      case 3: // 水平滑动 横版 n * 1
        showStyle = 7;
        break;
      case 4: // 水平滑动 横版 - 小 大 小
        showStyle = 8;
        break;
      case 5: // 垂直滑动 竖版 - 3 * row
        showStyle = 4;
        break;
      case 88: // 垂直滑动 横版 - 1 * row
        showStyle = 1;
        break;
      case 99: // 垂直滑动 竖版 - 2 * row
        showStyle = 3;
        break;
      default:
    }
  }
}

///
/// 样式 - 动漫
class ComicStyleModel<T> extends StyleBaseModel {
  ComicStyleModel();
  ComicStyleModel.fromJson(dynamic json, T Function(dynamic) fromJson) {
    if (json is! Map) return;
    id = json['tab_id'];
    title = json['tab_name'];
    showMore = json['show_more'] ?? true;
    showMax = json['show_number'] ?? 0;
    if (json['items'] is List) {
      value = json['items'].map<T>((i) => fromJson(i)).toList();
    }

    switch (json['show_style']) {
      case 'V-2*N':
        showStyle = 4; // 竖滑 竖版 2 * n
        break;
      case 'V-3*N':
        showStyle = 5; // 竖滑 竖版 3 * n
        break;
      default:
        showStyle = 5; // 竖滑 竖版 3 * n
    }
  }
}

///
/// 标签分类
class TagGroupModel {
  dynamic tabId;
  String tabName = '';
  List<String> tagsAry = [];

  TagGroupModel();
  TagGroupModel.fromJson(dynamic json) {
    if (json is! Map) return;
    tabId = json['tab_id'];
    tabName = json['tab_name'];
    if (json['tags_ary'] is List) {
      tagsAry = json['tags_ary'].map<String>((i) => '$i').toList();
    }
  }
}

/// Recommended Classification Model
class ClsItemModel<T> {
  int? id;
  int? constructId;
  int type = 0;
  String ico = '';
  int? contentType;
  String title = '';
  String? secondTitle;
  String? bannerScale;
  int? moreButton;
  int? morePageShowType;
  int? maxNum;
  String? showField;
  int? changeButton;
  int? sort;
  int? isMargin;
  int? status;
  String? createdAt;
  String? updatedAt;
  List<T> value = [];
  ClsItemModel();
  ClsItemModel.fromJson(json, T Function(dynamic) fromJson) {
    if (json is! Map) return;
    id = json['id'];
    constructId = json['construct_id'];
    type = json['type'] ?? 0;
    ico = json['ico'] ?? '';
    contentType = json['content_type'];
    title = json['title'] ?? '';
    secondTitle = json['second_title'];
    bannerScale = json['banner_scale'];
    moreButton = json['more_button'];
    morePageShowType = json['more_page_show_type'];
    maxNum = json['max_num'];
    showField = json['show_field'];
    changeButton = json['change_button'];
    sort = json['sort'];
    isMargin = json['is_margin'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['value'] is List) {
      value = json['value'].map<T>((i) => fromJson(i)).toList();
    }
  }
}

class TopicModel {
  dynamic id;
  String title = '';
  String desc = '';
  String background = '';
  String? tag;
  int? type;
  int? contentType;
  int? status;
  int? sort;
  String? createdAt;
  String? updatedAt;
  TopicModel();
  TopicModel.fromJson(dynamic json) {
    if (json is! Map) return;
    id = json['id'];
    title = json['title'] ?? '';
    desc = json['desc'] ?? '';
    background = json['background'] ?? '';
    tag = json['tag'];
    type = json['type'];
    contentType = json['content_type'];
    status = json['status'];
    sort = json['sort'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}

class StoreItemModel {
  int? uid;
  int? videoNumber;
  int? girlMeetNumber;
  int? girlChatNumber;
  dynamic gCoins;
  dynamic totalGCoins;
  dynamic videoCoins;
  dynamic videoTotalCoins;
  dynamic chatCoins;
  dynamic chatTotalCoins;

  StoreItemModel();
  StoreItemModel.fromJson(Map json) {
    uid = json["uid"];
    videoNumber = json["video_number"];
    girlMeetNumber = json["girl_meet_number"];
    girlChatNumber = json["girl_chat_number"];
    gCoins = json["g_coins"];
    totalGCoins = json["total_g_coins"];
    videoCoins = json["video_coins"];
    videoTotalCoins = json["video_total_coins"];
    chatCoins = json["chat_coins"];
    chatTotalCoins = json["chat_total_coins"];
  }
}
