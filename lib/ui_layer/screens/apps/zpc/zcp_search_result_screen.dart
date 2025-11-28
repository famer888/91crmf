import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/domain/type_def.dart';
import 'package:jycrpj/ui_layer/screens/apps/zpc/widget/zpc_feed_card.dart';
import 'package:jycrpj/ui_layer/screens/image_paths.dart';
import 'package:jycrpj/ui_layer/screens/theme.dart';
import 'package:provider/provider.dart';

import '../../../../domain/domain.dart';
import '../../../../domain/model/feed/feed_model.dart';
import '../../../utils/my_toast.dart';
import '../../common_widgets/my_list_view.dart';

class ZpcSearchResultScreen extends StatefulWidget {
  final String word;
  final int type;

  const ZpcSearchResultScreen({super.key, required this.word, required this.type});

  @override
  State<ZpcSearchResultScreen> createState() => _ZpcSearchResultScreenState();
}

class _ZpcSearchResultScreenState extends State<ZpcSearchResultScreen> {
  late final _appDomain = context.read<AppDomain>();

  Future<List<FeedModel>?> _getData({
    required int page,
    required int pageSize,
    required int type,
  }) async {
    final result = await _appDomain.getConstructByApiLink(
      apiLink: 'mvzpc/search',
      params: {'word': widget.word, 'type': widget.type, 'page': page, 'limit': pageSize},
    );

    if (result.status == 1) {
      final feedModelList = result.data?.map<FeedModel>((x) => FeedModel.fromJson(x)).toList();
      return feedModelList;
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Theme(
            data: Theme.of(context).copyWith(scaffoldBackgroundColor: Colors.white),
            child: Scaffold(
        appBar:AppBar(title: Text('ssjg'.tr(context: context),style: TextStyle(color: MyTheme.blackColor32, fontSize: 16.sp, fontWeight: FontWeight.w500)),leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon:  Image.asset(
                              MyImagePaths.appBackIcon,
                              width: 20.w,
                              height: 20.w,
                              color:const Color.fromRGBO(51, 51, 51, 1),
                            )),centerTitle: true  ),
        body: MyListView.grid(
          padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding, vertical: 8.w),
          childAspectRatio: ZpcFeedCard.aspectRatio,
          crossAxisSpacing: 8.w,
          itemBuilder: (context, item, index) => ZpcFeedCard(isList: false, feed: item),
          onFetchingMore: (currentPage, pageSize) => _getData(page: currentPage, pageSize: pageSize, type: widget.type),
        ),
      ),
    ),]),
    );
  }
}
