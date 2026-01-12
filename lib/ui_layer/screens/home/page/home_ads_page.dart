import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../domain/async_value.dart';
import '../../../../domain/model/home_ads_model.dart';
import '../../../../domain/remote_domain/domains/home.dart';
import '../../../utils/common_utils.dart';
import '../../common_widgets/my_image.dart';
import '../../common_widgets/status/loading.dart';
import '../../common_widgets/status/network_error.dart';
import '../../theme.dart';

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
      data: (data) => CustomScrollView(physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()), slivers: [
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
                return ReportGestureDetector(
                  onTap: () {
                    homeDomain.reqAdClickCount(id: e.reportId, type: e.reportType);
                    CommonUtils.launchUrl(e.linkUrl);
                  },
                  child: Column(
                    children: [
                      SizedBox(width: 60.w, height: 60.w, child: MyImage.network(e.imgUrl, borderRadius: 10.w)),
                      SizedBox(height: 5.w),
                      Text(e.title, style: MyTheme.white13, maxLines: 1),
                    ],
                  ),
                );
              }),
          Container(height: 0.6.w, margin: EdgeInsets.symmetric(vertical: 15.w), color: const Color.fromRGBO(45, 45, 45, 1)),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: 12.w),
            itemCount: data.bottom.length,
            itemBuilder: (context, index) {
              final e = data.bottom[index];
              return Padding(
                padding: EdgeInsets.only(bottom: 15.w),
                child: Row(
                  children: [
                    SizedBox(width: 60.w, height: 60.w, child: MyImage.network(e.imgUrl, borderRadius: 10.w)),
                    SizedBox(width: 10.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(e.title, style: MyTheme.white15, maxLines: 1),
                        SizedBox(height: 12.w),
                        Text(CommonUtils.formatN(e.clicked) + 'wcxz'.tr(context: context), style: MyTheme.white07_12, maxLines: 1),
                      ],
                    ),
                    const Spacer(),
                    ReportGestureDetector(
                      onTap: () {
                        homeDomain.reqAdClickCount(id: e.reportId, type: e.reportType);
                        CommonUtils.launchUrl(e.linkUrl);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 20),
                        decoration: BoxDecoration(color: MyTheme.blueColor63, borderRadius: BorderRadius.circular(45)),
                        child: Text('xz'.tr(context: context), style: MyTheme.white15, maxLines: 1),
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
