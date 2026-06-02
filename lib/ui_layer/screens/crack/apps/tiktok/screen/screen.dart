import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../../app_global.dart';
import '../../../../../../domain/model/crack_model.dart';
import '../../../../../../domain/remote_domain/domains/user.dart';
import '../../../../../notifiers/user_notifier.dart';
import '../../../../../router/paths.dart';
import '../../../../common_widgets/screen_background.dart';
import '../../../../common_widgets/search_app_bar.dart';
import '../../../app_util.dart';
import '../../../crack_app_type.dart';
import '../../../unlock_status_notifier.dart';
import '../widget/tiktok_top_navi_view.dart';

class TiktokCommunityScreen extends StatefulWidget {
  final int id;
  final CrackApp? crackApp;
  final VoidCallback? openEndDrawer;
  final bool showMoreButton;

  const TiktokCommunityScreen({
    super.key,
    required this.id,
    this.crackApp,
    this.openEndDrawer,
    this.showMoreButton = true,
  });

  @override
  State<TiktokCommunityScreen> createState() => _TiktokCommunityScreenState();
}

class _TiktokCommunityScreenState extends State<TiktokCommunityScreen> {
  late final _userDomain = context.read<UserDomain>();
  late final _userNotifier = context.read<UserNotifier>();
  late final _unlockStatusNotifier = context.read<UnlockStatusNotifier>();

  @override
  Widget build(BuildContext context) {
    if (AppGlobal.context == null) {
      AppGlobal.context = context;
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        ScreenBackground(
          child: Selector<UnlockStatusNotifier, bool>(selector: (_, notifier) {
            return notifier.isUnlockTiktok;
          }, builder: (context, isUnlockTiktok, child) {
            return Container(
                color: Color(0xFF181A25),
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: SearchAppBar(
                    appBarBackGroundColor: Color(0xFF130108),
                    marginChangeToPadding: true,
                    isCrackApp: true,
                    showLeftBack: false,
                    type: CrackAppType.tk,
                    openEndDrawer: widget.openEndDrawer,
                    showMoreButton: widget.showMoreButton,
                    onTap: () {
                      if (isUnlockTiktok) {
                        context.push(AppRouterPaths.tiktokSearch);
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
                  body: TiktokTopNaviView(id: widget.id, crackApp: widget.crackApp),
                ));
          }),
        ),
        // const _BlurView(),
      ],
    );
  }
}
