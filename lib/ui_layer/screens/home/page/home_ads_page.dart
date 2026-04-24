import 'package:analytics_sdk/analytics_sdk.dart';
import 'package:analytics_sdk/entity/ad_click_event.dart';
import 'package:analytics_sdk/entity/ad_impression_event.dart';
import 'package:analytics_sdk/entity/advertising_event.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/report/event_tracking.dart';
import 'package:jycrpj/report/ui_layer/report_timing_observer.dart';
import 'package:provider/provider.dart';

import '../../../../domain/async_value.dart';
import '../../../../domain/model/home_ads_model.dart';
import '../../../../domain/remote_domain/domains/home.dart';
import '../../../utils/common_utils.dart';
import '../../common_widgets/my_image.dart';
import '../../common_widgets/status/loading.dart';
import '../../common_widgets/status/network_error.dart';
import '../../theme.dart';

import '../../../../report/analytics/analytics_page_sync.dart';
import '../../../../report/ui_layer/report_gesture_detector.dart';

class HomeAdsPage extends StatefulWidget {
  final int pos;

  const HomeAdsPage({super.key, required this.pos});

  @override
  State<HomeAdsPage> createState() => _HomeAdsPageState();
}

class _HomeAdsPageState extends State<HomeAdsPage> {
  late final homeDomain = context.read<HomeDomain>();
  AsyncValue<HomeAdsModel> _asyncValue = const AsyncInit();

  Map<String, bool> topAdIdMap = {}; // 已经显示true 未显示null
  List<String> get topAdIds => List<String>.from(topAdIdMap.keys);
  bool didTopReport = false; //本生命周期内 只上报一次

  void _showTopAppAd(TopAdsModel tp) {
    // 没存进Map 就是没上传过show 上传&记录
    if (topAdIdMap[tp.advertiseCode] == null) {
      postActionReport(tp, "show");
      topAdIdMap[tp.advertiseCode ?? ''] = true;
    }

    if (topAdIds.length ==
        _asyncValue.data!.top.length) {
      postTopShowReport();
    }
  }

  //展示广告上报 展示完或页面消失上报
  void postTopShowReport() {
    if (didTopReport) return;

    TopAdsModel tp = _asyncValue.data!.top.first;
    final pageInfo = syncAnalyticsPageFromContext(context);
    AnalyticsSdk.instance.track(
      AdImpressionEvent(
        pageKey: pageInfo.pageKey,
        pageName: pageInfo.pageName,
        adSlotKey: tp.advertiseLocationCode,
        adSlotName: tp.adSlotName,
        adId: topAdIds.join(","),
        creativeId: "",
        adType: tp.adType.toString(),
      ),
    );
    EventTracking().reportSingle({
      "event": "ad_impression",
      "page_key": RouteStore.currentPageKey,
      "page_name": RouteStore.currentPageName,
      "ad_slot_key": tp.advertiseLocationCode,
      "ad_slot_name": tp.adSlotName,
      "ad_id": topAdIds.join(","),
      "creative_id": "",
      "ad_type": tp.adType,
    }).then((onValue) {
      didTopReport = true;
    });
  }

  Map<String, bool> bottomAdIdMap = {}; // 已经显示true 未显示null
  List<String> get bottomAdIds => List<String>.from(bottomAdIdMap.keys);
  bool didBottomReport = false; //本生命周期内 只上报一次

  void _showBottomAppAd(TopAdsModel tp) {
    // 没存进Map 就是没上传过show 上传&记录
    if (bottomAdIdMap[tp.advertiseCode] == null) {
      postActionReport(tp, "show");
      bottomAdIdMap[tp.advertiseCode ?? ''] = true;
    }

    if (bottomAdIds.length == _asyncValue.data!.bottom.length) {
      postBottomShowReport();
    }
  }

  //展示广告上报 展示完或页面消失上报
  void postBottomShowReport() {
    if (didBottomReport) return;

    TopAdsModel tp = _asyncValue.data!.bottom.first;
    EventTracking().reportSingle({
      "event": "ad_impression",
      "page_key": RouteStore.currentPageKey,
      "page_name": RouteStore.currentPageName,
      "ad_slot_key": tp.advertiseLocationCode,
      "ad_slot_name": tp.adSlotName,
      "ad_id": bottomAdIds.join(","),
      "creative_id": "",
      "ad_type": tp.adType,
    }).then((onValue) {
      didBottomReport = true;
    });
  }

