import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jycrpj/ui_layer/screens/apps/zpc/widget/zpc_top_navi_view.dart';

import '../../image_paths.dart';
import '../../../router/routes.dart';
import '../../theme.dart';

class ZpcCommunityScreen extends StatefulWidget {
  final int id;
  const ZpcCommunityScreen({super.key, required this.id});

  @override
  State<ZpcCommunityScreen> createState() => _ZpcCommunityScreenState();
}

class _ZpcCommunityScreenState extends State<ZpcCommunityScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Theme(
                data: Theme.of(context).copyWith(scaffoldBackgroundColor: Colors.white),
                child: Scaffold(
                  appBar: _buildSearchAppbarseaSearchAppBar(),
                  body: ZpcTopNaviView(id: widget.id),
                ),
              ),
            ],
          ),
        ),
        // const _BlurView(),
      ],
    );
  }

  PreferredSizeWidget _buildSearchAppbarseaSearchAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: SafeArea(
        bottom: false,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding, vertical: 5.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                child: Image.asset(
                  MyImagePaths.appBackIcon,
                  width: 20.w,
                  height: 20.w,
                  color: const Color.fromRGBO(17, 16, 18, 1),
                ),
                onTap: () {
                  context.pop();
                },
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: GestureDetector(
                  onTap: _handleZpcSearchTap,
                  child: Container(
                    height: 35.w,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17.5.w),
                        side: const BorderSide(color: Color.fromRGBO(45, 45, 45, 0.8), width: 0.5),
                      ),
                      color: const Color.fromRGBO(230, 228, 228, 1),
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
            ],
          ),
        ),
      ),
    );
  }

  void _handleZpcSearchTap() {
    const ZpcVideoSearchRoute('').push(context);
  }
}