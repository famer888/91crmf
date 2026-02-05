import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/domain/api_validator.dart';
import 'package:jycrpj/domain/model/category_topic_model.dart';
import 'package:jycrpj/domain/remote_domain/domains/dynamic.dart';
import 'package:jycrpj/domain/type_def.dart';
import 'package:jycrpj/report/ui_layer/report_gesture_detector.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_app_bar.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jycrpj/ui_layer/screens/theme.dart';
import 'package:jycrpj/ui_layer/utils/common_utils.dart';
import 'package:provider/provider.dart';

class Tiktok51MoreScreen extends StatefulWidget {
  const Tiktok51MoreScreen({
    super.key,
    required this.name,
    required this.id,
    required this.api,
  });

  final String name;
  final String id;
  final String api;

  @override
  State<Tiktok51MoreScreen> createState() => _Tiktok51MoreScreenState();
}

class _Tiktok51MoreScreenState extends State<Tiktok51MoreScreen> {
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
        itemBuilder: (context, item, index) => _Tiktok51MoreCard(data: item),
        onFetchingMore: (currentPage, pageSize) => _getTabList(page: currentPage, limit: pageSize),
      ),
    );
  }
}

class _Tiktok51MoreCard extends StatefulWidget {
  const _Tiktok51MoreCard({required this.data});

  final CategoryTopicModel data;

  @override
  State<_Tiktok51MoreCard> createState() => _Tiktok51MoreCardState();
}

class _Tiktok51MoreCardState extends State<_Tiktok51MoreCard> {
  late final dynamicDomain = context.read<DynamicDomain>();
  bool isFollowed = false;

  @override
  void initState() {
    super.initState();
    isFollowed = widget.data.isFollow;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  CommonUtils.renderEnFixedNumber(widget.data.favoritesNum),
                  style: MyTheme.white12medium.copyWith(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 4.w),
                Text(
                  CommonUtils.renderEnFixedNumber(widget.data.workNum),
                  style: MyTheme.white12medium.copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          ReportGestureDetector(
            onTap: () async {
              final result = await dynamicDomain.getConstructByApiLink(
                apiLink: 'tabnew51tikok/follow_tab',
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
                color: isFollowed ? Colors.transparent : MyTheme.tiktok51AppPrimaryColor,
                borderRadius: BorderRadius.circular(5.w),
                border: Border.all(color: isFollowed ? MyTheme.tiktok51AppPrimaryColor : Colors.transparent, width: 1.w),
              ),
              child: Text(
                isFollowed ? 'ygz'.tr(context: context) : 'jgz'.tr(context: context),
                style: isFollowed
                    ? MyTheme.blue80_12.copyWith(color: MyTheme.tiktok51AppPrimaryColor, fontWeight: FontWeight.w500)
                    : MyTheme.white12.copyWith(fontWeight: FontWeight.w500),
              ),
            ),
          )
        ],
      ),
    );
  }
}
