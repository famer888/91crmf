// 24 表示  草榴, 25 表示 91 暗网 ,26 表示 暗网禁区  27 表示 91 制片厂
enum CrackAppType {
  aw91(type: 25),
  awjq(type: 26),
  clsq(type: 24),
  zpc(type: 27),
  ;

  final int type;

  const CrackAppType({required this.type});
}
