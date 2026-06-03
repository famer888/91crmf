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
  late final _appDomain = context.read<AppDomain>();
  bool gridLayout = true;

  AsyncValue<dynamic> _asyncValue = const AsyncInit();

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _init() async {
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

  double _measureTextHeight({
    required BuildContext context,
    required String text,
    required TextStyle style,
    required double maxWidth,
    int? maxLines,
  }) {
    if (text.isEmpty) return 0;

    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: Directionality.of(context),
      maxLines: maxLines,
    )..layout(maxWidth: maxWidth);

    return textPainter.size.height;
  }

  double _calculateExpandedHeight(BuildContext context, dynamic data) {
    final topPadding = MediaQuery.paddingOf(context).top;
    final horizontalPadding = 24.w;
    final contentWidth = MediaQuery.sizeOf(context).width - horizontalPadding;
    final nicknameStyle = TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.w600);
    final descStyle = TextStyle(color: const Color(0xFFE8E8E8), fontSize: 14.sp, fontWeight: FontWeight.w400);
    final statsStyle = TextStyle(color: const Color(0xFFE8E8E8), fontSize: 14.sp, fontWeight: FontWeight.w400);
    final longVideoStyle = TextStyle(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.w400);
    final desc = data['desc']?.toString() ?? '';
    final nickname = data['nickname']?.toString() ?? '';
    final videosCount = CommonUtils.formatNumber(data['videos']);

    final contentHeight = _headerAvatarSize +
        _headerSpacingBelowAvatar +
        _measureTextHeight(
          context: context,
          text: nickname,
          style: nicknameStyle,
          maxWidth: contentWidth,
          maxLines: 1,
        ) +
        15.w +
        (desc.isNotEmpty
            ? _measureTextHeight(
                  context: context,
                  text: desc,
                  style: descStyle,
                  maxWidth: contentWidth,
                  maxLines: 3,
                ) +
                15.w
            : 0) +
        _measureTextHeight(
          context: context,
          text: videosCount,
          style: statsStyle,
          maxWidth: contentWidth,
          maxLines: 1,
        ) +
        15.w +
        _measureTextHeight(
          context: context,
          text: "长视频($videosCount)",
          style: longVideoStyle,
          maxWidth: contentWidth,
          maxLines: 1,
        );

    final dynamicHeight = topPadding + 50.w + contentHeight + 24.w;
    return dynamicHeight > (_toolbarHeight + _headerBannerHeight)
        ? dynamicHeight
        : (_toolbarHeight + _headerBannerHeight);
  }

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

  List<Widget> _buildHeaderSlivers(BuildContext context, dynamic data, bool innerBoxIsScrolled) {
    final topPadding = MediaQuery.paddingOf(context).top;
    final title = widget.userName;
    final desc = data['desc']?.toString() ?? '';
    final fabulous_count = CommonUtils.formatNumber(data['fabulous_count']);
    final videosCount = CommonUtils.formatNumber(data['videos']);
    final expandedHeight = _calculateExpandedHeight(context, data);

    return [
      SliverAppBar(
        pinned: true,
        expandedHeight: expandedHeight,
        toolbarHeight: _toolbarHeight,
        backgroundColor: const Color(0xFF181A25),
        surfaceTintColor: Colors.transparent,
        elevation: innerBoxIsScrolled ? 0.5 : 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: innerBoxIsScrolled && title.isNotEmpty
            ? Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: MyTheme.white255_18_B,
              )
            : null,
        leading: Padding(
          padding: EdgeInsets.only(left: MyTheme.pagePadding - 4.w),
          child: _buildBackButton(Colors.white),
        ),
        leadingWidth: 20.w + MyTheme.pagePadding,
        flexibleSpace: FlexibleSpaceBar(
          collapseMode: CollapseMode.pin,
          background: Stack(
            fit: StackFit.expand,
            alignment: Alignment.topCenter,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final imageUrl =
                        CommonUtils.clipImageUrl("${data['background_img']}", inputWidth: constraints.maxWidth);
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
              Positioned(
                top: topPadding + 50.w,
                left: 12.w,
                right: 12.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: _headerAvatarSize,
                      height: _headerAvatarSize,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(_headerAvatarSize), color: Color(0xFFF52C56)),
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
                      style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 15.w,
                    ),
                    if (desc.isNotEmpty) ...[
                      Text(
                        desc,
                        style: TextStyle(color: const Color(0xFFE8E8E8), fontSize: 14.sp, fontWeight: FontWeight.w400),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 15.w,
                      ),
                    ],
                    Row(
                      children: [
                        Text(
                          fabulous_count,
                          style:
                              TextStyle(color: const Color(0xFFE8E8E8), fontSize: 14.sp, fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Text(
                          "点赞",
                          style: TextStyle(
                              color: Colors.white.withOpacity(.5), fontSize: 12.sp, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15.w,
                    ),
                    Text(
                      "长视频($videosCount)",
                      style: TextStyle(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ];
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
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: _asyncValue.maybeWhen(
          data: (data) {
            return NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) =>
                  _buildHeaderSlivers(context, data, innerBoxIsScrolled),
              body: _buildTabBody(),
            );
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
      ),
    );
  }
}
