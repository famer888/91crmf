import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/domain/type_def.dart';
import 'package:jycrpj/ui_layer/router/routes.dart';
import 'package:provider/provider.dart';

import '../../../../../../domain/domain.dart';
import '../../../../../utils/common_utils.dart';
import '../../../../../utils/my_toast.dart';
import '../../../../common_widgets/my_app_bar.dart';
import '../../../../common_widgets/my_list_view.dart';
import '../../../../common_widgets/screen_background.dart';
import '../widget/tiktok_list_build.dart';

class TiktokVideoClassListScreen extends StatefulWidget {
  const TiktokVideoClassListScreen({super.key, required this.id, required this.name});

  final int id;
  final String name;

  @override
  State<TiktokVideoClassListScreen> createState() => _TiktokVideoClassListScreenState();
}

class _TiktokVideoClassListScreenState extends State<TiktokVideoClassListScreen> {
  late final _appDomain = context.read<AppDomain>();

  Future<List> _getData({
    required int page,
    required int pageSize,
  }) async {
    final param = {
      'nag_id': widget.id,
      'page': page,
      'limit': pageSize,
    };
    final result = await _appDomain.getConstructByApiLink(
      apiLink: '/api/tabnewttav/tab_list',
      params: param,
    );

    if (result.status == 1) {
      return result.data['list'] ?? [];
    }
    MyToast.showText(text: result.msg ?? '');
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
    final title = '${item['tab_name'] ?? ''}';
    final follow = '${item['favorites_num'] ?? '0'}';
    final works = '${item['work_num'] ?? '0'}';

    return GestureDetector(
      onTap: () {
        TiktokVideoClassDetailRoute(id: item['id']).push(context);
      },
      child: SizedBox(
        height: 90.w,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 172.w,
              height: 90.w,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.2),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: item['bg_thumb'] != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: Image.network(
                        '${item['bg_thumb']}',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                      ),
                    )
                  : null,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(color: Colors.white, fontSize: 14.sp),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '关注：${CommonUtils.formatNumber(follow)}',
                    style: TextStyle(color: Colors.white.withOpacity(.4), fontSize: 10.sp),
                  ),
                  Text(
                    '作品：${CommonUtils.formatNumber(works)}',
                    style: TextStyle(color: Colors.white.withOpacity(.4), fontSize: 10.sp),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
