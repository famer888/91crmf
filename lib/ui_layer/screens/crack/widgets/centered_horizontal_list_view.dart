import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/domain/model/crack_model.dart';
import 'package:jycrpj/ui_layer/screens/black/widget/interval_gesture_widget.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jycrpj/ui_layer/screens/crack/widgets/crack_status_tag.dart';
import 'package:jycrpj/ui_layer/screens/theme.dart';

typedef OnPageChanged = void Function(int index, CrackApp appData);

class CenteredHorizontalHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double height;
  final List<CrackApp> crackApps;
  final OnPageChanged onPageChanged;

  CenteredHorizontalHeaderDelegate({
    required this.height,
    required this.crackApps,
    required this.onPageChanged,
  });

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.black, // ⚠️ 一定要有背景色，防止穿透
      child: CenteredHorizontalListView(
        crackApps: crackApps,
        onPageChanged: onPageChanged,
      ),
    );
  }

  @override
  bool shouldRebuild(covariant CenteredHorizontalHeaderDelegate oldDelegate) {
    return oldDelegate.crackApps != crackApps;
  }
}

class CenteredHorizontalListView extends StatefulWidget {
  final List<CrackApp> crackApps;
  final Color? backgroundColor;
  final OnPageChanged onPageChanged;

  const CenteredHorizontalListView({super.key, required this.crackApps, required this.onPageChanged, this.backgroundColor});

  @override
  State<CenteredHorizontalListView> createState() => _CenteredHorizontalListViewState();
}

class _CenteredHorizontalListViewState extends State<CenteredHorizontalListView> {
  late final _screenUtil = ScreenUtil();
  final ScrollController _controller = ScrollController();

  late double itemWidth; // 你的 itemWidth
  final double horizontalPadding = 4 * MyTheme.spacing; // 左右 Padding
  final double pagePadding = 2 * MyTheme.pagePadding;
  double get itemTotalWidth => itemWidth + horizontalPadding + pagePadding;
  int _selectedIndex = 0;


  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // ⚠️ 只在这里计算一次
    itemWidth = (_screenUtil.screenWidth - 2 * MyTheme.pagePadding - 4 * MyTheme.spacing) / 5;
  }

  void _scrollToCenter(int index) {
    // 第 0、1 个不居中
    if (index < 2) return;

    final screenWidth = _screenUtil.screenWidth ;

    final targetOffset = index * itemTotalWidth + itemWidth / 2 - screenWidth / 2;

    _controller.animateTo(
      targetOffset.clamp(
        0.0,
        _controller.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: itemWidth + 28.w,
      color: widget.backgroundColor ?? const Color.fromRGBO(0, 0, 0, 0),
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: ListView.builder(
          controller: _controller,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: widget.crackApps.length,
          itemBuilder: (context, index) {
            final crackApp = widget.crackApps[index];
            return IntervalGestureWidget(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                _scrollToCenter(index);
                _onPageChanged(index);
                widget.onPageChanged.call(index, crackApp);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.w)),
                        border: Border.all(
                          width: 1.0,
                          color: _selectedIndex == index ? MyTheme.blueColor64 : const Color.fromRGBO(0, 0, 0, 0),
                        ),
                      ),
                      child: SizedBox.square(
                        dimension: itemWidth,
                        child: Stack(
                          children: [
                            MyImage.network(crackApp.logo, fit: BoxFit.cover, borderRadius: 10.w),
                            CrackStatusTag(appData: crackApp),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 5.w),
                    Text(
                      crackApp.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _selectedIndex == index ? MyTheme.blueColor64 : Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 11.sp,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }



  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
