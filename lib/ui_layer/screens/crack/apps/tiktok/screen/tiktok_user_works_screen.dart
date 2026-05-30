import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jycrpj/domain/type_def.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jycrpj/data_layer/repo/repo.dart';
import 'package:jycrpj/ui_layer/notifiers/home_config_notifier.dart';
import 'package:provider/provider.dart';

import '../../../../../../domain/async_value.dart';
import '../../../../../../domain/domain.dart';
import '../../../../../../domain/model/feed/feed_model.dart';
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
    final title = "${widget.userName ?? ''}";
    final expandedHeight = _toolbarHeight + _headerBannerHeight;

    return [
      SliverAppBar(
        primary: false,
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
                child: MyImage.network(
                  "${data['background_img']}",
                  fit: BoxFit.fitWidth,
                  width: double.infinity,
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
                              width: 84.w,
                              height: 84.w,
                              decoration:
                                  BoxDecoration(borderRadius: BorderRadius.circular(84.w), color: Color(0xFFF52C56)),
                              padding: EdgeInsets.all(2.w),
                              child: MyImage.network(
                                data['thumb'] ?? "",
                                borderRadius: 84.w,
                              ),
                            ),
                            SizedBox(
                              height: 23.w,
                            ),
                            Text(
                              "${data['nickname']}",
                              style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 15.w,
                            ),
                            if ("${data['desc'] ?? ""}".isNotEmpty) ...[
                              Text(
                                "${data['desc']}",
                                style:
                                    TextStyle(color: Color(0xFFE8E8E8), fontSize: 14.sp, fontWeight: FontWeight.w400),
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
                                  "${CommonUtils.formatNumber(data['videos'])}",
                                  style:
                                      TextStyle(color: Color(0xFFE8E8E8), fontSize: 14.sp, fontWeight: FontWeight.w400),
                                ),
                                SizedBox(width: 10.w,),
                                Text(
                                  "点赞",
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(.5),
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15.w,
                            ),
                            Text(
                              "长视频(${CommonUtils.formatNumber(data['videos'])})",
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
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding, vertical: 8.w),
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
    ;
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
