class CategoryTopicModel {
  final int id;
  final int tabId;
  final String icon;
  final String bgThumb;
  final String tabName;
  final int workNum;
  final int favoritesNum;
  bool isFollow;

  final List<dynamic> tagsArray;

  // 兼容福利姬 增加的字段
  int midStyleType;
  int groupId;
  String title;

  CategoryTopicModel({
    this.id = 0,
    this.tabId = 0,
    this.icon = '',
    this.bgThumb = '',
    this.tabName = '',
    this.workNum = 0,
    this.favoritesNum = 0,
    this.isFollow = false,
    this.midStyleType = 0,
    this.groupId = 0,
    this.title = '',
    this.tagsArray = const [],
  });

  factory CategoryTopicModel.fromJson(Map<String, dynamic> json) {
    return CategoryTopicModel(
      id: json['id'] ?? 0,
      tabId: json['tab_id'] ?? 0,
      icon: json['icon'] ?? '',
      bgThumb: json['bg_thumb'] ?? '',
      tabName: json['tab_name'] ?? '',
      workNum: json['work_num'] ?? 0,
      favoritesNum: json['favorites_num'] ?? 0,
      isFollow: (json['is_follow'] ?? 0) > 0,
      midStyleType: json['mid_style_type'] ?? 0,
      groupId: json['group_id'] ?? 0,
      title: json['title'] ?? '',
      tagsArray: json['tags_ary'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tab_id': tabId,
      'icon': icon,
      'bg_thumb': bgThumb,
      'tab_name': tabName,
      'work_num': workNum,
      'favorites_num': favoritesNum,
      'is_follow': isFollow ? 1 : 0,
      'mid_style_type': midStyleType,
      'group_id': groupId,
      'title': title,
      'tags_ary': tagsArray,
    };
  }
}