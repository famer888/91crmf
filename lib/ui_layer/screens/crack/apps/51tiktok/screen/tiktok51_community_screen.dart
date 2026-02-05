import 'package:flutter/material.dart';
import 'package:jycrpj/domain/domain.dart';
import 'package:jycrpj/domain/model/crack_model.dart';
import 'package:jycrpj/ui_layer/notifiers/user_notifier.dart';
import 'package:jycrpj/ui_layer/router/routes.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/search_app_bar.dart';
import 'package:jycrpj/ui_layer/screens/crack/app_util.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/51tiktok/widget/tiktok51_top_navi_view.dart';
import 'package:jycrpj/ui_layer/screens/crack/crack_app_type.dart';
import 'package:jycrpj/ui_layer/screens/crack/unlock_status_notifier.dart';
import 'package:provider/provider.dart';

class Tiktok51CommunityScreen extends StatefulWidget {
  final int id;
  final CrackApp? crackApp;
  final VoidCallback? openEndDrawer;

  const Tiktok51CommunityScreen({
    super.key,
    required this.id,
    this.crackApp,
    this.openEndDrawer,
  });

  @override
  State<Tiktok51CommunityScreen> createState() => _Tiktok51CommunityScreenState();
}

class _Tiktok51CommunityScreenState extends State<Tiktok51CommunityScreen> {
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
              selector: (_, notifier) => notifier.isUnlockTiktok51,
              builder: (context, isUnlockTiktok51, child) {
                return Scaffold(
                  appBar: SearchAppBar(
                    showLeftBack: false,
                    isCrackApp: true,
                    type: CrackAppType.tiktok51,
                    openEndDrawer: widget.openEndDrawer,
                    onTap: () {
                      if (isUnlockTiktok51) {
                        const Tiktok51VideoSearchRoute(args: '').push(context);
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
                  body: Tiktok51TopNaviView(id: widget.id, crackApp: widget.crackApp),
                );
              }),
        ),
        // const _BlurView(),
      ],
    );
  }
}
