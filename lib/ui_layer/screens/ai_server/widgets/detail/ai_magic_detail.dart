import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jycrpj/domain/async_value.dart';
import 'package:jycrpj/domain/model/ai/ai_magic_model.dart';
import 'package:jycrpj/domain/model/member_model.dart';
import 'package:jycrpj/domain/model/video_detail_model.dart';
import 'package:jycrpj/domain/remote_domain/domains/aimagic.dart';
import 'package:jycrpj/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jycrpj/ui_layer/notifiers/user_notifier.dart';
import 'package:jycrpj/ui_layer/router/routes.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/dialog/widgets/regular_dialog.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_app_bar.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/status/loading.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/status/network_error.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/video_player/shortv_mv_player.dart';
import 'package:jycrpj/ui_layer/screens/image_paths.dart';
import 'package:jycrpj/ui_layer/screens/theme.dart';
import 'package:jycrpj/ui_layer/utils/common_utils.dart';
import 'package:jycrpj/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';

class AIMagicDetail extends StatefulWidget {
  const AIMagicDetail({super.key, required this.data});
  final AIMagicModel data;

  @override
  State<AIMagicDetail> createState() => _AIMagicDetailState();
}

class _AIMagicDetailState extends State<AIMagicDetail> {
  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
        child: Scaffold(
      appBar: MyAppBar(
        title: widget.data.title,
      ),
      body: _Body(data: widget.data),
    ));
  }
}

class _Body extends StatefulWidget {
  const _Body({required this.data});
  final AIMagicModel data;

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> with WidgetsBindingObserver {
  late final _appDomain = context.read<AIMagicDomain>();
  late final homeConfig = context.read<HomeConfigNotifier>();
  late final userNotifier = context.read<UserNotifier>();
  late Member member = userNotifier.member;
  late int aiMagicCost = homeConfig.config.payAiMagic;
  int get freeNumber => userNotifier.member.aiMagicValue;
  int get coins => userNotifier.member.money;
  AsyncValue<dynamic> _asyncValue = const AsyncInit();

  // upList
  List<Map> upList = [];

  @override
  void initState() {
    _init();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeMetrics() {
    // Handle metrics change if needed
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _init() async {
    if (_asyncValue.isLoading) return;

    setState(() {
      _asyncValue = const AsyncLoading();
    });

    final videoJson = {
      'id': widget.data.id,
      'title': widget.data.title,
      'second_title': widget.data.title,
      'thumb_cover': widget.data.cover,
      'source_240': widget.data.video,
    };

    VideoData data = VideoData.fromJson(videoJson);

    _asyncValue = AsyncData(data);

    if (mounted) {
      setState(() {});
    }
  }
 
  Future<void> onSubmit() async {
    MyToast.showLoading(text: '正在提交...');
    final String thumb = upList[0]['media_url'].toString();
    final String thumbW = upList[0]['thumb_width'].toString();
    final String thumbH = upList[0]['thumb_height'].toString();
    final result = await _appDomain.aiMagicGenerate(
        materialId: widget.data.id.toString(),
        thumb: thumb,
        thumbW: thumbW,
        thumbH: thumbH);

    MyToast.closeAllLoading();
    if (result.status == 1) {
      CommonUtils.showDialog(
        context: context,
        builder: (context) => _buildSuccessDialog(),
      );
      final magicValue = freeNumber - 1;
      if (magicValue >= 0) {
        userNotifier.setMagicValue(num: magicValue);
      } else {
        userNotifier.setMoney(money: coins - aiMagicCost);
      }
    } else {
      MyToast.showText(text: result.msg ?? '生成失败');
    }
  }

  RegularDialog _buildSuccessDialog() {
    return RegularDialog(
      buttonText: 'gb'.tr(),
      title: 'zfcg'.tr(),
      content: Text('提交成功，稍后前往\n【AI记录】中查看',
          style: MyTheme.white255_15, textAlign: TextAlign.center),
      confirmOnTap: () async {
        clearUploadList();
        context.pop();
      },
    );
  }
  void clearUploadList() {
    upList.clear();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return _asyncValue.maybeWhen(
      data: (data) {
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                        padding: EdgeInsets.all(10.w),
                        width: double.infinity,
                        child: widget.data.video.isEmpty
                            ? widget.data.cover.isEmpty
                                ? const SizedBox()
                                : MyImage.network(widget.data.cover)
                            : AspectRatio(
                                aspectRatio: 1,
                                child:
                                    ShortvMvPlayer(info: data, noBack: true))),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.w),
                      child: AIImagePickerGrid(
                        upList: upList,
                        picLimit: 1,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 25.w),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            UploadMagicTip(
                              thumb: MyImagePaths.appAiMagicPic1,
                              title: "近身照",
                              icon: MyImagePaths.appAiMagicRight,
                            ),
                            UploadMagicTip(
                              thumb: MyImagePaths.appAiMagicPic2,
                              title: "上身有遮挡",
                              icon: MyImagePaths.appAiMagicError,
                            ),
                            UploadMagicTip(
                              thumb: MyImagePaths.appAiMagicPic3,
                              title: "不是正面",
                              icon: MyImagePaths.appAiMagicError,
                            ),
                            UploadMagicTip(
                              thumb: MyImagePaths.appAiMagicPic4,
                              title: "过于模糊",
                              icon: MyImagePaths.appAiMagicError,
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ),
            SubmitButton(
              upList: upList,
              onTap: () async {

                  onSubmit();
                }
            )
          ],
        );
      },
      error: (error, __) => NetworkErrorView(
        text: error is String? ? error : null,
        onTap: _init,
      ),
      orElse: () => const LoadingView(),
    );
  }
}

