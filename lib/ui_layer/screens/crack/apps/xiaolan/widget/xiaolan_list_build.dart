//类型枚举
import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jycrpj/ui_layer/router/paths.dart';
import 'package:jycrpj/ui_layer/router/routes.dart';
import 'package:jycrpj/ui_layer/utils/common_utils.dart';

import '../../../../../../domain/model/link_model.dart';
import '../../../../common_widgets/my_image.dart';

enum XiaoLanListBuildType {
//  一行大 第二行滚动
  oneBigSecondScroll,
//   一行滚动
  oneLineScroll,
//   四宫格
  fourGrid,
  sixGrid,
//   一行大+四宫格
  oneBigFourGrid,
//   创作达人
  creator,
//   用户横向滚动
  userScroll,
//   tag
  tag,
//   分类滚动
  categoryScroll,
}

class XiaoLanListBuild extends StatefulWidget {
  const XiaoLanListBuild({super.key, required this.type, this.model, this.linkModel, this.onRefresh});

  final LinkModel? linkModel;
  final XiaoLanListBuildType type;
  final dynamic model;
  final Future<String> Function()? onRefresh;

  @override
  State<XiaoLanListBuild> createState() => _XiaoLanListBuildState();
}

class _XiaoLanListBuildState extends State<XiaoLanListBuild> with SingleTickerProviderStateMixin {
  late final AnimationController _refreshIconController;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _refreshIconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
  }

  @override
  void dispose() {
    _refreshIconController.dispose();
    super.dispose();
  }

  void _openDaily() {
    XiaolanDailyRoute().push(context);
  }

  void _openCreator() {
    XiaolanCreatorRoute().push(context);
  }

  void _openDiscover(String type, {String nagId = ""}) {
    XiaolanDiscoverRoute(type: type, nagId: nagId).push(context);
  }

  void _openCategoryDetail(int id, String title, String type, {bool hasSort = true}) {
    if (!(widget.model is List) && widget.model['type'] == 5) {
      _openDaily();
      return;
    }
    XiaolanCategoryOrTagDetailRoute(id: id, title: title, type: type, has_sort: hasSort == true ? "1" : "0")
        .push(context);
  }

  Widget _buildTypeLayout() {
    switch (widget.type) {
      case XiaoLanListBuildType.categoryScroll:
        List items = widget.model ?? [];
        return Column(
          children: [
            _buildHead(
                name: "发现精彩",
                onTap: () {
                  _openDiscover(
                    'category',
                    nagId: "${widget.linkModel?.params['nag_id'] ?? ''}",
                  );
                }),
            SizedBox(
              height: 10.w,
            ),
            SizedBox(
              height: 103.w,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  dynamic item = items[index];
                  return SizedBox(
                    height: 103.w,
                    width: 103.w,
                    child: XiaoLanItem.build(XiaoLanItemType.category, item, onTap: () {
                      _openCategoryDetail(item['id'], item['title'], 'category');
                    }),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(width: 8.w),
                itemCount: items.length,
              ),
            )
          ],
        );
      case XiaoLanListBuildType.tag:
        List<dynamic> items = widget.model["item"] ?? [];
        items = items.take(6).toList();
        return Column(
          children: [
            _buildHead(
                name: widget.model["name"],
                onTap: () {
                  _openDiscover('tag');
                }),
            SizedBox(
              height: 10.w,
            ),
            _buildTagGrid(items)
          ],
        );
      case XiaoLanListBuildType.oneBigSecondScroll:
        List items = widget.model['list'] ?? [];
        return Column(
          children: [
            _buildHead(
                name: widget.model["title"],
                subName: widget.model["sub_title"],
                onTap: () {
                  // _openDiscover('tag');
                  _openCategoryDetail(widget.model['id'], widget.model['title'], 'category',
                      hasSort: "${widget.model['has_tab']}" == "1");
                }),
            if ((widget.model['list'] as List).length > 0) ...[
              SizedBox(
                height: 10.w,
              ),
              (items.length > 0)
                  ? SizedBox(
                      height: 218.h,
                      child: XiaoLanItem.build(XiaoLanItemType.video, items[0], onTap: () {
                        XiaolanVideoDetailRoute(id: items[0]['id']).push(context);
                      }))
                  : SizedBox.shrink(),
              SizedBox(height: 14.5.h),
              SizedBox(
                height: 84.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, _index) {
                    int index = _index;
                    if (index >= items.length - 1) {
                      return Container(
                        width: 145.w,
                        height: 99.5.h,
                        color: Colors.black.withValues(alpha: .5),
                      );
                    }
                    return SizedBox(
                      width: 145.w,
                      height: 99.5.h,
                      child: XiaoLanItem.build(XiaoLanItemType.video, items[index + 1], onTap: () {
                        XiaolanVideoDetailRoute(id: items[index + 1]['id']).push(context);
                      }),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(width: 8.w),
                  itemCount: items.length - 1 < 0 ? 0 : items.length - 1,
                ),
              ),
            ],
            SizedBox(
              height: 14.h,
            ),
            _buildHandle(onMoreTap: () {
              _openCategoryDetail(widget.model['id'], widget.model['title'], 'category',
                  hasSort: "${widget.model['has_tab']}" == "1");
            })
          ],
        );
      case XiaoLanListBuildType.oneLineScroll:
        List items = widget.model['list'] ?? [];
        return Column(
          children: [
            _buildHead(
                name: widget.model["title"],
                subName: widget.model["sub_title"],
                onTap: () {
                  // _openDiscover('tag');
                  _openCategoryDetail(widget.model['id'], widget.model['title'], 'category',
                      hasSort: "${widget.model['has_tab']}" == "1");
                }),
            if ((widget.model['list'] as List).length > 0) ...[
              SizedBox(
                height: 10.w,
              ),
              SizedBox(
                height: 208.5.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => SizedBox(
                      height: 208.5.h,
                      width: 318.w,
                      child: XiaoLanItem.build(XiaoLanItemType.video, items[index], onTap: () {
                        XiaolanVideoDetailRoute(id: items[index]['id']).push(context);
                      })),
                  separatorBuilder: (context, index) => SizedBox(width: 8.w),
                  itemCount: items.length,
                ),
              ),
            ],
            // SizedBox(
            //   height: 14.h,
            // ),
            // _buildHandle(onMoreTap: () {
            //   _openCategoryDetail(widget.model['id'], widget.model['title'], 'category',
            //       hasSort: "${widget.model['has_tab']}" == "1");
            // })
          ],
        );
      case XiaoLanListBuildType.fourGrid:
      case XiaoLanListBuildType.sixGrid:
        return Column(
          children: [
            _buildHead(
                name: widget.model["title"],
                subName: widget.model["sub_title"],
                onTap: () {
                  _openCategoryDetail(widget.model['id'], widget.model['title'], 'category',
                      hasSort: "${widget.model['has_tab']}" == "1");
                }),
            SizedBox(
              height: 10.w,
            ),
            GridView.builder(
              itemCount:
                  min(widget.type == XiaoLanListBuildType.fourGrid ? 4 : 6, (widget.model['list'] as List).length),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10.h,
                crossAxisSpacing: 8.w,
                childAspectRatio: 344 / 240,
              ),
              itemBuilder: (context, index) {
                if (widget.model['list'] is List && index < widget.model['list'].length) {
                  dynamic item = widget.model['list'][index];
                  return XiaoLanItem.build(XiaoLanItemType.video, item, onTap: () {
                    XiaolanVideoDetailRoute(id: item['id']).push(context);
                  });
                }
                return Container(
                  color: Colors.black.withValues(alpha: .5),
                );
              },
            ),
            SizedBox(
              height: 14.h,
            ),
            _buildHandle(onMoreTap: () {
              _openCategoryDetail(widget.model['id'], widget.model['title'], 'category',
                  hasSort: "${widget.model['has_tab']}" == "1");
            })
          ],
        );
      case XiaoLanListBuildType.oneBigFourGrid:
        List items = widget.model['list'] ?? [];

        return Column(
          children: [
            _buildHead(
                name: widget.model["title"],
                subName: widget.model["sub_title"],
                onTap: () {
                  // _openDiscover('tag');
                  _openCategoryDetail(widget.model['id'], widget.model['title'], 'category',
                      hasSort: "${widget.model['has_tab']}" == "1");
                }),
            if ((widget.model['list'] as List).length > 0) ...[
              SizedBox(
                height: 10.w,
              ),
              (items.length > 0)
                  ? SizedBox(
                      height: 218.h,
                      child: XiaoLanItem.build(XiaoLanItemType.video, items[0], onTap: () {
                        XiaolanVideoDetailRoute(id: items[0]['id']).push(context);
                      }))
                  : SizedBox.shrink(),
              SizedBox(height: 8.h),
              if ((widget.model['list'] as List).length > 4)
                GridView.builder(
                  itemCount: min(4, (widget.model['list'] as List).length - 1),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8.h,
                    crossAxisSpacing: 8.w,
                    childAspectRatio: 1.6,
                  ),
                  itemBuilder: (context, _index) {
                    int index = _index + 1;
                    if (widget.model['list'] is List && index < widget.model['list'].length) {
                      dynamic item = widget.model['list'][index];
                      return XiaoLanItem.build(XiaoLanItemType.video, item, onTap: () {
                        XiaolanVideoDetailRoute(id: item['id']).push(context);
                      });
                    }
                    return Container(
                      color: Colors.black.withValues(alpha: .5),
                    );
                  },
                ),
              _buildHandle(onMoreTap: () {
                _openCategoryDetail(widget.model['id'], widget.model['title'], 'category',
                    hasSort: "${widget.model['has_tab']}" == "1");
              })
            ]
          ],
        );
      case XiaoLanListBuildType.creator:
        return Column(
          children: [
            GestureDetector(
                onTap: () {
                  _openCreator();
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          height: 15.w,
                          width: 15.w,
                          child: MyImage.network(
                            widget.model['icon'],
                            width: 15.w,
                            height: 15.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          "${widget.model['name']}",
                          style: TextStyle(color: Color(0xFF333333), fontSize: 20.sp, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Spacer(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "查看更多",
                          style: TextStyle(color: Color(0xFF666666), fontSize: 12.sp, fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          width: 4.w,
                        ),
                        Image.asset(
                          "assets/images/app_issue_arrow.png",
                          color: Color(0xFF666666),
                          width: 5.w,
                        ),
                      ],
                    ),
                  ],
                )),
            SizedBox(
              height: 12.h,
            ),
            //   横向滚动
            SizedBox(
              height: 55.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  dynamic user = widget.model['item'][index];
                  return GestureDetector(
                    onTap: () {
                      XiaolanUserWorksRoute(userName: user['nickname'], id: "${user['uid']}").push(context);
                    },
                    child: Column(
                      children: [
                        Container(
                            width: 38.w,
                            height: 38.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: MyImage.network(user['thumb'],
                                width: 38.w, height: 38.w, fit: BoxFit.cover, borderRadius: 38.r)),
                        Spacer(),
                        Text(
                          "${user['nickname']}",
                          style: TextStyle(color: Colors.black.withValues(alpha: .7), fontSize: 12.sp),
                        )
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(width: 8.w),
                itemCount: (widget.model['item'] as List).length,
              ),
            )
          ],
        );
      case XiaoLanListBuildType.userScroll:
        return Column(
          children: [
            GestureDetector(
              onTap: () {
                XiaolanUserWorksRoute(userName: widget.model['nickname'], id: "${widget.model['aff']}").push(context);
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Container(
                  //   width: 38.w,
                  //   height: 38.h,
                  //   decoration: BoxDecoration(
                  //     color: Color(0xFFD9D9D9),
                  //     shape: BoxShape.circle,
                  //   ),
                  //   child: ,
                  // ),
                  SizedBox(
                    height: 38.w,
                    width: 38.w,
                    child: MyImage.network(
                      widget.model['thumb'],
                      width: 38.w,
                      height: 38.w,
                      fit: BoxFit.cover,
                      borderRadius: 38.r,
                    ),
                  ),
                  SizedBox(
                    width: 9.5.w,
                  ),
                  Text(
                    "${widget.model['nickname']}",
                    style: TextStyle(color: Color(0xFF333333), fontSize: 20.sp),
                  ),
                  Spacer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "查看更多",
                        style: TextStyle(color: Color(0xFF666666), fontSize: 12.sp, fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                      Image.asset(
                        "assets/images/app_issue_arrow.png",
                        color: Color(0xFF666666),
                        width: 5.w,
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 12.h,
            ),
            //   横向滚动
            SizedBox(
              height: 208.5.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => SizedBox(
                    height: 208.5.h,
                    width: 318.w,
                    child:
                        XiaoLanItem.build(XiaoLanItemType.video, (widget.model['mv_list'] as List)[index], onTap: () {
                      XiaolanVideoDetailRoute(id: (widget.model['mv_list'] as List)[index]['id']).push(context);
                    })),
                separatorBuilder: (context, index) => SizedBox(width: 8.w),
                itemCount: (widget.model['mv_list'] as List).length,
              ),
            )
          ],
        );
    }
  }

  Widget _buildTagGrid(List items) {
    return GridView.builder(
      itemCount: items.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 7.h,
        crossAxisSpacing: 7.w,
        childAspectRatio: 225 / 224,
      ),
      itemBuilder: (context, index) {
        dynamic item = items[index];
        return XiaoLanItem.build(XiaoLanItemType.tag, item, onTap: () {
          _openCategoryDetail(item['id'], item['name'] ?? '', 'tag');
        });
      },
    );
  }

  Widget _buildHandle({Function? onMoreTap}) {
    return Column(
      children: [
        SizedBox(height: 10.w,),
        Row(
          children: [
            Expanded(
                child: GestureDetector(
                  onTap: () async {
                    if (_isRefreshing || widget.onRefresh == null) {
                      return;
                    }
                    _isRefreshing = true;
                    _refreshIconController.repeat();
                    try {
                      await widget.onRefresh!.call();
                    } finally {
                      _isRefreshing = false;
                      if (mounted) {
                        _refreshIconController
                          ..stop()
                          ..reset();
                      }
                    }
                  },
                  child: Container(
                    height: 39.h,
                    decoration: BoxDecoration(
                      color: Color(0xFFF3F8FF),
                      borderRadius: BorderRadius.circular(20.5.w),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        RotationTransition(
                          turns: _refreshIconController,
                          child: Image.asset("assets/images/xiaolan_icon_refresh.png", width: 16.w),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          "换一换",
                          style: TextStyle(color: Color(0xFF333333), fontSize: 14.sp),
                        )
                      ],
                    ),
                  ),
                )),
            SizedBox(
              width: 8.w,
            ),
            Expanded(
                child: GestureDetector(
                  onTap: () {
                    onMoreTap?.call();
                  },
                  child: Container(
                    height: 39.h,
                    decoration: BoxDecoration(
                      color: Color(0xFFF3F8FF),
                      borderRadius: BorderRadius.circular(20.5.w),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/xiaolan_icon_more_list.png", width: 16.w),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          "查看更多",
                          style: TextStyle(color: Color(0xFF333333), fontSize: 14.sp),
                        )
                      ],
                    ),
                  ),
                )),
          ],
        )
      ],
    );
  }

  Widget _buildHead({required String name, String? subName = "", required Function onTap}) {
    return GestureDetector(
      onTap: () {
        onTap.call();
      },
      child:Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "${name}",
            style: TextStyle(color: Color(0xFF333333), fontSize: 20.sp, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 16.w,
          ),
          Text(
            "${subName}",
            style: TextStyle(color: Color(0xFF666666), fontSize: 12.sp, fontWeight: FontWeight.w400),
          ),
          Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "查看更多",
                style: TextStyle(color: Color(0xFF666666), fontSize: 12.sp, fontWeight: FontWeight.w400),
              ),
              SizedBox(
                width: 4.w,
              ),
              Image.asset(
                "assets/images/app_issue_arrow.png",
                color: Color(0xFF666666),
                width: 5.w,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.5.w),
      child: _buildTypeLayout(),
    );
  }
}

