import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/ui_layer/screens/crack/widgets/app_search_tab_bar.dart';

import '../../../../report/ui_layer/report_gesture_detector.dart';

class CustomTabItem {
  final String title;
  final IconData? icon;
  final String? imageUrl;

  /// 选中态渐变（背景）
  final Gradient? activeGradient;

  /// 下划线渐变（优先）
  final Gradient? indicatorGradient;

  /// 未选中态背景
  final Color? inactiveBg;

  /// 选中的文字大小
  double? activeTextSize = 16.sp;

  /// 未选中的文字大小
  double? inactiveTextSize = 16.sp;

  /// 选中的文字颜色
  Color? activeTextColor = const Color.fromRGBO(255, 255, 255, 1);

  /// 未选中的文字颜色
  Color? inactiveTextColor = const Color.fromRGBO(255, 255, 255, 1);

  CustomTabItem({
    required this.title,
    this.icon,
    this.imageUrl,
    this.activeGradient,
    this.indicatorGradient,
    this.inactiveBg,
    this.activeTextSize,
    this.inactiveTextSize,
    this.activeTextColor,
    this.inactiveTextColor,
  });
}

class CustomGradientTabBar extends StatefulWidget {
  final List<CustomTabItem> tabs;
  final ValueNotifier<int> selectedIndex;
  final EdgeInsets? padding;
  final double? height;
  final double? radius;
  final Color? backgroundColor;
  final double? tabPadding;
  final bool showRightWidget;
  final Widget? rightWidget;
  final OnChangeTabCallBack? onChangeTab;

  const CustomGradientTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    this.padding,
    this.height,
    this.radius,
    this.backgroundColor,
    this.tabPadding,
    this.onChangeTab,
    this.showRightWidget = false,
    this.rightWidget,
  });

  @override
  State<CustomGradientTabBar> createState() => _CustomGradientTabBarState();
}

class _CustomGradientTabBarState extends State<CustomGradientTabBar> {
  final ScrollController _scrollController = ScrollController();
  List<GlobalKey> _tabKeys = [];

 void _buildTabs() {
   _tabKeys = List.generate(widget.tabs.length, (_) => GlobalKey());

   widget.selectedIndex.addListener(_scrollToSelected);

   /// 🔥 首帧后自动滚动到初始 tab
   WidgetsBinding.instance.addPostFrameCallback((_) {
     _scrollToSelected();
   });
 }

  @override
  void initState() {
    super.initState();
    _buildTabs();
  }

  @override
  void didUpdateWidget(covariant CustomGradientTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 🔥 关键：当数据源或样式发生变化时，重建 tabs
    if (oldWidget.tabs != widget.tabs) {
      _buildTabs();
      setState(() {});
    }
  }

  @override
  void dispose() {
    widget.selectedIndex.removeListener(_scrollToSelected);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSelected() {
    final index = widget.selectedIndex.value;
    if (index < 0 || index >= _tabKeys.length) return;

    final keyContext = _tabKeys[index].currentContext;
    if (keyContext == null) return;

    final RenderBox box = keyContext.findRenderObject() as RenderBox;
    final RenderBox listBox = context.findRenderObject() as RenderBox;

    final tabOffset = box.localToGlobal(Offset.zero, ancestor: listBox);
    final tabCenter = tabOffset.dx + box.size.width / 2;
    final viewCenter = listBox.size.width / 2;

    final offset = _scrollController.offset + (tabCenter - viewCenter);

    _scrollController.animateTo(
      offset.clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
    );
  }

  double _indicatorWidth(CustomTabItem tab) {
    final base = tab.title.length * 8.w;
    return base.clamp(20.w, 46.w);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height ?? 40.w,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(color: widget.backgroundColor ?? const Color.fromRGBO(0, 0, 0, 0)),
      child: ValueListenableBuilder<int>(
        valueListenable: widget.selectedIndex,
        builder: (context, current, _) {
          return Row(
            children: [
              Expanded(
                child: ListView.separated(
                  controller: _scrollController,
                  // ✅
                  scrollDirection: Axis.horizontal,
                  padding: widget.padding ?? EdgeInsets.symmetric(horizontal: 12.w),
                  itemCount: widget.tabs.length,
                  separatorBuilder: (_, __) => SizedBox(width: 6.w),
                  itemBuilder: (context, index) {
                    final tab = widget.tabs[index];
                    final selected = index == current;

                    return ReportGestureDetector(
                      key: _tabKeys[index], // ✅ 关键
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        widget.selectedIndex.value = index;
                        widget.onChangeTab?.call(index);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        padding: EdgeInsets.symmetric(horizontal: widget.tabPadding ?? 10.w),
                        decoration: BoxDecoration(
                          gradient: selected ? tab.activeGradient : null,
                          color: selected ? null : tab.inactiveBg ?? Colors.transparent,
                          borderRadius: BorderRadius.circular(widget.radius ?? 5.w),
                        ),
                        alignment: Alignment.center,
                        child: Stack(
                          alignment: Alignment.center,
                          clipBehavior: Clip.none,
                          children: [
                            _TabContent(tab: tab, selected: selected),

                            /// ✅ 选中态下划线
                            Positioned(
                              bottom: -6.w, // 可调：贴底 or 悬浮
                              child: AnimatedOpacity(
                                opacity: selected ? 1 : 0,
                                duration: const Duration(milliseconds: 200),
                                child: Container(
                                  height: 3.5.w,
                                  width: _indicatorWidth(tab), // 动态宽度
                                  decoration: BoxDecoration(
                                    gradient: tab.indicatorGradient ??
                                        tab.activeGradient ??
                                        const LinearGradient(
                                          colors: [
                                            Color(0xFF5B8CFF),
                                            Color(0xFF8F6BFF),
                                          ],
                                        ),
                                    borderRadius: BorderRadius.circular(2.w),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (widget.showRightWidget)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: widget.rightWidget,
                ),
            ],
          );
        },
      ),
    );
  }
}

class _TabContent extends StatelessWidget {
  final CustomTabItem tab;
  final bool selected;

  const _TabContent({
    required this.tab,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: selected ? tab.activeTextSize : tab.inactiveTextSize,
      fontWeight: selected ? FontWeight.w600 : FontWeight.w600,
      color: selected ? tab.activeTextColor : tab.inactiveTextColor,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (tab.imageUrl != null)
          Padding(
            padding: EdgeInsets.only(right: 6.w),
            child: Image.network(tab.imageUrl!, width: 18.w, height: 18.w),
          )
        else if (tab.icon != null)
          Padding(
            padding: EdgeInsets.only(right: 6.w),
            child: Icon(tab.icon, size: 18.w, color: textStyle.color),
          ),
        Text(tab.title, style: textStyle),
      ],
    );
  }
}
