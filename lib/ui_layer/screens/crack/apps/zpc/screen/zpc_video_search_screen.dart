import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jycrpj/data_layer/repo/repo.dart';
import 'package:jycrpj/domain/api_validator.dart';
import 'package:jycrpj/domain/model/search_model.dart';
import 'package:jycrpj/domain/remote_domain/domains/search.dart';
import 'package:jycrpj/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jycrpj/ui_layer/router/routes.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/status/empty_data.dart';
import 'package:jycrpj/ui_layer/screens/image_paths.dart';
import 'package:jycrpj/ui_layer/screens/theme.dart';
import 'package:jycrpj/ui_layer/utils/common_utils.dart';
import 'package:jycrpj/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';

import '../../../../../../report/ui_layer/report_gesture_detector.dart';

class ZpcVideoSearchScreen extends StatefulWidget {
  final String args;

  const ZpcVideoSearchScreen({super.key, required this.args});

  @override
  State<ZpcVideoSearchScreen> createState() => _ZpcVideoSearchScreenState();
}

class _ZpcVideoSearchScreenState extends State<ZpcVideoSearchScreen> {
  final searchTextEditController = TextEditingController();
  late final _homeConfigNotifier = context.read<HomeConfigNotifier>();

  void onSubmitted(String keyword) {
    if (keyword.trim().isEmpty) {
      MyToast.showText(text: 'qsrgjz'.tr());
      return;
    }
    final searchHistory = _homeConfigNotifier.getSearchHistory(key: zpcSearchHistoryKey);

    final title = keyword.replaceAll('/', '|');
    if (!searchHistory.contains(keyword)) {
      _homeConfigNotifier.upsertSearchHistory(key: zpcSearchHistoryKey, searchHistory: searchHistory..add(keyword));
    }
    ZpcSearchResultRoute(word: title, type: 1).push(context);
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
        appBar: _SearchBar(
          textEditingController: searchTextEditController,
          onSubmitted: onSubmitted,
        ),
        body: ListView(
          padding: EdgeInsets.only(left: MyTheme.pagePadding, right: MyTheme.pagePadding, bottom: 50.w),
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15.w),
              child: Row(
                children: [
                  Text('ssjl'.tr(context: context), style: TextStyle(color: MyTheme.blackColor32, fontSize: 16.sp, fontWeight: FontWeight.w500)),
                  const Spacer(),
                  ReportGestureDetector(
                    onTap: () {
                      _homeConfigNotifier.clearSearchHistory(key: zpcSearchHistoryKey);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(tr('qcssjl'), style: TextStyle(color: MyTheme.blackColor32, fontSize: 12.sp, fontWeight: FontWeight.w400)),
                        SizedBox(width: 5.w),
                        SizedBox(
                          width: 16.w,
                          height: 16.w,
                          child: MyImage.asset(
                            MyImagePaths.appClearSearch,
                            width: 16.w,
                            height: 16.w,
                            color: MyTheme.zpcAppPrimaryColor,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Selector<HomeConfigNotifier, List<String>>(
                selector: (_, config) => config.getSearchHistory(key: zpcSearchHistoryKey),
                builder: (context, searchHistory, child) => searchHistory.isNotEmpty
                    ? Wrap(
                  spacing: 10.w,
                  runSpacing: 10.w,
                  children: [
                    for (final text in searchHistory)
                      _KeywordTile(
                        text: text,
                        onTap: () {
                          searchTextEditController.text = text;
                          onSubmitted(text);
                        },
                        onDelete: () {
                          final history = _homeConfigNotifier.getSearchHistory(key: zpcSearchHistoryKey);
                          _homeConfigNotifier.upsertSearchHistory(key: zpcSearchHistoryKey, searchHistory: history..remove(text));
                        },
                      )
                  ],
                )
                    : PageEmptyDataView(text: 'myss'.tr(context: context)),
              ),
            ),
            _SearchContentView(
              onSubmitted: (text) {
                searchTextEditController.text = text;
                onSubmitted(text);
              },
            )
          ],
        ),
      ),
    ),]),
    );
  }
}

class _SearchBar extends StatefulWidget implements PreferredSizeWidget {
  const _SearchBar({
    required this.textEditingController,
    required this.onSubmitted,
  });

  final TextEditingController textEditingController;
  final ValueChanged<String> onSubmitted;

  @override
  State<_SearchBar> createState() => _SearchBarState();

  @override
  final preferredSize = const Size.fromHeight(44);
}

class _SearchBarState extends State<_SearchBar> {
  TextEditingController get textEditingController => widget.textEditingController;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: MyTheme.navbarHegiht,
        padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
        child: Row(
          children: [
            ReportGestureDetector(
              child: Image.asset(
                              MyImagePaths.appBackIcon,
                              width: 20.w,
                              height: 20.w,
                              color:const Color.fromRGBO(51, 51, 51, 1),
                            ),
              onTap: () => context.pop(),
            ),
            Expanded(
              child: Container(
                height: 36.w,
                margin: EdgeInsets.symmetric(horizontal: 8.w),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.w)),
                  color: const Color.fromRGBO(230, 228, 228, 1),
                ),
                alignment: Alignment.center,
                child: _SearchTextField(textEditingController: textEditingController, onSubmitted: widget.onSubmitted),
              ),
            ),
            SizedBox(width: 5.w),
            ReportGestureDetector(
              onTap: () {
                widget.onSubmitted.call(textEditingController.text);
              },
              child: Text('ss'.tr(context: context), style: TextStyle(color: MyTheme.blackColor32, fontSize: 14.sp, fontWeight: FontWeight.w400)),
            ),
          ],
        ),
      ),
    );
  }
}

