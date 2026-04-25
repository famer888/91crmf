import 'dart:async';

import 'package:analytics_sdk/analytics_sdk.dart';
import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/configuration.dart';
import 'package:amplitude_flutter/events/base_event.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper_null_safety_flutter3/flutter_swiper_null_safety_flutter3.dart';
import 'package:jycrpj/app_config.dart';
import 'package:jycrpj/app_global.dart';
import 'package:jycrpj/data_layer/repo/repo.dart';
import 'package:jycrpj/report/analytics/analytics_report.dart';
import 'package:jycrpj/report/ui_layer/report_ad_view.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:jycrpj/ui_layer/screens/image_paths.dart';
import 'package:jycrpj/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as html;

import '../../domain/domain.dart';
import '../../domain/model/home_data_model.dart';
import '../notifiers/home_config_notifier.dart';
import '../notifiers/user_notifier.dart';
import '../router/routes.dart';
import '../utils/common_utils.dart';
import 'common_widgets/my_image.dart';
import 'common_widgets/pop_scope_wrapper.dart';
import 'common_widgets/status/network_error.dart';
import 'theme.dart';

import '../../report/ui_layer/report_gesture_detector.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late final cacheDomain = context.read<CacheDomain>();
  late final appDomain = context.read<AppDomain>();
  late final homeConfigNotifier = context.read<HomeConfigNotifier>();
  late final userNotifier = context.read<UserNotifier>();

  // AdModel? welcomeAds;
  List<AdModel>? welcomeStartScreenAds;
  String? officialWebUrl;

  bool isCheckingLine = true;
  bool showAd = false;

  List<String> lines = [];
  Amplitude? _amplitude;
  bool _isAmplitudeReady = false;

  @override
  void initState() {
    _initAmp();
    _loadDataFromCache();
    _checkLineAndFetchBeforeEnterHome();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AnalyticsSdk.instance.updateCurrentPage(
        pageKey: 'launch',
        pageName: '启动页',
      );
    });
    super.initState();
  }

  void _initAmp() async {
    final amplitude = Amplitude(
      Configuration(apiKey: "c9354b2d3cdf9bc6164f17bf6651ea43"),
    );
    final isBuilt = await amplitude.isBuilt;
    if (!mounted) return;

    _amplitude = amplitude;
    _isAmplitudeReady = isBuilt;
    await _trackAmplitude("open app");
  }

  Future<void> _trackAmplitude(String eventName) async {
    if (!_isAmplitudeReady) return;

    final amplitude = _amplitude;
    if (amplitude == null) return;

    try {
      await amplitude.track(
        BaseEvent(eventName, deviceId: appDomain.info["oauth_id"]?.toString()),
      );
    } catch (e) {
      debugPrint('Amplitude track failed: $e');
    }
  }

  void _loadDataFromCache() async {
    officialWebUrl = await cacheDomain.readOfficeWeb();
    // welcomeAds = await cacheDomain.readAds();
    // if (welcomeAds?.imgUrl case final url? when mounted) {
    //   precacheImage(NetworkImage(url), context);
    // }

    welcomeStartScreenAds = await cacheDomain.readStartScreenAds();

    setState(() {});
  }

  _checkLineAndFetchBeforeEnterHome() {
    appDomain.initLine(
      failed: () async {
        isCheckingLine = false;
        if (mounted) setState(() {});
        await _trackAmplitude("entry failure");
      },
      success: () async {
        await fetchAndApplyConfig(context);
        _enterAdOrHome();
        await _trackAmplitude("enter app");
      },
      lines: (x) {
        lines = x;
      },
    );
  }

  Future<void> _getClipboardText() async {
    if (kIsWeb) {
      final uri = Uri.parse(html.window.location.href.replaceAll('amp;', ''));
      String traceID = uri.queryParameters['trace_id'] ?? '';
      if (traceID.isNotEmpty) context.read<AppRepo>().setReportTraceId(traceID);

      String aff = uri.queryParameters[BuildConfig.affCodeKey] ?? '';
      if (aff.isNotEmpty) context.read<AppRepo>().setAffXCode(aff);

      analyticsReportInstall(context, traceID);
    } else {
      final result = await Clipboard.getData(Clipboard.kTextPlain);
      if (result?.text case final String text when text.isNotEmpty) {
        try {
          final params = Uri.splitQueryString(text);
          String traceID = params['trace_id'] ?? '';
          if (traceID.isNotEmpty)
            context.read<AppRepo>().setReportTraceId(traceID);

          String aff = params[BuildConfig.affCodeKey] ?? '';
          if (aff.isNotEmpty) context.read<AppRepo>().setAffXCode(aff);

          analyticsReportInstall(context, traceID);
        } catch (e) {
          return;
        }
      }
    }
  }

  _enterAdOrHome({bool showTip = false}) async {
    await _getClipboardText(); //config之前先获取trace_id aff_x_code

    if (await homeConfigNotifier.init() && mounted) {
      if (welcomeStartScreenAds?.isNotEmpty ?? false) {
        setState(() {
          showAd = true;
        });
        return;
      }
      const CrackRoute1().go(context);
    } else if (showTip) {
      MyToast.showText(text: 'wfljqsz'.tr(context: context));
    }
  }

  Widget checkLineView() => Center(
        child: isCheckingLine
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ReportGestureDetector(
                    onTap: () {
                      isCheckingLine = false;
                      if (mounted) setState(() {});
                    },
                    child: Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 20.w),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: const Color.fromRGBO(153, 153, 153, 1),
                              ),
                              children: [
                                TextSpan(
                                  text: 'jcxlsd'.tr(context: context),
                                  style: MyTheme.gray14,
                                ),
                                TextSpan(
                                  text: 'dwzl'.tr(context: context),
                                  style: TextStyle(
                                      color:
                                          const Color.fromRGBO(240, 75, 62, 1),
                                      fontSize: 14.sp,
                                      overflow: TextOverflow.ellipsis,
                                      decoration: TextDecoration.none),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Text(
                        //   'jcxlsd'.tr(context: context), //线路检测中，请稍等^_^ 若一直进不去请使用VPN翻墙软件观看！
                        //   style: MyTheme.gray14,
                        //   textAlign: TextAlign.center,
                        // ),
                        Positioned(
                          top: 43,
                          right: 48,
                          child: MyImage.asset(MyImagePaths.appClickLines,
                              width: 25.w, height: 29.w),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.w),
                  if (officialWebUrl?.isNotEmpty == true)
                    ReportGestureDetector(
                      onTap: () {
                        CommonUtils.launchUrl(officialWebUrl!);
                      },
                      child: Text(
                        '${'gwdzdz'.tr(context: context)}:\n$officialWebUrl', //若进不去点我重新安装
                        style: MyTheme.gray14,
                        maxLines: 3,
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              )
            : tryLinesWidget(),
      );

  //用户试用直链接
  Widget tryLinesWidget() => Center(
      child: lines.isEmpty
          ? NetworkErrorView(
              text: 'wfljqsz'.tr(context: context), //请检查手机网络设置或点击重试！
              onTap: _checkLineAndFetchBeforeEnterHome,
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'xzbycs'.tr(context: context),
                  style: MyTheme.white08_14_M,
                  maxLines: 5,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.w),
                Column(
                  children: lines.asMap().keys.map((x) {
                    return ReportGestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          appDomain.setBaseURL(lines[x].toString().trim());
                          _enterAdOrHome(showTip: true);
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              bottom: 10.w, left: 40.w, right: 40.w),
                          decoration: BoxDecoration(
                              color: MyTheme.gray117,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3.w))),
                          alignment: Alignment.center,
                          height: 36.w,
                          child: Text(
                              'byxl'
                                  .tr(context: context)
                                  .replaceAll("0", "${x + 1}"),
                              style: MyTheme.white13),
                        ));
                  }).toList(),
                )
              ],
            ));

  @override
  Widget build(BuildContext context) {
    AppGlobal.context = context;
    return PopScopeWrapper(
      child: ScreenBackground(
        child: Scaffold(
          // backgroundColor: MyTheme.bgColor,
          body: showAd
              ? ReportAdView(adModels: welcomeStartScreenAds!)
              : checkLineView(),
        ),
      ),
    );
  }
}

