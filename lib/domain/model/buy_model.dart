class BuyAppModel {
  final int paid;
  final String message;

  BuyAppModel({
    required this.paid,
    required this.message,
  });

  factory BuyAppModel.fromJson(Map<String, dynamic> json) {
    return BuyAppModel(
      paid: json['paid'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paid': paid,
      'message': message,
    };
  }

}

class BuyModel {
  List<BuyItemModel> data;

  BuyModel({
    required this.data,
  });

  factory BuyModel.fromJson(Map<String, dynamic> json) {
    return BuyModel(
      data: List<BuyItemModel>.from(json['data']?.map((app) => BuyItemModel.fromJson(app))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((i) => i.toJson()).toList(),
    };
  }
}

class BuyItemModel {
  final int id;
  final String appName;
  final int type;
  final int relatedId;
  final String createdAt;
  final AppModel? app;
  final Content? content;

  BuyItemModel({
    required this.id,
    required this.appName,
    required this.type,
    required this.relatedId,
    required this.createdAt,
    this.app,
    this.content,
  });

  factory BuyItemModel.fromJson(Map<String, dynamic> json) {
    return BuyItemModel(
      id: json['id'],
      appName: json['app_name'],
      type: json['type'],
      relatedId: json['related_id'],
      createdAt: json['created_at'],
      app: json['app'] != null ? AppModel.fromJson(json['app']) : null,
      content: json['content'] != null ? Content.fromJson(json['content']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'app_name': appName,
      'type': type,
      'related_id': relatedId,
      'created_at': createdAt,
      'app': app?.toJson(),
      'content': content?.toJson(),
    };
  }
}

class Content {
  final int? id;
  final String? title;
  final String? thumb;
  final bool? isLike;
  final bool? isFavorite;
  final bool? isPay;
  final bool? isNew;
  final bool? isHot;
  final bool? needVip;

  Content({
    this.id,
    this.title,
    this.thumb,
    this.isLike,
    this.isFavorite,
    this.isPay,
    this.isNew,
    this.isHot,
    this.needVip,
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      id: json['id'],
      title: json['title'],
      thumb: json['thumb'],
      isLike: (json['is_like'] ?? 0) > 0,
      isFavorite: (json['is_favorite'] ?? 0) > 0,
      isPay: (json['is_pay'] ?? 0) > 0,
      isNew: (json['is_new'] ?? 0) > 0,
      isHot: (json['is_hot'] ?? 0) > 0,
      needVip: (json['need_vip'] ?? 0) > 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'thumb': thumb,
      'is_like': isLike,
      'is_favorite': isFavorite,
      'is_pay': isPay,
      'is_new': isNew,
      'is_hot': isHot,
      'need_vip': needVip,
    };
  }
}

class AppModel {
  final int id;
  final String title;
  final String appName;
  final String logo;

  AppModel({
    required this.id,
    required this.title,
    required this.appName,
    required this.logo,
  });

  factory AppModel.fromJson(Map<String, dynamic> json) {
    return AppModel(
      id: json['id'],
      title: json['title'],
      appName: json['app_name'],
      logo: json['logo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'app_name': appName,
      'logo': logo,
    };
  }
}
