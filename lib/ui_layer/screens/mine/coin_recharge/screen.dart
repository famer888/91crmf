import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../domain/async_value.dart';
import '../../../../domain/domain.dart';
import '../../../../domain/enum.dart';
import '../../../../domain/model/product_vip_coin_model.dart';
import '../../../../report/ui_layer/report_gesture_detector.dart';
import '../../../notifiers/user_notifier.dart';
import '../../../router/routes.dart';
import '../../common_widgets/fixed_buy_button.dart';
import '../../common_widgets/my_app_bar.dart';
import '../../common_widgets/my_image.dart';
import '../../common_widgets/screen_background.dart';
import '../../common_widgets/status/loading.dart';
import '../../common_widgets/status/network_error.dart';
import '../../image_paths.dart';
import '../../theme.dart';

class CoinRechargeScreen extends StatefulWidget {
  const CoinRechargeScreen({super.key});

  @override
  State<CoinRechargeScreen> createState() => _CoinRechargeScreenState();
}

class _CoinRechargeScreenState extends State<CoinRechargeScreen> {
  final _type = MyProductType.coin;
  final productSelectedNotifier = ValueNotifier(0);
  late final _orderDomain = context.read<OrderDomain>();

  AsyncValue<ProductOfVipOrCoin> _asyncValue = const AsyncInit();

  @override
  void initState() {
    _init();
    super.initState();
  }

  Future<void> _init() async {
    if (_asyncValue.isLoading) return;

    setState(() {
      _asyncValue = const AsyncLoading();
    });

    final result = await _orderDomain.getProduct(type: _type);
    if (mounted) {
      setState(() {
        if (result.data case final data?) {
          _asyncValue = AsyncData(data);
        } else {
          _asyncValue = const AsyncError();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
        appBg: MyImage.asset(MyImagePaths.appBg, fit:BoxFit.cover, width: ScreenUtil().screenWidth, height: 148.w),
        child: Scaffold(
          appBar: MyAppBar(
            title: 'jbcz'.tr(context: context),
            rightWidget: ReportGestureDetector(
              onTap: () => RechargeRecordRoute(_type.id.toString()).push(context),
              child: Text('czjl'.tr(context: context), style: MyTheme.gray150_14),
            ),
          ),
          body: _asyncValue.maybeWhen(
            data: (value) => _Body(productOfVIP: value),
            error: (_, __) => NetworkErrorView(onTap: _init),
            orElse: () => const LoadingView(),
          ),
        ));
  }
}

class _Body extends StatefulWidget {
  const _Body({required this.productOfVIP});

  final ProductOfVipOrCoin productOfVIP;

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final productSelectedNotifier = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
              child: Column(
                children: [
                  SizedBox(height: 20.w),
                  const _SumArea(),
                  SizedBox(height: 20.w),
                  Row(
                    children: [
                      Text('xzczje'.tr(context: context), style: MyTheme.white255_13.w500.s16, textAlign: TextAlign.left),
                    ],
                  ),
                  SizedBox(height: 10.w),
                  _ProductArea(products: widget.productOfVIP.products, productSelectedNotifier: productSelectedNotifier),
                  SizedBox(height: 30.w)
                ],
              ),
            ),
          ),
        ),
        FixedBuyButton(
          notifier: productSelectedNotifier,
          products: widget.productOfVIP.products,
          vipText: widget.productOfVIP.vipText,
        ),
      ],
    );
  }
}

class _SumArea extends StatelessWidget {
  const _SumArea();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 84.2.w,
          margin: EdgeInsets.only(bottom: 10.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5.w)),
            gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color.fromRGBO(105, 60, 164, 0.8), Color.fromRGBO(74, 9, 9, 0.8)]),
          ),
        ),
        Container(
          height: 83.w,
          padding: EdgeInsets.all(10.w),
          margin: EdgeInsets.only(left: 0.6.w, right: 0.6.w, top: 0.6.w, bottom: 10.0.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5.w)),
            gradient: const LinearGradient(colors: [Color.fromRGBO(29, 4, 7, 0.8), Color.fromRGBO(29, 4, 7, 0.9)]),
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('jbye'.tr(context: context), style: MyTheme.white255_13.s18.w500),
                SizedBox(height: 10.w),
                Selector<UserNotifier, String>(
                    selector: (_, userNotifier) => '${userNotifier.member.money}',
                    builder: (context, money, child) {
                      return Text(money, textAlign: TextAlign.center, style: MyTheme.white255_13.s18.w500.color250_255_115, maxLines: 1);
                    }),
              ],
            ),
            const Spacer(),
            ReportGestureDetector(
              onTap: () {
                const CoinDetailRoute().push(context);
                // RechargeRecordRoute(MyProductType.coin.id.toString()).push(context);
              },
              child: Container(
                height: 32.w,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 6.w),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: MyTheme.gradient_90_114_colors),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text('xfmx'.tr(context: context), style: MyTheme.white255_13.s14.w500),
              ),
            )
          ]),
        ),
      ],
    );
  }
}

class _ProductArea extends StatelessWidget {
  const _ProductArea({
    required this.products,
    required this.productSelectedNotifier,
  });

  final List<Product> products;
  final ValueNotifier<int> productSelectedNotifier;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: productSelectedNotifier,
        builder: (context, isSelectedIndex, child) {
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 13,
              crossAxisSpacing: 13,
              childAspectRatio: 96 / 125,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) => ReportGestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => productSelectedNotifier.value = index,
              child: _CoinItem(product: products[index], isSelected: isSelectedIndex == index),
            ),
          );
        });
  }
}

class _CoinItem extends StatefulWidget {
  const _CoinItem({required this.product, required this.isSelected});

  final Product product;
  final bool isSelected;

  @override
  State<_CoinItem> createState() => _CoinItemState();
}

class _CoinItemState extends State<_CoinItem> {
  @override
  Widget build(BuildContext context) {
    final promoPrice = widget.product.promoPriceYuan.split('.').first;
    final price = widget.product.priceYuan.split('.').first;
    final isSelected = widget.isSelected;
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(0.5.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.w),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color.fromRGBO(105, 60, 164, 1), Color.fromRGBO(74, 9, 9, 1)],
            ),
          ),
          child:Container(
              decoration: BoxDecoration(
                border: Border.all(color: isSelected ? const Color.fromRGBO(255, 122, 122, 1) : const Color.fromRGBO(0, 0, 0, 0), width: 2.0),
                image : const DecorationImage(image: AssetImage(MyImagePaths.appMineRuleBg), fit: BoxFit.fitHeight),
              borderRadius: BorderRadius.circular(10.w),
            ),
            width: 114.w,
            height: 140.w,
            padding: EdgeInsets.symmetric(vertical: 10.w),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 12.w),
                  SizedBox(width: 47.w, height: 47.w, child: MyImage.asset(MyImagePaths.appCoins, width: 47.w, height: 47.w)),
                  SizedBox(height: 6.w),
                  Text(widget.product.pName,
                      style:  MyTheme.white255_13.s16.w500),
                  SizedBox(height: 6.w),
                  Text('¥$promoPrice', style: MyTheme.white255_13.s12.w400),
                ],
              ),
            ),
          ),
        ),
        if (widget.product.giveTip.isNotEmpty)
          Positioned(
            top: 0.5.w,
            left: 0.5.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.w),
              height: 20.w,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: MyTheme.gradient_90_114_colors),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10.w), bottomRight: Radius.circular(10.w)),
              ),
              child: Center(child: Text(widget.product.giveTip, style: MyTheme.white255_13.s11.w400)),
            ),
          )
      ],
    );
  }
}
