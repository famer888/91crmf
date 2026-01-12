import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_avatar.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../notifiers/home_config_notifier.dart';
import '../../../../notifiers/user_notifier.dart';
import '../../../../utils/common_utils.dart';
import '../../../../utils/my_toast.dart';
import '../../../common_widgets/my_image.dart';
import '../../../image_paths.dart';
import '../../../theme.dart';

import '../../../../../report/ui_layer/report_gesture_detector.dart';

class InviteQrDialog extends StatefulWidget {
  final VoidCallback cancel;
  final UserNotifier userNotifier;
  final HomeConfigNotifier homeConfigNotifier;
  final VoidCallback onSnap;

  const InviteQrDialog({super.key, required this.cancel, required this.userNotifier, required this.homeConfigNotifier, required this.onSnap});

  @override
  State<InviteQrDialog> createState() => _InviteQrDialogState();
}

class _InviteQrDialogState extends State<InviteQrDialog> {

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black45,
      child: ReportGestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 35.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 428.w,
                  width: 305.w,
                  padding: EdgeInsets.only(left: 0.w, top: 20.w, right: 0.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8.w)),
                    image: const DecorationImage(image: AssetImage(MyImagePaths.appMineJellyShareQrBg), fit: BoxFit.cover),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 66.w,
                        width: 305.w,
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            MyAvatar(
                              margin: 1,
                              size: 60.w,
                              thumb: widget.userNotifier.member.thumb,
                              gradient: const LinearGradient(colors: [Colors.white, Colors.white]),
                            ),
                            SizedBox(width: 10.w),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('cr'.tr(context: context), style: MyTheme.white255_13.s18.w600),
                                SizedBox(height: 10.w),
                                Text('kpzq'.tr(context: context), style: MyTheme.white255_14.w500.white25506),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 38.w),
                      ColoredBox(
                        color: Colors.white,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(5.w)),
                          child: QrImageView(
                              data: '${widget.userNotifier.member.share?.affUrl}',
                              version: 3,
                              size: 135.w,
                              padding: const EdgeInsets.all(8)),
                        ),
                      ),
                      SizedBox(height: 12.w),
                      Text('smgk'.tr(context: context), style: MyTheme.white255_12.w400),
                      SizedBox(height: 12.w),
                      Container(
                        width: 110.w,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 4.0.w, horizontal: 8.0.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.w)),
                          gradient: const LinearGradient(colors: MyTheme.gradient_90_135_colors),
                        ),
                        child: Text(
                          '${'yqm'.tr(context: context)} ${widget.userNotifier.member.share?.affCode}',
                          style: MyTheme.white255_12.w400,
                        ),
                      ),
                      SizedBox(height: 12.w),
                      Text(
                        '${'gwdz'.tr(context: context)}: ${widget.homeConfigNotifier.config.officeSite}',
                        style: MyTheme.white255_12.w400,
                        textAlign: TextAlign.center,
                        softWrap: true,
                        maxLines: 2,
                      ),
                      SizedBox(height: 15.w),
                      Row(
                        children: [
                          SizedBox(width: 22.5.w),
                          ReportGestureDetector(
                            onTap: () {
                              if (widget.userNotifier.member.share?.affUrlCopy != null &&
                                  widget.userNotifier.member.share?.affUrlCopy?.url?.isNotEmpty == true) {
                                _copyLinkShare();
                              }
                            },
                            child: Container(
                              height: 35.w,
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(horizontal: 32.w),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(colors: MyTheme.gradient_90_135_colors),
                                borderRadius: BorderRadius.circular(20.w),
                              ),
                              child: Text('fzlj'.tr(context: context), style: MyTheme.white255_14.w500),
                            ),
                          ),
                          SizedBox(width: 20.w),
                          ReportGestureDetector(
                            onTap: widget.onSnap,
                            child: Container(
                              height: 35.w,
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(horizontal: 32.w),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(colors: MyTheme.gradient_90_114_colors),
                                borderRadius: BorderRadius.circular(20.w),
                              ),
                              child: Text('bctp'.tr(context: context), style: MyTheme.white255_14.w500),
                            ),
                          ),
                          SizedBox(width: 22.5.w),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.w),
                Container(
                  height: 115.w,
                  width: 305.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8.w)),
                    image: const DecorationImage(image: AssetImage(MyImagePaths.appMineJellyShareBottomBg), fit: BoxFit.cover),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('yqbz'.tr(context: context), style: MyTheme.white255_14.w500),
                      SizedBox(height: 10.w),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                SizedBox(width: 46.w, height: 46.w, child: const MyImage.asset(MyImagePaths.appInvite1)),
                                SizedBox(height: 7.w),
                                Text('', style: MyTheme.white255_12.white25506.w400),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                SizedBox(width: 46.w, height: 46.w, child: const MyImage.asset(MyImagePaths.appInvite2)),
                                SizedBox(height: 7.w),
                                Text('yqhybd'.tr(context: context), style: MyTheme.white255_12.white25506.w400),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                SizedBox(width: 46.w, height: 46.w, child: const MyImage.asset(MyImagePaths.appInvite3)),
                                SizedBox(height: 7.w),
                                Text('yqhybd'.tr(context: context), style: MyTheme.white255_12.white25506.w400),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20.w),
                ReportGestureDetector(
                  onTap: () => widget.cancel.call(),
                  child: SizedBox(child: MyImage.asset(MyImagePaths.appCancelWithCircle, fit: BoxFit.cover, width: 33.w, height: 33.w)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 复制链接分享
  Future<void> _copyLinkShare() async {
    CommonUtils.copyToClipboard(text: '${widget.userNotifier.member.share?.affUrlCopy?.url}');
    MyToast.showText(text: 'fzcg'.tr());
  }

}

class _SnapShotView extends StatelessWidget {
  const _SnapShotView({this.affUrl, this.affCode, this.officeSite});

  final String? affUrl;
  final String? affCode;
  final String? officeSite;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: MyTheme.bgColor),
        Positioned(
          left: MyTheme.pagePadding,
          right: MyTheme.pagePadding,
          child: Column(
            children: [
              SizedBox(height: 30.w),
              SizedBox(
                height: 467.w,
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 0,
                      child: Container(
                        height: 428.w,
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.w)),
                        child: Column(
                          children: [
                            SizedBox(height: 90.w),
                            SizedBox(
                              height: 45.w,
                              child: Center(
                                child: Text('Hey bro，我在${'yybt'.tr(context: context)}，来免费看原创乱伦视频', style: MyTheme.black13.s10),
                              ),
                            ),
                            SizedBox(
                              width: 198.w,
                              height: 198.w,
                              child: Stack(
                                children: [
                                  const Positioned.fill(
                                    child: MyImage.asset(MyImagePaths.appMineShareQrcodeBg),
                                  ),
                                  Center(
                                    child: SizedBox(
                                      width: 154.w,
                                      height: 154.w,
                                      child: QrImageView(
                                        data: '$affUrl',
                                        version: 3,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 26.5.w),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(22.5.w),
                              child: Container(
                                width: 185.w,
                                height: 45.w,
                                decoration: const BoxDecoration(gradient: MyTheme.shareButtonGradient),
                                child: Center(
                                  child: RichText(
                                    text: TextSpan(
                                        text: '${'tgm'.tr(context: context)}:',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        children: <TextSpan>[
                                          const TextSpan(text: '  '),
                                          TextSpan(
                                            text: '$affCode',
                                            style: TextStyle(color: Colors.white, fontSize: 17.sp, fontWeight: FontWeight.w600),
                                          )
                                        ]),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: MyImage.asset(
                        MyImagePaths.appLogo,
                        width: 80.w,
                        height: 80.w,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.w),
              Text(
                '${'gwdz'.tr(context: context)}：$officeSite',
                style: TextStyle(color: Colors.white, decoration: TextDecoration.none, fontSize: 19.sp, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 11.w),
              Text(
                'qwsy'.tr(context: context),
                style: TextStyle(
                  color: Colors.white,
                  decoration: TextDecoration.none,
                  height: 1.4,
                  fontWeight: FontWeight.normal,
                  fontSize: 13.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
