import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jycrpj/domain/type_def.dart';
import 'package:jycrpj/ui_layer/router/routes.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/status/loading.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/status/network_error.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/video_player/shortv_mv_player.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/tiktok/widget/tiktok_list_build.dart';
import 'package:jycrpj/ui_layer/utils/common_utils.dart';
import 'package:jycrpj/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';
import 'package:utils/utils.dart';

import '../../../../../../domain/domain.dart';
import '../../../../../../domain/model/banner_model.dart';
import '../../../../../../domain/model/video_detail_model.dart';
import '../../../../../../report/ui_layer/report_gesture_detector.dart';
import '../../../widgets/scroll_top_button.dart';
import '../widget/tiktok_ads_header.dart';

class TiktokVideoDetailScreen extends StatefulWidget {
  final int id;

  const TiktokVideoDetailScreen({super.key, required this.id});

  @override
  State<TiktokVideoDetailScreen> createState() => _TiktokVideoDetailScreenState();
}

enum _LoadState { init, loading, success, error }

class _TiktokVideoDetailScreenState extends State<TiktokVideoDetailScreen> {
  late final _appDomain = context.read<AppDomain>();
  _LoadState _loadState = _LoadState.init;
  Map<String, dynamic>? _detail;
  List _recommendList = [];
  bool _isLiked = false;
  int _likeCount = 0;
  bool _isfavorite = false;
  int _favoriteCount = 0;
  bool _isLiking = false;

  final ValueNotifier<List<BannerModel>> bannersNotifier = ValueNotifier([]);
  final ScrollController _nestedController = ScrollController();
  final ValueNotifier<bool> _showToTopBtn = ValueNotifier(false);

  Future<void> _toggleLike() async {
    if (_isLiking) return;
    _isLiking = true;
    final result = await _appDomain.getConstructByApiLink(
      apiLink: '/api/favoritesttav/mv_like',
      params: {'id': widget.id},
    );
    _isLiking = false;
    if (result.status == 1) {
      setState(() {
        _isLiked = !_isLiked;
        _likeCount += _isLiked ? 1 : -1;
      });
      MyToast.showText(text: result.data['data']?['msg'] ?? '操作成功');
    } else {
      MyToast.showText(text: result.msg ?? '操作失败');
    }
  }

  Future<void> _onFavorite() async {
    MyToast.showLoading();
    final result = await _appDomain.getConstructByApiLink(
      apiLink: '/api/mvttav/favorite',
      params: {
        'id': widget.id,
        'relatedId': widget.id,
      },
    );
    MyToast.closeAllLoading();
    if (result.status == 1) {
      MyToast.showText(text: result.data['data']?['msg'] ?? '操作成功');
      setState(() {
        _isfavorite = !_isfavorite;
        _favoriteCount += _isfavorite ? 1 : -1;
      });
    } else {
      MyToast.showText(text: result.msg ?? '操作失败');
    }
  }

  @override
  void initState() {
    _initData();
    super.initState();
  }

  Future<void> _initData() async {
    if (_loadState == _LoadState.loading) return;
    setState(() => _loadState = _LoadState.loading);

    final result = await _appDomain.getConstructByApiLink(
      apiLink: '/api/mvttav/detail',
      params: {'id': widget.id},
    );

    if (result.status == 1) {
      if (result.data['ads'] case final List data when data.isNotEmpty && bannersNotifier.value.isEmpty) {
        final banner = data.map((x) => BannerModel.fromJson(x)).toList();
        bannersNotifier.value = banner;
      }

      final data = result.data as Map<String, dynamic>;
      _detail = data['row'] as Map<String, dynamic>;
      _getRecommend();
      _likeCount = (_detail!['like'] ?? 0) as int;
      _isLiked = (_detail!['is_like'] ?? 0) == 1;

      _favoriteCount = (_detail!['favorite'] ?? 0) as int;
      _isfavorite = (_detail!['is_favorite'] ?? 0) == 1;
      if (mounted) setState(() => _loadState = _LoadState.success);
    } else {
      if (result.msg case final msg? when msg.isNotEmpty) {
        MyToast.showText(text: msg);
      }
      if (mounted) setState(() => _loadState = _LoadState.error);
    }
  }

  Future _getRecommend() async {
    final result2 = await _appDomain.getConstructByApiLink(
      apiLink: '/api/mvttav/recommend',
      params: {'id': widget.id},
    );
    if (mounted) {
      setState(() {
        _recommendList = result2.data['list'] ?? [];
      });
    }
  }

