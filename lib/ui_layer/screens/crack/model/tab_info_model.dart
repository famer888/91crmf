class TabInfoModel {
  int tabId;
  String tabName;
  String tagsStr;
  String icon;
  String subTitle;
  int workNum;
  int favoritesNum;
  String bgThumb;
  String intro;
  int rating;
  bool isFollow;

  TabInfoModel({
    this.tabId = 0,
    this.tabName = '',
    this.tagsStr = '',
    this.icon = '',
    this.subTitle = '',
    this.workNum = 0,
    this.favoritesNum = 0,
    this.bgThumb = '',
    this.intro = '',
    this.rating = 0,
    this.isFollow = false,
  });

  factory TabInfoModel.fromJson(Map<String, dynamic> json) {
    return TabInfoModel(
      tabId: json['tab_id'] ?? 0,
      tabName: json['tab_name'] ?? '',
      tagsStr: json['tags_str'] ?? '',
      icon: json['icon'] ?? '',
      subTitle: json['sub_title'] ?? '',
      workNum: json['work_num'] ?? 0,
      favoritesNum: json['favorites_num'] ?? 0,
      bgThumb: json['bg_thumb'] ?? '',
      intro: json['intro'] ?? '',
      rating: json['rating'] ?? 0,
      isFollow: (json['is_follow'] ?? 0) > 0,
    );
  }
}