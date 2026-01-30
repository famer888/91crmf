import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jycrpj/domain/async_value.dart';
import 'package:jycrpj/domain/domain.dart';
import 'package:jycrpj/domain/model/banner_model.dart';
import 'package:jycrpj/domain/model/home_data_model.dart';
import 'package:jycrpj/domain/model/video_detail_model.dart';
import 'package:jycrpj/domain/type_def.dart';
import 'package:jycrpj/ui_layer/notifiers/user_notifier.dart';
import 'package:jycrpj/ui_layer/router/routes.dart';
import 'package:jycrpj/ui_layer/screens/black/widget/convenience.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/status/loading.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/status/network_error.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/video_player/shortv_mv_player.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/pzhan/model/pzhan_model.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/pzhan/widget/pzhan_feed_card.dart';
import 'package:jycrpj/ui_layer/screens/crack/crack_app_type.dart';
import 'package:jycrpj/ui_layer/screens/crack/widgets/app_video_collect_button.dart';
import 'package:jycrpj/ui_layer/screens/crack/widgets/scroll_top_button.dart';
import 'package:jycrpj/ui_layer/screens/image_paths.dart';
import 'package:jycrpj/ui_layer/screens/theme.dart';
import 'package:jycrpj/ui_layer/utils/common_utils.dart';
import 'package:jycrpj/ui_layer/utils/download_utils.dart';
import 'package:jycrpj/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';

import '../../../../../../report/ui_layer/report_general_banner.dart';
import '../../../../../../report/ui_layer/report_gesture_detector.dart';

class PZhanVideoDetailScreen extends StatefulWidget {
  final int id;

  const PZhanVideoDetailScreen({super.key, required this.id});

  @override
  State<PZhanVideoDetailScreen> createState() => _PZhanVideoDetailScreenState();
}

