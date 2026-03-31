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
import '../../../../../utils/my_toast.dart';
import '../../../../common_widgets/my_app_bar.dart';
import '../../../../common_widgets/screen_background.dart';
import '../../../../common_widgets/status/loading.dart';
import '../../../../common_widgets/status/network_error.dart';
import '../../../../theme.dart';
import '../widget/xiaolan_list_build.dart';

class XiaolanDailyScreen extends StatefulWidget {
  const XiaolanDailyScreen({super.key});

  @override
  State<XiaolanDailyScreen> createState() => _XiaolanDailyScreenState();
}

class _XiaolanDailyScreenState extends State<XiaolanDailyScreen> {
  late final _appDomain = context.read<AppDomain>();
  late final _homeConfigNotifier = context.read<HomeConfigNotifier>();
  DateTime _selectedDate = DateTime.now();
  AsyncValue<List> _asyncValue = const AsyncData([]);

  static const List<String> _monthLabels = [
    '一月',
    '二月',
    '三月',
    '四月',
    '五月',
    '六月',
    '七月',
    '八月',
    '九月',
    '十月',
    '十一月',
    '十二月',
  ];

  String get _recommendDateLabel {
    final month = _selectedDate.month.toString().padLeft(2, '0');
    final day = _selectedDate.day.toString().padLeft(2, '0');
    return '$month-$day推荐';
  }

  Future<void> _openCalendarDialog() async {
    final pickedDate = await showDialog<DateTime>(
      context: context,
      builder: (context) => _XiaolanCalendarDialog(
        initialDate: _selectedDate,
        monthLabels: _monthLabels,
      ),
    );

    if (pickedDate == null || !mounted) {
      return;
    }

    setState(() {
      _selectedDate = pickedDate;
      _asyncValue = const AsyncLoading();
      Future.delayed(const Duration(milliseconds: 300), () {
        _asyncValue = AsyncData([]);
      });
    });
  }

  @override
  void initState() {
    super.initState();
  }

  // sort hot/new
  Future<List> _getData({
    required int page,
    required int pageSize,
  }) async {
    bool isInit = false;
    final year = _selectedDate.year.toString();
    final month = _selectedDate.month.toString().padLeft(2, '0');
    final day = _selectedDate.day.toString().padLeft(2, '0');
    final result = await _appDomain.getConstructByApiLink(apiLink: "/api/dailyvideoxiaolan/list", params: {
      "date": "$year-$month-$day",
      "page": page,
      "limit": pageSize,
    });

    if (!isInit) {
      setState(() {
        isInit = true;
      });
    }

    if (result.status == 1) {
      return result.data['list'];
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      bgColor: Colors.white,
      child: Stack(
        children: [
          Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: Image.asset('assets/images/xiaolan_top_navi_bg.png', width: double.infinity, fit: BoxFit.cover)),
          Scaffold(
              backgroundColor: Colors.transparent,
              appBar: MyAppBar(
                  // title: "今日推荐",
                  titleWidget: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 2 * MyTheme.pagePadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("今日推荐", style: MyTheme.white255_18_B.copyWith(color: Color(0xFF151515))),
                        Text(_recommendDateLabel, style: TextStyle(fontSize: 12.sp, color: Color(0xFF9C9C9C))),
                      ],
                    ),
                  ),
                  backIconColor: Color(0xFF151515),
                  titleColor: Color(0xFF151515),
                  backgroundColor: Colors.transparent,
                  rightWidget: GestureDetector(
                    onTap: _openCalendarDialog,
                    child: Image.asset('assets/images/xiaolan_icon_calendar.png', width: 21.w, height: 21.w),
                  )),
              body: _asyncValue.maybeWhen(
                  error: (_, __) => NetworkErrorView(onTap: () {
                        _getData(page: 1, pageSize: 20);
                      }),
                  orElse: () => const LoadingView(),
                  data: (data) {
                    return MyListView.grid(
                      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding, vertical: 8.w),
                      crossAxisCount: 2,
                      mainAxisSpacing: 10.h,
                      crossAxisSpacing: 8.w,
                      childAspectRatio: 344 / 240,
                      itemBuilder: (context, item, index) =>
                          XiaoLanItem.build(XiaoLanItemType.video, item, onTap: () {
                            XiaolanVideoDetailRoute(id: item['id']).push(context);
                          }),
                      onFetchingMore: (currentPage, pageSize) {
                        final res = _getData(page: currentPage, pageSize: pageSize);
                        return res;
                      },
                    );
                  }))
        ],
      ),
    );
  }
}

