import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../domain/model/banner_model.dart';
import '../../../../../../domain/model/nav_model.dart';
import '../../../../../../report/ui_layer/report_general_banner.dart';
import '../../../../theme.dart';

class XiaoLanAdsHeader extends StatefulWidget {
  const XiaoLanAdsHeader({
    required this.bannersNotifier,
  });

  final ValueNotifier<List<BannerModel>> bannersNotifier;

  @override
  State<XiaoLanAdsHeader> createState() => _XiaoLanAdsHeaderState();
}

class _XiaoLanAdsHeaderState extends State<XiaoLanAdsHeader> {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ValueListenableBuilder(
          valueListenable: widget.bannersNotifier,
          builder: (context, banners, child) {
            if (banners.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
              child: ReportGeneralAppsListVidget(data: banners, titleColor: Colors.black.withValues(alpha: .7)),
            );
          },
        ),
      ],
    );
  }
}
