import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/domain/api_validator.dart';
import 'package:jycrpj/domain/model/category_topic_model.dart';
import 'package:jycrpj/domain/remote_domain/domains/dynamic.dart';
import 'package:jycrpj/domain/type_def.dart';
import 'package:jycrpj/report/ui_layer/report_gesture_detector.dart';
import 'package:jycrpj/ui_layer/router/routes.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_app_bar.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jycrpj/ui_layer/screens/theme.dart';
import 'package:jycrpj/ui_layer/utils/common_utils.dart';
import 'package:provider/provider.dart';

class PZhanMoreScreen extends StatefulWidget {
  const PZhanMoreScreen({
    super.key,
    required this.name,
    required this.id,
    required this.api,
  });

  final String name;
  final String id;
  final String api;

  @override
  State<PZhanMoreScreen> createState() => _PZhanMoreScreenState();
}

class _PZhanMoreScreenState extends State<PZhanMoreScreen> {
  late final dynamicDomain = context.read<DynamicDomain>();
  bool _isInit = true;

  Future<List<CategoryTopicModel>> _getTabList({required int page, required int limit}) async {
    final result = await dynamicDomain.getConstructByApiLink(apiLink: widget.api, params: {
      'nag_id': widget.id,
      'page': page,
      'limit': limit,
    });
    if (_isInit) {
      _isInit = false;
      setState(() {});
    }

    if (result.isValid) {
      if (result.data['list'] case final List data when data.isNotEmpty) {
        final categoryTopicModels = data.map<CategoryTopicModel>((e) => CategoryTopicModel.fromJson(e)).toList();
        return categoryTopicModels;
      }
    }
    return [];
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: widget.name),
      body: MyListView.list(
        scrollController: PrimaryScrollController.of(context),
        itemBuilder: (context, item, index) => _PZhanMoreCard(data: item),
        onFetchingMore: (currentPage, pageSize) => _getTabList(page: currentPage, limit: pageSize),
      ),
    );
  }
}

class _PZhanMoreCard extends StatefulWidget {
  const _PZhanMoreCard({required this.data});

  final CategoryTopicModel data;

  @override
  State<_PZhanMoreCard> createState() => _PZhanMoreCardState();
}

class _PZhanMoreCardState extends State<_PZhanMoreCard> {
  late final dynamicDomain = context.read<DynamicDomain>();
  bool isFollowed = false;

  @override
  void initState() {
    super.initState();
    isFollowed = widget.data.isFollow;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        PZhanTopicRoute(
          name: widget.data.tabName,
          id: widget.data.tabId.toString(),
          api: 'tabnewpzhan/list_tab_mv',
        ).push(context);
      },
      child: Container(
        width: ScreenUtil().screenWidth,
        height: 90.w,
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 90.w,
              width: 153.w,
              child: MyImage.network(
                widget.data.bgThumb,
                height: 110.w,
                width: 152.w,
                fit: BoxFit.cover,
                backgroundColor: MyTheme.imageBgColor,
                borderRadius: 5.w,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.data.tabName, style: MyTheme.white255_15_M.w600),
                  SizedBox(height: 4.w),
                  Text(
                    '${CommonUtils.renderEnFixedNumber(widget.data.favoritesNum)}${'gz'.tr(context: context)}',
                    style: MyTheme.white12medium.copyWith(fontWeight: FontWeight.w500, color: MyTheme.grayColor180),
                  ),
                  SizedBox(height: 4.w),
                  Text(
                    '${CommonUtils.renderEnFixedNumber(widget.data.workNum)}${'zp'.tr(context: context)}',
                    style: MyTheme.white12medium.copyWith(fontWeight: FontWeight.w500, color: MyTheme.grayColor180),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10.w),
            ReportGestureDetector(
              onTap: () async {
                final result = await dynamicDomain.getConstructByApiLink(
                  apiLink: 'tabnewpzhan/follow_tab',
                  params: {'tab_id': widget.data.tabId},
                );
                if (result.isValid) {
                  widget.data.isFollow = true;
                  setState(() {
                    isFollowed = !isFollowed;
                  });
                }
              },
              behavior: HitTestBehavior.translucent,
              child: Container(
                height: 28.w,
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.w),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isFollowed ? MyTheme.pzhanAppSearchBarBackgroundColor : MyTheme.pzhanAppPrimaryColor,
                  borderRadius: BorderRadius.circular(16.w),
                  // border: Border.all(color: isFollowed ? MyTheme.pzhanAppPrimaryColor : MyTheme.pzhanAppSearchBarBackgroundColor, width: 1.w),
                ),
                child: Text(
                  isFollowed ? 'ygz'.tr(context: context) : 'jgz'.tr(context: context),
                  style: isFollowed
                      ? MyTheme.blue80_12.copyWith(color: MyTheme.whiteColor, fontWeight: FontWeight.w600)
                      : MyTheme.white12.copyWith(fontWeight: FontWeight.w600, color: MyTheme.blackColor),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