class UploadMagicTip extends StatelessWidget {
  const UploadMagicTip({
    super.key,
    required this.thumb,
    required this.title,
    required this.icon,
  });

  final String thumb;
  final String title;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          thumb,
          width: 85.w,
          fit: BoxFit.fitHeight,
        ),
        SizedBox(height: 5.w),
        Text(
          title,
          style: MyTheme.white14,
        ),
        SizedBox(height: 5.w),
        Center(
          child: Image.asset(
            icon,
            width: 15.w,
            fit: BoxFit.fitHeight,
          ),
        )
      ],
    );
  }
}

class SubmitButton extends StatefulWidget {
  const SubmitButton({super.key, this.onTap, required this.upList});
  final Function? onTap;
  final List<Map> upList;

  @override
  State<SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<SubmitButton> {
  late final homeConfig = context.read<HomeConfigNotifier>();

  void _handleTap(BuildContext context) {
    if (widget.upList.isEmpty) {
      CommonUtils.showDialog(
        context: context,
        builder: (context) => _buildAlertDialog(),
      );
      return;
    }

    final userNotifier = context.read<UserNotifier>();
    final member = userNotifier.member;
    final freeNumber = member.aiMagicValue;
    final coins = member.money;
    final aiMagicCost = homeConfig.config.payAiMagic;

    if (freeNumber > 0) {
      widget.onTap?.call();
    } else if (coins < aiMagicCost) {
     CommonUtils.showDialog(
      context: context,
      builder: (context) => _buildBalanceInsufficientDialog(coins: coins, aiMagicCost: aiMagicCost),
     );
    } else {
      widget.onTap?.call();
    }
  }
  RegularDialog _buildAlertDialog() {
    return RegularDialog(
      buttonText: 'qd'.tr(),
      title: 'wxts'.tr(),
      content: Text('qsctp'.tr(context: context),
          style: MyTheme.white255_15, textAlign: TextAlign.center),
    );
  }



  RegularDialog _buildBalanceInsufficientDialog({required int coins, required int aiMagicCost}) {
    return RegularDialog(
      buttonText: 'qwcz'.tr(),
      cancelText: 'qx'.tr(),
      title: 'gmjb'.tr(),
      content: Column(children: [
        Row(children: [
          Text('jbye'.tr() + ': $coins', style: MyTheme.white255_15),
          const Spacer(),
          GestureDetector(
              onTap: () {
                context.pop();
                const CoinRechargeRoute().push(context);
              },
              child: Text('ljcz'.tr(),
                  style: const TextStyle(
                      color: MyTheme.jellyCyanColor103224185,
                      decoration: TextDecoration.underline,
                      decorationColor: MyTheme.jellyCyanColor103224185))),
        ]),
        SizedBox(height: 10.w),
        Row(
          children: [
            Text('zfje'.tr(), style: MyTheme.white255_15),
            const Spacer(),
            RichText(
                text: TextSpan(children: [
              TextSpan(text: '$aiMagicCost', style: MyTheme.orange247_15),
              TextSpan(text: 'jb'.tr(), style: MyTheme.white255_15),
            ]))
          ],
        )
      ]),
      confirmOnTap: () {
        context.pop();
        const CoinRechargeRoute().push(context);
      },
      cancelOnTap: () {
        context.pop();
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    // 使用 context.watch 来监听 UserNotifier 的变化
    final userNotifier = context.watch<UserNotifier>();
    final member = userNotifier.member;
    final aiMagicCost = homeConfig.config.payAiMagic;
    final freeNumber = member.aiMagicValue;
    final coins = member.money;

    final String buttonText = freeNumber > 0
        ? '免费生成（剩余 $freeNumber 次）'
        : '需消耗 $aiMagicCost 金币【余额 $coins】生成';
    return GestureDetector(
      onTap: () => _handleTap(context),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.all(15.w),
        padding: EdgeInsets.symmetric(vertical: 12.w),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35.r),
            gradient: MyTheme.gradient_90_114),
        child: Text(buttonText, style: MyTheme.white16medium),
      ),
    );
  }
}

