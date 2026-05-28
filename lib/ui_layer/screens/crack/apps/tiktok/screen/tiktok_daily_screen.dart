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
import '../widget/tiktok_list_build.dart';

class TiktokDailyScreen extends StatefulWidget {
  const TiktokDailyScreen({super.key});

  @override
  State<TiktokDailyScreen> createState() => _TiktokDailyScreenState();
}

class _TiktokDailyScreenState extends State<TiktokDailyScreen> {
  late final _appDomain = context.read<AppDomain>();
  DateTime _selectedDate = DateTime.now();
  final GlobalKey<MyListViewState<dynamic>> _listKey = GlobalKey<MyListViewState<dynamic>>();

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
      builder: (context) => _TiktokCalendarDialog(
        initialDate: _selectedDate,
        monthLabels: _monthLabels,
      ),
    );

    if (pickedDate == null || !mounted) {
      return;
    }

    setState(() {
      _selectedDate = pickedDate;
      _listKey.currentState?.reloadPage();

      // Future.delayed(const Duration(milliseconds: 300), () {
      //   _asyncValue = AsyncData([]);
      // });
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
      if(result.data is List ){
        return result.data;
      }
      return result.data['list'];
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
        bgColor: Color(0xFF181A25),
        child:  Scaffold(
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
                    Text("今日热点", style: MyTheme.white255_18_B.copyWith(color: Color(0xFF151515))),
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
          body: MyListView.grid(
            padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding, vertical: 8.w),
            key: _listKey,
            crossAxisCount: 2,
            mainAxisSpacing: 10.h,
            crossAxisSpacing: 8.w,
            childAspectRatio: 344 / 240,
            itemBuilder: (context, item, index) => TiktokItem.build(TiktokItemType.video, item, onTap: () {
              TiktokVideoDetailRoute(id: item['id']).push(context);
            }),
            onFetchingMore: (currentPage, pageSize) async{
              final res = await _getData(page: currentPage, pageSize: pageSize);
              return res;
            },
          ))
    );
  }
}

class _TiktokCalendarDialog extends StatefulWidget {
  const _TiktokCalendarDialog({required this.initialDate, required this.monthLabels});

  final DateTime initialDate;
  final List<String> monthLabels;

  @override
  State<_TiktokCalendarDialog> createState() => _TiktokCalendarDialogState();
}

class _TiktokCalendarDialogState extends State<_TiktokCalendarDialog> {
  static const List<String> _weekLabels = ['日', '一', '二', '三', '四', '五', '六'];

  late DateTime _focusedMonth;
  _PickerLevel _pickerLevel = _PickerLevel.none;

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

  void _togglePicker() {
    setState(() {
      _pickerLevel = _pickerLevel == _PickerLevel.none ? _PickerLevel.year : _PickerLevel.none;
    });
  }

  List<int> _buildYearOptions() {
    final nowYear = DateTime.now().year;
    const int yearsBack = 20;
    final start = (nowYear - yearsBack).clamp(1970, nowYear);
    return List<int>.generate(nowYear - start + 1, (i) => start + i).reversed.toList();
  }

  void _selectYear(int year) {
    final now = DateTime.now();
    var nextMonth = _focusedMonth.month;
    if (year == now.year && nextMonth > now.month) {
      nextMonth = now.month;
    }
    setState(() {
      _focusedMonth = DateTime(year, nextMonth, 1);
      _pickerLevel = _PickerLevel.month;
    });
  }

