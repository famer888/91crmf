import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jycrpj/domain/type_def.dart';
import 'package:provider/provider.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_list_view.dart';

import '../../../../../../domain/async_value.dart';
import '../../../../../../domain/domain.dart';
import '../../../../../router/routes.dart';
import '../../../../../utils/common_utils.dart';
import '../../../../../utils/my_toast.dart';
import '../../../../common_widgets/my_app_bar.dart';
import '../../../../common_widgets/my_image.dart';
import '../../../../common_widgets/screen_background.dart';
import '../../../../common_widgets/status/loading.dart';
import '../../../../common_widgets/status/network_error.dart';
import '../../../../image_paths.dart';
import '../../../../theme.dart';
import '../widget/tiktok_list_build.dart';

class TiktokUserWorksScreen extends StatefulWidget {
  const TiktokUserWorksScreen({super.key, required this.userId, required this.userName});

  final String userId;
  final String userName;

  @override
  State<TiktokUserWorksScreen> createState() => _TiktokUserWorksScreenState();
}

class _TiktokUserWorksScreenState extends State<TiktokUserWorksScreen> {
  static const Color _collapsedAppBarColor = Color(0xFF181A25);

  late final _appDomain = context.read<AppDomain>();
  bool gridLayout = true;
  bool _innerBoxIsScrolled = false;

  final ScrollController _scrollController = ScrollController();

  double _appBarOpacity = 0;

  AsyncValue<dynamic> _asyncValue = const AsyncInit();

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    _scrollController.addListener(() {
// 开始渐变的位置
      const start = 50.0;

// 完全变黑的位置
      const end = 200.0;

      final offset = _scrollController.offset;

      double opacity;

      if (offset <= start) {
        opacity = 0;
      } else if (offset >= end) {
        opacity = 1;
      } else {
        opacity = (offset - start) / (end - start);
      }

      if (opacity != _appBarOpacity) {
        setState(() {
          _appBarOpacity = opacity;
        });
      }
    });
    if (_asyncValue.isLoading) return;

    setState(() {
      _asyncValue = const AsyncLoading();
    });
    final result = await _appDomain.getConstructByApiLink(apiLink: "/api/Communityttav/peer_center", params: {
      "aff": widget.userId,
    });
    if (result.status == 1) {
      _asyncValue = AsyncData(result.data);
    } else {
      _asyncValue = const AsyncError();
    }

