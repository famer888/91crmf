import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../../domain/api_validator.dart';
import '../../../../../domain/domain.dart';
import '../../../../../domain/enum.dart';
import '../../../../../domain/model/coin_detail_model.dart';
import '../../../common_widgets/my_app_bar.dart';
import '../../../common_widgets/my_list_view.dart';
import '../../../common_widgets/screen_background.dart';
import '../../../theme.dart';
import '../../../../utils/my_toast.dart';

import '../../../../../report/ui_layer/report_gesture_detector.dart';

class CoinDetailScreen extends StatefulWidget {
  const CoinDetailScreen({super.key});

  @override
  State<CoinDetailScreen> createState() => _CoinDetailScreenState();
}

class _CoinDetailScreenState extends State<CoinDetailScreen> {
  late final List<({String name, MyCoinFilterType type})> filterList = [
    (name: 'qb'.tr(context: context), type: MyCoinFilterType.all),
    (name: 'shr'.tr(context: context), type: MyCoinFilterType.income),
    (name: 'zhc'.tr(context: context), type: MyCoinFilterType.expenditure)
  ];

  late final appDomain = context.read<UserDomain>();
  MyCoinFilterType filterType = MyCoinFilterType.all;
  ValueNotifier<bool> showFilterNotifier = ValueNotifier(false);

  Future<List<CoinDetail>> _getData({
    required int currentPage,
    required int limit,
  }) async {
    final result = await appDomain.getListMoneyDetail(
      page: currentPage,
      limit: limit,
      type: filterType,
    );

    if (result.msg case final msg? when !result.isValid) {
      MyToast.showText(text: msg);
    }

    return result.data!;
  }

  void changeFilterType({required MyCoinFilterType sort}) {
    setState(() {
      showFilterNotifier.value = !showFilterNotifier.value;
      filterType = sort;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        appBar: MyAppBar(
          title: 'jbmxwa'.tr(context: context),
          showDiver: true,
          rightWidget: ReportGestureDetector(
            onTap: () => showFilterNotifier.value = !showFilterNotifier.value,
            child: Text('sx'.tr(context: context), style: MyTheme.gray150_14),
          ),
        ),
        body: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 13.w),
                child: Row(
                  children: [
                    SizedBox(width: 13.w),
                    Text('shix'.tr(context: context), style: MyTheme.white255_13.s14.w400.white25508),
                    const Spacer(),
                    Text('sj'.tr(context: context), style: MyTheme.white255_13.s14.w400.white25508),
                    const Spacer(),
                    Text('je2'.tr(context: context), style: MyTheme.white255_13.s14.w400.white25508),
                    SizedBox(width: 13.w),
                  ],
                ),
              ),
            ),
            Positioned.fill(
              top: 30.w,
              child: MyListView<CoinDetail>.list(
                key: ValueKey(filterType),
                padding: EdgeInsets.all(MyTheme.pagePadding),
                contentPadding: 16.w,
                itemBuilder: (context, item, index) => _CoinItem(item: item),
                onFetchingMore: (currentPage, pageSize) => _getData(currentPage: currentPage, limit: pageSize),
              ),
            ),
            ValueListenableBuilder(
              valueListenable: showFilterNotifier,
              builder: (context, showFilter, child) => AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                top: 0,
                right: (showFilter ? 13 : -68).w,
                child: AnimatedOpacity(
                  opacity: showFilter ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    width: 68.w,
                    height: 98.w,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.w), color: const Color(0xff191919)),
                    child: Column(
                      children: [
                        for (final filter in filterList)
                          Expanded(
                            child: ReportGestureDetector(
                              onTap: () => changeFilterType(sort: filter.type),
                              child: Center(
                                child: Text(
                                  filter.name,
                                  style: filter.type == filterType ? MyTheme.white16bold : MyTheme.white14,
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CoinItem extends StatelessWidget {
  const _CoinItem({required this.item});

  final CoinDetail item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${item.sourceStr}', style: MyTheme.white244_16),
              Text('${item.type == 1 ? '+' : '-'} ${item.coin}', style: MyTheme.white244_20_M),
            ],
          ),
          SizedBox(height: 11.5.w),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text('${item.desc}', style: MyTheme.gray153_12, maxLines: 1)),
              const Spacer(),
              Text('${item.createdAt}', style: MyTheme.gray153_12),
            ],
          ),
        ],
      ),
    );
  }
}
