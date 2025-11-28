class HomeAdsModel {
  final List<TopAdsModel> top;
  final List<TopAdsModel> bottom;

  HomeAdsModel({required this.top, required this.bottom});

  factory HomeAdsModel.fromJson(Map<String, dynamic> json) {
    return HomeAdsModel(
      top: List.from(json['top'].map((e) => TopAdsModel.fromJson(e))),
      bottom: List.from(json['bottom'].map((e) => TopAdsModel.fromJson(e))),
    );
  }
}

class TopAdsModel {
  final int id;
  final String description;
  final String imgUrl;
  final String urlConfig;
  final String title;
  final int position;
  final String? androidDownUrl;
  final String? iosDownUrl;
  final int type;
  final int status;
  final int oauthType;
  final String mvM3u8;
  final String channel;
  final String createAt;
  final String router;
  final String startAt;
  final String endAt;
  final int clicked;
  final int sort;
  final String urlStr;
  final String linkUrl;
  final String url;
  final String resourceUrl;
  final int redirectType;
  final int reportId;
  final int reportType;

  const TopAdsModel({
    this.id = 0,
    this.description = '',
    this.imgUrl = '',
    this.urlConfig = '',
    this.position = 0,
    this.title = '',
    this.androidDownUrl = '',
    this.iosDownUrl = '',
    this.type = 0,
    this.status = 0,
    this.oauthType = 0,
    this.mvM3u8 = '',
    this.channel = '',
    this.createAt = '',
    this.router = '',
    this.startAt = '',
    this.endAt = '',
    this.clicked = 0,
    this.sort = 0,
    this.urlStr = '',
    this.linkUrl = '',
    this.url = '',
    this.resourceUrl = '',
    this.redirectType = 0,
    this.reportId = 0,
    this.reportType = 0,
  });

  factory TopAdsModel.fromJson(Map<String, dynamic> json) {
    return TopAdsModel(
      id: json['id'] ?? 0,
      description: json['description'] ?? '',
      imgUrl: json['img_url'] ?? '',
      urlConfig: json['url_config'] ?? '',
      position: json['position'] ?? 0,
      title: json['title'] ?? 0,
      androidDownUrl: json['android_down_url'] ?? '',
      iosDownUrl: json['ios_down_url'] ?? '',
      type: json['type'] ?? 0,
      status: json['status'] ?? 0,
      oauthType: json['oauth_type'] ?? 0,
      mvM3u8: json['mv_m3u8'] ?? '',
      channel: json['channel'] ?? '',
      createAt: json['create_at'] ?? '',
      router: json['router'] ?? '',
      startAt: json['start_at'] ?? '',
      endAt: json['end_at'] ?? '',
      clicked: json['clicked'] ?? 0,
      sort: json['sort'] ?? 0,
      urlStr: json['url_str'] ?? '',
      linkUrl: json['link_url'] ?? '',
      url: json['url'] ?? '',
      resourceUrl: json['resource_url'] ?? '',
      redirectType: json['redirect_type'] ?? 0,
      reportId: json['report_id'] ?? 0,
      reportType: json['report_type'] ?? 0,
    );
  }
}

