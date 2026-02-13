import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/domain/domain.dart';
import 'package:jycrpj/domain/model/collection_model.dart';
import 'package:jycrpj/domain/type_def.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jycrpj/ui_layer/screens/crack/crack_app_type.dart';
import 'package:provider/provider.dart';

import '../../../router/routes.dart';
import '../../../utils/common_utils.dart';
import '../../theme.dart';

import '../../../../report/ui_layer/report_gesture_detector.dart';

class CollectionAppScreen extends StatefulWidget {
  const CollectionAppScreen({super.key});

  @override
  State<CollectionAppScreen> createState() => _CollectionAppScreenState();
}

class _CollectionAppScreenState extends State<CollectionAppScreen> {
  late final _dynamicDomain = context.read<DynamicDomain>();
  String _lastIx = '';

  Future<List<MineVideoCardData>> _init({int page = 1, int limit = 15, int type = 0}) async {
    final result = await _dynamicDomain.getConstructByApiLink(
      apiLink: 'user/getUserFavor',
      params: {'page': page, 'limit': limit, 'type': type, 'lastIx': _lastIx},
    );

    if (result.status == 1) {
      final resData = result.data;
      final lastIx = resData['last_ix'];
      if (lastIx == _lastIx) {
        return [];
      } else {
        _lastIx = lastIx;
        if (result.data['list'] case final List data when data.isNotEmpty) {
          final curVideoCardDataList = data.map<MineVideoCardData>((e) => MineVideoCardData.fromJson(e)).toList();
          return curVideoCardDataList;
        } else {
          return [];
        }
      }
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.grid(
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding, vertical: 8.w),
      childAspectRatio: 170 / 125,
      crossAxisSpacing: 8.w,
      itemBuilder: (context, item, index) => _CollectAppVideoItem(item),
      isNeedMore: true,
      onFetchingMore: (currentPage, pageSize) {
        if (currentPage == 1) {
          _lastIx = '';
        }
        final res = _init(page: currentPage, limit: pageSize);
        return res;
      },
    );
  }
}

class _CollectAppVideoItem extends StatelessWidget {
  final MineVideoCardData data;

  const _CollectAppVideoItem(this.data);

  String getTag() {
    final type = data.type;
    if (type == CrackAppType.zpc.type) {
      return tr('zpcsp');
    } else if (type == CrackAppType.clsq.type) {
      return tr('clsp');
    } else if (type == CrackAppType.awjq.type) {
      return tr('awjq');
    } else if (type == CrackAppType.aw91.type) {
      return tr('aw91');
    } else if (type == CrackAppType.hjsq.type) {
      return tr('hjsq');
    } else if (type == CrackAppType.pzhan.type) {
      return tr('pzhan');
    } else if (type == CrackAppType.tiktok51.type) {
      return tr('tiktok51');
    } else if (type == CrackAppType.gd.type) {
      return tr('gdcm');
    } else if (type == CrackAppType.xiaolan.type) {
      return tr('xiaolan');
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return ReportGestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        final type = data.type;
        if (type == CrackAppType.zpc.type) {
          ZpcVideoDetailRoute(data.id ?? 0).push(context);
        } else if (type == CrackAppType.clsq.type) {
          ClVideoDetailRoute(data.id ?? 0).push(context);
        } else if (type == CrackAppType.awjq.type) {
          AnWangRestrictedDetailRoute(id: data.id ?? 0).push(context);
        } else if (type == CrackAppType.pzhan.type) {
          PZhanVideoDetailRoute(id: data.id ?? 0).push(context);
        } else if (type == CrackAppType.aw91.type) {
          Aw91VideoDetailRoute(id: data.id ?? 0).push(context);
        } else if (type == CrackAppType.hjsq.type) {
          HjsqVideoDetailRoute(data.id ?? 0).push(context);
        } else if (type == CrackAppType.tiktok51.type) {
          Tiktok51VideoDetailRoute(id: data.id ?? 0).push(context);
        } /* else if (type == CrackAppType.gd.type) {
          GdVideoDetailRoute(id: data.id ?? 0).push(context);
        } else if (type == CrackAppType.xiaolan.type) {
          XiaolanVideoDetailRoute(id: data.id ?? 0).push(context);
        }  */
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
                      MyImage.network(data.coverHorizontal ?? '', fit: BoxFit.cover, backgroundColor: MyTheme.imageBgColor, borderRadius: 5.w),
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
                              Text('${CommonUtils.renderFixedNumber(data.playCt ?? 0)}${'bf'.tr()}', style: MyTheme.white12medium),
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
                child: Text(data.title ?? '', style: MyTheme.white244_14, maxLines: 1),
              ),
            ),
          ],
        );
      }),
    );
  }
}
