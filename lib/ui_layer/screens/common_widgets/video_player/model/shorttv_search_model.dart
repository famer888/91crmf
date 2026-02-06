import 'package:jycrpj/domain/model/black_model.dart';

class SearchData {
  String word;
  int type;

  SearchData({
    this.word = '',
    this.type = 0,
  });
}

class ShorttvSearchHotModel {
  List<HotWordModel> mvList;
  List<HotWordModel> mvHjgjList;
  List<HotWordModel> mvPzhanList;
  List<HotWordModel> vlogList;
  List<HotWordModel> bookList;
  List<HotWordModel> girlList;
  List<HotWordModel> picList;
  List<HotWordModel> storyList;
  List<HotWordModel> allList;

  ShorttvSearchHotModel({
    this.mvList = const [],
    this.mvHjgjList = const [],
    this.mvPzhanList = const [],
    this.vlogList = const [],
    this.bookList = const [],
    this.girlList = const [],
    this.picList = const [],
    this.storyList = const [],
    this.allList = const [],
  });

  factory ShorttvSearchHotModel.fromJson(Map<String, dynamic> json) =>
      ShorttvSearchHotModel(
        mvList: List<HotWordModel>.from(json['mv']?.map((e) => HotWordModel.fromJson(e)) ?? []),
        mvHjgjList: List<HotWordModel>.from(json['mvhjgj']?.map((e) => HotWordModel.fromJson(e)) ?? []),
        mvPzhanList:List<HotWordModel>.from(json['mvpzhan']?.map((e) => HotWordModel.fromJson(e)) ?? []),
        vlogList:List<HotWordModel>.from(json['vlog']?.map((e) => HotWordModel.fromJson(e)) ?? []),
        bookList:List<HotWordModel>.from(json['book']?.map((e) => HotWordModel.fromJson(e)) ?? []),
        girlList:List<HotWordModel>.from(json['girl']?.map((e) => HotWordModel.fromJson(e)) ?? []),
        picList:List<HotWordModel>.from(json['pic']?.map((e) => HotWordModel.fromJson(e)) ?? []),
        storyList:List<HotWordModel>.from(json['story']?.map((e) => HotWordModel.fromJson(e)) ?? []),
        allList:List<HotWordModel>.from(json['all']?.map((e) => HotWordModel.fromJson(e)) ?? []),
      );
}

class HotWordModel {
  int type;
  String work;
  int num;

  HotWordModel({this.type = 0, this.work = '', this.num = 0,});

  factory HotWordModel.fromJson(Map<String, dynamic> json) =>
      HotWordModel(
        type: json['type'],
        work: json['work'],
        num: json['num'],
      );

  Map<String, dynamic> toJson() =>
      {
        'type': type,
        'work': work,
        'num': num,
      };
}

class BlackSearchListModel {
  String lastIx;
  List<BlackListItemModel> list;

  BlackSearchListModel({
    required this.list,
    required this.lastIx,
  });

  factory BlackSearchListModel.fromJson(Map<String, dynamic> json) {
    return BlackSearchListModel(
      list: List<BlackListItemModel>.from(json['list']?.map((app) => BlackListItemModel.fromJson(app))),
      lastIx: json['last_ix'],
    );
  }
}