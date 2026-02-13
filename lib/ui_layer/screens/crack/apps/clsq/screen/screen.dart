import 'package:flutter/material.dart';
import 'package:jycrpj/domain/model/crack_model.dart';
import 'package:jycrpj/domain/remote_domain/domains/user.dart';
import 'package:jycrpj/ui_layer/notifiers/user_notifier.dart';
import 'package:jycrpj/ui_layer/router/routes.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/search_app_bar.dart';
import 'package:jycrpj/ui_layer/screens/crack/app_util.dart';
import 'package:jycrpj/ui_layer/screens/crack/crack_app_type.dart';
import 'package:jycrpj/ui_layer/screens/crack/unlock_status_notifier.dart';
import 'package:provider/provider.dart';

import '../widget/cl_top_navi_view.dart';

class ClCommunityScreen extends StatefulWidget {
  final int id;
  final CrackApp? crackApp;
  final VoidCallback? openEndDrawer;
  final bool showMoreButton;

  const ClCommunityScreen({
    super.key,
    required this.id,
    this.crackApp,
    this.openEndDrawer,
    this.showMoreButton = true,
  });

  @override
  State<ClCommunityScreen> createState() => _ClCommunityScreenState();
}

class _ClCommunityScreenState extends State<ClCommunityScreen> {
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
                return Scaffold(
                  appBar: SearchAppBar(
                    isCrackApp: true,
                    showLeftBack: false,
                    type: CrackAppType.clsq,
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
                  body: ClTopNaviView(id: widget.id, crackApp: widget.crackApp),
                );
              }),
        ),
        // const _BlurView(),
      ],
    );
  }
}
