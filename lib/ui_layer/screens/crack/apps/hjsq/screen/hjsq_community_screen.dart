import 'package:flutter/material.dart';
import 'package:jycrpj/domain/model/crack_model.dart';
import 'package:jycrpj/domain/remote_domain/domains/user.dart';
import 'package:jycrpj/ui_layer/notifiers/user_notifier.dart';
import 'package:jycrpj/ui_layer/router/routes.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/search_app_bar.dart';
import 'package:jycrpj/ui_layer/screens/crack/app_util.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/hjsq/widget/hjsq_top_navi_view.dart';
import 'package:jycrpj/ui_layer/screens/crack/crack_app_type.dart';
import 'package:jycrpj/ui_layer/screens/crack/unlock_status_notifier.dart';
import 'package:provider/provider.dart';

class HjsqCommunityScreen extends StatefulWidget {
  final int id;
  final CrackApp? crackApp;
  final bool showMoreButton;
  final VoidCallback? openEndDrawer;

  const HjsqCommunityScreen({
    super.key,
    required this.id,
    this.crackApp,
    this.openEndDrawer,
    this.showMoreButton = true,
  });

  @override
  State<HjsqCommunityScreen> createState() => _HjsqCommunityScreenState();
}

class _HjsqCommunityScreenState extends State<HjsqCommunityScreen> {
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
              selector: (_, notifier) => notifier.isUnlockHjsq,
              builder: (context, isUnlockHjsq, child) {
                return Scaffold(
                  appBar: SearchAppBar(
                    showLeftBack: false,
                    isCrackApp: true,
                    type: CrackAppType.hjsq,
                    openEndDrawer: widget.openEndDrawer,
                    showMoreButton: widget.showMoreButton,
                    onTap: () {
                      if (isUnlockHjsq) {
                        const HjsqVideoSearchRoute(args: '').push(context);
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
                  body: HjsqTopNaviView(id: widget.id, crackApp: widget.crackApp),
                );
              }),
        ),
        // const _BlurView(),
      ],
    );
  }
}
