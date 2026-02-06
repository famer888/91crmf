import 'user_model.dart';

class VideoCommentListModel {
  int? id;
  int? aff;
  int? relatedId;
  int? pid;
  String? text;
  int? likeCt;
  int? likeFct;
  int? status;
  String? reason;
  String? createdAt;
  String? updatedAt;
  List<VideoCommentListModel>? comments;
  int? isLike;
  int? mvId;
  int? mvAff;
  String? content;
  int likeCount;
  int? replayCount;
  UserModel? member;

  VideoCommentListModel({
    this.id,
    this.aff,
    this.relatedId,
    this.pid,
    this.text,
    this.likeCt,
    this.likeFct,
    this.status,
    this.reason,
    this.createdAt,
    this.updatedAt,
    this.comments,
    this.isLike,
    this.mvId,
    this.mvAff,
    this.content,
    required this.likeCount,
    this.replayCount,
    this.member,
  });

  factory VideoCommentListModel.fromJson(Map<String, dynamic> json) =>
      VideoCommentListModel(
        id: json['id']?.toInt(),
        aff: json['aff']?.toInt(),
        relatedId: json['related_id']?.toInt(),
        pid: json['pid']?.toInt(),
        text: json['text']?.toString(),
        likeCt: json['like_ct']?.toInt() ?? 0,
        likeFct: json['like_fct']?.toInt() ?? 0,
        status: json['status']?.toInt(),
        reason: json['reason']?? '',
        createdAt: json['created_at']?.toString(),
        updatedAt: json['updated_at']?.toString(),
        comments: List<VideoCommentListModel>.from((json['comments'] ?? []).map((e) => VideoCommentListModel.fromJson(e))),
        isLike: json['is_like']?.toInt(),
        mvId: json['mv_id']?.toInt(),
        mvAff: json['mv_aff']?.toInt(),
        content: json['content']?.toString(),
        likeCount: json['like_count']?.toInt() ?? 0,
        replayCount: json['replay_count']?.toInt(),
        member: (json['user'] != null)
            ? UserModel.fromJson(json['user'])
            : null,
      );

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "aff": aff,
      "related_id": relatedId,
      "pid": pid,
      "text": text,
      "like_ct": likeCt,
      "like_fct": likeFct,
      "status": status,
      "reason": reason,
      "created_at": createdAt,
      "updated_at": updatedAt,
      "comments": comments,
      "is_like": isLike,
      "mv_id": mvId,
      "mv_aff": mvAff,
      "content": content,
      "like_count": likeCount,
      "replay_count": replayCount,
    };
  }
}

class VideoCommentModel {
  List<VideoCommentListModel>? list;
  String? lastIx;

  VideoCommentModel({
    this.list,
    this.lastIx,
  });
  VideoCommentModel.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      final a = json['list'];
      final arr0 = <VideoCommentListModel>[];
      a.forEach((v) {
        arr0.add(VideoCommentListModel.fromJson(v));
      });
      list = arr0;
    }
    lastIx = json['last_ix']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (list != null) {
      final arr0 = [];
      for (var v in list!) {
        arr0.add(v.toJson());
      }
      data['list'] = arr0;
    }
    data['last_ix'] = lastIx;
    return data;
  }
}
