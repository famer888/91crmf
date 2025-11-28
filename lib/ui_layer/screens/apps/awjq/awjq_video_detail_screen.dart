import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jycrpj/domain/model/banner_model.dart';
import 'package:jycrpj/domain/model/home_data_model.dart';
import 'package:jycrpj/domain/type_def.dart';
import 'package:jycrpj/ui_layer/router/routes.dart';
import 'package:jycrpj/ui_layer/screens/apps/awjq/widget/awjq_collect_button.dart';
import 'package:jycrpj/ui_layer/screens/apps/awjq/widget/awjq_feed_card.dart';
import 'package:jycrpj/ui_layer/screens/apps/crack_app_type.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jycrpj/ui_layer/screens/image_paths.dart';
import 'package:provider/provider.dart';

import '../../../../domain/async_value.dart';
import '../../../../domain/domain.dart';
import '../../../../domain/model/feed/feed_model.dart';
import '../../../../domain/model/video_detail_model.dart';
import '../../../notifiers/user_notifier.dart';
import '../../../utils/common_utils.dart';
import '../../../utils/download_utils.dart';
import '../../../utils/my_toast.dart';
import '../../black/widget/convenience.dart';
import '../../common_widgets/general_banner.dart';
import '../../common_widgets/screen_background.dart';
import '../../common_widgets/status/loading.dart';
import '../../common_widgets/status/network_error.dart';
import '../../common_widgets/video_player/shortv_mv_player.dart';
import '../../theme.dart';

class AwjqVideoDetailScreen extends StatefulWidget {
  final int id;

  const AwjqVideoDetailScreen({super.key, required this.id});

  @override
  State<AwjqVideoDetailScreen> createState() => _AwjqVideoDetailScreenState();
}

class _AwjqVideoDetailScreenState extends State<AwjqVideoDetailScreen> {
  late final _appDomain = context.read<AppDomain>();
  final ValueNotifier<List<FeedModel>> _recommendVideoListNotifier = ValueNotifier([]);
  AsyncValue<VideoDetailData> _asyncValue = const AsyncInit();