    if (mounted) {
      setState(() {});
    }
  }

  // sort hot/new
  Future<List> _getData({
    required int page,
    required int pageSize,
  }) async {
    bool isInit = false;

    final result = await _appDomain.getConstructByApiLink(apiLink: "/api/Worksttav/videos", params: {
      "uid": widget.userId,
      "page": page,
      "limit": pageSize,
    });

    if (!isInit) {
      setState(() {
        isInit = true;
      });
    }

    if (result.status == 1) {
      return result.data['data'];
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
    return [];
  }

  double get _headerBannerHeight => 250.w;

  double get _toolbarHeight => MyTheme.navbarHegiht;

  /// 头像尺寸（PWA / 客户端均走 ScreenUtil，与设计稿一致）
  double get _headerAvatarSize => 84.w;

  /// 头像与昵称间距，与头部 Column 中 SizedBox 一致
  double get _headerSpacingBelowAvatar => 23.w;

  Widget _buildBackButton(Color iconColor) {
    return GestureDetector(
      onTap: () => context.pop(),
      child: Image.asset(
        MyImagePaths.appBackIcon,
        width: 20.w,
        height: 20.w,
        color: iconColor,
      ),
    );
  }

  Widget _buildTabBody() {
    return MyListView.grid(
      padding: EdgeInsets.symmetric(
        horizontal: MyTheme.pagePadding,
      ),
      crossAxisCount: gridLayout ? 2 : 1,
      mainAxisSpacing: 10.w,
      crossAxisSpacing: gridLayout ? 8.w : 10.w,
      childAspectRatio: gridLayout ? 344 / 240 : 704 / 439,
      itemBuilder: (context, item, index) => TiktokItem.build(TiktokItemType.video, item, onTap: () {
        TiktokVideoDetailRoute(id: item['id']).push(context);
      }),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      bgColor: const Color(0xFF181A25),
      child: _asyncValue.maybeWhen(
        data: (data) {
          final topPadding = MediaQuery.paddingOf(context).top;
          final title = widget.userName;
          final desc = data['desc']?.toString() ?? '';
          final fabulous_count = CommonUtils.formatNumber(data['fabulous_count']);
          final videosCount = CommonUtils.formatNumber(data['videos']);
          return Scaffold(
              extendBodyBehindAppBar: true,
              backgroundColor: Colors.transparent,
              body: Stack(
                children: [
                  NestedScrollView(
                      controller: _scrollController,
                      headerSliverBuilder: (context, innerBoxIsScrolled) {
                        return [
                          SliverToBoxAdapter(
                              child: Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      final imageUrl = CommonUtils.clipImageUrl("${data['background_img']}",
                                          inputWidth: constraints.maxWidth);
                                      return FadeInImage.memoryNetwork(
                                        placeholder: kTransparentImage,
                                        image: imageUrl,
                                        fit: BoxFit.fitWidth,
                                        alignment: Alignment.topCenter,
                                        width: double.infinity,
                                        fadeOutDuration: const Duration(milliseconds: 300),
                                        fadeInDuration: const Duration(milliseconds: 500),
                                        imageErrorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 11.w),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: topPadding + 70.w,
                                    ),
                                    Container(
                                      width: _headerAvatarSize,
                                      height: _headerAvatarSize,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(_headerAvatarSize),
                                          color: Color(0xFFF52C56)),
                                      padding: EdgeInsets.all(2.w),
                                      child: MyImage.network(
                                        data['thumb'] ?? "",
                                        borderRadius: _headerAvatarSize,
                                      ),
                                    ),
                                    SizedBox(
                                      height: _headerSpacingBelowAvatar,
                                    ),
                                    Text(
                                      "${data['nickname']}",
                                      style:
                                          TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      height: 15.w,
                                    ),
                                    if (desc.isNotEmpty) ...[
                                      Text(
                                        desc,
                                        style: TextStyle(
                                            color: const Color(0xFFE8E8E8),
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(
                                        height: 15.w,
                                      ),
                                    ],
                                    Text.rich(TextSpan(children: [
                                      TextSpan(
                                        text: fabulous_count,
                                        style: TextStyle(
                                            color: const Color(0xFFE8E8E8),
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      TextSpan(
                                        text: "  点赞",
                                        style: TextStyle(
                                            color: Colors.white.withOpacity(.5),
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ])),
                                    SizedBox(
                                      height: 15.w,
                                    ),
                                    Text(
                                      "长视频($videosCount)",
                                      style:
                                          TextStyle(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.w400),
                                    ),
                                    SizedBox(
                                      height: 10.w,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ))
                        ];
                      },
                      body: _buildTabBody()),
                  Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        color: _collapsedAppBarColor.withOpacity(_appBarOpacity),
                        child: MyAppBar(
                          title: title,
                          backIconColor: Colors.white,
                          titleColor: Colors.white.withOpacity(_appBarOpacity),
                          backgroundColor: Colors.transparent,
                        ),
                      ))
                ],
              ));
        },
        error: (_, __) => Column(
          children: [
            SafeArea(
              bottom: false,
              child: SizedBox(
                height: _toolbarHeight,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: _buildBackButton(Colors.white),
                  ),
                ),
              ),
            ),
            Expanded(
              child: NetworkErrorView(onTap: _init),
            ),
          ],
        ),
        orElse: () => const SafeArea(child: LoadingView()),
      ),
    );
  }
}
