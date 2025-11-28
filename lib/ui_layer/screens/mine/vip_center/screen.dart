import 'package:bot_toast/bot_toast.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jycrpj/ui_layer/screens/image_paths.dart';
import 'package:provider/provider.dart';

import '../../../../domain/api_validator.dart';
import '../../../../domain/async_value.dart';
import '../../../../domain/domain.dart';
import '../../../../domain/enum.dart';
import '../../../../domain/model/exp_of_vip_model.dart';
import '../../../../domain/model/product_vip_coin_model.dart';
import '../../../../domain/type_def.dart';
import '../../../notifiers/user_notifier.dart';
import '../../../router/routes.dart';
import '../../../utils/my_toast.dart';
import '../../common_widgets/gradient_text.dart';
import '../../common_widgets/member_vip.dart';
import '../../common_widgets/my_app_bar.dart';
import '../../common_widgets/my_avatar.dart';
import '../../common_widgets/my_image.dart';
import '../../common_widgets/partial_clickable_text.dart';
import '../../common_widgets/screen_background.dart';
import '../../common_widgets/status/loading.dart';
import '../../common_widgets/status/network_error.dart';
import '../../common_widgets/dialog/widgets/pay_dialog.dart';
import '../../theme.dart';

class VipCenterScreen extends StatefulWidget {
  //停用
  final int pageIndex;
  const VipCenterScreen({super.key, this.pageIndex = 0});

  @override
  State<VipCenterScreen> createState() => _VipCenterScreenState();
}

class _VipCenterScreenState extends State<VipCenterScreen> {
  final _type = MyProductType.vip;
  late final _orderDomain = context.read<OrderDomain>();
  // late final _signDomain = context.read<SignDomain>();

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

    final results = await Future.wait([
      _orderDomain.getProduct(type: _type),
    ]);

    setState(() {
      if (results[0].isValid) {
        _asyncValue = AsyncData(results[0].data as ProductOfVipOrCoin);
      } else {
        _asyncValue = const AsyncError();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        backgroundColor: MyTheme.color11_10_33,
        appBar: MyAppBar(
          title: 'hyzx'.tr(context: context),
          rightWidget: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => RechargeRecordRoute(_type.id.toString()).push(context),
            child: Text('czjl'.tr(context: context), style: MyTheme.white14),
          ),
        ),
        body: _asyncValue.maybeWhen(
          data: (value) => _Body(productOfVIP: value),
          error: (_, __) => NetworkErrorView(onTap: _init),
          orElse: () => const LoadingView(),
        ),
      ),
    );
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
        SizedBox(height: 10.w),
        const _UserInfoArea(),
        SizedBox(height: 20.w),
           _ProductCardArea(
              products: widget.productOfVIP.products,
              selectedNotifier: productSelectedNotifier,
            ),
        SizedBox(height: 20.w),
        Expanded(child: _openVipContent()),
      ],
    );
  }

  Widget _openVipContent() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: const Color.fromRGBO(35, 34, 55, 1)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MyImage.asset(MyImagePaths.appVipL, width: 42.w, height: 10.w),
                          SizedBox(width: 20.w),
                          Text('hytq'.tr(context: context), style: MyTheme.white16mudium, maxLines: 100, textAlign: TextAlign.center),
                          SizedBox(width: 20.w),
                          MyImage.asset(MyImagePaths.appVipR, width: 42.w, height: 10.w),
                        ],
                      ),
                      SizedBox(height: 15.w),
                      _RightArea(
                        notifier: productSelectedNotifier,
                        products: widget.productOfVIP.products,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.w),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
                  child: PartialClickableText(
                    prefixText: 'cztx'.tr(context: context),
                    afterFixText: 'zxkf'.tr(context: context),
                    prefixTextStyle: TextStyle(color: const Color.fromRGBO(255, 255, 255, 1), fontSize: 12.sp),
                    afterTextStyle: TextStyle(color: MyTheme.color247_93_96, fontSize: 12.sp),
                    onTap: () {
                      const MineCustomerServiceRoute().push(context);
                    },
                  ),
                ),
                SizedBox(height: 25.w),
              ],
            ),
          )
        ),
        _CustomBuyButton(
          notifier: productSelectedNotifier,
          products: widget.productOfVIP.products,
          vipText: widget.productOfVIP.vipText,
        ),
      ],
    );
  }

}

