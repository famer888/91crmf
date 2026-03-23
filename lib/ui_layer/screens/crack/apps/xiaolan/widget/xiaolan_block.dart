//类型枚举
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum XiaolanBlockType {
//  一行大 第二行滚动
  oneBigSecondScroll,
//   六宫格
  sixGrid,
//   一行滚动
  oneLineScroll,
//   四宫格
  fourGrid,
//   一行大+四宫格
  oneBigFourGrid,
//   创作达人
  creator,
//   用户横向滚动
  userScroll,
//   分类
  classify,
}

class XiaoLanBlock extends StatefulWidget {
  const XiaoLanBlock({super.key, required this.type});

  final XiaolanBlockType type;

  @override
  State<XiaoLanBlock> createState() => _XiaoLanBlockState();
}

class _XiaoLanBlockState extends State<XiaoLanBlock> {
  Widget _buildItem({required String label, double? spacing}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: .2),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: const Color(0xFFE5EAF3)),
          ),
          child: Stack(
            children: [
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
                      borderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(8.r), bottomRight: Radius.circular(8.r)),
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
                              "999",
                              style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                        Text(
                          "23:04",
                          style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  ))
            ],
          ),
        )),
        SizedBox(
          height: spacing ?? 6.5.h,
        ),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: const Color(0xFF1A1A1A),
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );
  }

  Widget _buildTypeLayout() {
    switch (widget.type) {
      case XiaolanBlockType.classify:
        return GridView.builder(
          itemCount: 6,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 7.h,
            crossAxisSpacing: 7.w,
            childAspectRatio: 225/224,
          ),
          itemBuilder: (context, index) => Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: .5),
              borderRadius: BorderRadius.circular(7.5.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "同城越爱",
                  style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 4.5.h,),
                Text(
                  "1222W",
                  style: TextStyle(color: Color(0xFFCBCBCB), fontSize: 10.sp, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        );
      case XiaolanBlockType.oneBigSecondScroll:
        return Column(
          children: [
            SizedBox(
              height: 218.h,
              child: _buildItem(
                label: "一行大图占位",
                spacing: 7.h,
              ),
            ),
            SizedBox(height: 14.5.h),
            SizedBox(
              height: 84.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => SizedBox(
                  width: 145.w,
                  height: 99.5.h,
                  child: _buildItem(
                    label: "横滑${index + 1}",
                    spacing: 4.h,
                  ),
                ),
                separatorBuilder: (context, index) => SizedBox(width: 8.w),
                itemCount: 6,
              ),
            ),
          ],
        );
      case XiaolanBlockType.sixGrid:
        return Column(
          children: [
            GridView.builder(
              itemCount: 6,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10.h,
                crossAxisSpacing: 8.w,
                childAspectRatio: 344 / 240,
              ),
              itemBuilder: (context, index) => _buildItem(label: "九宫格${index + 1}", spacing: 4.h),
            ),
            SizedBox(
              height: 14.h,
            ),
            _buildHandle()
          ],
        );
      case XiaolanBlockType.oneLineScroll:
        return SizedBox(
          height: 208.5.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => SizedBox(
                height: 208.5.h,
                width: 318.w,
                child: _buildItem(
                  label: "横滑${index + 1}",
                )),
            separatorBuilder: (context, index) => SizedBox(width: 8.w),
            itemCount: 8,
          ),
        );
      case XiaolanBlockType.fourGrid:
        return Column(
          children: [
            GridView.builder(
              itemCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10.h,
                crossAxisSpacing: 8.w,
                childAspectRatio: 344 / 240,
              ),
              itemBuilder: (context, index) => _buildItem(label: "四宫格${index + 1}"),
            ),
            SizedBox(
              height: 14.h,
            ),
            _buildHandle()
          ],
        );
      case XiaolanBlockType.oneBigFourGrid:
        return Column(
          children: [
            SizedBox(
              height: 218.h,
              child: _buildItem(
                label: "一行大图占位",
              ),
            ),
            SizedBox(height: 8.h),
            GridView.builder(
              itemCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8.h,
                crossAxisSpacing: 8.w,
                childAspectRatio: 1.6,
              ),
              itemBuilder: (context, index) => _buildItem(label: "四宫格${index + 1}"),
            ),
            SizedBox(
              height: 14.h,
            ),
            _buildHandle()
          ],
        );
      case XiaolanBlockType.creator:
        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "🏆 创作达人",
                  style: TextStyle(color: Color(0xFF333333), fontSize: 20.sp, fontWeight: FontWeight.w600),
                ),
                Spacer(),
                GestureDetector(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/app_issue_arrow.png",
                        color: Color(0xFF666666),
                        width: 5.w,
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 12.h,
            ),
            //   横向滚动
            SizedBox(
              height: 56.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => GestureDetector(
                  child: Column(
                    children: [
                      Container(
                        width: 38.w,
                        height: 38.h,
                        decoration: BoxDecoration(
                          color: Color(0xFFD9D9D9),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Spacer(),
                      Text(
                        "东方商厦",
                        style: TextStyle(color: Colors.black.withValues(alpha: .7), fontSize: 12.sp),
                      )
                    ],
                  ),
                ),
                separatorBuilder: (context, index) => SizedBox(width: 8.w),
                itemCount: 8,
              ),
            )
          ],
        );
      case XiaolanBlockType.userScroll:
        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 38.w,
                  height: 38.h,
                  decoration: BoxDecoration(
                    color: Color(0xFFD9D9D9),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(
                  width: 9.5.w,
                ),
                Text(
                  "东方商厦",
                  style: TextStyle(color: Color(0xFF333333), fontSize: 20.sp),
                ),
                Spacer(),
                GestureDetector(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/app_issue_arrow.png",
                        color: Color(0xFF666666),
                        width: 5.w,
                      ),
                    ],
                  ),
                )
              ],
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
                    child: _buildItem(
                      label: "横滑${index + 1}",
                    )),
                separatorBuilder: (context, index) => SizedBox(width: 8.w),
                itemCount: 8,
              ),
            )
          ],
        );
    }
  }

  Widget _buildHandle() {
    return Row(
      children: [
        Expanded(
            child: GestureDetector(
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
                Image.asset("assets/images/xiaolan_icon_refresh.png", width: 16.w),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.5.w),
      child: Column(
        children: [
          SizedBox(
            height: 15.h,
          ),
          if (widget.type != XiaolanBlockType.creator && widget.type != XiaolanBlockType.userScroll) ...[
            Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                    top: -11.w,
                    left: 0,
                    child: Opacity(
                      opacity: .1,
                      child: ShaderMask(
                        shaderCallback: (bounds) {
                          return const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFF103265),
                              Color(0x00103265),
                            ],
                          ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height));
                        },
                        child: Text(
                          "RECOM MEND",
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "板块名称",
                      style: TextStyle(color: Color(0xFF333333), fontSize: 20.sp, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: 16.w,
                    ),
                    Text(
                      "副文案说明",
                      style: TextStyle(color: Color(0xFF666666), fontSize: 12.sp, fontWeight: FontWeight.w400),
                    ),
                    Spacer(),
                    GestureDetector(
                      child: Row(
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
                    )
                  ],
                )
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
          ],
          _buildTypeLayout(),
        ],
      ),
    );
  }
}
