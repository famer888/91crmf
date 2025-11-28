class BannerModel {
  final int id;
  final String linkUrl;
  final String resourceUrl;
  final int redirectType;
  final String? title;
  final String? name;
  final String? desc;
  final String router;
  final int? openType;
  final int? fId;
  final int reportId;
  final int reportType;
  final String urlStr;

  BannerModel(
      {required this.id,
      required this.linkUrl,
      required this.resourceUrl,
      required this.redirectType,
      this.title,
      this.name,
      this.desc,
      required this.router,
      this.openType,
      this.fId,
      required this.reportId,
      required this.reportType,
      required this.urlStr});

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
      id: json['id'],
      linkUrl: json['link_url'],
      resourceUrl: json['resource_url'],
      redirectType: json['redirect_type'],
      title: json['title'],
      name: json['name'],
      desc: json['desc'],
      router: json['router'] ?? '',
      openType: json['open_type'],
      fId: json['f_id'],
      reportId: json['report_id'],
      reportType: json['report_type'],
      urlStr: json['url_str'] ?? '');

  Map<String, dynamic> toJson() => {
        'id': id,
        'link_url': linkUrl,
        'resource_url': resourceUrl,
        'redirect_type': redirectType,
        'title': title,
        'desc': desc,
        'router': router,
        'open_type': openType,
        'f_id': fId,
        'report_id': reportId,
        'report_type': reportType,
        'url_str': urlStr,
      };
}
