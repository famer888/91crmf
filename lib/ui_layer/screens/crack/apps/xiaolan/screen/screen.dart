import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../domain/model/crack_model.dart';
import '../../../../../../domain/remote_domain/domains/user.dart';
import '../../../../../notifiers/user_notifier.dart';
import '../../../../../router/routes.dart';
import '../../../../common_widgets/screen_background.dart';
import '../../../../common_widgets/search_app_bar.dart';
import '../../../app_util.dart';
import '../../../crack_app_type.dart';
import '../../../unlock_status_notifier.dart';
import '../../clsq/widget/cl_top_navi_view.dart';
import '../widget/xiaolan_top_navi_view.dart';

class XiaoLanCommunityScreen extends StatefulWidget {
  final int id;
  final CrackApp? crackApp;
  final VoidCallback? openEndDrawer;
  final bool showMoreButton;

  const XiaoLanCommunityScreen({
    super.key,
    required this.id,
    this.crackApp,
    this.openEndDrawer,
    this.showMoreButton = true,
  });

  @override
  State<XiaoLanCommunityScreen> createState() => _XiaoLanCommunityScreenState();
}

class _XiaoLanCommunityScreenState extends State<XiaoLanCommunityScreen> {
  late final _userDomain = context.read<UserDomain>();
  late final _userNotifier = context.read<UserNotifier>();
  late final _unlockStatusNotifier = context.read<UnlockStatusNotifier>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ScreenBackground(
          child: Selector<UnlockStatusNotifier, bool>(
              selector: (_, notifier) => notifier.isUnlockClsq,
              builder: (context, isUnlockClsq, child) {
                return Container(
                  color: Colors.white,
                  child: Stack(
                    children: [
                      Positioned(
                          left: 0,
                          right: 0,
                          top: 0,
                          child: Image.asset('assets/images/xiaolan_top_navi_bg.png',
                              width: double.infinity, fit: BoxFit.cover)),
                      Scaffold(
                        backgroundColor: Colors.transparent,
                        appBar: SearchAppBar(
                          appBarBackGroundColor:Color(0xFF130108),
                          marginChangeToPadding:true,
                          isCrackApp: true,
                          showLeftBack: false,
                          type: CrackAppType.xiaolan,
                          openEndDrawer: widget.openEndDrawer,
                          showMoreButton: widget.showMoreButton,
                          onTap: () {
                            if (isUnlockClsq) {
                              const ClVideoSearchRoute('').push(context);
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
                          },
                        ),
                        body: XiaoLanTopNaviView(id: widget.id, crackApp: widget.crackApp),
                      )
                    ],
                  ),
                );
              }),
        ),
        // const _BlurView(),
      ],
    );
  }
}
