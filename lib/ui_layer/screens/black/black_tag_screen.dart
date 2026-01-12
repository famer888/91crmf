import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/ui_layer/screens/black/widget/black_item_widget.dart';
import 'package:jycrpj/ui_layer/utils/common_utils.dart';
import 'package:provider/provider.dart';

import '../../../domain/model/banner_model.dart';
import '../../../domain/model/black_model.dart';
import '../../../domain/remote_domain/domains/black_domain.dart';
import '../../notifiers/user_notifier.dart';
import '../../utils/my_toast.dart';
import '../common_widgets/general_banner.dart';
import '../common_widgets/my_list_view.dart';
import '../theme.dart';

import '../../../report/ui_layer/report_general_banner.dart';

class BlackTagScreen extends StatefulWidget {
  final BlackModel blockModel;

  const BlackTagScreen({super.key, required this.blockModel});

  @override
  State<BlackTagScreen> createState() => _BlackTagScreenState();
}

class _BlackTagScreenState extends State<BlackTagScreen> {
  final ValueNotifier<List<BannerModel>> _bannersNotifier = ValueNotifier([]);
  late final userNotifier = context.read<UserNotifier>();
  late final _screenUtils = ScreenUtil();
  late final _blockDomain = context.read<BlackDomain>();
  bool isInit = false;

  Future<List<BlackListItemModel>?> _getData({int page = 1, int pageSize = 20}) async {
    final result = await _blockDomain.getBlackList(mid: widget.blockModel.mid, page: page, limit: pageSize);
    if (!isInit) {
      setState(() {
        isInit = true;
      });
    }
    if (result.status == 1) {
      final blackListContentModel = result.data;
      if (blackListContentModel != null) {
        final banners = blackListContentModel.banners;
        if (banners.isNotEmpty && _bannersNotifier.value.isEmpty) {
          // banner监听只赋一次值
          _bannersNotifier.value = banners;
        }
        final blackListItemModelList = blackListContentModel.list;
        if (blackListItemModelList.isNotEmpty) {
          return blackListItemModelList;
        }
      } else {
        CommonUtils.log('没有数据了...');
      }
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
    return null;
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  void dispose() {
    _bannersNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.list(
      key: UniqueKey(),
      header: _Header(bannersNotifier: _bannersNotifier),
      contentPadding: 15.w,
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
      itemBuilder: (context, item, index) => BlackItemWidget(item: item, itemWidth: (_screenUtils.screenWidth - MyTheme.pagePadding * 2)),
      onFetchingMore: (currentPage, pageSize) => _getData(page: currentPage, pageSize: pageSize),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.bannersNotifier});

  final ValueNotifier<List<BannerModel>> bannersNotifier;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ValueListenableBuilder(
          valueListenable: bannersNotifier,
          builder: (context, banners, child) {
            if (banners.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding, vertical: MyTheme.pagePadding),
              child: ReportGeneralAppsListVidget(
                data: banners,
                titleColor: MyTheme.whiteColor,
              ),
            );
          },
        ),
      ],
    );
  }
}
