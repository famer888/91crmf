import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/domain/type_def.dart';
import 'package:provider/provider.dart';

import '../../../../../../domain/domain.dart';
import '../../../../../router/routes.dart';
import '../../../../../utils/common_utils.dart';
import '../../../../../utils/my_toast.dart';
import '../../../../common_widgets/my_app_bar.dart';
import '../../../../common_widgets/my_image.dart';
import '../../../../common_widgets/my_list_view.dart';
import '../../../../common_widgets/screen_background.dart';

class TiktokCreatorScreen extends StatefulWidget {
  final String name;
  final String id;

  const TiktokCreatorScreen({
    super.key,
    required this.name,
    required this.id,
  });

  @override
  State<TiktokCreatorScreen> createState() => _TiktokCreatorScreenState();
}

class _TiktokCreatorScreenState extends State<TiktokCreatorScreen> with TickerProviderStateMixin {
  late final _appDomain = context.read<AppDomain>();

  Future<List> _getData({
    required int page,
    required int pageSize,
  }) async {
    final param = {
      'group_id': widget.id,
      'page': page,
      'limit': pageSize,
    };
    try {
      final result = await _appDomain.getConstructByApiLink(
        apiLink: '/api/mvlistttav/uper_list',
        params: param,
      );

      if (result.status == 1) {
        return result.data ?? [];
      }
      MyToast.showText(text: result?.msg ?? '');
    } catch (e) {}
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      bgColor: const Color(0xFF181A25),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: MyAppBar(
          title: widget.name,
          backIconColor: Colors.white,
          titleColor: Colors.white,
          backgroundColor: const Color(0xFF181A25),
        ),
        body: MyListView.list(
          padding: EdgeInsets.symmetric(horizontal: 12.5.w, vertical: 8.w),
          contentPadding: 10.w,
          itemBuilder: (context, item, index) {
            return _ClassListRow(item: item);
          },
          onFetchingMore: (currentPage, pageSize) {
            return _getData(page: currentPage, pageSize: pageSize);
          },
        ),
      ),
    );
  }
}

/// 固定高度行，避免 [Spacer] 在 sliver 列表中引发布局/鼠标追踪断言。
class _ClassListRow extends StatelessWidget {
  const _ClassListRow({required this.item});

  final dynamic item;

  @override
  Widget build(BuildContext context) {
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
                        '${CommonUtils.formatNumber(fabulous_count)}点赞  作品：${CommonUtils.formatNumber(works)}  粉丝：${CommonUtils.formatNumber(follow)}',
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
