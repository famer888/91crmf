import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jycrpj/data_layer/repo/repo.dart';
import 'package:jycrpj/domain/api_validator.dart';
import 'package:jycrpj/domain/remote_domain/domains/dynamic.dart';
import 'package:jycrpj/domain/type_def.dart';
import 'package:jycrpj/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jycrpj/ui_layer/router/routes.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/status/empty_data.dart';
import 'package:jycrpj/ui_layer/screens/crack/model/app_model.dart';
import 'package:jycrpj/ui_layer/screens/image_paths.dart';
import 'package:jycrpj/ui_layer/screens/theme.dart';
import 'package:jycrpj/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';

import '../../../../../../report/ui_layer/report_gesture_detector.dart';

class Tiktok51VideoSearchScreen extends StatefulWidget {
  final String args;

  const Tiktok51VideoSearchScreen({super.key, required this.args});

  @override
  State<Tiktok51VideoSearchScreen> createState() => _Tiktok51VideoSearchScreenState();
}

class _Tiktok51VideoSearchScreenState extends State<Tiktok51VideoSearchScreen> {
  final searchTextEditController = TextEditingController();
  late final _homeConfigNotifier = context.read<HomeConfigNotifier>();

  void onSubmitted(String keyword) {
    if (keyword.trim().isEmpty) {
      MyToast.showText(text: 'qsrgjz'.tr());
      return;
    }
    final searchHistory = _homeConfigNotifier.getSearchHistory(key: tiktok51SearchHistoryKey);

    final title = keyword.replaceAll('/', '|');
    if (!searchHistory.contains(keyword)) {
      _homeConfigNotifier.upsertSearchHistory(key: tiktok51SearchHistoryKey, searchHistory: searchHistory..add(keyword));
    }
    Tiktok51SearchResultRoute(word: title, type: 1).push(context);
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Stack(fit: StackFit.expand, children: [
        Theme(
          data: Theme.of(context).copyWith(scaffoldBackgroundColor: Colors.black),
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
                      Text(
                        'ssjl'.tr(context: context),
                        style: TextStyle(color: MyTheme.whiteColor, fontSize: 16.sp, fontWeight: FontWeight.w500),
                      ),
                      const Spacer(),
                      ReportGestureDetector(
                        onTap: () {
                          _homeConfigNotifier.clearSearchHistory(key: tiktok51SearchHistoryKey);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(tr('qcssjl'), style: TextStyle(color: MyTheme.white07Color, fontSize: 12.sp, fontWeight: FontWeight.w400)),
                            SizedBox(width: 5.w),
                            SizedBox(
                              width: 16.w,
                              height: 16.w,
                              child: MyImage.asset(
                                MyImagePaths.appClearSearch,
                                width: 16.w,
                                height: 16.w,
                                color: MyTheme.tiktok51AppPrimaryColor,
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
                    selector: (_, config) => config.getSearchHistory(key: tiktok51SearchHistoryKey),
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
                              final history = _homeConfigNotifier.getSearchHistory(key: tiktok51SearchHistoryKey);
                              _homeConfigNotifier.upsertSearchHistory(key: tiktok51SearchHistoryKey, searchHistory: history..remove(text));
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
        ),
      ]),
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
                color: const Color.fromRGBO(255, 255, 255, 1),
              ),
              onTap: () => context.pop(),
            ),
            Expanded(
              child: Container(
                height: 36.w,
                margin: EdgeInsets.symmetric(horizontal: 8.w),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.w),
                    side: BorderSide(
                      color: const Color.fromRGBO(45, 45, 45, 0.6),
                      width: 0.5.w,
                    ),
                  ),
                  color: const Color.fromRGBO(31, 28, 29, 0.7),
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
              child: Text(
                'ss'.tr(context: context),
                style: TextStyle(color: MyTheme.whiteColor, fontSize: 14.sp, fontWeight: FontWeight.w400),
              ),
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
      decoration: BoxDecoration(color: const Color.fromRGBO(32, 32, 32, 1), borderRadius: BorderRadius.circular(3.w)),
      padding: EdgeInsets.fromLTRB(12.w, 4.w, 12.w, 5.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ReportGestureDetector(
            onTap: onTap,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100.w),
              child: Text(
                text,
                style: TextStyle(color: const Color.fromRGBO(255, 255, 255, 0.7), fontSize: 14.sp, fontWeight: FontWeight.w400),
                maxLines: 1,
              ),
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
      cursorColor: const Color.fromRGBO(255, 255, 255, 1),
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
      style: TextStyle(color: const Color.fromRGBO(255, 255, 255, 1), fontSize: 13.sp),
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
  late final _appDomain = context.read<DynamicDomain>();
  final ValueNotifier<List<AppSearchHotModel>> _hotsNotifier = ValueNotifier([]);

  @override
  void initState() {
    _initData();
    super.initState();
  }

  @override
  void dispose() {
    _hotsNotifier.dispose();
    super.dispose();
  }

  Future _initData() async {
    final result = await _appDomain.getConstructByApiLink(
      apiLink: '/api/searchtiktok51/hotsearch',
      params: {},
    );
    if (result.isValid && mounted) {
      final data = result.data;
      if (data['list'] case final List data when data.isNotEmpty) {
        _hotsNotifier.value = data.map<AppSearchHotModel>((e) => AppSearchHotModel.fromJson(e)).toList();
      }
    } else if (result.msg case final msg?) {
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
        ValueListenableBuilder(
            valueListenable: _hotsNotifier,
            builder: (_, hots, __) {
              if (hots.isEmpty) {
                return const SizedBox.shrink();
              }

              return Column(
                children: [
                  SizedBox(height: 30.w),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 4.w),
                      Text(
                        'rmtj'.tr(context: context),
                        style: TextStyle(color: MyTheme.whiteColor, fontSize: 16.sp, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
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
                          widget.onSubmitted(hots[index].title);
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
                                      color: Color(index == 0
                                          ? 0xFFFF4242
                                          : index == 1
                                          ? 0xFFFFAD42
                                          : index == 2
                                          ? 0xFF7E42FF
                                          : 0xFF939393),
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
                                  hots[index].title,
                                  style: TextStyle(
                                    color: const Color.fromRGBO(255, 255, 255, 1),
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
                                    '${hots[index].num}${'cll'.tr(context: context)}',
                                    style: TextStyle(
                                      color: const Color.fromRGBO(255, 255, 255, 0.7),
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      itemCount: hots.length),
                ],
              );
            }),
      ],
    );
  }
}