class AIImagePickerGrid extends StatefulWidget {
  const AIImagePickerGrid({
    super.key,
    required this.upList,
    required this.picLimit,
  });
  final List<Map> upList;
  final int picLimit;
  @override
  State<AIImagePickerGrid> createState() => _AIImagePickerGridState();
}

class _AIImagePickerGridState extends State<AIImagePickerGrid> {
  late final homeConfigNotifier = context.read<HomeConfigNotifier>();
  List<Map> get upList => widget.upList;
  int get picLimit => widget.picLimit;
   String uploadMaxSize = '2M';
  Future<void> imagePickerAssets() async {
    if (await CommonUtils.pickImage() case final xFile?) {
      final ext = xFile.name.split('.').last.toLowerCase();
      if (!['jpg', 'jpeg', 'png'].contains(ext)) {
        MyToast.showText(text: '只支持 jpg/jpeg/png 格式的图片');
        return;
      }
      MyToast.showLoading(text: 'scz'.tr());
      final result = await homeConfigNotifier.uploadImage(xFile);
      if (result != null && result['code'] == 1) {
        final url = "${result['msg']}";

        final image = await decodeImageFromList(await xFile.readAsBytes());

        upList.add({
          'media_url': url,
          'url': homeConfigNotifier.config.imgBase + url,
          'thumb_width': image.width,
          'thumb_height': image.height,
        });
        if (mounted) {
          setState(() {});
        }
      } else {
        MyToast.showText(text: result?['msg'] ?? 'failed');
      }
      MyToast.closeAllLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: upList.isEmpty ? imagePickerAssets : null, 
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 130.h, 
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(6.w)),
              color: MyTheme.brownColor38_21_13,
            ),
            child: upList.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      MyImage.asset(MyImagePaths.appPhotoUpload,width: 40.w,height: 40.w,),
                      Text('djscrwxx'.tr(context: context),
                          style: MyTheme.white13),
                      Text(
                          'tpdxbcg'.tr(context: context) +
                              uploadMaxSize,
                          style: TextStyle(
                              fontSize: 10.sp,
                              color: const Color(0xff9f9f9f))),
                    ],
                  )
                : Stack(
                    children: [
                      MyImage.network(
                        upList[0]['url'],
                        fit: BoxFit.fitHeight,
                        width: double.infinity,
                        height: double.infinity,
                        borderRadius: 6.w,
                        backgroundColor: MyTheme.imageBgColor,
                      ),
                      Positioned(
                        top: 8.w,
                        right: 8.w,
                        child: GestureDetector(
                          onTap: () {
                            widget.upList.removeAt(0);
                            if (mounted) {
                              setState(() {});
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(5.w),
                            decoration: const BoxDecoration(
                              color: Color(0xFF3094FF),
                              shape: BoxShape.circle, 
                            ),
                            child: Icon(
                              Icons.delete_forever,
                              size: 20.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
          ),
          IgnorePointer(
            child: CustomPaint(
              size: Size(double.infinity, 130.h),
              painter: DashedBorderPainter(
                borderRadius: 6.w,
                color: const Color(0xff9f9f9f),
                strokeWidth: 1.0,
                dashWidth: 5.0,
                dashSpace: 3.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