class _XiaolanCalendarDialog extends StatefulWidget {
  const _XiaolanCalendarDialog({required this.initialDate, required this.monthLabels});

  final DateTime initialDate;
  final List<String> monthLabels;

  @override
  State<_XiaolanCalendarDialog> createState() => _XiaolanCalendarDialogState();
}

class _XiaolanCalendarDialogState extends State<_XiaolanCalendarDialog> {
  static const List<String> _weekLabels = ['日', '一', '二', '三', '四', '五', '六'];

  late DateTime _focusedMonth;

  @override
  void initState() {
    super.initState();
    _focusedMonth = DateTime(widget.initialDate.year, widget.initialDate.month, 1);
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _changeMonth(int offset) {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + offset, 1);
    });
  }

  List<DateTime> _buildCalendarDays() {
    final firstDayOfMonth = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final leadingDays = firstDayOfMonth.weekday % 7;
    final startDay = firstDayOfMonth.subtract(Duration(days: leadingDays));
    return List.generate(42, (index) => DateTime(startDay.year, startDay.month, startDay.day + index));
  }

  @override
  Widget build(BuildContext context) {
    final days = _buildCalendarDays();
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final monthTitle = '${_focusedMonth.year}年 ${widget.monthLabels[_focusedMonth.month - 1]}';

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
      backgroundColor: Colors.transparent,
      child: Container(
        width: 398.w,
        decoration: BoxDecoration(
          color: Color(0xFFF7F8FA),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 16.r, offset: Offset(0, 4.h)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xFFFBFBFB),
                border: Border(bottom: BorderSide(color: Color(0xFFF2F3F5))),
              ),
              padding: EdgeInsets.only(top: 24.w, bottom: 12.w, left: 24.w, right: 24.w),
              child: Row(
                children: [
                  _MonthSwitchButton(icon: Icons.arrow_back_ios_new_rounded, onTap: () => _changeMonth(-1)),
                  Expanded(
                    child: Center(
                      child: Text(
                        monthTitle,
                        style: TextStyle(fontSize: 15.sp, color: Color(0xFF2A2A2A), fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  _MonthSwitchButton(icon: Icons.arrow_forward_ios_rounded, onTap: () => _changeMonth(1)),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.w),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFF2F3F5))),
              ),
              child: Row(
                children: _weekLabels
                    .map(
                      (label) => Expanded(
                        child: Center(
                          child: Text(
                            label,
                            style: TextStyle(fontSize: 14.sp, color: Color(0xFF1D2129), fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.w),
              physics: NeverScrollableScrollPhysics(),
              itemCount: days.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                crossAxisSpacing: 8.w,
                mainAxisSpacing: 8.h,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                final day = days[index];
                final isCurrentMonth = day.month == _focusedMonth.month;
                final isSelected = _isSameDate(day, widget.initialDate);
                final isFutureDate = day.isAfter(todayDate);
                return GestureDetector(
                  onTap: isFutureDate ? null : () => Navigator.of(context).pop(day),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isFutureDate ? Color(0xFFF3F4F6) : (isSelected ? Color(0xFFE8F3FF) : Color(0xFFF6F7F8)),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      '${day.day}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color:
                            isFutureDate ? Color(0xFFC7CBD1) : (isCurrentMonth ? Color(0xFF2D2D2D) : Color(0xFFAEB2B8)),
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _MonthSwitchButton extends StatelessWidget {
  const _MonthSwitchButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 24.w,
        height: 24.w,
        alignment: Alignment.center,
        decoration:
            BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: Color(0xFFF2F3F5))),
        child: Icon(icon, size: 12.w, color: Color(0xFF1D2129)),
      ),
    );
  }
}
