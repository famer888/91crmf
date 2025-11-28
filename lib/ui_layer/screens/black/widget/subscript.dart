import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/ui_layer/screens/image_paths.dart';
import '../../theme.dart';
import 'convenience.dart';

class AdsSubscriptWidget extends StatelessWidget {
  final int? pos;

  const AdsSubscriptWidget({super.key, this.pos});

  @override
  Widget build(BuildContext context) {
    return Convenience.buildContainerWidget(
      gradient: MyTheme.gradient_90_135,
      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5.w), topRight: Radius.circular(5.w)),
      width: 25.w,
      height: 15.w,
      alignment: Alignment.center,
      child: Text('gg'.tr(context: context), style: MyTheme.white14.s12),
    );
  }
}

/// VIP
class VipSubscriptWidget extends StatelessWidget {
  final int? pos; // 默认右
  const VipSubscriptWidget({super.key, this.pos});

  @override
  Widget build(BuildContext context) {
    return Convenience.buildContainerWidget(
      gradient: MyTheme.vip_gradient_90_135,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(pos == 0 ? 5.w : 0),
        bottomRight: Radius.circular(pos == 0 ? 0 : 5.w),
        topLeft: Radius.circular(pos == 0 ? 0 : 5.w),
        topRight: Radius.circular(pos == 0 ? 5.w : 0),
      ),
      width: 28.w,
      height: 17.w,
      alignment: Alignment.center,
      child: Text('VIP', style: MyTheme.white14.s12),
    );
  }
}

/// 金币
class CoinSubscriptWidget extends StatelessWidget {
  final int? pos;

  const CoinSubscriptWidget({super.key, this.pos});

  @override
  Widget build(BuildContext context) {
    return Convenience.buildContainerWidget(
      gradient: MyTheme.gradient_90_114,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(pos == 0 ? 5.w : 0),
        bottomRight: Radius.circular(pos == 0 ? 0 : 5.w),
        topLeft: Radius.circular(pos == 0 ? 0 : 5.w),
        topRight: Radius.circular(pos == 0 ? 5.w : 0),
      ),
      width: 28.w,
      height: 17.w,
      alignment: Alignment.center,
      child: Text('jb'.tr(context: context), style: MyTheme.white14.s12),
    );
  }
}

/// 自制 - 原创
class OriginSubscriptWidget extends StatelessWidget {
  final int? pos;

  const OriginSubscriptWidget({super.key, this.pos});

  @override
  Widget build(BuildContext context) {
    return Convenience.buildContainerWidget(
      gradient: MyTheme.subOrgGradient,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(pos == 0 ? 0 : 5.w),
        bottomRight: Radius.circular(pos == 0 ? 5.w : 0),
        topLeft: Radius.circular(pos == 0 ? 5.w : 0),
        topRight: Radius.circular(pos == 0 ? 0 : 5.w),
      ),
      width: 25.w,
      height: 15.w,
      alignment: Alignment.center,
      child: Text('yc1'.tr(context: context), style: MyTheme.white14.s9),
    );
  }
}

/// 精品 - 精选
class BoutiqueSubscriptWidget extends StatelessWidget {
  final int? pos;

  const BoutiqueSubscriptWidget({super.key, this.pos});

  @override
  Widget build(BuildContext context) {
    return Convenience.buildContainerWidget(
      gradient: MyTheme.subButGradient,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(pos == 0 ? 0 : 5.w),
        bottomRight: Radius.circular(pos == 0 ? 5.w : 0),
        topLeft: Radius.circular(pos == 0 ? 5.w : 0),
        topRight: Radius.circular(pos == 0 ? 0 : 5.w),
      ),
      width: 25.w,
      height: 15.w,
      alignment: Alignment.center,
      child: Text('jp'.tr(context: context), style: MyTheme.white14.s9),
    );
  }
}

/// 专属
class ExclusiveSubscriptWidget extends StatelessWidget {
  final int? pos;

  const ExclusiveSubscriptWidget({super.key, this.pos});

  @override
  Widget build(BuildContext context) {
    return Convenience.buildContainerWidget(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(pos == 0 ? 0 : 5.w),
        bottomRight: Radius.circular(pos == 0 ? 5.w : 0),
        topLeft: Radius.circular(pos == 0 ? 5.w : 0),
        topRight: Radius.circular(pos == 0 ? 0 : 5.w),
      ),
      gradient: MyTheme.subExcGradient,
      width: 25.w,
      height: 15.w,
      alignment: Alignment.center,
      child: Text('zs1'.tr(context: context), style: MyTheme.white14.s9),
    );
  }
}

/// 热门
class HotSubscriptWidget extends StatelessWidget {
  final int? pos;

  const HotSubscriptWidget({super.key, this.pos});

  @override
  Widget build(BuildContext context) {
    return Convenience.buildContainerWidget(
      margin: EdgeInsets.only(top: 2.w, left: 1.w),
      borderRadius: BorderRadius.circular(2.w),
      width: 15.w,
      height: 20.w,
      child: Image.asset(MyImagePaths.appSubHot),
    );
  }
}

class NewSubscriptWidget extends StatelessWidget {
  final int? pos;

  const NewSubscriptWidget({super.key, this.pos});

  @override
  Widget build(BuildContext context) {
    return Convenience.buildContainerWidget(width: 32.w, height: 26.w, child: Image.asset(MyImagePaths.appSubNew));
  }
}
