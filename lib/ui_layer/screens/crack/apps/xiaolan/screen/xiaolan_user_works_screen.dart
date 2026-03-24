import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../domain/async_value.dart';
import '../../../../../../domain/domain.dart';
import '../../../../../../domain/model/feed/feed_model.dart';
import '../../../../common_widgets/my_app_bar.dart';
import '../../../../common_widgets/screen_background.dart';
import '../../../../common_widgets/status/loading.dart';
import '../../../../common_widgets/status/network_error.dart';
import '../widget/xiaolan_list_build.dart';

class XiaolanUserWorksScreen extends StatefulWidget {
  const XiaolanUserWorksScreen({super.key, required this.userName});

  final String userName;

  @override
  State<XiaolanUserWorksScreen> createState() => _XiaolanUserWorksScreenState();
}

class _XiaolanUserWorksScreenState extends State<XiaolanUserWorksScreen> {
  AsyncValue<List<FeedModel>> _asyncValue = const AsyncInit();
  late final _appDomain = context.read<AppDomain>();

  @override
  void initState() {
    _initTagList();
    super.initState();
  }

  // sort hot/new
  Future<void> _initTagList() async {
    if (_asyncValue.isLoading) return;
    setState(() {
      _asyncValue = const AsyncLoading();
    });

    _asyncValue = AsyncData([]);
    //
    //
    // final result = await _appDomain.getConstructByApiLink(
    //     apiLink: 'mvhjgj/list_tag_mvs',
    //     params: {'tag': widget.videoTag, 'sort': 'hot'});
    // if (result.status == 1) {
    //   if (result.data case final list when list.isNotEmpty) {
    //     final feedModelList =
    //         list?.map<FeedModel>((x) => FeedModel.fromJson(x)).toList();
    //     _asyncValue = AsyncData(feedModelList);
    //   }
    // } else {
    //   MyToast.showText(text: result.msg ?? '');
    //   _asyncValue = const AsyncError();
    // }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      bgColor: Colors.white,
      child: Stack(
        children: [
          Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: Image.asset('assets/images/xiaolan_top_navi_bg.png', width: double.infinity, fit: BoxFit.cover)),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: MyAppBar(
                title: widget.userName,
                backIconColor: Color(0xFF151515),
                titleColor: Color(0xFF151515),
                backgroundColor: Colors.transparent),
            body: _asyncValue.maybeWhen(
                orElse: () => const LoadingView(),
                error: (_, __) => NetworkErrorView(onTap: _initTagList),
                data: (data) {
                  return XiaoLanListBuild(type: XiaoLanListBuildType.fourGrid, showHandle: false, showHead: false);
                }),
          )
        ],
      ),
    );
  }
}