class _PZhanVideoDetailScreenState extends State<PZhanVideoDetailScreen> {
  late final _appDomain = context.read<AppDomain>();
  final ValueNotifier<List<PZhanVideoModel>> _recommendVideoListNotifier = ValueNotifier([]);
  AsyncValue<PZhanVideoModel> _asyncValue = const AsyncInit();
  List<Notice>? _noticeList;

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    _initData();
    _getVideoRecommendList();
    super.initState();
  }

  @override
  void dispose() {
    _recommendVideoListNotifier.dispose();
    super.dispose();
  }

  Future _initData() async {
    if (_asyncValue.isLoading) return;
    setState(() {
      _asyncValue = const AsyncLoading();
    });

    final result = await _appDomain.getConstructByApiLink(apiLink: 'mvpzhan/detail', params: {'id': widget.id});
    if (result.status == 1) {
      final data = result.data;
      if (data['ads'] case final list when list.isNotEmpty) {
        _noticeList = list.map<Notice>((x) => Notice.fromJson(x)).toList();
      }
      if (data['row'] != null) {
        final videoDetailData = PZhanVideoModel.fromJson(data['row']);
        _asyncValue = AsyncData(videoDetailData);
      }
    } else {
      if (result.msg case final msg? when msg.isNotEmpty) {
        MyToast.showText(text: msg);
      }
      _asyncValue = const AsyncError();
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _getVideoRecommendList() async {
    final result = await _appDomain.getConstructByApiLink(apiLink: 'mvpzhan/recommend', params: {'id': widget.id});
    if (result.status == 1) {
      if (result.data['ads'] case final list when list.isNotEmpty) {
        _noticeList = list.map<Notice>((x) => Notice.fromJson(x)).toList();
      }
      if (result.data['list'] case final list when list.isNotEmpty) {
        final feedModelList = list.map<PZhanVideoModel>((x) => PZhanVideoModel.fromJson(x)).toList();
        if (mounted) {
          _recommendVideoListNotifier.value = feedModelList;
        }
      }
    } else {
      if (result.msg case final msg? when msg.isNotEmpty) {
        MyToast.showText(text: msg);
      }
    }
  }

  // 视频下载
  void _videoDownload(PZhanVideoModel videoData) async {
    CommonUtils.log('视频下载开始 免费状态isfree: ${videoData.isFree}');
    final result = await _appDomain.getConstructByApiLink(apiLink: 'mvpzhan/download', params: {'id': widget.id});
    CommonUtils.log('视频下载:$result');
    if (result.status == 1) {
      final downloadUrl = result.data['downloadUrl'];
      CommonUtils.log('视频下载地址:$downloadUrl');
      _startDownload(downloadUrl, videoData);
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
  }

  Future<void> _startDownload(String downloadUrl, PZhanVideoModel videoData) async {
    // 先判断本地有没有
    final userNotifier = context.read<UserNotifier>();
    final privilegeDomain = context.read<PrivilegeDomain>();
    final downloadUtil = context.read<DownloadUtil>();
    privilegeDomain.downNum(id: '${videoData.id}', type: CrackAppType.clsq.type).then((res) {
      if (res.status == 1) {
        final downNum = userNotifier.member.videoDownloadValue ?? 0;
        if (downNum > 0) {
          userNotifier.setDownNum(num: downNum - 1);
          final taskInfo = {
            'id': '${videoData.id}',
            'urlPath': videoData.playUrl,
            'title': videoData.title,
            'thumbCover': videoData.coverThumbUrl,
            'tags': videoData.tagsList.join('/'),
            'contentType': 1,
            'downloading': false,
            'isWaiting': true,
            'downloadUrl': downloadUrl,
          };
          downloadUtil.createDownloadTask(taskInfo: taskInfo);
        } else {
          MyToast.showText(text: '下载次数已经消耗完毕');
        }
      } else {
        MyToast.showText(text: res.msg ?? '');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true, // 允许返回
      onPopInvoked: (didPop) {
        if (didPop) {
          // 页面真的已经被移出栈了
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
        }
      },
      child: ScreenBackground(
        child: SafeArea(
          bottom: false,
          child: Scaffold(
            extendBodyBehindAppBar: true,
            floatingActionButton: ReportGestureDetector(
              onTap: () {
                context.pop();
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 40.w),
                height: 45.w,
                width: 45.w,
                decoration: BoxDecoration(gradient: MyTheme.gradient_90_114, borderRadius: BorderRadius.all(Radius.circular(20.w))),
                child: Center(child: Text('fahui'.tr(context: context), style: MyTheme.white255_13_M)),
              ),
            ),
            body: _asyncValue.maybeWhen(
              orElse: () => const LoadingView(),
              error: (_, __) => NetworkErrorView(onTap: _initData),
              data: (data) => Column(
                children: [
                  VideoView(data: data),
                  Container(
                    color: const Color.fromRGBO(16, 16, 16, 1),
                    padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 13.w),
                    child: Row(
                      children: [
                        Text('简介', style: MyTheme.white255_13.s16.w500),
                        const Spacer(),
                        // ReportGestureDetector(
                        //   onTap: () {
                        //     AppDialog.showLineDialog(context, _userNotifier);
                        //   },
                        //   child: Row(
                        //     mainAxisSize: MainAxisSize.min,
                        //     children: [
                        //       SizedBox(
                        //         width: 15.w,
                        //         height: 15.w,
                        //         child: MyImage.asset(MyImagePaths.appSwitchLine, width: 15.w, height: 15.w),
                        //       ),
                        //       SizedBox(width: 4.w),
                        //       Text('切换路线', style: MyTheme.white255_10.white25507.w400),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  Container(color: const Color.fromRGBO(255, 255, 255, 0.9), height: 0.2.w),
                  Expanded(
                    child: _Body(
                      id: widget.id,
                      data: data,
                      banners: _noticeList,
                      recommendVideoListNotifier: _recommendVideoListNotifier,
                      downloadCallback: () async {
                        _videoDownload(data);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Body extends StatefulWidget {
  final ValueNotifier<List<PZhanVideoModel>> recommendVideoListNotifier;

  const _Body({
    required this.id,
    required this.data,
    required this.banners,
    required this.recommendVideoListNotifier,
    this.downloadCallback,
  });

  final int id;
  final PZhanVideoModel data;
  final List<Notice>? banners;
  final VoidCallback? downloadCallback;

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _showToTopButtonNotifier = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _showToTopButtonNotifier.dispose();
    super.dispose();
  }

  void _scrollListener() {
    // 当滚动位置超过300时显示按钮
    if (_scrollController.offset > 300 && !_showToTopButtonNotifier.value) {
      setState(() {
        _showToTopButtonNotifier.value = true;
      });
    } else if (_scrollController.offset <= 300 && _showToTopButtonNotifier.value) {
      setState(() {
        _showToTopButtonNotifier.value = false;
      });
    }
  }

  // 回到顶部的方法
  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Color.fromRGBO(16, 16, 16, 1)),
      child: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController, // 添加 controller
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              SliverList.list(
                children: [
                  SizedBox(height: 10.w),
                  Row(
                    children: [
                      SizedBox(width: 13.w),
                      Expanded(
                        child: Text(widget.data.title, style: MyTheme.white255_14.w400, maxLines: 2, softWrap: true),
                      ),
                      SizedBox(width: 13.w),
                    ],
                  ),
                  if (widget.data.tagsList.isNotEmpty) _buildTagListWidget(widget.data.tagsList.join(',')),
                  SizedBox(height: 10.w),
                  _buildStatisticalDataWidget(),
                  _buildBannerWidget(widget.banners),
                  Row(
                    children: [
                      SizedBox(width: 13.w),
                      Expanded(child: Text('xgtj'.tr(context: context), style: MyTheme.white255_12.s16.w500)),
                      SizedBox(width: 13.w),
                    ],
                  ),
                  SizedBox(height: 10.w),
                  ValueListenableBuilder(
                      valueListenable: widget.recommendVideoListNotifier,
                      builder: (context, recommendVideos, child) {
                        return Padding(
                          padding: EdgeInsets.all(MyTheme.pagePadding),
                          child: GridView.builder(
                            shrinkWrap: true,
                            itemCount: recommendVideos.length,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10.w,
                              mainAxisSpacing: 10.w,
                              childAspectRatio: MyTheme.aspectRatio,
                            ),
                            itemBuilder: (context, index) {
                              final item = recommendVideos[index];
                              return PZhanFeedCard(isList: false, feed: item, isInVideoDetail: true);
                            },
                          ),
                        );
                      }),
                  SizedBox(height: 10.w),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 110.w,
            right: 20.w,
            child: ScrollTopButton(
              showToTopButtonNotifier: _showToTopButtonNotifier,
              scrollTopCallback: _scrollToTop,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerWidget(List<Notice>? list) {
    if (list == null || list.isEmpty) return const SizedBox.shrink();

    try {
      final banners = list
          .map(
            (e) => BannerModel(
              id: e.id ?? 0,
              title: e.title,
              name: e.name,
              linkUrl: e.linkUrl ?? '',
              resourceUrl: e.resourceUrl ?? '',
              redirectType: e.redirectType ?? 0,
              router: e.router ?? '',
              reportId: e.reportId ?? 0,
              reportType: e.reportType ?? 0,
              urlStr: e.urlStr ?? '',
              adType: e.adType,
              adSlotName: e.adSlotName,
              advertiseCode: e.advertiseCode,
              advertiseLocationCode: e.advertiseLocationCode,
            ),
          )
          .toList();
      return Padding(padding: EdgeInsets.all(MyTheme.pagePadding), child: ReportGeneralAppsListVidget(data: banners));
    } catch (e) {
      CommonUtils.log('banner转换出错:$e');
    }
    return const SizedBox.shrink();
  }

  Widget _buildStatisticalDataWidget() {
    Widget current = Row(children: [
      Expanded(child: Text('${CommonUtils.formatNumber(widget.data.playNum)}次观看', style: MyTheme.white255_13.w400)),
      Visibility(
        visible: !kIsWeb,
        child: ReportGestureDetector(
          onTap: () async {
            widget.downloadCallback?.call();
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 20.w,
                height: 20.w,
                child: MyImage.asset(MyImagePaths.appDownloadIcon, width: 20.w, height: 20.w),
              ),
              SizedBox(width: 5.w),
              Text('xz'.tr(context: context), style: MyTheme.white255_13.white25508)
            ],
          ),
        ),
      ),
      SizedBox(width: 20.w),
      AppVideoCollectButton(
        apiUrl: 'user/favorites',
        collectedColor: MyTheme.pzhanAppPrimaryColor,
        isCollected: widget.data.isFavorite > 0,
        id: widget.data.id,
        callback: (isCollected) {
          if (isCollected) {
            widget.data.isFavorite++;
          } else {
            widget.data.isFavorite--;
          }
        },
      ),
      SizedBox(width: 20.w),
      ReportGestureDetector(
        onTap: () async {
          const ShareInviteRoute().push(context);
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 20.w,
              height: 20.w,
              child: MyImage.asset(MyImagePaths.appShareIcon, width: 15.w, height: 15.w),
            ),
            SizedBox(width: 5.w),
            Text('fx'.tr(context: context), style: MyTheme.white255_13.white25508)
          ],
        ),
      ),
    ]);

    return Convenience.buildContainerWidget(padding: EdgeInsets.fromLTRB(13.w, 0, 13.w, 0), child: current);
  }

  Widget _buildTagListWidget(String tagStr) {
    List<String> tags = tagStr.split(',');
    tags = tags.where((i) => i.isNotEmpty).toList();

    Widget current = Wrap(
      runSpacing: 9.w,
      spacing: 12.w,
      children: tags.map((e) {
        return Convenience.buildChildActionWidget(
          onTap: () {
            PZhanVideoTagRoute(e).push(context);
          },
          padding: EdgeInsets.fromLTRB(8.w, 2.w, 8.w, 2.w),
          borderRadius: BorderRadius.circular(2.w),
          gradient: const LinearGradient(colors: [Color.fromRGBO(58, 57, 62, 1), Color.fromRGBO(58, 57, 62, 1)]),
          child: Text('#$e', style: MyTheme.white255_12),
        );
      }).toList(),
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(12.5.w, 10.w, 12.5.w, 0),
      child: current,
    );
  }
}

class VideoView extends StatelessWidget {
  const VideoView({super.key, required this.data});

  final PZhanVideoModel data;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ShortvMvPlayer(
        info: VideoData(
          id: data.id,
          source240: data.payUrlFull,
          coverThumbHorizontal: data.coverThumbUrl,
          coins: data.coins,
          isfree: data.isFree,
          tags: data.tagsList.join(','),
          title: data.title,
          duration: data.duration,
          countPlay: data.playNum,
          countLike: data.like,
          countComment: data.comment,
          rating: data.rating,
          createdAt: data.createdStr,
          refreshAt: data.refreshAt.toString(),
          thumbCover: data.coverThumbUrl,
          thumbHeight: data.thumbHeight,
          thumbWidth: data.thumbWidth,
        ),
      ),
    );
  }
}
