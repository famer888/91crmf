class NavModel {
  final int id;
  final int relatedId;
  final int elementId;
  final String linkUrl;
  final String resourceUrl;
  final int redirectType;
  final String name;
  final String desc;
  final int sort;
  final String createdAt;
  final String updatedAt;
  final String router;
  final int openType;
  final String urlStr;

  NavModel({
    required this.id,
    this.relatedId = 0,
    this.elementId = 0,
    required this.linkUrl,
    required this.resourceUrl,
    required this.redirectType,
    required this.name,
    required this.desc,
    this.sort = 0,
    this.createdAt = '',
    this.updatedAt = '',
    required this.router,
    required this.openType,
    this.urlStr = '',
  });

  factory NavModel.fromJson(Map<String, dynamic> json) => NavModel(
        id: json['id'],
        relatedId: json['related_id'] ?? 0,
        elementId: json['element_id'] ?? 0,
        linkUrl: json['link_url'],
        resourceUrl: json['resource_url'],
        redirectType: json['redirect_type'],
        name: json['name'],
        desc: json['desc'],
        sort: json['sort'] ?? 0,
        createdAt: json['created_at'] ?? '',
        updatedAt: json['updated_at'] ?? '',
        router: json['router'],
        openType: json['open_type'],
        urlStr: json['url_str'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'related_id': relatedId,
        'element_id': elementId,
        'link_url': linkUrl,
        'resource_url': resourceUrl,
        'redirect_type': redirectType,
        'name': name,
        'desc': desc,
        'sort': sort,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'router': router,
        'open_type': openType,
        'url_str': urlStr,
      };
}