// class BottomAdsModel extends TopAdsModel {
//   final String title;
//
//   const BottomAdsModel({
//     this.title = '',
//     // 继承父类的所有参数，使用 super 关键字传递
//     super.id,
//     super.description,
//     super.imgUrl,
//     super.urlConfig,
//     super.position,
//     super.androidDownUrl = null,
//     super.iosDownUrl = null,
//     super.type,
//     super.status,
//     super.oauthType,
//     super.mvM3u8,
//     super.channel,
//     super.createAt,
//     super.router,
//     super.startAt,
//     super.endAt,
//     super.clicked,
//     super.sort,
//     super.urlStr,
//     super.linkUrl,
//     super.url,
//     super.resourceUrl,
//     super.redirectType,
//     super.reportId,
//     super.reportType,
//   });
//
//   // 工厂构造函数，从 JSON 创建 BottomAdsModel
//   factory BottomAdsModel.fromJson(Map<String, dynamic> json) {
//     return BottomAdsModel(
//       title: json['title'] ?? '',
//       id: json['id'] ?? 0,
//       description: json['description'] ?? '',
//       imgUrl: json['img_url'] ?? '',
//       urlConfig: json['url_config'] ?? '',
//       position: json['position'] ?? 0,
//       androidDownUrl: json['android_down_url'] ?? '',
//       iosDownUrl: json['ios_down_url'] ?? '',
//       type: json['type'] ?? 0,
//       status: json['status'] ?? 0,
//       oauthType: json['oauth_type'] ?? 0,
//       mvM3u8: json['mv_m3u8'] ?? '',
//       channel: json['channel'] ?? '',
//       createAt: json['create_at'] ?? '',
//       router: json['router'] ?? '',
//       startAt: json['start_at'] ?? '',
//       endAt: json['end_at'] ?? '',
//       clicked: json['clicked'] ?? 0,
//       sort: json['sort'] ?? 0,
//       urlStr: json['url_str'] ?? '',
//       linkUrl: json['link_url'] ?? '',
//       url: json['url'] ?? '',
//       resourceUrl: json['resource_url'] ?? '',
//       redirectType: json['redirect_type'] ?? 0,
//       reportId: json['report_id'] ?? 0,
//       reportType: json['report_type'] ?? 0,
//     );
//   }
//
//   // 可选：添加拷贝方法，方便创建修改后的实例
//   BottomAdsModel copyWith({
//     String? title,
//     int? id,
//     String? description,
//     String? imgUrl,
//     String? urlConfig,
//     int? position,
//     String? androidDownUrl,
//     String? iosDownUrl,
//     int? type,
//     int? status,
//     int? oauthType,
//     String? mvM3u8,
//     String? channel,
//     String? createAt,
//     String? router,
//     String? startAt,
//     String? endAt,
//     int? clicked,
//     int? sort,
//     String? urlStr,
//     String? linkUrl,
//     String? url,
//     String? resourceUrl,
//     int? redirectType,
//     int? reportId,
//     int? reportType,
//   }) {
//     return BottomAdsModel(
//       title: title ?? this.title,
//       id: id ?? this.id,
//       description: description ?? this.description,
//       imgUrl: imgUrl ?? this.imgUrl,
//       urlConfig: urlConfig ?? this.urlConfig,
//       position: position ?? this.position,
//       androidDownUrl: androidDownUrl ?? this.androidDownUrl,
//       iosDownUrl: iosDownUrl ?? this.iosDownUrl,
//       type: type ?? this.type,
//       status: status ?? this.status,
//       oauthType: oauthType ?? this.oauthType,
//       mvM3u8: mvM3u8 ?? this.mvM3u8,
//       channel: channel ?? this.channel,
//       createAt: createAt ?? this.createAt,
//       router: router ?? this.router,
//       startAt: startAt ?? this.startAt,
//       endAt: endAt ?? this.endAt,
//       clicked: clicked ?? this.clicked,
//       sort: sort ?? this.sort,
//       urlStr: urlStr ?? this.urlStr,
//       linkUrl: linkUrl ?? this.linkUrl,
//       url: url ?? this.url,
//       resourceUrl: resourceUrl ?? this.resourceUrl,
//       redirectType: redirectType ?? this.redirectType,
//       reportId: reportId ?? this.reportId,
//       reportType: reportType ?? this.reportType,
//     );
//   }
//
//   // 可选：重写 toString 方法，方便调试
//   @override
//   String toString() {
//     return 'BottomAdsModel{title: $title, id: $id, description: $description}';
//   }
//
//   // 可选：重写 == 操作符和 hashCode，用于比较
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//           other is BottomAdsModel &&
//               runtimeType == other.runtimeType &&
//               title == other.title &&
//               id == other.id;
//
//   @override
//   int get hashCode => title.hashCode ^ id.hashCode;
// }
