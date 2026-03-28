import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/domain/async_value.dart';
import 'package:jycrpj/domain/model/crack_model.dart';
import 'package:jycrpj/domain/model/home_data_model.dart';
import 'package:jycrpj/domain/model/link_model.dart';
import 'package:jycrpj/domain/remote_domain/domains/dynamic.dart';
import 'package:jycrpj/domain/type_def.dart';
import 'package:jycrpj/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jycrpj/ui_layer/router/routes.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/keep_alive_wrapper.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_tab_bar.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/status/loading.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/status/network_error.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/clsq/widget/cl_api_link_view.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/xiaolan/widget/xiaolan_api_link_view.dart';
import 'package:jycrpj/ui_layer/screens/crack/crack_app_type.dart';
import 'package:jycrpj/ui_layer/screens/crack/widgets/lock_mask.dart';
import 'package:jycrpj/ui_layer/screens/crack/unlock_status_notifier.dart';
import 'package:jycrpj/ui_layer/screens/theme.dart';
import 'package:jycrpj/ui_layer/screens/webview/screen.dart';
import 'package:provider/provider.dart';

import '../../../../../../domain/model/banner_model.dart';
import 'xiaolan_ads_header.dart';

class XiaolanCreatorSubView extends StatefulWidget {
  const XiaolanCreatorSubView({
    super.key,
    required this.type,
    required this.filter,
    required this.bannersNotifier,
  });

  final ValueNotifier<List<BannerModel>> bannersNotifier;
  final dynamic type;
  final dynamic filter;

  @override
  State<XiaolanCreatorSubView> createState() => _XiaolanCreatorSubViewState();
}

class _XiaolanCreatorSubViewState extends State<XiaolanCreatorSubView> with TickerProviderStateMixin {
  late final _appDomain = context.read<DynamicDomain>();
  AsyncValue<List> _asyncValue = const AsyncInit();

  @override
  void initState() {
    _init();
    super.initState();
  }

  Future<void> _init() async {
    if (_asyncValue.isLoading) return;

    setState(() {
      _asyncValue = const AsyncLoading();
    });

    final result = await _appDomain
        .getConstructByApiLink(apiLink: widget.type['api'], params: {'type': widget.type['param'] ?? ""});

    if (result.status == 1) {
      List data = result.data as List;
      if (data.isEmpty) data = [{}, {}, {}];
      _asyncValue = AsyncData(data);
    } else {
      _asyncValue = const AsyncError();
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _asyncValue.maybeWhen(
        data: (data) {
          if (data.isEmpty)
            return Center(
              child: Text(
                "暂无数据",
                style: TextStyle(color: Colors.white, fontSize: 15.sp),
              ),
            );
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 12.5.w),
            child: Column(
              children: [
                SizedBox(
                  height: 25.w,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(child: _buildTop3Item(data.length > 1 ? data[1] : {}, 1)),
                    SizedBox(
                      width: 4.w,
                    ),
                    Expanded(child: _buildTop3Item(data.length > 0 ? data[0] : {}, 0)),
                    SizedBox(
                      width: 4.w,
                    ),
                    Expanded(child: _buildTop3Item(data.length > 2 ? data[2] : {}, 2)),
                  ],
                ),
                SizedBox(
                  height: 19.w,
                ),
                if (data.length > 3)
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, _index) {
                      int index = _index + 4;
                      String no = "${index}";
                      // 判断index在data中是否存在
                      return Row(
                        children: [
                          Text(
                            "${no.length < 2 ? "0" : ""}${no}",
                            style: TextStyle(color: Colors.white, fontSize: 15.sp),
                          ),
                          SizedBox(
                            width: 16.w,
                          ),
                          Expanded(child: _buildUser(data[3 + _index], vertical: false))
                        ],
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(
                      height: 20.w,
                    ),
                    itemCount: data.length - 3,
                  ),
                SizedBox(
                  height: 12.5.w,
                )
              ],
            ),
          );
        },
        error: (_, __) => NetworkErrorView(onTap: _init),
        orElse: () => const LoadingView(),
      ),
    );
  }

  Widget _buildTop3Item(dynamic item, int index) {
    return Column(
      children: [
        _buildUser(
          item,
          vertical: true,
        ),
        SizedBox(
          height: 22.5.h,
        ),
        Image.asset(
          "assets/images/xiaolan_no${index + 1}.png",
          width: double.infinity,
        ),
      ],
    );
  }

  Widget _buildUser(dynamic user, {bool vertical = true}) {
    double avatarSize = vertical ? 65.w : 44.w;
    List<Widget> widgets = [
      Container(
        width: avatarSize,
        height: avatarSize,
        decoration: BoxDecoration(shape: BoxShape.circle),
        child: MyImage.network(
          user["thumb"] ?? "",
          width: avatarSize,
          height: avatarSize,
          fit: BoxFit.cover,
          borderRadius: avatarSize / 2,
          backgroundColor: Colors.grey,
        ),
      ),
      SizedBox(
        width: 6.w,
        height: 3.5.w,
      ),
      Column(
        children: [
          Text(
            "${user["nickname"] ?? "测试数据"}",
            style: TextStyle(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.w400),
          ),
          Text(
            "作品数：342",
            style: TextStyle(color: Color(0x66E4E4E4), fontSize: 12.sp, fontWeight: FontWeight.w400),
          ),
        ],
      )
    ];
    Widget content;
    if (vertical == true) {
      content = Column(
        children: widgets,
      );
    } else {
      content = Row(
        children: widgets,
      );
    }
    return GestureDetector(
      onTap: () {
        XiaolanUserWorksRoute(id: user["id"] ?? "", userName: user["nickname"] ?? "").push(context);
      },
      child: content,
    );
  }
}
