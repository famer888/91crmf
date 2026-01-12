import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/domain/async_value.dart';
import 'package:jycrpj/domain/domain.dart';
import 'package:jycrpj/domain/model/feed/feed_model.dart';
import 'package:jycrpj/domain/type_def.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_app_bar.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/status/loading.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/status/network_error.dart';
import 'package:jycrpj/ui_layer/screens/crack/apps/awjq/widget/awjq_feed_card.dart';
import 'package:jycrpj/ui_layer/screens/theme.dart';
import 'package:jycrpj/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';

class AwjqTagScreen extends StatefulWidget {
  final String videoTag;

  const AwjqTagScreen({super.key, required this.videoTag});

  @override
  State<AwjqTagScreen> createState() => _AwjqTagScreenState();
}

class _AwjqTagScreenState extends State<AwjqTagScreen> {
  AsyncValue<List<FeedModel>> _asyncValue = const AsyncInit();
  late final _appDomain = context.read<AppDomain>();

  @override
  void initState() {
    _initTagList();
    super.initState();
  }

  // sort hot/new
  Future<void> _initTagList() async {
    if (_asyncValue.isLoading) return;
    setState(() {
      _asyncValue = const AsyncLoading();
    });

    final result = await _appDomain.getConstructByApiLink(apiLink: 'mvawjq/list_tag_mvs', params: {'tag': widget.videoTag, 'sort': 'hot'});
    if (result.status == 1) {
      if (result.data case final list when list.isNotEmpty) {
        final feedModelList = list?.map<FeedModel>((x) => FeedModel.fromJson(x)).toList();
        _asyncValue = AsyncData(feedModelList);
      }
    } else {
      MyToast.showText(text: result.msg ?? '');
      _asyncValue = const AsyncError();
    }

    if (mounted) {
      setState(() {});
    }

  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(16, 16, 16, 1),
        appBar: MyAppBar(title: widget.videoTag, backgroundColor: const Color.fromRGBO(16, 16, 16, 1)),
        body: _asyncValue.maybeWhen(
            orElse: () => const LoadingView(),
            error: (_, __) => NetworkErrorView(onTap: _initTagList),
            data: (data) {
              return Padding(
                padding: EdgeInsets.only(left: MyTheme.pagePadding, top: MyTheme.pagePadding, right: MyTheme.pagePadding),
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: data.length,
                  physics: const AlwaysScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.w,
                    mainAxisSpacing: 10.w,
                    childAspectRatio: MyTheme.aspectRatio,
                  ),
                  itemBuilder: (context, index) {
                    final item = data[index];
                    return AwjqFeedCard(isList: false, feed: item);
                  },
                ),
              );
            }
        ),
      ),
    );
  }
}
