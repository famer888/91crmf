import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/domain/remote_domain/domains/buy.dart';
import 'package:jycrpj/ui_layer/router/routes.dart';
import 'package:jycrpj/ui_layer/screens/black/vip_pay_dialog.dart';
import 'package:jycrpj/ui_layer/screens/black/widget/interval_gesture_widget.dart';
import 'package:jycrpj/ui_layer/screens/black/widget/subscript.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jycrpj/ui_layer/screens/theme.dart';
import 'package:provider/provider.dart';

import '../../../../domain/model/buy_model.dart';
import '../../../utils/my_toast.dart';

class BuyChildScreen extends StatefulWidget {
  final int type;
  final bool isList;

  const BuyChildScreen({super.key, required this.type, required this.isList});

  @override
  State<BuyChildScreen> createState() => _BuyChildScreenState();
}

class _BuyChildScreenState extends State<BuyChildScreen> {
  late final _screenUtil = ScreenUtil();
  late final _buyDomain = context.read<BuyDomain>();
  final double _childAspectRatio = 54 / 76;

  Future<List<BuyItemModel>> _getBuyData({int page = 1, int limit = 15, required int type}) async {
    final result = await _buyDomain.buyList(page: page, limit: limit, type: type);
    if (result.status == 1) {
      return result.data ?? [];
    } else {
      MyToast.showText(text: result.msg ?? '');
      return [];
    }
  }

  double itemWidth() {
    return widget.isList
        ? _screenUtil.screenWidth - MyTheme.pagePadding * 2
        : (_screenUtil.screenWidth - (5 - 1) * 10.w - MyTheme.pagePadding * 2) / 5;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isList
        ? MyListView.list(
            padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding, vertical: 8.w),
            itemBuilder: (context, item, index) => Container(
              padding: EdgeInsets.only(bottom: 12.w),
              child: _buildListItem(item, itemWidth()),
            ),
            isNeedMore: true,
            onFetchingMore: (currentPage, pageSize) {
              final res = _getBuyData(page: currentPage, limit: pageSize, type: widget.type);
              return res;
            },
          )
        : MyListView.grid(
            childAspectRatio: _childAspectRatio,
            crossAxisCount: 5,
            crossAxisSpacing: 10.w,
            mainAxisSpacing: 10.w,
            itemBuilder: (context, item, index) => _buildGridItem(item, itemWidth()),
            onFetchingMore: (currentPage, pageSize) {
              final res = _getBuyData(page: currentPage, limit: pageSize, type: widget.type);
              return res;
            });
  }

  Widget _buildGridItem(BuyItemModel buyItemModel, double itemWidth) {
    if (buyItemModel.app == null) return const SizedBox.shrink();

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // 跳转视频详情
        if (buyItemModel.appName == 'hjgj') {
          // 草榴社区
          const ClCommunityRoute(id: 1).push(context);
        } else if (buyItemModel.appName == 'awjq') {
          // 暗网禁区
          const AnWangRestrictedRoute(id: 1).push(context);
        } else if (buyItemModel.appName == '91aw') {
          // 91暗网
          const DarkWeb91Route(id: 1).push(context);
        } else if (buyItemModel.appName == 'zpc') {
          // 91制片厂
          const ZpcCommunityRoute(id: 1).push(context);
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: itemWidth,
            height: itemWidth,
            child: AspectRatio(aspectRatio: 1, child: MyImage.network(buyItemModel.app!.logo, fit: BoxFit.cover, borderRadius: 8.w)),
          ),
          SizedBox(height: 8.w),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Text(buyItemModel.app!.title, style: MyTheme.white255_13_M.s12.w400.white25507),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(BuyItemModel buyItemModel, double itemWidth) {
    if (buyItemModel.content == null) return const SizedBox.shrink();

    Widget current = Stack(children: [
      MyImage.network(buyItemModel.content!.thumb ?? '', width: itemWidth, height: 120.w, borderRadius: 6.w),
      Positioned(top: 0, right: 0, child: _buildSubscripteWidget(buyItemModel.content!)),
      Positioned(top: 0, left: 0, child: _buildBlackTypeWidget(buyItemModel)),
    ]);
    current = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      current,
      Padding(
        padding: EdgeInsets.only(top: 5.5.w, bottom: 2.w),
        child: Text(buyItemModel.content!.title ?? '',
            style: TextStyle(
              color: const Color.fromRGBO(255, 255, 255, 1),
              fontWeight: FontWeight.w400,
              fontSize: 14.sp,
              overflow: TextOverflow.ellipsis,
              decoration: TextDecoration.none,
            ),
            maxLines: 2),
      ),
      SizedBox(height: 2.w),
      _buildSubContentWidget(buyItemModel),
    ]);
    return IntervalGestureWidget(
      onTap: () {
        if (buyItemModel.content!.needVip ?? false) {
          VipPayDialog.showVipDialog(context);
        } else {
          BlockDetailsRoute(id: buyItemModel.content!.id ?? 0).push(context);
        }
      },
      child: current,
    );
  }

  Widget _buildSubContentWidget(BuyItemModel buyItemModel) {
    String content = '';
    content += ' · ${buyItemModel.createdAt}';
    // if (buyItemModel.category.isNotEmpty) {
    //   List list = item.category;
    //   if (list.length > 2) {
    //     list = list.sublist(0, 2);
    //   }
    //   content += ' · ${list.map((i) => i.name).join(' · ')}';
    // }

    return Row(children: [
      Expanded(
        flex: 1,
        child: Text(content,
            style: TextStyle(
              color: const Color.fromRGBO(255, 255, 255, 1),
              fontWeight: FontWeight.w400,
              fontSize: 11.sp,
              overflow: TextOverflow.ellipsis,
              decoration: TextDecoration.none,
            ),
            overflow: TextOverflow.ellipsis),
      ),
      // SizedBox(width: 10.w),
      // Text(
      //   '${CommonUtils.formatNumber(item.viewNum)}浏览',
      //   style: TextStyle(
      //     color: const Color.fromRGBO(255, 255, 255, 1),
      //     fontWeight: FontWeight.w400,
      //     fontSize: 11.sp,
      //     overflow: TextOverflow.ellipsis,
      //     decoration: TextDecoration.none,
      //   ),
      //   overflow: TextOverflow.ellipsis,
      // ),
    ]);
  }

  Widget _buildSubscripteWidget(Content content) {
    if (content.isHot ?? false) {
      return Container(margin: EdgeInsets.only(right: 6.w, top: 2.w), child: const HotSubscriptWidget());
    }
    if (content.isNew ?? false) {
      return const NewSubscriptWidget();
    }
    return const SizedBox();
  }

  Widget _buildBlackTypeWidget(BuyItemModel buyItemModel) {
    if (buyItemModel.type == 1) return const VipSubscriptWidget();
    if (buyItemModel.type == 2) return const CoinSubscriptWidget();
    return const SizedBox();
  }
}
