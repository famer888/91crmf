import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../../domain/async_value.dart';
import '../../../../../../domain/domain.dart';
import '../../../../../../domain/model/feed/feed_model.dart';
import '../../../../../../report/ui_layer/report_gesture_detector.dart';
import '../../../../common_widgets/my_app_bar.dart';
import '../../../../common_widgets/my_tab_bar.dart';
import '../../../../common_widgets/screen_background.dart';
import '../../../../common_widgets/status/loading.dart';
import '../../../../common_widgets/status/network_error.dart';
import '../../../../image_paths.dart';

class XiaolanCreatorScreen extends StatefulWidget {
  const XiaolanCreatorScreen({super.key});

  @override
  State<XiaolanCreatorScreen> createState() => _XiaolanCreatorScreenState();
}

class _XiaolanCreatorScreenState extends State<XiaolanCreatorScreen> with TickerProviderStateMixin {
  AsyncValue<List<FeedModel>> _asyncValue = const AsyncInit();
  late final _appDomain = context.read<AppDomain>();

  late final TabController _tabController;
  int _initialIndex = 0;
  List<String> titles = ['推荐', '获赞', '上传', '收益'];

  List<String> subTitles = ['日榜', "周榜", "月榜"];

  @override
  void initState() {
    _tabController = TabController(length: titles.length, vsync: this, initialIndex: _initialIndex);

    _initTagList();
    super.initState();
  }

  // sort hot/new
  Future<void> _initTagList() async {
    if (_asyncValue.isLoading) return;
    setState(() {
      _asyncValue = const AsyncLoading();
    });

    _asyncValue = AsyncData([]);
    //
    //
    // final result = await _appDomain.getConstructByApiLink(
    //     apiLink: 'mvhjgj/list_tag_mvs',
    //     params: {'tag': widget.videoTag, 'sort': 'hot'});
    // if (result.status == 1) {
    //   if (result.data case final list when list.isNotEmpty) {
    //     final feedModelList =
    //         list?.map<FeedModel>((x) => FeedModel.fromJson(x)).toList();
    //     _asyncValue = AsyncData(feedModelList);
    //   }
    // } else {
    //   MyToast.showText(text: result.msg ?? '');
    //   _asyncValue = const AsyncError();
    // }

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
            body: SafeArea(
              child: LayoutBuilder(builder: (context, constraints) {
                return SizedBox(
                  height: constraints.maxHeight, // 使用父级约束的高度
                  child: TabBarWithView.line(
                    tabController: _tabController,
                    initialIndex: _initialIndex,
                    isCenter: true,
                    tabBarLeftWidget: Row(
                      children: [
                        SizedBox(width: 13.w,),
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
                          SizedBox(width: 13.w,),
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
                    titles: titles,
                    views: titles.asMap().entries.map((e) {
                      if (e.key > 0) return _buildFilterView();
                      return Padding(padding: EdgeInsets.symmetric(horizontal: 12.5.w), child: _buildView());
                    }).toList(),
                  ),
                );
              }),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFilterView() {
    return LayoutBuilder(builder: (context, constraints) {
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
          titles: subTitles,
          views: subTitles.map((e) {
            return Padding(padding: EdgeInsets.symmetric(horizontal: 12.5.w), child: _buildView());
          }).toList(),
        ),
      );
    });
  }

  Widget _buildView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(child: _buildTop3Item(1)),
              SizedBox(
                width: 4.w,
              ),
              Expanded(child: _buildTop3Item(0)),
              SizedBox(
                width: 4.w,
              ),
              Expanded(child: _buildTop3Item(2)),
            ],
          ),
          SizedBox(
            height: 19.w,
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              String no = "${index + 4}";
              return Row(
                children: [
                  Text(
                    "${no.length < 2 ? "0" : ""}${no}",
                    style: TextStyle(color: Colors.white, fontSize: 15.sp),
                  ),
                  SizedBox(
                    width: 16.w,
                  ),
                  Expanded(child: _buildUser(vertical: false))
                ],
              );
            },
            separatorBuilder: (context, index) => SizedBox(
              height: 20.w,
            ),
            itemCount: 20,
          ),
          SizedBox(
            height: 12.5.w,
          )
        ],
      ),
    );
  }

  Widget _buildTop3Item(int index) {
    return Column(
      children: [
        _buildUser(vertical: true),
        SizedBox(
          height: 22.5.h,
        ),
        Image.asset(
          "assets/images/xiaolan_no${index + 1}.png",
          width: double.infinity,
        ),
      ],
    );
  }

  Widget _buildUser({bool vertical = true}) {
    double avatarSize = vertical ? 65.w : 44.w;
    List<Widget> widgets = [
      Container(
        width: avatarSize,
        height: avatarSize,
        decoration: BoxDecoration(color: Color(0xFF0060FC), shape: BoxShape.circle),
      ),
      SizedBox(
        width: 6.w,
        height: 3.5.w,
      ),
      Column(
        children: [
          Text(
            "创作达人",
            style: TextStyle(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.w400),
          ),
          Text(
            "作品数：342",
            style: TextStyle(color: Color(0x66E4E4E4), fontSize: 12.sp, fontWeight: FontWeight.w400),
          ),
        ],
      )
    ];
    if (vertical == true) {
      return Column(
        children: widgets,
      );
    } else {
      return Row(
        children: widgets,
      );
    }
  }
}
