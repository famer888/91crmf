import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/domain/async_value.dart';
import 'package:jycrpj/domain/domain.dart';
import 'package:jycrpj/domain/model/feed/feed_model.dart';
import 'package:jycrpj/domain/type_def.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_app_bar.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/status/loading.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/status/network_error.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/clsq/widget/cl_feed_card.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/xiaolan/widget/xiaolan_list_build.dart';
import 'package:jycrpj/ui_layer/screens/theme.dart';
import 'package:jycrpj/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';

class XiaoLanBlockScreen extends StatefulWidget {
  final String videoTag;

  const XiaoLanBlockScreen({super.key, required this.videoTag});

  @override
  State<XiaoLanBlockScreen> createState() => _XiaoLanBlockScreenState();
}

class _XiaoLanBlockScreenState extends State<XiaoLanBlockScreen> {
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
                title: widget.videoTag,
                backIconColor: Color(0xFF151515),
                titleColor: Color(0xFF151515),
                backgroundColor: Colors.transparent),
            body: _asyncValue.maybeWhen(
                orElse: () => const LoadingView(),
                error: (_, __) => NetworkErrorView(onTap: _initTagList),
                data: (data) {
                  return XiaoLanListBuild(type: XiaoLanListBuildType.fourGrid,);
                }),
          )
        ],
      ),
    );
  }
}
