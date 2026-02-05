class AppVideoModel {
  int id;
  String fanId;
  int uid;
  int coins;
  String title;
  int duration;
  int thumbWidth;
  int thumbHeight;
  int rating;
  int refreshAt;
  int isFree;
  int like;
  int comment;
  int type;
  int isAw;
  int isOriginal;
  int favoriteNum;
  int isPay;
  String playUrl;
  String payUrlFull;
  int myTicketNumber;
  List<String> tagsList;
  String tagsId;
  String tags;
  String coverThumbUrl;
  String coverHorizontal;
  String createdStr;
  int isLike;
  String durationStr;
  String isFreeStr;
  int typeNew;
  int isFavorite;
  int playNum;
  String source240;

  String? description;
  String? subTitle;
  String url;

  int crackAppType;

  int? adType;
  String? adSlotName;
  String? advertiseCode;
  String? advertiseLocationCode;

  AppVideoModel({
    this.id = 0,
    this.fanId = '',
    this.uid = 0,
    this.coins = 0,
    this.title = '',
    this.duration = 0,
    this.thumbWidth = 0,
    this.thumbHeight = 0,
    this.rating = 0,
    this.refreshAt = 0,
    this.isFree = 0,
    this.like = 0,
    this.comment = 0,
    this.type = 0,
    this.isAw = 0,
    this.isOriginal = 0,
    this.favoriteNum = 0,
    this.isPay = 0,
    this.playUrl = '',
    this.source240 = '',
    this.payUrlFull = '',
    this.myTicketNumber = 0,
    this.tagsList = const [],
    this.tags = '',
    this.tagsId = '',
    this.coverThumbUrl = '',
    this.coverHorizontal = '',
    this.createdStr = '',
    this.isLike = 0,
    this.durationStr = '',
    this.isFreeStr = '',
    this.typeNew = 0,
    this.isFavorite = 0,
    this.playNum = 0,
    this.description,
    this.subTitle,
    this.url = '',
    this.crackAppType = 0,
    this.adType = 0,
    this.adSlotName = '',
    this.advertiseCode = '',
    this.advertiseLocationCode = '',
  });

  factory AppVideoModel.fromJson(Map<String, dynamic> json) {
    return AppVideoModel(
        id: json['id'] ?? 0,
        fanId: json['fan_id'] ?? '',
        uid: json['uid'] ?? 0,
        coins: json['coins'] ?? 0,
        title: json['title'] ?? '',
        duration: json['duration'] ?? 0,
        thumbWidth: json['thumb_width'] ?? 0,
        thumbHeight: json['thumb_height'] ?? 0,
        rating: json['rating'] ?? 0,
        refreshAt: json['refresh_at'] ?? 0,
        isFree: json['is_free'] ?? 0,
        like: json['like'] ?? 0,
        comment: json['comment'] ?? 0,
        type: json['type'] ?? 0,
        isAw: json['is_aw'] ?? 0,
        isOriginal: json['is_original'] ?? 0,
        favoriteNum: json['favorite_num'] ?? 0,
        isPay: json['is_pay'] ?? 0,
        playUrl: json['play_url'] ?? '',
        source240: json['source_240'] ?? '',
        playNum: json['play_num'] ?? 0,
        payUrlFull: json['pay_url_full'] ?? '',
        myTicketNumber: json['my_ticket_number'] ?? 0,
        tagsList: List<String>.from(json['tags_list']?.map((x) => x) ?? []),
        tags: json['tags'] ?? '',
        tagsId: json['tags_id'] ?? '',
        coverThumbUrl: json['cover_thumb_url'] ?? '',
        coverHorizontal: json['cover_horizontal'] ?? '',
        createdStr: json['created_str'] ?? '',
        isLike: json['is_like'] ?? 0,
        durationStr: json['duration_str'] ?? '',
        isFreeStr: json['is_free_str'] ?? '',
        typeNew: json['type_new'] ?? 0,
        isFavorite: json['is_favorite'] ?? 0,
        description: json['description'] ?? '',
        subTitle: json['sub_title'] ?? '',
        url: json['url'] ?? '',
        crackAppType: json['crack_app_type'] ?? 0,
        adType: json['ad_type'] ?? 0,
        adSlotName: json['ad_slot_name'] ?? '',
        advertiseCode: json['advertise_code'] ?? '',
        advertiseLocationCode: json['advertise_location_code'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fan_id': fanId,
      'uid': uid,
      'coins': coins,
      'title': title,
      'duration': duration,
      'thumb_width': thumbWidth,
      'thumb_height': thumbHeight,
      'rating': rating,
      'refresh_at': refreshAt,
      'is_free': isFree,
      'like': like,
      'comment': comment,
      'type': type,
      'is_aw': isAw,
      'is_original': isOriginal,
      'favorite_num': favoriteNum,
      'is_pay': isPay,
      'play_url': playUrl,
      'source_240': source240,
      'play_num': playNum,
      'pay_url_full': payUrlFull,
      'my_ticket_number': myTicketNumber,
      'tags_list': tagsList,
      'tags_id': tagsId,
      'tags': tags,
      'cover_thumb_url': coverThumbUrl,
      'cover_horizontal': coverHorizontal,
      'created_str': createdStr,
      'is_like': isLike,
      'duration_str': durationStr,
      'is_free_str': isFreeStr,
      'type_new': typeNew,
      'is_favorite': isFavorite,
      'description': description,
      'sub_title': subTitle,
      'url': url,
      'crack_app_type': crackAppType,
      'ad_type': adType,
      'ad_slot_name': adSlotName,
      'advertise_code': advertiseCode,
      'advertise_location_code': advertiseLocationCode,
    };
  }

  AppVideoModel copyWith({
    int? id,
    String? fanId,
    int? uid,
    int? coins,
    String? title,
    int? duration,
    int? thumbWidth,
    int? thumbHeight,
    int? rating,
    int? refreshAt,
    int? isFree,
    int? like,
    int? comment,
    int? type,
    int? isAw,
    int? isOriginal,
    int? favoriteNum,
    String? playUrl,
    int? playNum,
    String? payUrlFull,
    int? myTicketNumber,
    List<String>? tagsList,
    String? coverThumbUrl,
    String? createdStr,
    int? isLike,
    String? durationStr,
    String? isFreeStr,
    int? typeNew,
    int? isFavorite,
    String? description,
    String? subTitle,
    String? url,
    int? crackAppType,
    int? adType,
    String? adSlotName,
    String? advertiseCode,
    String? advertiseLocationCode,
  }) {
    return AppVideoModel(
      id: id ?? this.id,
      fanId: fanId ?? this.fanId,
      uid: uid ?? this.uid,
      coins: coins ?? this.coins,
      title: title ?? this.title,
      duration: duration ?? this.duration,
      thumbWidth: thumbWidth ?? this.thumbWidth,
      thumbHeight: thumbHeight ?? this.thumbHeight,
      rating: rating ?? this.rating,
      refreshAt: refreshAt ?? this.refreshAt,
      isFree: isFree ?? this.isFree,
      like: like ?? this.like,
      comment: comment ?? this.comment,
      type: type ?? this.type,
      isAw: isAw ?? this.isAw,
      isOriginal: isOriginal ?? this.isOriginal,
      favoriteNum: favoriteNum ?? this.favoriteNum,
      playUrl: playUrl ?? this.playUrl,
      playNum: playNum ?? this.playNum,
      payUrlFull: payUrlFull ?? this.payUrlFull,
      myTicketNumber: myTicketNumber ?? this.myTicketNumber,
      tagsList: tagsList ?? this.tagsList,
      coverThumbUrl: coverThumbUrl ?? this.coverThumbUrl,
      createdStr: createdStr ?? this.createdStr,
      isLike: isLike ?? this.isLike,
      durationStr: durationStr ?? this.durationStr,
      isFreeStr: isFreeStr ?? this.isFreeStr,
      typeNew: typeNew ?? this.typeNew,
      isFavorite: isFavorite ?? this.isFavorite,
      description: description ?? this.description,
      subTitle: subTitle ?? this.subTitle,
      url: url ?? this.url,
      crackAppType: crackAppType ?? this.crackAppType,
      adType: adType ?? this.adType,
      adSlotName: adSlotName ?? this.adSlotName,
      advertiseCode: advertiseCode ?? this.advertiseCode,
      advertiseLocationCode: advertiseLocationCode ?? this.advertiseLocationCode,
    );
  }
}

class AppSearchHotModel {
  String title;
  String num;
  int rank;

  AppSearchHotModel({
    this.title = '',
    this.num = '',
    this.rank = 0,
  });

  factory AppSearchHotModel.fromJson(Map<String, dynamic> json) {
    return AppSearchHotModel(
      title: json['title'] ?? '',
      num: json['num'] ?? '',
      rank: json['rank'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'num': num,
      'rank': rank,
    };
  }
}

class AppMidStyleUpModel {
  final String title;
  final int groupId;
  final List<MidStyleUpListModel> list;

  AppMidStyleUpModel({
    this.title = '',
    this.groupId = 0,
    this.list = const [],
  });

  factory AppMidStyleUpModel.fromJson(Map<String, dynamic> json) {
    return AppMidStyleUpModel(
      title: json['title'] ?? '',
      groupId: json['group_id'] ?? 0,
      list: json['list'] != null ? List<MidStyleUpListModel>.from(json['list'].map((e) => MidStyleUpListModel.fromJson(e))) : [],
    );
  }
}

class MidStyleUpListModel {
  int uid;
  String nickname;
  String desc;
  int fansCount;
  int videos;
  String thumbFull;

  MidStyleUpListModel({
    this.uid = 0,
    this.nickname = '',
    this.desc = '',
    this.fansCount = 0,
    this.videos = 0,
    this.thumbFull = '',
  });

  factory MidStyleUpListModel.fromJson(Map<String, dynamic> json) {
    return MidStyleUpListModel(
      uid: json['uid'] ?? 0,
      nickname: json['nickname'] ?? '',
      desc: json['desc'] ?? '',
      fansCount: json['fans_count'] ?? 0,
      videos: json['videos'] ?? 0,
      thumbFull: json['thumb_full'] ?? '',
    );
  }
}