class AdView extends StatefulWidget {
  const AdView({super.key, required this.adModels});

  final List<AdModel> adModels;

  @override
  State<AdView> createState() => _AdViewState();
}

class _AdViewState extends State<AdView> {
  final ValueNotifier<int> countDownNotifier = ValueNotifier(5);
  late final Timer _timer;

  @override
  void initState() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      countDownNotifier.value -= 1;
      if (countDownNotifier.value == 0) {
        _timer.cancel();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    countDownNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final length = widget.adModels.length;

    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
            child: Swiper(
          autoplay: length > 1,
          itemBuilder: (BuildContext context, int index) {
            precacheImage(
                NetworkImage(CommonUtils.getThumb(widget
                    .adModels[(index + 1).clamp(0, length - 1)]
                    .toJson())),
                context);

            return ReportGestureDetector(
              onTap: () {
                final ad = widget.adModels[index];
                CommonUtils.openRoute(context, {
                  'report_id': ad.id,
                  'report_type': ad.type,
                  'link_url': ad.url,
                });
              },
              child: MyImage.network(
                CommonUtils.getThumb(widget.adModels[index].toJson()),
                fit: BoxFit.cover,
              ),
            );
          },
          itemCount: length,
          pagination: SwiperPagination(
            builder: SwiperCustomPagination(
              builder: (context, config) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  length,
                  (index) {
                    bool isActive = config.activeIndex == index;
                    return Container(
                      width: 5.w,
                      height: 5.w,
                      margin: EdgeInsets.only(right: 7.w),
                      decoration: BoxDecoration(
                        color: isActive
                            ? Colors.white
                            : Colors.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        )),
        Positioned(
          top: MediaQuery.of(context).padding.top + 10.w,
          right: 15.w,
          child: ReportGestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              if (countDownNotifier.value > 0) return;
              const CrackRoute1().go(context);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5.w, horizontal: 15.w),
              height: 35.w,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(0, 0, 0, 0.5),
                borderRadius: BorderRadius.circular(35.w),
              ),
              child: Center(
                child: ValueListenableBuilder(
                  valueListenable: countDownNotifier,
                  builder: (context, count, _) => Text(
                    '${count > 0 ? count : 'adtg'.tr(context: context)}',
                    style: MyTheme.white15semibold,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
