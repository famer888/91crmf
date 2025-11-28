import 'post_model.dart';

class MineVideoListModel {
  final List<MineVideoCardData>? list;
  final String? lastIx;

  MineVideoListModel({
    this.list,
    this.lastIx,
  });

  factory MineVideoListModel.fromJson(Map<String, dynamic> json) {
    return MineVideoListModel(list: List.from(json['list'].map((e) => MineVideoCardData.fromJson(e))), lastIx: json['last_ix'] as String?);
  }

  Map<String, dynamic> toJson() => {'list': list?.map((e) => e.toJson()).toList(), 'last_ix': lastIx};
}

class MineVideoCardData {
  final int? mvType;
  final int? duration;
  final int? id;
  final int? playCt;
  final String? title;
  final String? coverVertical;
  final String? coverHorizontal;
  final String? tags;
  final String? desc;
  final int? relatedId;
  final int? xId;
  final int? type;
  final String? source;
  final int? channel;
  final String? sourceOriginStr;
  final List<String>? tagList;
  final int? isPlay;
  final int? discount;
  final int? discountCoins;
  final bool? isPackage;

  MineVideoCardData({
    this.mvType,
    this.duration,
    this.id,
    this.playCt,
    this.title,
    this.coverVertical,
    this.coverHorizontal,
    this.tags,
    this.desc,
    this.relatedId,
    this.xId,
    this.type,
    this.source,
    this.channel,
    this.sourceOriginStr,
    this.tagList,
    this.isPlay,
    this.discount,
    this.discountCoins,
    this.isPackage,
  });

  factory MineVideoCardData.fromJson(Map<String, dynamic> json) {
    return MineVideoCardData(
      id: json['id'],
      mvType: json['mv_type'],
      duration: json['duration'],
      playCt: json['play_ct'],
      title: json['title'],
      coverVertical: json['cover_vertical'],
      coverHorizontal: json['cover_horizontal'],
      tags: json['tags'],
      desc: json['desc'],
      relatedId: json['related_id'],
      xId: json['x_id'],
      type: json['type'],
      source: json['source'],
      channel: json['channel'],
      sourceOriginStr: json['source_origin_str'],
      tagList: json['tag_list'] != null ? List<String>.from(json['tag_list']) : null,
      isPlay: json['is_play'],
      discount: json['discount'],
      discountCoins: json['discount_coins'],
      isPackage: json['is_package'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'mv_type': mvType,
        'duration': duration,
        'play_ct': playCt,
        'title': title,
        'cover_vertical': coverVertical,
        'cover_horizontal': coverHorizontal,
        'tags': tags,
        'desc': desc,
        'related_id': relatedId,
        'x_id': xId,
        'type': type,
        'source': source,
        'channel': channel,
        'source_origin_str': sourceOriginStr,
        'tag_list': tagList,
        'is_play': isPlay,
        'discount': discount,
        'discount_coins': discountCoins,
        'is_package': isPackage,
      };
}

class MineTieztListModel {
  final List<PostModel>? list;
  final String? lastIx;

  MineTieztListModel({
    this.list,
    this.lastIx,
  });

  factory MineTieztListModel.fromJson(Map<String, dynamic> json) {
    return MineTieztListModel(
      list: List.from(json['list'].map((e) => PostModel.fromJson(e))),
      lastIx: json['last_ix'] as String?,
    );
  }
}
