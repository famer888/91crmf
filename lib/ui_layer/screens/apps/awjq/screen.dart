import 'package:flutter/material.dart';
import 'package:jycrpj/ui_layer/screens/apps/awjq/widget/awjq_top_navi_view.dart';

import '../../common_widgets/screen_background.dart';
import '../../common_widgets/search_app_bar.dart';

class AwRestrictedAreaScreen extends StatefulWidget {
  final int id;
  const AwRestrictedAreaScreen({super.key, required this.id});

  @override
  State<AwRestrictedAreaScreen> createState() => _AwRestrictedAreaScreenState();
}

class _AwRestrictedAreaScreenState extends State<AwRestrictedAreaScreen> {

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ScreenBackground(
          child: Scaffold(
            appBar: const SearchAppBar(showLeftBack: true, type: SearchAppBarType.awqj),
            body: AwjqTopNaviView(id: widget.id),
          ),
        ),
        // const _BlurView(),
      ],
    );
  }
}