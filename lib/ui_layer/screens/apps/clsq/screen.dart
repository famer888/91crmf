import 'package:flutter/material.dart';

import '../../common_widgets/screen_background.dart';
import '../../common_widgets/search_app_bar.dart';
import 'widget/cl_top_navi_view.dart';

class ClCommunityScreen extends StatefulWidget {
  final int id;
  const ClCommunityScreen({super.key, required this.id});

  @override
  State<ClCommunityScreen> createState() => _ClCommunityScreenState();
}

class _ClCommunityScreenState extends State<ClCommunityScreen> {

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ScreenBackground(
          child: Scaffold(
            appBar: const SearchAppBar(showLeftBack: true, type: SearchAppBarType.clsq),
            body: ClTopNaviView(id: widget.id),
          ),
        ),
        // const _BlurView(),
      ],
    );
  }
}