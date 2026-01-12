class VideoVisitModel {
  final String title;
  final int duration;
  final int playCount;
  final int id;
  final int crackAppType;
  final String imgUrl;

  VideoVisitModel({
    required this.title,
    required this.duration,
    required this.playCount,
    required this.id,
    required this.crackAppType,
    required this.imgUrl,
  });

  factory VideoVisitModel.fromJson(Map<String, dynamic> json) {
    return VideoVisitModel(
      title: json['title'],
      duration: json['duration'],
      playCount: json['play_count'],
      id: json['id'],
      crackAppType: json['crack_app_type'],
      imgUrl: json['img_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'duration': duration,
      'play_count': playCount,
      'id': id,
      'crack_app_type': crackAppType,
      'img_url': imgUrl,
    };
  }
}
