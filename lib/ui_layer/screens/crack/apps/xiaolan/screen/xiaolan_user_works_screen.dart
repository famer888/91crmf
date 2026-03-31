import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jycrpj/domain/type_def.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jycrpj/data_layer/repo/repo.dart';
import 'package:jycrpj/ui_layer/notifiers/home_config_notifier.dart';
import 'package:provider/provider.dart';

import '../../../../../../domain/async_value.dart';
import '../../../../../../domain/domain.dart';
import '../../../../../../domain/model/feed/feed_model.dart';
import '../../../../../router/routes.dart';
import '../../../../../utils/my_toast.dart';
import '../../../../common_widgets/my_app_bar.dart';
import '../../../../common_widgets/screen_background.dart';
import '../../../../common_widgets/status/loading.dart';
import '../../../../common_widgets/status/network_error.dart';
import '../../../../theme.dart';
import '../widget/xiaolan_list_build.dart';

class XiaolanUserWorksScreen extends StatefulWidget {
  const XiaolanUserWorksScreen({super.key, required this.userId, required this.userName});

  final String userId;
  final String userName;

  @override
  State<XiaolanUserWorksScreen> createState() => _XiaolanUserWorksScreenState();
}

class _XiaolanUserWorksScreenState extends State<XiaolanUserWorksScreen> {

  late final _appDomain = context.read<AppDomain>();

  @override
  void initState() {
    super.initState();
  }

  // sort hot/new
  Future<List> _getData({
    required int page,
    required int pageSize,
  }) async {
    bool isInit = false;

    final result = await _appDomain.getConstructByApiLink(apiLink: "/api/usersxiaolan/videos", params: {
      "uid": widget.userId,
      "page": page,
      "limit": pageSize,
    });

    if (!isInit) {
      setState(() {
        isInit = true;
      });
    }

    if (result.status == 1) {
      return result.data;
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
    return [];
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
                  title: "${widget.userName}",
                  backIconColor: Color(0xFF151515),
                  titleColor: Color(0xFF151515),
                  backgroundColor: Colors.transparent),
              body: MyListView.grid(
                padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding, vertical: 8.w),
                crossAxisCount: 3,
                mainAxisSpacing: 7.h,
                crossAxisSpacing: 7.w,
                childAspectRatio: 225 / 224,
                itemBuilder: (context, item, index) => XiaoLanItem.build(XiaoLanItemType.video, item, onTap: () {
                  XiaolanVideoDetailRoute(id: item['id']).push(context);
                }),
                onFetchingMore: (currentPage, pageSize) {
                  final res = _getData(page: currentPage, pageSize: pageSize);
                  return res;
                },
              ))
        ],
      ),
    );
  }
}
