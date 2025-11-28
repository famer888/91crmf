import 'package:flutter/material.dart';
import 'package:jycrpj/ui_layer/screens/apps/91aw/widget/aw91_top_navi_view.dart';

import '../../common_widgets/screen_background.dart';
import '../../common_widgets/search_app_bar.dart';

class Aw91CommunityScreen extends StatefulWidget {
  final int id;
  const Aw91CommunityScreen({super.key, required this.id});

  @override
  State<Aw91CommunityScreen> createState() => _Aw91CommunityScreenState();
}

class _Aw91CommunityScreenState extends State<Aw91CommunityScreen> {

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ScreenBackground(
          child: Scaffold(
            appBar: const SearchAppBar(showLeftBack: true, type: SearchAppBarType.aw91),
            body: Aw91TopNaviView(id: widget.id),
          ),
        ),
        // const _BlurView(),
      ],
    );
  }
}