  void _selectMonth(int month) {
    final now = DateTime.now();
    if (_focusedMonth.year == now.year && month > now.month) {
      return;
    }
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, month, 1);
      _pickerLevel = _PickerLevel.none;
    });
  }

  List<DateTime> _buildCalendarDays() {
    final firstDayOfMonth = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final leadingDays = firstDayOfMonth.weekday % 7;
    final startDay = firstDayOfMonth.subtract(Duration(days: leadingDays));
    return List.generate(42, (index) => DateTime(startDay.year, startDay.month, startDay.day + index));
  }

  Widget _buildPicker() {
    final now = DateTime.now();

    if (_pickerLevel == _PickerLevel.year) {
      final years = _buildYearOptions();
      return Padding(
        padding: EdgeInsets.fromLTRB(24.w, 16.w, 24.w, 24.w),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: years.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 10.w,
            mainAxisSpacing: 10.w,
            childAspectRatio: 2.2,
          ),
          itemBuilder: (context, index) {
            final year = years[index];
            final isSelected = year == _focusedMonth.year;
            return GestureDetector(
              onTap: () => _selectYear(year),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFE8F3FF) : const Color(0xFFF6F7F8),
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(color: isSelected ? const Color(0xFF7AB7FF) : const Color(0xFFF2F3F5)),
                ),
                child: Text(
                  '$year年',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF1D2129),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            );
          },
        ),
      );
    }

    if (_pickerLevel == _PickerLevel.month) {
      return Padding(
        padding: EdgeInsets.fromLTRB(24.w, 16.w, 24.w, 24.w),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 12,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10.w,
            mainAxisSpacing: 10.w,
            childAspectRatio: 2.6,
          ),
          itemBuilder: (context, index) {
            final month = index + 1;
            final isFuture = _focusedMonth.year == now.year && month > now.month;
            final isSelected = month == _focusedMonth.month;
            return GestureDetector(
              onTap: isFuture ? null : () => _selectMonth(month),
              child: Opacity(
                opacity: isFuture ? 0.45 : 1,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFE8F3FF) : const Color(0xFFF6F7F8),
                    borderRadius: BorderRadius.circular(6.r),
                    border: Border.all(color: isSelected ? const Color(0xFF7AB7FF) : const Color(0xFFF2F3F5)),
                  ),
                  child: Text(
                    widget.monthLabels[month - 1],
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: const Color(0xFF1D2129),
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    }

    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final days = _buildCalendarDays();
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final monthTitle = '${_focusedMonth.year}年 ${widget.monthLabels[_focusedMonth.month - 1]}';
    final showPicker = _pickerLevel != _PickerLevel.none;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
      backgroundColor: Colors.transparent,
      child: Container(
        width: 398.w,
        decoration: BoxDecoration(
          color: Color(0xFFF7F8FA),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16.r, offset: Offset(0, 4.h)),
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
                      child: GestureDetector(
                        onTap: _togglePicker,
                        behavior: HitTestBehavior.opaque,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              monthTitle,
                              style: TextStyle(fontSize: 15.sp, color: const Color(0xFF2A2A2A), fontWeight: FontWeight.w500),
                            ),
                            SizedBox(width: 6.w),
                            Icon(
                              showPicker ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                              size: 18.w,
                              color: const Color(0xFF2A2A2A),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  _MonthSwitchButton(icon: Icons.arrow_forward_ios_rounded, onTap: () => _changeMonth(1)),
                ],
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              child: showPicker
                  ? _buildPicker()
                  : Column(
                      key: const ValueKey('calendar'),
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.w),
                          decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(color: Color(0xFFF2F3F5))),
                          ),
                          child: Row(
                            children: _weekLabels
                                .map(
                                  (label) => Expanded(
                                    child: Center(
                                      child: Text(
                                        label,
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: const Color(0xFF1D2129),
                                          fontWeight: FontWeight.w400,
                                        ),
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
                          physics: const NeverScrollableScrollPhysics(),
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
                                  color: isFutureDate
                                      ? const Color(0xFFF3F4F6)
                                      : (isSelected ? const Color(0xFFE8F3FF) : const Color(0xFFF6F7F8)),
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Text(
                                  '${day.day}',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: isFutureDate
                                        ? const Color(0xFFC7CBD1)
                                        : (isCurrentMonth ? const Color(0xFF2D2D2D) : const Color(0xFFAEB2B8)),
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
          ],
        ),
      ),
    );
  }
}

enum _PickerLevel { none, year, month }

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
