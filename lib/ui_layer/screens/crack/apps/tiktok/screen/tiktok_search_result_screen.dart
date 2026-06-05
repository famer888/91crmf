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
import '../../../../../utils/common_utils.dart';
import '../../../../../utils/my_toast.dart';
import '../../../../common_widgets/my_app_bar.dart';
import '../../../../common_widgets/my_image.dart';
import '../../../../common_widgets/my_tab_bar.dart';
import '../../../../common_widgets/screen_background.dart';
import '../../../../common_widgets/status/loading.dart';
import '../../../../common_widgets/status/network_error.dart';
import '../../../../theme.dart';
import '../widget/tiktok_list_build.dart';

class TiktokSearchResultScreen extends StatefulWidget {
  const TiktokSearchResultScreen({super.key, required this.kwy});

  final String kwy;

  @override
  State<TiktokSearchResultScreen> createState() => _TiktokSearchResultScreenState();
}

class _TiktokSearchResultScreenState extends State<TiktokSearchResultScreen> {
  late final _appDomain = context.read<AppDomain>();
  late final _homeConfigNotifier = context.read<HomeConfigNotifier>();

  @override
  void initState() {
    _homeConfigNotifier.upsertSearchHistory(key: tiktokSearchHistoryKey, searchWord: widget.kwy);
    super.initState();
  }

  // sort hot/new
  Future<List> _getData({
    required int page,
    required int pageSize,
  }) async {
    bool isInit = false;

    final result = await _appDomain.getConstructByApiLink(apiLink: "/api/searchttav/mv", params: {
      "kwy": widget.kwy,
      "page": page,
      "limit": pageSize,
    });

    if (!isInit) {
      setState(() {
        isInit = true;
      });
    }

    if (result.status == 1) {
      return result.data['list'];
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
    return [];
  }


  Future<List> _getUserData({
    required int page,
    required int pageSize,
  }) async {
    bool isInit = false;

    final result = await _appDomain.getConstructByApiLink(apiLink: "/api/searchttav/users", params: {
      "keyword": widget.kwy,
      "page": page,
      "limit": pageSize,
    });

    if (!isInit) {
      setState(() {
        isInit = true;
      });
    }

    if (result.status == 1) {
      return result.data['list'];
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
        bgColor: Color(0xFF181A25),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: MyAppBar(
              title: "${widget.kwy}",
              backIconColor: Colors.white,
              titleColor: Colors.white,
              backgroundColor: Colors.transparent),
          body: TabBarWithView.line(
              tabBarPadding: EdgeInsets.zero,
              initialIndex: 0,
              tabBarHeight: 54.w,
              linearColors: const [Color(0xFFFF2E59), Color(0xFFFF2E59)],
              labelStyle: TextStyle(color: const Color(0xFFFF2E59), fontSize: 16.sp, fontWeight: FontWeight.w600),
              unselectedLabelStyle: TextStyle(
                color: const Color(0xFFFFFFFF),
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
              ),
              titles: ['视频', '用户'],
              views: [
                MyListView.grid(
                  padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding, vertical: 8.w),
                  crossAxisCount: 2,
                  mainAxisSpacing: 10.h,
                  crossAxisSpacing: 8.w,
                  childAspectRatio: 344 / 240,
                  itemBuilder: (context, item, index) =>
                      TiktokItem.build(TiktokItemType.video, item, onTap: () {
                        TiktokVideoDetailRoute(id: item['id']).push(context);
                      }),
                  onFetchingMore: (currentPage, pageSize) {
                    final res = _getData(page: currentPage, pageSize: pageSize);
                    return res;
                  },
                ),
                MyListView.list(
                  padding: EdgeInsets.symmetric(horizontal: 12.5.w, vertical: 8.w),
                  contentPadding: 10.w,
                  itemBuilder: (context, item, index) => _buildUser(item),
                  onFetchingMore: (currentPage, pageSize) {
                    final res = _getUserData(page: currentPage, pageSize: pageSize);
                    return res;
                  },
                )
              ]),
        ));
  }

  Widget _buildUser(dynamic item) {
    final title = item['nickname'] ?? '';
    final follow = item['fans_count'] ?? 0;
    final works = item['videos'] ?? 0;
    final fabulous_count = item['fabulous_count'] ?? 0;

    return GestureDetector(
      onTap: () {
        TiktokUserWorksRoute(id: "${item['uid']}", userName: item['nickname'] ?? '').push(context);
      },
      child: Container(
        height: 103.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          color: Color(0xFF22262F),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 50.w,
                  height: 50.w,
                  decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(50.w), color: Colors.white.withOpacity(.9)),
                  child: MyImage.network("${item['thumb_full'] ?? ""}",
                      fit: BoxFit.cover, borderRadius: 50.w, backgroundColor: Colors.white.withOpacity(.9)),
                ),
                SizedBox(width: 7.w),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 4.w),
                      Text(
                        '${CommonUtils.formatNumber(fabulous_count)}点赞  作品：${CommonUtils.formatNumber(works)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white.withOpacity(.4), fontSize: 12.sp),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Text(
              "${item['desc'] ?? ""}",
              style: TextStyle(color: Colors.white.withOpacity(.4), fontSize: 13.sp, fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
