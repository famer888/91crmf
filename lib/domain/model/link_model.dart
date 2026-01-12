class LinkModel {
  LinkModel({
    required this.id,
    this.relatedId = 0,
    this.elementId = 0,
    this.linkUrl = '',
    this.resourceUrl = '',
    this.redirectType = 0,
    this.name = '',
    this.desc = '',
    this.type = 0,
    this.sort = 0,
    this.createdAt = '',
    this.updatedAt = '',
    this.api = '',
    required this.params,
    this.uiType = 0,
    this.isNavPrepend = false,
    this.current = false,
    this.midStyle = 0,
    this.botStyle = 0,
    this.showIcon = false,
  });

  int id;
  int relatedId;
  int elementId;
  String linkUrl;
  String resourceUrl;
  int redirectType;
  String name;
  int type;
  String desc;
  int sort;
  String createdAt;
  String updatedAt;
  String api;
  Map params;
  int uiType;
  bool isNavPrepend;
  bool current;
  int midStyle;
  int botStyle;
  bool showIcon;

  factory LinkModel.fromJson(Map<String, dynamic> json) => LinkModel(
        id: json['id'],
        relatedId: json['related_id'] ?? 0,
        elementId: json['element_id'] ?? 0,
        current: json['current'] ?? false,
        linkUrl: json['link_url'] ?? '',
        resourceUrl: json['resource_url'] ?? '',
        redirectType: json['redirect_type'] ?? 0,
        name: json['name'] ?? '',
        type: json['type'] ?? 0,
        desc: json['desc'] ?? '',
        sort: json['sort'] ?? 0,
        createdAt: json['created_at'] ?? '',
        updatedAt: json['updated_at'] ?? '',
        api: json['api'] ?? '',
        params: json['params'],
        uiType: json['ui_type'] ?? 0,
        midStyle: json['mid_style'] ?? 0,
        botStyle: json['bot_style'] ?? 0,
        showIcon: json['show_icon'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'related_id': relatedId,
        'element_id': elementId,
        'link_url': linkUrl,
        'resource_url': resourceUrl,
        'redirect_type': redirectType,
        'name': name,
        'type': type,
        'desc': desc,
        'sort': sort,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'api': api,
        'params': params,
        'ui_type': uiType,
        'current': current,
        'mid_style': midStyle,
        'bot_style': botStyle,
        'show_icon': showIcon,
      };
}
