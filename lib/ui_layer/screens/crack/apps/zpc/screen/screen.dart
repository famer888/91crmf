import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/domain/model/crack_model.dart';
import 'package:jycrpj/domain/remote_domain/domains/user.dart';
import 'package:jycrpj/ui_layer/notifiers/user_notifier.dart';
import 'package:jycrpj/ui_layer/router/routes.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jycrpj/ui_layer/screens/crack/app_util.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/zpc/widget/zpc_top_navi_view.dart';
import 'package:jycrpj/ui_layer/screens/crack/unlock_status_notifier.dart';
import 'package:jycrpj/ui_layer/screens/image_paths.dart';
import 'package:jycrpj/ui_layer/screens/theme.dart';
import 'package:provider/provider.dart';

import '../../../../../../report/ui_layer/report_gesture_detector.dart';

class ZpcCommunityScreen extends StatefulWidget {
  final int id;
  final CrackApp? crackApp;
  final VoidCallback? openEndDrawer;

  const ZpcCommunityScreen({
    super.key,
    required this.id,
    this.crackApp,
    this.openEndDrawer,
  });

  @override
  State<ZpcCommunityScreen> createState() => _ZpcCommunityScreenState();
}

class _ZpcCommunityScreenState extends State<ZpcCommunityScreen> {
  late final _userDomain = context.read<UserDomain>();
  late final _userNotifier = context.read<UserNotifier>();
  late final _unlockStatusNotifier = context.read<UnlockStatusNotifier>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Theme(
                data: Theme.of(context).copyWith(scaffoldBackgroundColor: Colors.white),
                child: Selector<UnlockStatusNotifier, bool>(
                    selector: (_, notifier) => notifier.isUnlockZpc91,
                    builder: (context, isUnlockZpc91, child) {
                      return Scaffold(
                        appBar: _buildSearchAppbarseaSearchAppBar(isUnlockZpc91),
                        body: ZpcTopNaviView(id: widget.id, crackApp: widget.crackApp),
                      );
                    }),
              ),
            ],
          ),
        ),
        // const _BlurView(),
      ],
    );
  }

  PreferredSizeWidget _buildSearchAppbarseaSearchAppBar(bool isUnlockZpc91) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: SafeArea(
        bottom: false,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding, vertical: 5.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ReportGestureDetector(
                  onTap: () {
                    _handleZpcSearchTap(isUnlockZpc91);
                  },
                  child: Container(
                    height: 35.w,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17.5.w),
                        side: const BorderSide(color: Color.fromRGBO(45, 45, 45, 0.8), width: 0.5),
                      ),
                      color: const Color.fromRGBO(230, 228, 228, 1),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: 12.w),
                        Image.asset(MyImagePaths.appSearchIcon, width: 12.w, height: 12.w),
                        SizedBox(width: 2.w),
                        Container(
                          width: 1.w,
                          height: 16.w,
                          color: const Color.fromRGBO(255, 255, 255, 0.04),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(child: Text('stzdmmhbt'.tr(context: context), style: MyTheme.gray172_14)),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              ReportGestureDetector(
                onTap: () {
                  widget.openEndDrawer?.call();
                },
                child: Container(
                  padding: EdgeInsets.only(top: 5.w, bottom: 5.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox.square(
                        dimension: 24.w,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.w),
                          child: const MyImage.asset(MyImagePaths.appMore, fit: BoxFit.cover, color: MyTheme.blackColor),
                        ),
                      ),
                      Text('gd'.tr(context: context), style: MyTheme.black12.s11),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleZpcSearchTap(bool isUnlockZpc91) {
    if (isUnlockZpc91) {
      const ZpcVideoSearchRoute('').push(context);
    } else {
      if (widget.crackApp == null) return;
      // 解锁弹窗
      AppUtil.checkUnlockStatus(
        context: context,
        crackApp: widget.crackApp!,
        userNotifier: _userNotifier,
        unlockStatusNotifier: _unlockStatusNotifier,
        userDomain: _userDomain,
      );
    }
  }
}
