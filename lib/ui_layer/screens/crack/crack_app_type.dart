// 24 表示  草榴, 25 表示 91 暗网 ,26 表示 暗网禁区  27 表示 91 制片厂 29 表示 pzhan
enum CrackAppType {
  normal(type: 0, appName: '', topNavApi: ''),
  aw91(type: 25, appName: '91aw', topNavApi: 'element91aw/getElementById'),
  awjq(type: 26, appName: 'awjq', topNavApi: 'elementawjq/getElementById'),
  clsq(type: 24, appName: 'hjgj', topNavApi: 'elementhjgj/getElementById'),
  zpc(type: 27, appName: 'zpc', topNavApi: 'elementzpc/getElementById'),
  pzhan(type: 29, appName: 'pzhan', topNavApi: 'navigationpzhan/index'),
  gd(type: 30, appName: 'gd', topNavApi: 'elementgd/getElementById'),
  xiaolan(type: 31, appName: 'bluemv', topNavApi: 'tabnewxiaolan/index'),
  hjsq(type: 32, appName: 'hjsq', topNavApi: 'elementhjsq/getElementById'),
  tiktok51(type: 33, appName: '51tikok', topNavApi: 'navigation51tikok/index'),
  ;

  final int type;
  final String appName;
  final String topNavApi;

  const CrackAppType({required this.type, required this.appName, required this.topNavApi});
}
