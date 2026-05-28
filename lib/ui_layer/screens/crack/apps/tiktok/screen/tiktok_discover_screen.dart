import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jycrpj/domain/type_def.dart';
import 'package:jycrpj/ui_layer/router/routes.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:provider/provider.dart';

import '../../../../../../domain/async_value.dart';
import '../../../../../../domain/domain.dart';
import '../../../../../../domain/model/feed/feed_model.dart';
import '../../../../../utils/my_toast.dart';
import '../../../../common_widgets/my_app_bar.dart';
import '../../../../common_widgets/screen_background.dart';
import '../../../../common_widgets/status/loading.dart';
import '../../../../common_widgets/status/network_error.dart';
import '../../../../theme.dart';
import '../../../widgets/scroll_top_button.dart';
import '../widget/tiktok_list_build.dart';

class TiktokDiscoverScreen extends StatefulWidget {
  const TiktokDiscoverScreen({super.key, required this.type, required this.nagId});

  final String type;
  final String nagId;

  @override
  State<TiktokDiscoverScreen> createState() => _TiktokDiscoverScreenState();
}

class _TiktokDiscoverScreenState extends State<TiktokDiscoverScreen> {
  late final _appDomain = context.read<AppDomain>();

  final ScrollController _nestedController = ScrollController();
  final ValueNotifier<bool> _showToTopBtn = ValueNotifier(false);

  @override
  void initState() {
    // _initTagList();
    super.initState();
  }

  @override
  void dispose() {
    _nestedController.dispose();
    _showToTopBtn.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    if (!_nestedController.hasClients) return;

    _showToTopBtn.value = false;
    _nestedController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  // sort hot/new
  Future<List> _getData({
    required int page,
    required int pageSize,
  }) async {
    bool isInit = false;

    final result = await _appDomain.getConstructByApiLink(
        apiLink:
            "${{"tag": "/api/tabnewxiaolan/list_tags", "category": "/api/tabnewxiaolan/construct_list"}[widget.type]}",
        params: {
          "nag_id": widget.nagId,
          "page": page,
          "limit": pageSize,
        });

    if (!isInit) {
      setState(() {
        isInit = true;
      });
    }

    if (result.status == 1) {
      return result.data['list'];
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      bgColor: Color(0xFF181A25),
      child: Stack(
        children: [
          Scaffold(
              backgroundColor: Colors.transparent,
              appBar: MyAppBar(
                  title: "发现精彩",
                  backIconColor: Color(0xFF151515),
                  titleColor: Color(0xFF151515),
                  backgroundColor: Colors.transparent),
              body: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification notification) {
                    if (!_nestedController.hasClients) return false;
                    final pos = _nestedController.position;
                    final viewportHeight = pos.viewportDimension * 0.4; // NestedScrollView可视高度
                    final offset = pos.pixels;

                    final overOnePage = offset >= viewportHeight;
                    _showToTopBtn.value = overOnePage;
                    return false;
                  },
                  child: MyListView.grid(
                    scrollController: _nestedController,
                    padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding, vertical: 8.w),
                    crossAxisCount: 3,
                    mainAxisSpacing: 7.h,
                    crossAxisSpacing: 7.w,
                    childAspectRatio: 225 / 224,
                    itemBuilder: (context, item, index) => TiktokItem.build(
                        widget.type == "tag" ? TiktokItemType.tag : TiktokItemType.category, item, onTap: () {
                      TiktokCategoryOrTagDetailRoute(
                              id: item['id'],
                              type: widget.type,
                              title: item['name'] ?? item['title'] ?? '',
                              has_sort: item['has_sort'] ?? '1')
                          .push(context);
                    }),
                    onFetchingMore: (currentPage, pageSize) {
                      final res = _getData(page: currentPage, pageSize: pageSize);
                      return res;
                    },
                  ))),
          Positioned(
            right: 20.w,
            bottom: 42.w,
            child: ScrollTopButton(
              showToTopButtonNotifier: _showToTopBtn,
              scrollTopCallback: _scrollToTop,
            ),
          ),
        ],
      ),
    );
  }
}
