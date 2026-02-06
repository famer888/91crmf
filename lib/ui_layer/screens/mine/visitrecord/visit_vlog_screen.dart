import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/app_global.dart';
import 'package:jycrpj/domain/model/vlog_model.dart';
import 'package:jycrpj/ui_layer/router/routes.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/status/empty_data.dart';
import 'package:jycrpj/ui_layer/screens/crack/app_video_visit_util.dart';
import 'package:jycrpj/ui_layer/screens/vlog/card/vlog_card.dart';
import 'package:jycrpj/ui_layer/utils/common_utils.dart';

class VisitVlogScreen extends StatefulWidget {
  const VisitVlogScreen({super.key});

  @override
  State<VisitVlogScreen> createState() => _VisitVlogScreenState();
}

class _VisitVlogScreenState extends State<VisitVlogScreen> {
  final ValueNotifier<List<VlogModel>> _visitVlogModelsNotifier = ValueNotifier([]);

  void _getVisitVlogData() async {
    final List<VlogModel>? visitFeedModels = await AppVisitUtil.getVlogVisitRecord(context);
    if (visitFeedModels == null) {
      _visitVlogModelsNotifier.value = [];
    } else {
      if (visitFeedModels.isEmpty) {
        _visitVlogModelsNotifier.value = [];
      } else {
        _visitVlogModelsNotifier.value = visitFeedModels.reversed.toList();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (context.mounted) {
        _getVisitVlogData();
      }
    });
  }

  @override
  void dispose() {
    _visitVlogModelsNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _visitVlogModelsNotifier,
      builder: (context, visitVlogModels, child) {
        return Container(
          alignment: Alignment.topCenter,
          child: visitVlogModels.isEmpty
              ? PageEmptyDataView(text: 'mysj'.tr(context: context))
              : GridView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: 8.w),
                  itemCount: visitVlogModels.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8.w,
                    crossAxisSpacing: 8.w,
                    childAspectRatio: 170 / 245,
                  ),
                  itemBuilder: (context, index) {
                    final item = visitVlogModels[index];
                    return VlogCard(
                      maxLine: 1,
                      data: item,
                      onTapFunc: (type) {
                        if (type == 1) {
                          //点击短视频视频
                          AppGlobal.shortVideosInfo = {
                            'list': visitVlogModels,
                            'page': 1,
                            'index': index,
                            'api': 'vlog/list_tag',
                            'params': {
                              'limit': 15,
                            }
                          };
                          const VlogSecondRoute().push(context);
                        } else {
                          //广告类型
                          CommonUtils.openRoute(context, item.toJson());
                        }
                      },
                    );
                  },
                ),
        );
      },
    );
  }
}
