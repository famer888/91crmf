class ReportVideoModel {
  String description;
  String title;
  String subTitle;
  String cover;
  String advertiseLocationCode;
  String adSlotName;
  String advertiseCode;
  int adType;

  ReportVideoModel({
    this.description = '',
    this.title = '',
    this.subTitle = '',
    this.cover = '',
    this.advertiseLocationCode = '',
    this.adSlotName = '',
    this.advertiseCode = '',
    this.adType = 0,
  });

  factory ReportVideoModel.fromJson(Map<String, dynamic> json) {
    return ReportVideoModel(
      description: json['description'] ?? '',
      title: json['title'] ?? '',
      subTitle: json['subTitle'] ?? '',
      cover: json['cover'] ?? '',
      advertiseLocationCode: json['advertiseLocationCode'] ?? '',
      adSlotName: json['adSlotName'] ?? '',
      advertiseCode: json['advertiseCode'] ?? '',
      adType: json['adType'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'title': title,
      'subTitle': subTitle,
      'cover': cover,
      'advertiseLocationCode': advertiseLocationCode,
      'adSlotName': adSlotName,
      'advertiseCode': advertiseCode,
      'adType': adType,
    };
  }
}
