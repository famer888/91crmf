class BannerModel {
  final int id;
  final String resourceUrl;
  final String? name;
  final String? desc;
  final String router;
  final int reportId;
  final int reportType;
  final int? openType;
  final int? fId;
  final int? adType;
  final String? adSlotName;
  final String? advertiseCode;
  final String? advertiseLocationCode;
  final String urlStr;
  final String linkUrl;
  final int redirectType;
  final String? title;

  BannerModel({
    required this.id,
    this.resourceUrl = '',
    this.name,
    this.desc,
    this.router = '',
    this.reportId = 0,
    this.reportType = 0,
    this.openType,
    this.fId,
    this.adType,
    this.adSlotName,
    this.advertiseCode,
    this.advertiseLocationCode,
    this.urlStr = '',
    this.linkUrl = '',
    this.redirectType = 0,
    this.title,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
      id: json['id'],
      linkUrl: json['link_url'] ?? '',
      resourceUrl: json['resource_url'] ?? '',
      redirectType: json['redirect_type'] ?? 0,
      title: json['title'],
      name: json['name'],
      desc: json['desc'] ?? '',
      router: json['router'] ?? '',
      openType: json['open_type'] ?? 0,
      fId: json['f_id'] ?? 0,
      reportId: json['report_id'] ?? 0,
      reportType: json['report_type'] ?? 0,
      urlStr: json['url_str'] ?? '',
      adType: json['ad_type'] ?? 0,
      adSlotName: json['ad_slot_name'] ?? '',
      advertiseCode: json['advertise_code'] ?? '',
      advertiseLocationCode: json['advertise_location_code'] ?? '',
  );

  Map<String, dynamic> toJson() => {
        'id': id,
        'link_url': linkUrl,
        'resource_url': resourceUrl,
        'redirect_type': redirectType,
        'title': title,
        'name': name,
        'desc': desc,
        'router': router,
        'open_type': openType,
        'f_id': fId,
        'report_id': reportId,
        'report_type': reportType,
        'url_str': urlStr,
        'ad_type': adType,
        'ad_slot_name': adSlotName,
        'advertise_code': advertiseCode,
        'advertise_location_code': advertiseLocationCode,
      };
}