  @override
  void dispose() {
    bannersNotifier.dispose();
    _nestedController.dispose();
    _showToTopBtn.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    if (!_nestedController.hasClients) return;

    _showToTopBtn.value = false;
    _nestedController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      bgColor: Color(0xFF181A25),
      child: Scaffold(
        backgroundColor: Color(0xFF181A25),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_loadState == _LoadState.loading || _loadState == _LoadState.init) {
      return const LoadingView();
    }
    if (_loadState == _LoadState.error || _detail == null) {
      return NetworkErrorView(onTap: _initData);
    }
    return _buildContent(_detail!);
  }

  Widget _buildContent(Map<String, dynamic> detail) {
    final playUrl = detail['play_url'] as String? ?? '';
    final title = detail['title'] as String? ?? '';
    final tagsList = detail['tags_list'];
    final List<String> tags = tagsList is List ? List<String>.from(tagsList) : [];
    final durationStr = detail['duration_str'] as String? ?? '';
    final rating = detail['play_num'] ?? 0;

    return Column(
      children: [
        // 视频播放器
        Container(
          color: Colors.black,
          child: SafeArea(
            bottom: false,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: _VideoPlayerView(
                playUrl: playUrl,
                coverUrl: detail['cover_thumb_url'] as String? ?? '',
              ),
            ),
          ),
        ),
        Expanded(
            child: Stack(
          children: [
            NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification notification) {
                  if (!_nestedController.hasClients) return false;
                  final pos = _nestedController.position;
                  final viewportHeight = pos.viewportDimension * 0.4; // NestedScrollView可视高度
                  final offset = pos.pixels;

                  final overOnePage = offset >= viewportHeight;
                  _showToTopBtn.value = overOnePage;
                  return false;
                },
                child: SingleChildScrollView(
                  controller: _nestedController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: Container(
                            padding: EdgeInsets.symmetric(vertical: 13.w, horizontal: 11.w),
                            decoration:
                                BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFF343743), width: 1.w))),
                            child: Text(
                              "简介",
                              style: TextStyle(color: Color(0xFFF3F3F4), fontSize: 15.sp),
                            ),
                          ))
                        ],
                      ),
                      SizedBox(
                        height: 8.w,
                      ),
                      // 标题
                      Container(
                        color: Color(0xFF181A25),
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          title,
                          textAlign: TextAlign.start,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(0xFFE8E8E8),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 11.w,
                      ),
                      // 标签
                      if (tags.isNotEmpty) ...[
                        Container(
                          color: Color(0xFF181A25),
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: Wrap(
                            spacing: 8.w,
                            runSpacing: 8.w,
                            children: tags.map((tag) {
                              return ReportGestureDetector(
                                onTap: () {
                                  TiktokVideoClassDetailRoute(id: 0)
                                      .push(context);
                                  // TiktokTagRoute(tag: tag).push(context)
                                  // context.push('/xiaolanCategoryOrTagDetail/$id/${type}/${hasSort ? "1" : "0"}/${Uri.encodeComponent(title)}');
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.w),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF282B34),
                                    borderRadius: BorderRadius.circular(5.w),
                                  ),
                                  child: Text(
                                    '#$tag',
                                    style: TextStyle(fontSize: 12.sp, color: const Color(0xFFD2D3D4)),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(
                          height: 15.w,
                        ),
                      ],
                      Container(
                          color: Color(0xFF181A25),
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: Row(
                            children: [
                              Expanded(
                                  child: GestureDetector(
                                onTap: () {
                                  TiktokUserWorksRoute(
                                    id: "${detail['user']['uid']}",
                                    userName: detail['user']['nickname'],
                                  ).push(context);
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      width: 36.w,
                                      height: 36.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25.w),
                                      ),
                                      child: MyImage.network(detail['user']['thumb'],
                                          fit: BoxFit.cover,
                                          borderRadius: 25.w,
                                          backgroundColor: const Color(0xFFE6E6E6)),
                                    ),
                                    SizedBox(
                                      width: 11.w,
                                    ),
                                    Expanded(
                                        child: Text(
                                      "${detail['user']['nickname']}",
                                      style: TextStyle(
                                          color: Color(0xFFE8E8E8), fontSize: 15.sp, fontWeight: FontWeight.w400),
                                    ))
                                  ],
                                ),
                              )),
                              Text(
                                "作品${CommonUtils.formatNumber(_detail?['user']['fans_count'] ?? 0)}",
                                style: TextStyle(color: Color(0xFF8A8B8C), fontSize: 13.sp),
                              ),
                              Container(
                                height: 12.w,
                                width: 1.w,
                                color: Color(0xFF8A8B8C),
                                margin: EdgeInsets.symmetric(horizontal: 7.w),
                              ),
                              Text(
                                "粉丝${CommonUtils.formatNumber(_detail?['user']['fans_count'] ?? 0)}",
                                style: TextStyle(color: Color(0xFF8A8B8C), fontSize: 13.sp),
                              ),
                            ],
                          )),
                      SizedBox(
                        height: 15.w,
                      ),

                      // 统计信息
                      Container(
                        color: Color(0xFF181A25),
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Row(
                          children: [
                            Text("${CommonUtils.formatNumber(rating)}次观看",
                                style: TextStyle(fontSize: 12.sp, color: const Color(0xFFD8D8D8))),
                            const Spacer(),
                            GestureDetector(
                              onTap: _toggleLike,
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/images/tiktok_icon_like.png",
                                    width: 16.w,
                                    color: _isLiked ? Color(0xFFF52C56) : Color(0xFFD8D8D8),
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Text('${CommonUtils.formatNumber(_likeCount)}',
                                      style: TextStyle(fontSize: 12.sp, color: const Color(0xFFD8D8D8))),
                                ],
                              ),
                            ),
                            SizedBox(width: 16.w),
                            GestureDetector(
                              onTap: _toggleLike,
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/images/tiktok_icon_collection.png",
                                    width: 16.w,
                                    color: _isfavorite ? Color(0xFFF52C56) : Color(0xFFD8D8D8),
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Text('${CommonUtils.formatNumber(_likeCount)}',
                                      style: TextStyle(fontSize: 12.sp, color: const Color(0xFFD8D8D8))),
                                ],
                              ),
                            ),
                            SizedBox(width: 16.w),
                            GestureDetector(
                              onTap: () {
                                ShareInviteRoute().push(context);
                                // TiktokVideoCommentRoute(videoId: widget.id).push(context);
                              },
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/images/tiktok_icon_share.png",
                                    width: 16.w,
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Text(
                                    '分享',
                                    style: TextStyle(fontSize: 12.sp, color: const Color(0xFFD8D8D8)),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15.w,
                      ),
                      TiktokAdsHeader(
                        bannersNotifier: bannersNotifier,
                      ),
                      SizedBox(
                        height: 15.w,
                      ),
                      // 推荐列表标题
                      Container(
                        color: Color(0xFF181A25),
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Text(
                          '为你推荐',
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: Color(0xFFF3F3F4),
                          ),
                        ),
                      ),
                      // 推荐列表
                      Container(
                        color: Color(0xFF181A25),
                        child: _recommendList.isEmpty
                            ? Container(
                                height: 200,
                                child: Center(
                                  child: Text(
                                    '暂无推荐',
                                    style: TextStyle(fontSize: 14.sp, color: const Color(0xFF999999)),
                                  ),
                                ),
                              )
                            : GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.symmetric(horizontal: 12.5.w, vertical: 8.w),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 10.h,
                                  crossAxisSpacing: 8.w,
                                  childAspectRatio: 344 / 240,
                                ),
                                itemCount: _recommendList.length,
                                itemBuilder: (context, index) {
                                  final item = _recommendList[index];
                                  return TiktokItem.build(
                                    TiktokItemType.video,
                                    item,
                                    onTap: () {
                                      TiktokVideoDetailRoute(id: item['id']).push(context);
                                    },
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                )),
            Positioned(
              right: 20.w,
              bottom: 42.w,
              child: ScrollTopButton(
                showToTopButtonNotifier: _showToTopBtn,
                scrollTopCallback: _scrollToTop,
              ),
            ),
          ],
        ))
      ],
    );
  }

  Widget _buildStatItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15.sp, color: const Color(0xFF999999)),
        SizedBox(width: 3.w),
        Text(text, style: TextStyle(fontSize: 12.sp, color: const Color(0xFF999999))),
      ],
    );
  }
}

class _VideoPlayerView extends StatelessWidget {
  final String playUrl;
  final String coverUrl;

  const _VideoPlayerView({required this.playUrl, required this.coverUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: playUrl.isNotEmpty
          ? ShortvMvPlayer(
              info: VideoData(
                source240: playUrl,
                coverThumbVerticle: coverUrl,
                isfree: 1,
              ),
            )
          : Center(
              child: Icon(Icons.play_circle_outline, color: Colors.white, size: 48.sp),
            ),
    );
  }
}
