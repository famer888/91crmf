import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../router/routes.dart';
import '../theme.dart';

import '../image_paths.dart';
//请自行按需添加
enum SearchAppBarType {
  normal,
  clsq,
  awqj,
  aw91,
  zpc,
}

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? backArrowOnTap;
  final bool showLeftBack;
  final bool showRightRank;
  final SearchAppBarType? type;

  const SearchAppBar({
    super.key,
    this.backArrowOnTap,
    this.showLeftBack = false,
    this.showRightRank = false,
    this.type = SearchAppBarType.normal,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding, vertical: 5.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (showLeftBack)
              GestureDetector(
                child: Image.asset(
                  MyImagePaths.appBackIcon,
                  width: 20.w,
                  height: 20.w,
                  color: type == SearchAppBarType.zpc ?const Color.fromRGBO(17, 16, 18, 1) : null,
                ),
                onTap: () {
                  if (backArrowOnTap != null) {
                    backArrowOnTap?.call();
                  } else {
                    context.pop();
                  }
                },
              ),
            SizedBox(width: 10.w),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  if (type == SearchAppBarType.zpc) {
                    const ZpcVideoSearchRoute('').push(context);
                  } else if (type == SearchAppBarType.awqj) {
                    const AwjqVideoSearchRoute(args: '').push(context);
                  } else if (type == SearchAppBarType.aw91) {
                    const Aw91VideoSearchRoute(args: '').push(context);
                  } else if (type == SearchAppBarType.clsq) {
                    const ClVideoSearchRoute('').push(context);
                  } else {
                    const SearchRoute().push(context);
                  }
                },
                child: Container(
                  height: 35.w,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17.5.w),
                      side: const BorderSide(color: Color.fromRGBO(45, 45, 45, 0.8), width: 0.5),
                    ),
                    color: type == SearchAppBarType.zpc ?const Color.fromRGBO(230, 228, 228, 1) : const Color.fromRGBO(31, 28, 29, 0.6),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 12.w),
                      Image.asset(MyImagePaths.appSearchIcon, width: 12.w, height: 12.w),
                      SizedBox(width: 2.w),
                      Container(
                        width: 1.w,
                        height: 16.w,
                        color: const Color.fromRGBO(255, 255, 255, 0.04),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          'stzdmmhbt'.tr(context: context),
                          style: MyTheme.gray172_14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            if (showRightRank)
              GestureDetector(
                onTap: () {
                  // const MineWelfareRoute(index: 1).push(context);

                  const RankRoute().push(context);
                },
                child: Image.asset(
                  MyImagePaths.appRankList,
                  // MyImagePaths.appSearchLogo,
                  width: 45.w,
                  fit: BoxFit.fitHeight,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  final Size preferredSize = const Size.fromHeight(60);
}