class _UserInfoArea extends StatelessWidget {
  const _UserInfoArea();

  @override
  Widget build(BuildContext context) {
    final member = context.watch<UserNotifier>().member;
    final expiredTime = member.expiredAt.toString().split(' ')[0];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
      child: Column(
        children: [
          Row(
            children: [
              MyAvatar(
                thumb: member.thumb,
                margin: 2,
                size: 67.w,
                gradient: const LinearGradient(
                  colors: [Color(0xffdfab8f), Color(0xffcf8856)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              SizedBox(width: 13.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          constraints: BoxConstraints(maxWidth: 150.w),
                          child: Text(
                            member.nickname,
                            style: TextStyle(
                                // fontFamily: hanyi,
                                color: const Color.fromRGBO(255, 255, 255, 1),
                                fontSize: 15.sp,
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.w600,
                                height: 1,
                                decoration: TextDecoration.none),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.w),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 3.0.w, horizontal: 6.0.w),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(4.w), bottomRight: Radius.circular(4.5.w)),
                          border: Border.all(color: const Color.fromRGBO(105, 136, 248, 1), width: 0.5),
                          gradient: const LinearGradient(colors: [Color.fromRGBO(61, 84, 245, 1), Color.fromRGBO(17, 52, 96, 1)])),
                      child: Text(
                        member.vipLevel < 2 ? 'khykp'.tr(context: context) : '${'dqrq'.tr(context: context)} $expiredTime',
                        style: MyTheme.color255_236_90,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class _ProductCardArea extends StatelessWidget {
  const _ProductCardArea({
    required this.products,
    required this.selectedNotifier,
  });

  final List<Product> products;
  final ValueNotifier selectedNotifier;

  @override
  Widget build(BuildContext context) {
          return CarouselSlider.builder(
            itemCount: products.length,
            options: CarouselOptions(
              viewportFraction: 0.75,
              enlargeCenterPage: true,
              enlargeFactor: 0.3, 
              enableInfiniteScroll: true,
              autoPlay: false,
              height: 150.w, 
              onPageChanged: (index, reason) {
                selectedNotifier.value = index;
              },
            ),
            itemBuilder: (context, index, realIndex) {
              return ValueListenableBuilder(
                valueListenable: selectedNotifier,
                builder: (context, selectedIndex, child) {
                  return _ProductItem(
                    product: products[index],
                    isSelected: selectedIndex == index,
                  );
                },
              );
            },
          );
}
}

class _ProductItem extends StatelessWidget {
  final Product product;
  final bool isSelected;

  const _ProductItem({required this.product, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final promoPrice = '¥${product.promoPriceYuan.split('.').first}';
    final price = '¥${product.priceYuan.split('.').first}';

    return Stack(
        children: [
          Positioned.fill(child: MyImage.network(product.bgImg, fit: BoxFit.fill)),
          // Positioned(top: 0, left: 0, child: Text(product.pName, style: TextStyle(color: Colors.white, fontSize: 15.sp))),
             Align(
              alignment: const FractionalOffset(0.2, 0.87),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    promoPrice,
                    style: TextStyle(
                      color: MyTheme.blueColor81_151_241,
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(0, -4.h),
                    child: Text(
                      price,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        decoration: TextDecoration.lineThrough,
                        decorationThickness: 1.5,
                        decorationColor: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
    );
  }
}


class _RightArea extends StatelessWidget {
  const _RightArea({
    required this.notifier,
    required this.products,
  });

  final ValueNotifier<int> notifier;
  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: notifier,
        builder: (context, selectedIndex, child) {
          return ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
            shrinkWrap: true,
            itemCount: products[selectedIndex].rights.length,
            separatorBuilder: (context, index) => Container(height: 12, color: Colors.transparent),
            // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //   crossAxisCount: 2,
            //   childAspectRatio: 166 / 70,
            //   crossAxisSpacing: 10.w,
            //   mainAxisSpacing: 10.w,
            // ),
            primary: false,
            itemBuilder: (context, index) => _RightItem(
              logo: products[selectedIndex].rights[index].img,
              title: products[selectedIndex].rights[index].name,
              subTitle: products[selectedIndex].rights[index].desc,
            ),
          );
        });
  }
}

class _RightItem extends StatelessWidget {
  const _RightItem({
    required this.title,
    required this.subTitle,
    required this.logo,
  });

  final String title;
  final String subTitle;
  final String logo;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 50.w, height: 50.w, child: MyImage.network(logo, fit: BoxFit.fitHeight)),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
              child: GradientText(
                title,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: MyTheme.white06_15_Blod,
                gradient: const LinearGradient(
                  colors: [
                    Color.fromRGBO(48, 161, 255, 1),
                    Color.fromRGBO(87, 155, 241, 1),
                  ],
                ),
              ),
            ),
            SizedBox(height: 6.w),
            SizedBox(
              child: Text(
                subTitle,
                style: TextStyle(
                    color: const Color.fromRGBO(255, 255, 255, 1),
                    fontSize: 12.sp,
                    overflow: TextOverflow.ellipsis,
                    decoration: TextDecoration.none),
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            )
          ]),
        )
      ],
    );
  }
}

class _ExpArea extends StatelessWidget {
  const _ExpArea({
    required this.expOfVipList,
  });

  final List<ExpOfVIP> expOfVipList;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.4,
        crossAxisSpacing: 6.w,
        mainAxisSpacing: 10.w,
      ),
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: expOfVipList.length,
      itemBuilder: (context, index) => _ExpItem(exp: expOfVipList[index]),
    );
  }
}

