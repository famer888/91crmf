import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jycrpj/domain/model/banner_model.dart';
import 'package:jycrpj/domain/type_def.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/xiaolan/widget/xiaolan_creator_sub_view.dart';
import 'package:provider/provider.dart';

import '../../../../../../domain/async_value.dart';
import '../../../../../../domain/domain.dart';
import '../../../../../../domain/model/feed/feed_model.dart';
import '../../../../../../report/ui_layer/report_gesture_detector.dart';
import '../../../../../utils/my_toast.dart';
import '../../../../common_widgets/my_app_bar.dart';
import '../../../../common_widgets/my_tab_bar.dart';
import '../../../../common_widgets/screen_background.dart';
import '../../../../common_widgets/status/loading.dart';
import '../../../../common_widgets/status/network_error.dart';
import '../../../../image_paths.dart';
import '../../../widgets/scroll_top_button.dart';
import '../widget/xiaolan_ads_header.dart';

class XiaolanCreatorScreen extends StatefulWidget {
  const XiaolanCreatorScreen({super.key});

  @override
  State<XiaolanCreatorScreen> createState() => _XiaolanCreatorScreenState();
}

class _XiaolanCreatorScreenState extends State<XiaolanCreatorScreen> with TickerProviderStateMixin {
  AsyncValue<dynamic> _asyncValue = const AsyncInit();
  late final _appDomain = context.read<AppDomain>();
  final ValueNotifier<List<BannerModel>> bannersNotifier = ValueNotifier([]);
  final ScrollController _nestedController = ScrollController();
  final ValueNotifier<bool> _showToTopBtn = ValueNotifier(false);
  List<String> titles = ['推荐', '获赞', '上传', '收益'];

  List<String> subTitles = ['日榜', "周榜", "月榜"];

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  void dispose() {
    bannersNotifier.dispose();
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

  // sort hot/new
  Future<void> _getData() async {
    if (_asyncValue.isLoading) return;
    setState(() {
      _asyncValue = const AsyncLoading();
    });

    final result = await _appDomain.getConstructByApiLink(apiLink: '/api/tabnewxiaolan/rankConf', params: {});
    if (result.status == 1) {
      if (result.data['ads'] case final List data when data.isNotEmpty && bannersNotifier.value.isEmpty) {
        final ads = data.map((x) => BannerModel.fromJson(x)).toList();
        bannersNotifier.value = ads;
      }

      if (result.data case final list when list.isNotEmpty) {
        _asyncValue = AsyncData(result.data);
      }
    } else {
      MyToast.showText(text: result.msg ?? '');
      _asyncValue = const AsyncError();
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      bgColor: Colors.white,
      child: Stack(
        children: [
          Positioned.fill(
              child: Container(
                  decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFB030DA),
                Color(0xFF050188),
              ],
            ),
          ))),
          Scaffold(
              backgroundColor: Colors.transparent,
              body: _asyncValue.maybeWhen(
                  error: (_, __) => NetworkErrorView(onTap: _getData),
                  orElse: () => const LoadingView(),
                  data: (data) {
                    return SafeArea(
                      child: LayoutBuilder(builder: (context, constraints) {
                        return SizedBox(
                          height: constraints.maxHeight, // 使用父级约束的高度
                          child: TabBarWithView.line(
                            isCenter: true,
                            tabBarLeftWidget: Row(
                              children: [
                                SizedBox(
                                  width: 13.w,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: ReportGestureDetector(
                                    child: Image.asset(
                                      MyImagePaths.appBackIcon,
                                      width: 20.w,
                                      height: 20.w,
                                    ),
                                    onTap: () {
                                      context.pop();
                                    },
                                  ),
                                )
                              ],
                            ),
                            tabBarRightWidget: Opacity(
                              opacity: 0,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 13.w,
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: ReportGestureDetector(
                                      child: Image.asset(
                                        MyImagePaths.appBackIcon,
                                        width: 20.w,
                                        height: 20.w,
                                      ),
                                      onTap: () {},
                                    ),
                                  )
                                ],
                              ),
                            ),
                            linearColors: [Color(0xFFCB4AED), Color(0xFF5D3EF9)],
                            labelStyle: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w600),
                            unselectedLabelStyle: TextStyle(
                              color: Colors.white.withValues(alpha: .5),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                            ),
                            titles: ((data['list'] ?? []) as List).map((e) => "${e['name']}").toList(),
                            views: ((data['list'] ?? []) as List).asMap().entries.map((e) {
                              return _buildFilterView(data, e.value);
                              // if (e.key > 0) return _buildFilterView();
                              // return Padding(padding: EdgeInsets.symmetric(horizontal: 12.5.w), child: _buildView());
                            }).toList(),
                          ),
                        );
                      }),
                    );
                  })),
          Positioned(
            right: 20.w,
            bottom: 42.w,
            child: ScrollTopButton(
              showToTopButtonNotifier: _showToTopBtn,
              scrollTopCallback: _scrollToTop,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterView(dynamic data, dynamic type) {
    return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          if (!_nestedController.hasClients) return false;
          final pos = _nestedController.position;
          final viewportHeight = pos.viewportDimension * 0.4; // NestedScrollView可视高度
          final offset = pos.pixels;

          final overOnePage = offset >= viewportHeight;
          _showToTopBtn.value = overOnePage;
          return false;
        },
        child: NestedScrollView(
            controller: _nestedController,
            headerSliverBuilder: (_, __) => [
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 15.w,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child:
                        XiaoLanAdsHeader(bannersNotifier: bannersNotifier, color: Colors.white.withValues(alpha: .7)),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 35.w,
                    ),
                  )
                ],
            body: LayoutBuilder(builder: (context, constraints) {
              return SizedBox(
                height: constraints.maxHeight, // 使用父级约束的高度
                child: TabBarWithView.line(
                  isCenter: true,
                  linearColors: [Colors.transparent, Colors.transparent],
                  labelPadding: 0,
                  tabPadding: EdgeInsets.zero,
                  tabBuilder: (context, tab) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0x33D9D9D9),
                            borderRadius: BorderRadius.circular(32.w),
                          ),
                          child: tab,
                        )
                      ],
                    );
                  },
                  tabItemBuilder: (context, index, isSelected, child) {
                    return Container(
                      width: 80.w,
                      height: 32.w,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: isSelected == true
                              ? [
                                  Color(0xFFCB4AED),
                                  Color(0xFF5D3EF9),
                                ]
                              : [Colors.transparent, Colors.transparent],
                        ),
                        borderRadius: BorderRadius.circular(
                          !isSelected && index == 1 ? 0 : 32.w,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        subTitles[index],
                        style: TextStyle(color: Colors.white, fontSize: 15.sp),
                      ),
                    );
                  },
                  titles: ((data['time_conf'] ?? []) as List).map((e) => "${e['name']}").toList(),
                  views: ((data['time_conf'] ?? []) as List).map((e) {
                    return LayoutBuilder(builder: (context, constraints) {
                      return SizedBox(
                          height: constraints.maxHeight, // 使用父级约束的高度
                          child: XiaolanCreatorSubView(
                            type: type,
                            filter: e,
                            bannersNotifier: bannersNotifier,
                          ));
                    });
                    // return Padding(padding: EdgeInsets.symmetric(horizontal: 12.5.w), child: _buildView());
                  }).toList(),
                ),
              );
            })));
  }
}