class _KeywordTile extends StatelessWidget {
  const _KeywordTile({
    required this.text,
    required this.onTap,
    required this.onDelete,
  });

  final String text;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28.w,
      decoration: BoxDecoration(color: const Color.fromRGBO(186, 186, 186, 1), borderRadius: BorderRadius.circular(3.w)),
      padding: EdgeInsets.fromLTRB(12.w, 4.w, 12.w, 5.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ReportGestureDetector(
            onTap: onTap,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100.w),
              child: Text(text, style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w400), maxLines: 1),
            ),
          ),
          // Container(color: const Color(0xffffffff), height: 13.w, width: 1.w, margin: EdgeInsets.symmetric(horizontal: 10.w)),
          // ReportGestureDetector(
          //   behavior: HitTestBehavior.translucent,
          //   onTap: onDelete,
          //   child: MyImage.asset(MyImagePaths.appRecordDeleteIcon, width: 10.w, height: 10.w, fit: BoxFit.fitWidth),
          // )
        ],
      ),
    );
  }
}

class _SearchTextField extends StatelessWidget {
  const _SearchTextField({
    required this.textEditingController,
    required this.onSubmitted,
  });

  final TextEditingController textEditingController;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      cursorColor: const Color.fromRGBO(23, 21, 24, 1),
      onSubmitted: onSubmitted,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'pmnyfh'.tr(context: context),
        hintStyle: MyTheme.gray8f8e90_13,
        contentPadding: EdgeInsets.zero,
        prefixIcon: Row(
          children: [
            SizedBox(width: 12.w),
            MyImage.asset(MyImagePaths.appSearchIcon, width: 12.w, height: 12.w),
            SizedBox(width: 2.w),
          ],
        ),
        prefixIconConstraints: BoxConstraints(maxHeight: 35.w, maxWidth: 35.w),
      ),
      style: TextStyle(color: const Color.fromRGBO(23, 21, 24, 1), fontSize: 13.sp),
    );
  }
}

class _SearchContentView extends StatefulWidget {
  const _SearchContentView({
    required this.onSubmitted,
  });

  final ValueChanged<String> onSubmitted;

  @override
  State<_SearchContentView> createState() => _SearchContentViewState();
}

class _SearchContentViewState extends State<_SearchContentView> {
  late final searchDomain = context.read<SearchDomain>();
  SearchModel? _data;

  @override
  void initState() {
    _initData();
    super.initState();
  }

  Future _initData() async {
    final res = await searchDomain.searchHotList();
    if (res.isValid && mounted) {
      setState(() {
        _data = res.data;
      });
    } else if (res.msg case final msg?) {
      MyToast.showText(text: msg);
    }
  }

  /// 热搜文字颜色
  final Map<int, int> colorMap = {
    0: 0xFFFF4242,
    1: 0xFFFFAD42,
    2: 0xFF7E42FF,
  };

  @override
  Widget build(BuildContext context) {
    if (_data == null) return const SizedBox.shrink();
    // final banner = _data!.banner;
    final hotTags = _data!.top.all;

    return Column(
      children: [
        SizedBox(height: 16.w),
        // banner.isNotEmpty
        //     ? ReportGeneralAppsListVidget(
        //         aspectRatio: 7 / 2,
        //         data: banner,
        //         radius: 5.0,
        //       )
        //     : const SizedBox.shrink(),
        hotTags.isNotEmpty
            ? Column(
          children: [
            SizedBox(height: 30.w),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 4.w),
                Text('rmtj'.tr(context: context), style: TextStyle(color: MyTheme.blackColor32, fontSize: 16.sp, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
                const Spacer(),
              ],
            ),
            ListView.builder(
                shrinkWrap: true,
                addRepaintBoundaries: false,
                addAutomaticKeepAlives: false,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => ReportGestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    widget.onSubmitted(hotTags[index].work);
                  },
                  child: SizedBox(
                    height: 35.w,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: 5.w),
                        SizedBox(
                          height: ScreenUtil().setWidth(20),
                          width: ScreenUtil().setWidth(20),
                          // decoration: BoxDecoration(
                          //     gradient: LinearGradient(
                          //       colors: [
                          //         Color(index == 0 ? 0xFFFF4242 : (index == 1 ? 0xFFFFAD42 : (index == 2 ? 0xFF7E42FF : 0xFFFFFFFF))),
                          //         Color(index == 0 ? 0xFFFF4242 : (index == 1 ? 0xFFFFAD42 : (index == 2 ? 0xFF7E42FF : 0xFFFFFFFF)))
                          //       ],
                          //       begin: Alignment.centerLeft,
                          //       end: Alignment.centerRight,
                          //     ),
                          //     borderRadius: const BorderRadius.all(Radius.circular(3))),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                color: Color(index == 0 ? 0xFFFF4242 : index == 1 ? 0xFFFFAD42 : index == 2 ? 0xFF7E42FF : 0xFF939393),
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                overflow: TextOverflow.ellipsis,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            hotTags[index].work,
                            style: TextStyle(
                              color: const Color.fromRGBO(23, 21, 24, 1),
                              fontSize: 14.sp,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 1,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            MyImage.asset(MyImagePaths.appSearHotkeyN, width: 14.w, height: 14.w),
                            SizedBox(width: 5.w),
                            Text(
                              '${CommonUtils.renderFixedNumber(hotTags[index].num)}${'wcll'.tr(context: context)}',
                              style: TextStyle(color: MyTheme.blackColor32, fontSize: 15.sp, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                itemCount: hotTags.length),
          ],
        )
            : const SizedBox.shrink(),
      ],
    );
  }
}