  @override
  void initState() {
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

    final result = await _appDomain.getConstructByApiLink(apiLink: 'mvawjq/getDetail', params: {'id': widget.id});
    if (result.status == 1) {
      final videoDetailData = VideoDetailData.fromJson(result.data);
      _asyncValue = AsyncData(videoDetailData);
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
    final result = await _appDomain.getConstructByApiLink(apiLink: 'mvawjq/getDetailRecommendList', params: {'id': widget.id});
    if (result.status == 1) {
      if (result.data case final list when list.isNotEmpty) {
        final feedModelList = list.map<FeedModel>((x) => FeedModel.fromJson(x)).toList();
        _recommendVideoListNotifier.value = feedModelList;
      }
    } else {
      if (result.msg case final msg? when msg.isNotEmpty) {
        MyToast.showText(text: msg);
      }
    }
  }

  // 视频下载
  void _videoDownload(VideoData videoData) async {
    CommonUtils.log('视频下载开始 免费状态isfree: ${videoData.isfree}');
    final result = await _appDomain.getConstructByApiLink(apiLink: 'mvawjq/download', params: {'id': widget.id});
    CommonUtils.log('视频下载:$result');
    if (result.status == 1) {
      final downloadUrl = result.data['downloadUrl'];
      CommonUtils.log('视频下载地址:$downloadUrl');
      _startDownload(downloadUrl, videoData);
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
  }

  Future<void> _startDownload(String downloadUrl, VideoData videoData) async {
    // 先判断本地有没有
    final userNotifier = context.read<UserNotifier>();
    final privilegeDomain = context.read<PrivilegeDomain>();
    final downloadUtil = context.read<DownloadUtil>();
    privilegeDomain.downNum(id: '${videoData.id}', type: CrackAppType.awjq.type).then((res) {
      if (res.status == 1) {
        final downNum = userNotifier.member.videoDownloadValue ?? 0;
        if (downNum > 0) {
          userNotifier.setDownNum(num: downNum - 1);
          final tags = videoData.tags == '' || videoData.tags == null ? [] : videoData.tags!.split(',');
          final taskInfo = {
            'id': '${videoData.id}',
            'urlPath': videoData.source240,
            'title': videoData.title,
            'thumbCover': videoData.coverThumbHorizontal ?? videoData.coverThumbVerticle,
            'tags': tags.join('/'),
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
    return ScreenBackground(
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          extendBodyBehindAppBar: true,
          floatingActionButton: GestureDetector(
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
                VideoView(data: data.detail),
                Container(
                  color: const Color.fromRGBO(16, 16, 16, 1),
                  padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 13.w),
                  child: Row(
                    children: [
                      Text('简介', style: MyTheme.white255_13.s16.w500),
                      const Spacer(),
                      // GestureDetector(
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
                  recommendVideoListNotifier: _recommendVideoListNotifier,
                  downloadCallback: () {
                    _videoDownload(data.detail);
                  },
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Body extends StatefulWidget {
  final ValueNotifier<List<FeedModel>> recommendVideoListNotifier;

  const _Body({
    required this.id,
    required this.data,
    required this.recommendVideoListNotifier,
    this.downloadCallback,
  });

  final int id;
  final VideoDetailData data;
  final VoidCallback? downloadCallback;

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Color.fromRGBO(16, 16, 16, 1)),
      child: CustomScrollView(physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()), slivers: [
        SliverList.list(
          children: [
            SizedBox(height: 10.w),
            Row(
              children: [
                SizedBox(width: 13.w),
                Expanded(
                  child: Text(
                    (widget.data.detail.desc != null && widget.data.detail.desc!.isNotEmpty == true)
                        ? widget.data.detail.desc!
                        : (widget.data.detail.title ?? ''),
                    style: MyTheme.white255_14.w400,
                    maxLines: 2,
                    softWrap: true,
                  ),
                ),
                SizedBox(width: 13.w),
              ],
            ),
            if (widget.data.detail.tags != null && widget.data.detail.tags!.isNotEmpty) _buildTagListWidget(widget.data.detail.tags!),
            SizedBox(height: 10.w),
            _buildStatisticalDataWidget(),
            _buildBannerWidget(widget.data.banner),
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
                        childAspectRatio: AwjqFeedCard.aspectRatio,
                      ),
                      itemBuilder: (context, index) {
                        final item = recommendVideos[index];
                        return AwjqFeedCard(isList: false, feed: item, isInVideoDetail: true);
                      },
                    ),
                  );
                }),
            SizedBox(height: 10.w),
          ],
        ),
      ]),
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
                name: e.title,
                linkUrl: e.linkUrl ?? '',
                resourceUrl: e.resourceUrl ?? '',
                redirectType: e.redirect_type ?? 0,
                router: e.router ?? '',
                reportId: e.reportId ?? 0,
                reportType: e.reportType ?? 0,
                urlStr: e.urlStr ?? ''),
          )
          .toList();
      return Padding(padding: EdgeInsets.all(MyTheme.pagePadding), child: GeneralBannerAppsListWidget(data: banners));
    } catch (e) {
      CommonUtils.log('banner转换出错:$e');
    }
    return const SizedBox.shrink();
  }

  Widget _buildStatisticalDataWidget() {
    Widget current = Row(children: [
      Expanded(child: Text('${CommonUtils.formatNumber(widget.data.detail.countPlay ?? 0)}次观看', style: MyTheme.white255_13.w400)),
      GestureDetector(
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
      SizedBox(width: 20.w),
      AwjqCollectButton(
        apiUrl: 'user/favorites',
        isCollected: widget.data.detail.userFavorites > 0,
        id: widget.data.detail.id ?? 0,
        callback: (isCollected) {
          if (isCollected) {
            widget.data.detail.userFavorites++;
          } else {
            widget.data.detail.userFavorites--;
          }
        },
      ),
      SizedBox(width: 20.w),
      GestureDetector(
        onTap: () async {
          const ShareInviteRoute().push(context);
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 20.w,
              height: 20.w,
              child: MyImage.asset(MyImagePaths.appShareIcon, width: 20.w, height: 20.w),
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
            AwjqVideoTagRoute(videoTag: e).push(context);
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

  final VideoData data;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ShortvMvPlayer(info: data),
    );
  }
}
