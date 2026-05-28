import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../domain/model/banner_model.dart';
import '../../../../../../domain/model/nav_model.dart';
import '../../../../../../report/ui_layer/report_general_banner.dart';
import '../../../../theme.dart';

class TiktokAdsHeader extends StatefulWidget {
  const TiktokAdsHeader({
    required this.bannersNotifier,
    this.color,
  });

  final Color? color;
  final ValueNotifier<List<BannerModel>> bannersNotifier;

  @override
  State<TiktokAdsHeader> createState() => _TiktokAdsHeaderState();
}

class _TiktokAdsHeaderState extends State<TiktokAdsHeader> {
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
              child: ReportGeneralAppsListVidget(
                  data: banners, titleColor: widget.color ?? Colors.white),
            );
          },
        ),
      ],
    );
  }
}