  //上传广告行为
  void postActionReport(TopAdsModel tp, String action) {
    AnalyticsSdk.instance.track(
      AdvertisingEvent(
        eventType: action,
        advertisingKey: tp.advertiseLocationCode,
        advertisingName: tp.adSlotName,
        advertisingId: tp.advertiseCode,
      ),
    );
    EventTracking().reportSingle({
      "event": "advertising",
      "event_type": action,
      "advertising_key": tp.advertiseLocationCode,
      "advertising_name": tp.adSlotName,
      "advertising_id": tp.advertiseCode,
    });
  }

  //点击广告上报
  void postClickReport(TopAdsModel tp) {
    final pageInfo = syncAnalyticsPageFromContext(context);
    AnalyticsSdk.instance.track(
      AdClickEvent(
        pageKey: pageInfo.pageKey,
        pageName: pageInfo.pageName,
        adSlotKey: tp.advertiseLocationCode,
        adSlotName: tp.adSlotName,
        adId: tp.advertiseCode,
        creativeId: '',
        adType: tp.adType.toString(),
      ),
    );
    postActionReport(tp, "click");

    EventTracking().reportSingle({
      "event": "ad_click",
      "page_key": RouteStore.currentPageKey,
      "page_name": RouteStore.currentPageName,
      "ad_slot_key": tp.advertiseLocationCode,
      "ad_slot_name": tp.adSlotName,
      "ad_id": tp.advertiseCode,
      "creative_id": "",
      "ad_type": tp.adType,
    }).then((value) {
      // CommonUtils.log(value);
    });
  }

  _init() async {
    if (_asyncValue.isLoading) return;

    setState(() {
      _asyncValue = const AsyncLoading();
    });

    final result = await homeDomain.getHomeApp(pos: widget.pos);
    if (result.status == 1) {
      if (result.data == null) {
        _asyncValue = const AsyncError();
      } else {
        _asyncValue = AsyncData(result.data!);
      }
    } else {
      _asyncValue = const AsyncError();
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _asyncValue.maybeWhen(
      data: (data) => CustomScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverList.list(children: [
              GridView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: 10.w),
                  itemCount: data.top.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    mainAxisSpacing: 10.w,
                    crossAxisSpacing: 5.w,
                    childAspectRatio: 100 / 135,
                  ),
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final e = data.top[index];
                    _showTopAppAd(e);
                    return ReportGestureDetector(
                      onTap: () {
                        homeDomain.reqAdClickCount(
                            id: e.reportId, type: e.reportType);
                        CommonUtils.launchUrl(e.linkUrl);
                        postClickReport(e);
                      },
                      child: Column(
                        children: [
                          SizedBox(
                              width: 60.w,
                              height: 60.w,
                              child: MyImage.network(e.imgUrl,
                                  borderRadius: 10.w)),
                          SizedBox(height: 5.w),
                          Text(e.title, style: MyTheme.white13, maxLines: 1),
                        ],
                      ),
                    );
                  }),
              Container(
                  height: 0.6.w,
                  margin: EdgeInsets.symmetric(vertical: 15.w),
                  color: const Color.fromRGBO(45, 45, 45, 1)),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(vertical: 12.w),
                itemCount: data.bottom.length,
                itemBuilder: (context, index) {
                  final e = data.bottom[index];
                  _showBottomAppAd(e);
                  return Padding(
                    padding: EdgeInsets.only(bottom: 15.w),
                    child: Row(
                      children: [
                        SizedBox(
                            width: 60.w,
                            height: 60.w,
                            child:
                                MyImage.network(e.imgUrl, borderRadius: 10.w)),
                        SizedBox(width: 10.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(e.title, style: MyTheme.white15, maxLines: 1),
                            SizedBox(height: 12.w),
                            Text(
                                CommonUtils.formatN(e.clicked) +
                                    'wcxz'.tr(context: context),
                                style: MyTheme.white07_12,
                                maxLines: 1),
                          ],
                        ),
                        const Spacer(),
                        ReportGestureDetector(
                          onTap: () {
                            homeDomain.reqAdClickCount(
                                id: e.reportId, type: e.reportType);
                            CommonUtils.launchUrl(e.linkUrl);
                            postClickReport(e);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 7, horizontal: 20),
                            decoration: BoxDecoration(
                                color: MyTheme.blueColor63,
                                borderRadius: BorderRadius.circular(45)),
                            child: Text('xz'.tr(context: context),
                                style: MyTheme.white15, maxLines: 1),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ]),
          ]),
      error: (_, __) => NetworkErrorView(onTap: _init),
      orElse: () => const LoadingView(),
    );
  }
}
