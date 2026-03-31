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
import 'package:jycrpj/ui_layer/screens/crack/apps/xiaolan/widget/xiaolan_list_build.dart';
import 'package:jycrpj/ui_layer/utils/common_utils.dart';
import 'package:jycrpj/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';

import '../../../../../../domain/domain.dart';
import '../../../../../../domain/model/banner_model.dart';
import '../../../../../../domain/model/video_detail_model.dart';
import '../../../../../../report/ui_layer/report_gesture_detector.dart';
import '../widget/xiaolan_ads_header.dart';

class XiaolanVideoDetailScreen extends StatefulWidget {
  final int id;

  const XiaolanVideoDetailScreen({super.key, required this.id});

  @override
  State<XiaolanVideoDetailScreen> createState() => _XiaolanVideoDetailScreenState();
}

enum _LoadState { init, loading, success, error }

class _XiaolanVideoDetailScreenState extends State<XiaolanVideoDetailScreen> {
  late final _appDomain = context.read<AppDomain>();
  _LoadState _loadState = _LoadState.init;
  Map<String, dynamic>? _detail;
  List _recommendList = [];
  bool _isLiked = false;
  int _likeCount = 0;
  bool _isLiking = false;

  final ValueNotifier<List<BannerModel>> bannersNotifier = ValueNotifier([]);
  final ScrollController _nestedController = ScrollController();
  final ValueNotifier<bool> _showToTopBtn = ValueNotifier(false);

  Future<void> _toggleLike() async {
    if (_isLiking) return;
    _isLiking = true;
    final result = await _appDomain.getConstructByApiLink(
      apiLink: '/api/mvxiaolan/liking',
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

  Future<void> _onFollow(dynamic user) async {
    MyToast.showLoading();
    final result = await _appDomain.getConstructByApiLink(
      apiLink: '/api/user/toggle_follow',
      params: {'is_follow': user['is_follow'] == 1 ? 0 : 1, "aff": user['aff']},
    );
    MyToast.closeAllLoading();
    if (result.status == 1) {
      MyToast.showText(text: result.data['data']?['msg'] ?? '操作成功');
      setState(() {
        user['is_follow'] = user['is_follow'] == 1 ? 0 : 1;
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
      apiLink: '/api/mvxiaolan/detail480',
      params: {'id': widget.id},
    );

    if (result.status == 1) {
      if (result.data['ads'] case final List data when data.isNotEmpty && bannersNotifier.value.isEmpty) {
        final banner = data.map((x) => BannerModel.fromJson(x)).toList();
        bannersNotifier.value = banner;
      }

      final data = result.data as Map<String, dynamic>;
      _detail = data['detail'] as Map<String, dynamic>;
      final recommend = data['recommend'];
      _recommendList = (recommend is List) ? recommend : [];
      _likeCount = (_detail!['like'] ?? 0) as int;
      _isLiked = (_detail!['is_like'] ?? 0) == 1;
      if (mounted) setState(() => _loadState = _LoadState.success);
    } else {
      if (result.msg case final msg? when msg.isNotEmpty) {
        MyToast.showText(text: msg);
      }
      if (mounted) setState(() => _loadState = _LoadState.error);
    }
  }

  @override
  void dispose() {
    bannersNotifier.dispose();
    _nestedController.dispose();
    _showToTopBtn.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      bgColor: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.white,
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
    final rating = detail['rating'] ?? 0;
    final like = detail['like'] ?? 0;
    final comment = detail['comment'] ?? 0;

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
            child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 15.w,
              ),
              Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Row(
                    children: [
                      Expanded(
                          child: GestureDetector(
                        onTap: () {
                          XiaolanUserWorksRoute(
                            id: "${detail['user']['uid']}",
                            userName: detail['user']['nickname'],
                          ).push(context);
                        },
                        child: Row(
                          children: [
                            Container(
                              width: 50.w,
                              height: 50.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.w),
                              ),
                              child: MyImage.network(detail['user']['thumb'],
                                  fit: BoxFit.cover, borderRadius: 25.w, backgroundColor: const Color(0xFFE6E6E6)),
                            ),
                            SizedBox(
                              width: 11.w,
                            ),
                            Expanded(
                                child: Text(
                              "${detail['user']['nickname']}",
                              style: TextStyle(color: Color(0xFF151515), fontSize: 15.sp, fontWeight: FontWeight.w500),
                            ))
                          ],
                        ),
                      )),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          _onFollow(detail['user']);
                        },
                        child: Container(
                            height: 32.w,
                            width: 69.w,
                            decoration: BoxDecoration(
                              color: Color(0xFF558AEF),
                              borderRadius: BorderRadius.circular(32.w),
                            ),
                            alignment: Alignment.center,
                            child: Text(detail['user']['is_follow'] == 1 ? "已关注" : "关注",
                                style: TextStyle(fontSize: 14.sp, color: Colors.white))),
                      )
                    ],
                  )),
              SizedBox(
                height: 15.w,
              ),
              // 标题
              Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  textAlign: TextAlign.start,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: const Color(0xFF1A1A1A),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                height: 15.w,
              ),
              // 标签
              if (tags.isNotEmpty) ...[
                Container(
                  color: Colors.white,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Wrap(
                    spacing: 8.w,
                    runSpacing: 8.w,
                    children: tags.map((tag) {
                      return ReportGestureDetector(
                        onTap: () {
                          XiaolanCategoryOrTagDetailRoute(id: 0, title: tag, type: 'tag', has_sort: "1").push(context);
                          // XiaolanTagRoute(tag: tag).push(context)
                          // context.push('/xiaolanCategoryOrTagDetail/$id/${type}/${hasSort ? "1" : "0"}/${Uri.encodeComponent(title)}');
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2F2F2),
                            borderRadius: BorderRadius.circular(5.w),
                          ),
                          child: Text(
                            '#$tag',
                            style: TextStyle(fontSize: 12.sp, color: const Color(0xFF666666)),
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
              // 统计信息
              Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Row(
                  children: [
                    Text("${CommonUtils.formatNumber(rating)}播放   ${detail['created_at']}",
                        style: TextStyle(fontSize: 12.sp, color: const Color(0xFF666666))),
                    const Spacer(),
                    GestureDetector(
                      onTap: _toggleLike,
                      child: Row(
                        children: [
                          Image.asset(
                            _isLiked ? "assets/images/app_short_like_h.png" : "assets/images/xiaolan_icon_like.png",
                            width: 16.w,
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Text('${CommonUtils.formatNumber(_likeCount)}',
                              style: TextStyle(fontSize: 12.sp, color: const Color(0xFF666666))),
                        ],
                      ),
                    ),
                    SizedBox(width: 16.w),
                    GestureDetector(
                      onTap: () {
                        ShareInviteRoute().push(context);
                        // XiaolanVideoCommentRoute(videoId: widget.id).push(context);
                      },
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/images/xiaolan_icon_share.png",
                            width: 16.w,
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Text(
                            '分享',
                            style: TextStyle(fontSize: 12.sp, color: const Color(0xFF666666)),
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
              XiaoLanAdsHeader(
                bannersNotifier: bannersNotifier,
              ),
              SizedBox(
                height: 15.w,
              ),
              // 推荐列表标题
              Container(
                color: Colors.white,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Text(
                  '为你推荐',
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.black,
                  ),
                ),
              ),
              // 推荐列表
              Container(
                color: Colors.white,
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
                          return XiaoLanItem.build(
                            XiaoLanItemType.video,
                            item,
                            onTap: () {
                              XiaolanVideoDetailRoute(id: item['id']).push(context);
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
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
