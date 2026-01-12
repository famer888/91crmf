import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/domain/model/banner_model.dart';
import 'package:jycrpj/domain/model/nav_model.dart';
import 'package:jycrpj/ui_layer/router/routes.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/general_banner.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jycrpj/ui_layer/screens/image_paths.dart';
import 'package:jycrpj/ui_layer/screens/theme.dart';
import 'package:jycrpj/ui_layer/utils/common_utils.dart';

import '../../../../report/ui_layer/report_general_banner.dart';

import '../../../../report/ui_layer/report_gesture_detector.dart';

class BannerTopicsView extends StatefulWidget {
  final ValueNotifier<List<BannerModel>> bannersNotifier;
  final ValueNotifier<List<NavModel>> topicsNotifier;
  final Color titleColor;
  final Color topicBackgroundColor;
  final Color zkTextColor;
  final String moreVideoApi;
  final ValueChanged<String>? onLinkNavTap;

  const BannerTopicsView({
    super.key,
    required this.bannersNotifier,
    required this.topicsNotifier,
    required this.titleColor,
    required this.topicBackgroundColor,
    required this.zkTextColor,
    required this.moreVideoApi,
    this.onLinkNavTap,
  });

  @override
  State<BannerTopicsView> createState() => _BannerTopicsViewState();
}

class _BannerTopicsViewState extends State<BannerTopicsView> {
  List<NavModel> contentTopics = [];
  bool isShowAllTopics = false;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      SizedBox(height: 10.w),
      ValueListenableBuilder(
          valueListenable: widget.bannersNotifier,
          builder: (context, customTabItems, _) {
            if (customTabItems.isEmpty) return const SizedBox.shrink();

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
              child: ReportGeneralAppsListVidget(
                data: customTabItems,
                titleColor: widget.titleColor,
              ),
            );
          }),
      SizedBox(height: 12.w),
      ValueListenableBuilder(
        valueListenable: widget.topicsNotifier,
        builder: (context, topics, child) {
          if (topics.isEmpty) return const SizedBox.shrink();

          bool isGirlTopic = topics.first.resourceUrl.isNotEmpty; //如果配置了图片则横行展示上图下文布局

          if (isGirlTopic) {
            contentTopics = topics;
          } else {
            if (topics.length > 8 && !isShowAllTopics) {
              contentTopics = topics.sublist(0, 8);
            } else {
              contentTopics = topics;
            }
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isGirlTopic
                  ? girdTopicView(contentTopics)
                  : Padding(
                      padding: EdgeInsets.only(bottom: 3.w),
                      child: GridView.builder(
                          shrinkWrap: true,
                          addRepaintBoundaries: false,
                          addAutomaticKeepAlives: false,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: contentTopics.length,
                          padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            childAspectRatio: 80.w / 35.w,
                            mainAxisSpacing: 10.w,
                            crossAxisSpacing: 10.w,
                          ),
                          itemBuilder: (context, index) {
                            final topic = topics[index];
                            return DecoratedBox(
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.w)),
                                color: widget.topicBackgroundColor, // Color(0xff262631),
                              ),
                              child: Center(
                                child: ReportGestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    final linkUrl = topic.linkUrl;
                                    final redirectType = topic.redirectType;
                                    if (linkUrl.isEmpty) {
                                      return;
                                    }

                                    if (redirectType < 3) {
                                      CommonUtils.openRoute(context, topic.toJson());
                                    } else {
                                      if (topic.openType == 0) {
                                        widget.onLinkNavTap?.call(topic.linkUrl);
                                      } else if (topic.openType == 1) {
                                        MoreVideoRoute(name: topic.name, id: topic.linkUrl, api: widget.moreVideoApi).push(context);
                                      }
                                    }
                                  },
                                  child: Text(topic.name, style: MyTheme.white13),
                                ),
                              ),
                            );
                          }),
                    ),
              isGirlTopic ? Container() : SizedBox(height: 5.w),
              isGirlTopic
                  ? Container()
                  : Offstage(
                      offstage: topics.length <= 8 || isShowAllTopics,
                      child: InkWell(
                        onTap: () {
                          isShowAllTopics = true;
                          if (mounted) {
                            setState(() {});
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 6.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'zkckgd'.tr(context: context),
                                style: TextStyle(
                                  color: widget.zkTextColor,
                                  fontSize: 12.sp,
                                  overflow: TextOverflow.ellipsis,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              SizedBox(width: 3.w),
                              MyImage.asset(MyImagePaths.appDownGray, width: 10.w, height: 10.w)
                            ],
                          ),
                        ),
                      ),
                    ),
            ],
          );
        },
      ),
    ]);
  }

  Widget girdTopicView(List<NavModel> contentTopics) {
    return SizedBox(
      height: 75.w,
      // padding: EdgeInsets.all(5.w),
      child: GridView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: contentTopics.length,
          padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 1 / 0.7,
            mainAxisSpacing: 10.w,
            crossAxisSpacing: 10.w,
          ),
          itemBuilder: (context, index) {
            final topic = contentTopics[index];
            return ReportGestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                final linkUrl = topic.linkUrl;
                final redirectType = topic.redirectType;
                if (linkUrl.isEmpty) {
                  return;
                }

                if (redirectType < 3) {
                  CommonUtils.openRoute(context, topic.toJson());
                } else {
                  if (topic.openType == 0) {
                    widget.onLinkNavTap?.call(topic.linkUrl);
                  } else if (topic.openType == 1) {
                    MoreVideoRoute(name: topic.name, id: topic.linkUrl, api: widget.moreVideoApi).push(context);
                  }
                }
              },
              child: Column(
                children: [
                  MyImage.network(topic.resourceUrl, width: 50.w, height: 50.w, borderRadius: 5.w),
                  SizedBox(height: 3.w),
                  Text(topic.name, style: MyTheme.white11),
                ],
              ),
            );
          }),
    );
  }
}