enum XiaoLanItemType {
  video,
  tag,
  category,
  user,
}

class XiaoLanItem {
  static Widget build(XiaoLanItemType type, dynamic item, {Function? onTap}) {
    switch (type) {
      case XiaoLanItemType.video:
        return GestureDetector(
            onTap: () {
              onTap?.call();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: .2),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                          child: MyImage.network("${item['cover_thumb_url']}", fit: BoxFit.cover, borderRadius: 8.r)),
                      // cover_thumb_url
                      Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                            ).copyWith(top: 2.5.h, bottom: 4.h),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black.withValues(alpha: .5),
                                  Colors.black.withValues(alpha: 0),
                                ],
                              ),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(8.r), bottomRight: Radius.circular(8.r)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      "assets/images/xiaolan_icon_play.png",
                                      width: 10.5.w,
                                    ),
                                    SizedBox(
                                      width: 4.5.w,
                                    ),
                                    Text(
                                      "${CommonUtils.formatNumber(item['rating'])}",
                                      style:
                                          TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.w400),
                                    )
                                  ],
                                ),
                                Text(
                                  "${item['duration_str']}",
                                  style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.w400),
                                )
                              ],
                            ),
                          ))
                    ],
                  ),
                )),
                SizedBox(
                  height: 6.5.h,
                ),
                Text(
                  "${item['title']}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: const Color(0xFF1A1A1A),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ));
      case XiaoLanItemType.tag:
        return GestureDetector(
          onTap: () {
            onTap?.call();
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: .5),
              borderRadius: BorderRadius.circular(7.5.r),
            ),
            child: Stack(
              children: [
                MyImage.network("${item['img_url_full']}", fit: BoxFit.cover, borderRadius: 7.5.r),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: .5),
                      borderRadius: BorderRadius.circular(7.5.r),
                    ),
                  ),
                ),
                Positioned.fill(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      "${item["name"]}",
                      style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 4.5.h,
                    ),
                    Text(
                      "${CommonUtils.formatNumber(item["works_num"] ?? 0)}",
                      style: TextStyle(color: Color(0xFFCBCBCB), fontSize: 10.sp, fontWeight: FontWeight.w400),
                    ),
                  ],
                ))
              ],
            ),
          ),
        );
      case XiaoLanItemType.category:
        return GestureDetector(
            onTap: () {
              onTap?.call();
            },
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: .5),
                    borderRadius: BorderRadius.circular(7.r),
                  ),
                  child: MyImage.network(item["bg_thumb"], fit: BoxFit.cover, borderRadius: 7.r),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(7.r),
                      bottomRight: Radius.circular(7.r),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 9.9,
                        sigmaY: 9.9,
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: Color(0x66555555), // 半透明叠加色（关键，不然模糊会很弱）
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "${item["title"]}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ));
      case XiaoLanItemType.user:
        return Container();
    }
  }
}
