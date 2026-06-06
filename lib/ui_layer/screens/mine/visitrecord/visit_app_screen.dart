import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/ui_layer/router/routes.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/status/empty_data.dart';
import 'package:jycrpj/ui_layer/screens/crack/app_video_visit_util.dart';
import 'package:jycrpj/ui_layer/screens/crack/crack_app_type.dart';
import 'package:jycrpj/ui_layer/screens/mine/visitrecord/visit_model.dart';
import 'package:jycrpj/ui_layer/utils/common_utils.dart';

import '../../theme.dart';

import '../../../../report/ui_layer/report_gesture_detector.dart';

class VisitAppScreen extends StatefulWidget {
  const VisitAppScreen({super.key});

  @override
  State<VisitAppScreen> createState() => _VisitAppScreenState();
}

class _VisitAppScreenState extends State<VisitAppScreen> {
  final ValueNotifier<List<VideoVisitModel>> _visitFeedModelsNotifier = ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (context.mounted) {
        _getVisitVideoData();
      }
    });
  }

  @override
  void dispose() {
    _visitFeedModelsNotifier.dispose();
    super.dispose();
  }

  void _getVisitVideoData() async {
    final List<VideoVisitModel>? visitFeedModels = await AppVisitUtil.getAppVisitRecord(context);
    if (visitFeedModels == null) {
      _visitFeedModelsNotifier.value = [];
    } else {
      if (visitFeedModels.isEmpty) {
        _visitFeedModelsNotifier.value = [];
      } else {
        _visitFeedModelsNotifier.value = visitFeedModels.reversed.toList();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _visitFeedModelsNotifier,
      builder: (context, visitFeedModels, child) {
        return Container(
          alignment: Alignment.topCenter,
          child: visitFeedModels.isEmpty
              ? PageEmptyDataView(text: 'mysj'.tr(context: context))
              : GridView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: 8.w),
                  itemCount: visitFeedModels.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8.w,
                    crossAxisSpacing: 8.w,
                    childAspectRatio: 170 / 120,
                  ),
                  itemBuilder: (context, index) {
                    final feedModel = visitFeedModels[index];
                    return _VisitAppVideoItem(feedModel);
                  },
                ),
        );
      },
    );
  }
}

class _VisitAppVideoItem extends StatelessWidget {
  final VideoVisitModel data;

  const _VisitAppVideoItem(this.data);

  String get imageUrl => CommonUtils.getThumb(data.toJson());

  String getTag() {
    final type = data.crackAppType;
    if (type == CrackAppType.zpc.type) {
      return tr('zpcsp');
    } else if (type == CrackAppType.clsq.type) {
      return tr('clsp');
    } else if (type == CrackAppType.awjq.type) {
      return tr('awjq');
    } else if (type == CrackAppType.aw91.type) {
      return tr('aw91');
    } else if (type == CrackAppType.pzhan.type) {
      return tr('pzhan');
    } else if (type == CrackAppType.hjsq.type) {
      return tr('hjsq');
    } else if (type == CrackAppType.tiktok51.type) {
      return tr('tiktok51');
    } else if (type == CrackAppType.gd.type) {
      return tr('gdcm');
    } else if (type == CrackAppType.xiaolan.type) {
      return tr('xiaolan');
    } else if (type == CrackAppType.tk.type) {
      return "Tiktok破解";
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return ReportGestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        final type = data.crackAppType;
        if (type == CrackAppType.zpc.type) {
          ZpcVideoDetailRoute(data.id).push(context);
        } else if (type == CrackAppType.clsq.type) {
          ClVideoDetailRoute(data.id).push(context);
        } else if (type == CrackAppType.awjq.type) {
          AnWangRestrictedDetailRoute(id: data.id).push(context);
        } else if (type == CrackAppType.aw91.type) {
          Aw91VideoDetailRoute(id: data.id).push(context);
        } else if (type == CrackAppType.pzhan.type) {
          PZhanVideoDetailRoute(id: data.id).push(context);
        } else if (type == CrackAppType.hjsq.type) {
          HjsqVideoDetailRoute(data.id).push(context);
        } else if (type == CrackAppType.tiktok51.type) {
          Tiktok51VideoDetailRoute(id: data.id).push(context);
        } else if (type == CrackAppType.tk.type) {
          TiktokVideoDetailRoute(id: data.id ?? 0).push(context);
        }
        /* else if (type == CrackAppType.gd.type) {
          GdVideoDetailRoute(id: data.id).push(context);
        } else if (type == CrackAppType.xiaolan.type) {
          XiaolanVideoDetailRoute(id: data.id).push(context);
        }*/

        AppVisitUtil.updateCrackAppVisitRecord(context, data);
      },
      child: LayoutBuilder(builder: (context, cons) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 97.w,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      MyImage.network(imageUrl,
                          fit: BoxFit.cover, backgroundColor: MyTheme.imageBgColor, borderRadius: 5.w),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 22.w,
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.w),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color.fromRGBO(16, 16, 16, 0.05),
                                Color.fromRGBO(16, 16, 16, 0.9),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${CommonUtils.renderFixedNumber(data.playCount)}${'bf'.tr()}',
                                  style: MyTheme.white12medium),
                              Text(RelativeDateFormat.getHMTime(time: data.duration), style: MyTheme.white12medium),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          margin: EdgeInsets.only(top: 5.w, right: 5.w),
                          padding: EdgeInsets.symmetric(horizontal: 4.5.w, vertical: 3.w),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: MyTheme.gradient_90_135_colors),
                            borderRadius: BorderRadius.all(Radius.circular(3.w)),
                          ),
                          child: Text(getTag(), style: MyTheme.white255_14.s11.w400),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(data.title, style: MyTheme.white244_14, maxLines: 1),
              ),
            ),
          ],
        );
      }),
    );
  }
}
