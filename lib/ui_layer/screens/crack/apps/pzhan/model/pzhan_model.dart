class PZhanVideoModel {
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

  PZhanVideoModel({
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

  factory PZhanVideoModel.fromJson(Map<String, dynamic> json) {
    return PZhanVideoModel(
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

  PZhanVideoModel copyWith({
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
    return PZhanVideoModel(
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

class PZhanSearchHotModel {
  String title;
  String num;
  int rank;

  PZhanSearchHotModel({
    this.title = '',
    this.num = '',
    this.rank = 0,
  });

  factory PZhanSearchHotModel.fromJson(Map<String, dynamic> json) {
    return PZhanSearchHotModel(
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

class PZhanCategoryTopicModel {
  final int id;
  final int tabId;
  final String icon;
  final String bgThumb;
  final String tabName;
  final int workNum;
  final int favoritesNum;
  final bool isFollow;

  // 兼容福利姬 增加的字段
  int midStyleType;
  int groupId;
  String title;

  PZhanCategoryTopicModel({
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
  });

  factory PZhanCategoryTopicModel.fromJson(Map<String, dynamic> json) {
    return PZhanCategoryTopicModel(
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
    };
  }
}

/*
mid_style_up: {title: 热门福利姬, group_id: 2,
 list: [{uid: 103, nickname: 芋圆呀呀, desc: , fans_count: 0, videos: 0, thumb_full: https://new.fgibqt.cn//new/xiao/20201117/2020111718131473778.png},
 {uid: 108, nickname: 爆机少女喵小吉, desc: , fans_count: 0, videos: 0, thumb_full: https://new.fgibqt.cn//new/xiao/20201117/2020111718121175287.png},
  {uid: 102, nickname: 白桃少女, desc: , fans_count: 0, videos: 0, thumb_full: https://new.fgibqt.cn//new/xiao/20201117/2020111718103034588.png},
   {uid: 104, nickname: 米娜学姐, desc: , fans_count: 0, videos: 0, thumb_full: https://new.fgibqt.cn//new/xiao/20201117/2020111718103034588.png},
    {uid: 127, nickname: 布丁大法, desc: , fans_count: 0, videos: 0, thumb_full: https://new.fgibqt.cn//new/xiao/20201117/2020111718123176813.png},
     {uid: 105, nickname: 麻酥酥, desc: , fans_count: 0, videos: 0, thumb_full: https://new.fgibqt.cn//new/xiao/20201117/2020111718130364920.png},
      {uid: 109, nickname: 小尤奈, desc: , fans_count: 0, videos: 0, thumb_full: https://new.fgibqt.cn//new/xiao/20201117/2020111718110525410.png},
      {uid: 120, nickname: 占星猫, desc: , fans_count: 0, videos: 0, thumb_full: https://new.fgibqt.cn//new/xiao/20201117/2020111718130364920.png},
      {uid: 107, nickname: 八月未央, desc: , fans_count: 0, videos: 0, thumb_full: https://new.fgibqt.cn//new/xiao/20201117/2020111718104250323.png},
       {uid: 117, nickname: 小丁, desc: , fans_count: 0, videos: 0, thumb_full: https://new.fgibqt.cn//new/xiao/20201117/2020111718122168304.png},
       {uid: 106, nickname: 抖娘利世, desc: , fans_count: 0, videos: 0, thumb_full: https://new.fgibqt.cn//new/xiao/20201117/2020111718103034588.png},
        {uid: 115, nickname: 狗头萝莉, desc: , fans_count: 0, videos: 0, thumb_full: https://new.fgibqt.cn//new/xiao/20201117/2020111718131473778.png},
         {uid: 101, nickname: 樱井宁宁, desc: , fans_count: 0, videos: 0, thumb_full: https://new.fgibqt.cn//new/xiao/20201117/2020111718124397110.png},
          {uid: 116, nickname: 萌白酱, desc: , fans_count: 0, videos: 0, thumb_full: https://new.fgibqt.cn//new/xiao/20201117/2020111718125288438.png},
           {uid: 113, nickname: 米胡桃, desc: , fans_count: 0, videos: 0, thumb_full: https://new.fgibqt.cn//new/xiao/20201117/2020111718123176813.png},
            {uid: 118, nickname: 习呆呆, desc: , fans_count: 0, videos: 0, thumb_full: https://new.fgibqt.cn//new/xiao/20201117/2020111718123176813.png},
             {uid: 111, nickname: 芋喵喵, desc: , fans_count: 0, videos: 0, thumb_full: https://new.fgibqt.cn//new/xiao/20201117/2020111718105627574.png},
              {uid: 110, nickname: 发条少女, desc: , fans_count: 0, videos: 0, thumb_full: https://new.fgibqt.cn//new/xiao/20201117/2020111718122168304.png},
               {uid: 114, nickname: 吟吟娘, desc: , fans_count: 0, videos: 0, thumb_full: https://new.fgibqt.cn//new/xiao/20201117/2020111718121175287.png},
                {uid: 112, nickname: 奈汐酱, desc: , fans_count: 0, videos: 0, thumb_full: https://new.fgibqt.cn//new/xiao/20201117/2020111718123176813.png},
                {uid: 119, nickname: 桃谷谷, desc: , fans_count: 0, videos: 0, thumb_full: https://new.fgibqt.cn//new/xiao/20201117/2020111718110525410.png},
                 {uid: 126, nickname: 奶萝喵四, desc: , fans_count: 0, videos: 0, thumb_full: https://new.fgibqt.cn//new/xiao/20201117/2020111718110525410.png}]},
 */
class PZhanMidStyleUpModel {
  final String title;
  final int groupId;
  final List<MidStyleUpListModel> list;

  PZhanMidStyleUpModel({
    this.title = '',
    this.groupId = 0,
    this.list = const [],
  });

  factory PZhanMidStyleUpModel.fromJson(Map<String, dynamic> json) {
    return PZhanMidStyleUpModel(
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