class _ExpItem extends StatefulWidget {
  final ExpOfVIP exp;

  const _ExpItem({
    required this.exp,
  });

  @override
  State<_ExpItem> createState() => _ExpItemState();
}

class _ExpItemState extends State<_ExpItem> {
  late final signDomain = context.read<SignDomain>();
  late final userNotifier = context.read<UserNotifier>();

  Future<void> _sendExpCoverVIP() async {
    if (userNotifier.member.exp != 0) {
      MyToast.showLoading(text: 'gmdd'.tr(context: context));
      final result = await signDomain.expConvertVIP(id: widget.exp.id);
      BotToast.closeAllLoading();
      if (result.status == 1) {
        await userNotifier.init();
        if (mounted) {
          context.pop();
        }
      }
      MyToast.showText(text: result.msg ?? '');
    } else {
      MyToast.showText(text: 'jfyebz'.tr(context: context));
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemWidth = (MediaQuery.sizeOf(context).width - MyTheme.pagePadding * 2 - 6) / 2;
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6.w),
          child: _buildProductImage(widget.exp, itemWidth),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10.w),
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6.w),
                  child: MyImage.asset(MyImagePaths.appMineCzItem, width: itemWidth - 20, height: 60, fit: BoxFit.fill),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 7.w),
                      Text(
                        widget.exp.vipStr,
                        style: TextStyle(
                          color: const Color.fromRGBO(255, 236, 90, 1),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 5.w),
                      Text(
                        getDesc(widget.exp),
                        style: TextStyle(
                          color: const Color.fromRGBO(255, 255, 255, 1),
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 7.w),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.w),
            Row(
              children: [
                SizedBox(width: 10.w),
                Text(
                  widget.exp.expStr,
                  style: TextStyle(
                    color: const Color.fromRGBO(255, 255, 255, 1),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: _sendExpCoverVIP,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4.w, horizontal: 8.w),
                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30.w)), gradient: MyTheme.dhButtonGradient),
                    child: Center(
                      child: RichText(text: TextSpan(text: 'ljdh'.tr(context: context), style: MyTheme.white255_12)),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProductImage(ExpOfVIP exp, double itemWidth) {
    return (exp.bgImg != null && exp.bgImg!.isNotEmpty)
        ? MyImage.network(exp.bgImg!, width: itemWidth, height: 196, fit: BoxFit.fill)
        : MyImage.asset(MyImagePaths.appMineCzBg, width: itemWidth, height: 196, fit: BoxFit.fill);
  }

  String getDesc(ExpOfVIP exp) {
    if (exp.desc == null || exp.desc!.isEmpty) {
      final title = widget.exp.vipStr;
      if (title == '3天VIP' || title == '60天VIP') {
        return 'cyqzzy'.tr(context: context);
      } else if (title == '10金币' || title == '20金币') {
        return 'qzjbty'.tr(context: context);
      } else if (title == '1次AI脱衣') {
        return '1cty'.tr(context: context);
      }
    } else {
      return exp.desc!;
    }
    return '';
  }
}

class _CustomBuyButton extends StatefulWidget {
  const _CustomBuyButton({
    required this.notifier,
    required this.products,
    required this.vipText,
  });

  final ValueNotifier<int> notifier;
  final List<Product> products;
  final String vipText;

  @override
  State<_CustomBuyButton> createState() => _CustomBuyButtonState();
}

class _CustomBuyButtonState extends State<_CustomBuyButton> {
  Future<void> _showPay(int selectedIndex) => showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => PayDialog(
          product: widget.products[selectedIndex],
          tip: widget.vipText,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF111127),
      ),
      child: ValueListenableBuilder(
        valueListenable: widget.notifier,
        builder: (context, selectedIndex, child) {
          final product = widget.products[selectedIndex];
          final promoPrice = product.promoPriceYuan.split('.').first;
          final originalPrice = product.priceYuan.split('.').first;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10.w),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
                child: GestureDetector(
                  onTap: () => _showPay(selectedIndex),
                  child: Container(
                    height: 50.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.w),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromRGBO(105, 60, 164, 1),
                            Color.fromRGBO(74, 9, 9, 1),

                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(30.w),
                      ),
                      padding: EdgeInsets.only(left: 16.w),
                      child: Row(
                        children: [
                           Row(
                              children: [
                                Text(
                                  'zf'.tr(context: context),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Text('¥$promoPrice', style: TextStyle(color: Colors.white, fontSize: 27.sp, fontWeight: FontWeight.w600),),
                                
                                  SizedBox(width: 8.w),
                                Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 2.w),
                                      child: Text(
                                        '${'yj'.tr(context: context)} ¥$originalPrice',
                                        style: TextStyle(
                                          color: const Color(0xFF9E9E9E),
                                          fontSize: 11.sp,
                                        ),
                                      ),
                                    ),
                                    Positioned.fill(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          width: double.infinity,
                                          height: 1.2,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                
                              ],
                            ),
                          const  Expanded(child: SizedBox()),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 5.w,vertical: 3.w),
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                            decoration: BoxDecoration(
                              gradient: MyTheme.gradient_90_114,
                                borderRadius: BorderRadius.circular(30.w),
                            ),
                            child: Center(
                              child: Text(
                                'gmgk'.tr(context: context),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.w),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => const MineCustomerServiceRoute().push(context),
                child: Text.rich(
                  TextSpan(
                    text: 'zflx'.tr(context: context),
                    style: TextStyle(
                      color: const Color(0xFFc6c7c9),
                      fontSize: 10.sp,
                    ),
                    children: [
                      TextSpan(
                        text: 'zxkf'.tr(context: context),
                        style: TextStyle(
                          color: MyTheme.gradient_90_114_colors.first,
                          fontSize: 10.sp,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8.w)
            ],
          );
        },
      ),
    );
  }
}
