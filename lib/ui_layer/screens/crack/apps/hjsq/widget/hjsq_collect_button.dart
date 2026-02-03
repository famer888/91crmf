import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/domain/domain.dart';
import 'package:jycrpj/domain/type_def.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jycrpj/ui_layer/screens/crack/crack_app_type.dart';
import 'package:jycrpj/ui_layer/screens/image_paths.dart';
import 'package:jycrpj/ui_layer/screens/theme.dart';
import 'package:jycrpj/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';

import '../../../../../../report/ui_layer/report_gesture_detector.dart';

typedef CollectCallback = Function(bool isCollected);

class HjsqCollectButton extends StatefulWidget {
  final int id;
  final String apiUrl;
  final bool isCollected;
  final CollectCallback callback;

  const HjsqCollectButton({super.key, required this.apiUrl, required this.isCollected, required this.id, required this.callback});

  @override
  State<HjsqCollectButton> createState() => _HjsqCollectButtonState();
}

class _HjsqCollectButtonState extends State<HjsqCollectButton> {
  late final _appDomain = context.read<AppDomain>();

  bool _isCollected = false;

  void onChangeCollected() {
    setState(() {
      _isCollected = !_isCollected;
    });
    widget.callback.call(_isCollected);
  }

  @override
  void initState() {
    _isCollected = widget.isCollected;
    super.initState();
  }

  // 'type'      => 'required|integer',  24 表示  草榴, 25 表示 91 暗网 ,26 表示 暗网禁区  27表示  91 制片厂
  Future<void> onCollect() async {
    final result = await _appDomain.getConstructByApiLink(
      apiLink: widget.apiUrl,
      params: {'type': '24'/*'${CrackAppType.hjsq.type}'*/, 'relatedId': widget.id},
    );
    if (result.status == 1) {
      onChangeCollected();
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ReportGestureDetector(
      onTap: () async {
        await onCollect();
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 20.w,
            height: 20.w,
            child: _isCollected
                ? MyImage.asset(MyImagePaths.appCollectRedOn, width: 20.w, height: 20.w, color: MyTheme.hjsqAppPrimaryColor)
                : MyImage.asset(MyImagePaths.appCollectOff, width: 20.w, height: 20.w),
          ),
          SizedBox(width: 5.w),
          Text('sc'.tr(context: context), style: MyTheme.white255_13.white25508)
        ],
      ),
    );
  }
}
