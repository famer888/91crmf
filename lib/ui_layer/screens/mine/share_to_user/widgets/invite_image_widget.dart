import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jycrpj/ui_layer/notifiers/user_notifier.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/gradient_text.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jycrpj/ui_layer/screens/image_paths.dart';
import 'package:jycrpj/ui_layer/screens/theme.dart';
import 'package:qr_flutter/qr_flutter.dart';

class InviteImageWidget extends StatelessWidget {
  final GlobalKey snapShotViewKey;
  final UserNotifier userNotifier;
  final HomeConfigNotifier homeConfigNotifier;

  const InviteImageWidget({super.key, required this.userNotifier, required this.homeConfigNotifier, required this.snapShotViewKey});

  @override
  Widget build(BuildContext context) {
    final screenUtil = ScreenUtil();
    return Container(
      alignment: Alignment.center,
      width: screenUtil.screenWidth,
      height: screenUtil.screenHeight,
      child: RepaintBoundary(
        key: snapShotViewKey,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: 24.w),
          decoration: BoxDecoration(
              image: const DecorationImage(image: AssetImage(MyImagePaths.appInviteCradBackground), fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(0)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 24.w),
              GradientText(
                '成功分享1位好友并下载',
                gradient: const LinearGradient(colors: MyTheme.gradient_90_114_colors),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20.sp,
                  overflow: TextOverflow.ellipsis,
                  decoration: TextDecoration.none,
                ),
              ),
              SizedBox(height: 15.w),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 38.w,
                    height: 1.w,
                    margin: EdgeInsets.only(top: 3.w, right: 8.w),
                    child: MyImage.asset(MyImagePaths.appLeftLine, width: 38.w, height: 1.w),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: '即可获得', style: MyTheme.white255_14.white.w400),
                        TextSpan(
                          text: '3天VIP',
                          style: TextStyle(color: MyTheme.color250_255_115, fontSize: 15.sp, fontWeight: FontWeight.w600),
                        ),
                        TextSpan(text: '奖励，可无限叠加', style: MyTheme.white255_14.white.w400),
                      ],
                    ),
                  ),
                  Container(
                    width: 38.w,
                    height: 1.w,
                    margin: EdgeInsets.only(top: 3.w, left: 8.w),
                    child: MyImage.asset(MyImagePaths.appRightLine, width: 38.w, height: 1.w),
                  ),
                ],
              ),
              SizedBox(height: 20.w),
              SizedBox(
                height: 398.w,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0.w,
                      right: 0.w,
                      top: 33.w,
                      child: SizedBox(
                        height: 365.w,
                        width: 297.w,
                        child: MyImage.asset(MyImagePaths.appInviteCardBg, height: 365.w, width: 297.w),
                      ),
                    ),
                    Positioned(
                      left: 0.w,
                      right: 0.w,
                      top: 80.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('91成人-免费破解版', style: MyTheme.white255_18.w600),
                          SizedBox(height: 10.w),
                          Text('全网优质视频合集', style: MyTheme.white255_14.w400.white25507),
                          SizedBox(height: 20.w),
                          SizedBox(
                            width: 192.w,
                            height: 170.w,
                            child: Stack(
                              children: [
                                SizedBox(
                                  width: 190.w,
                                  height: 178.w,
                                  child: MyImage.asset(
                                    MyImagePaths.appScanIcon,
                                    width: 192.w,
                                    height: 170.w,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    width: 135.w,
                                    height: 135.w,
                                    decoration: const BoxDecoration(color: MyTheme.whiteColor),
                                    child: QrImageView(data: '${userNotifier.member.share?.affUrl}', version: 3),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.w),
                            margin: EdgeInsets.only(top: 20.w),
                            decoration: BoxDecoration(gradient: MyTheme.gradient_90_135, borderRadius: BorderRadius.circular(5.w)),
                            child: RichText(
                              text: TextSpan(
                                  text: 'yqm'.tr(context: context),
                                  style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w500),
                                  children: <TextSpan>[
                                    const TextSpan(text: '  '),
                                    TextSpan(
                                      text: '${userNotifier.member.share?.affCode}',
                                      style: TextStyle(color: MyTheme.color250_255_115, fontSize: 14.sp, fontWeight: FontWeight.w400),
                                    )
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 0.w,
                      right: 0.w,
                      top: 0.w,
                      child: SizedBox(
                        width: 66.w,
                        height: 66.w,
                        child: MyImage.asset(MyImagePaths.appLogoIcon, width: 66.w, height: 66.w),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.w),
              Text(
                '${'gwdz'.tr(context: context)}: ${homeConfigNotifier.config.officeSite}',
                style: MyTheme.white255_14.s15.w500,
                textAlign: TextAlign.center,
                softWrap: true,
                maxLines: 2,
              ),
              SizedBox(height: 10.w),
              SizedBox(
                width: screenUtil.screenWidth - 66.w,
                child: Text(
                  'fxts'.tr(context: context),
                  style: MyTheme.white255_12.white25507.w400,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  maxLines: 2,
                ),
              ),
              SizedBox(height: 24.w),
            ],
          ),
        ),
      ),
    );
  }
}
