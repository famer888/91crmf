import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jycrpj/app_global.dart';
import 'package:jycrpj/data_layer/repo/repo.dart';
import 'package:jycrpj/domain/api_validator.dart';
import 'package:jycrpj/domain/model/black_model.dart';
import 'package:jycrpj/domain/model/vlog_model.dart';
import 'package:jycrpj/domain/remote_domain/domains/black_domain.dart';
import 'package:jycrpj/domain/remote_domain/domains/vlog.dart';
import 'package:jycrpj/report/ui_layer/report_gesture_detector.dart';
import 'package:jycrpj/report/ui_layer/report_search_click.dart';
import 'package:jycrpj/ui_layer/const.dart';
import 'package:jycrpj/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jycrpj/ui_layer/router/routes.dart';
import 'package:jycrpj/ui_layer/screens/black/widget/black_item_widget.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/keep_alive_wrapper.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_tab_bar.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/video_player/model/shorttv_search_model.dart';
import 'package:jycrpj/ui_layer/screens/image_paths.dart';
import 'package:jycrpj/ui_layer/screens/theme.dart';
import 'package:jycrpj/ui_layer/screens/vlog/card/vlog_card.dart';
import 'package:jycrpj/ui_layer/utils/common_utils.dart';
import 'package:jycrpj/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';

class ShorttvSearchResultScreen extends StatefulWidget {
  const ShorttvSearchResultScreen({super.key, required this.word});

  final String word;

  @override
  State<ShorttvSearchResultScreen> createState() => _ShorttvSearchResultScreenState();
}

class _ShorttvSearchResultScreenState extends State<ShorttvSearchResultScreen> with TickerProviderStateMixin {
  late final _homeConfigNotifier = context.read<HomeConfigNotifier>();
  late final ValueNotifier<SearchData?> _refreshNotifier = ValueNotifier(null);
  final _searchTextEditController = TextEditingController();

  final _tabTitles = [
    'home_dsp'.tr(),
    'home_hl'.tr(),
  ];
  late final TabController _tabController;
  int _initialIndex = 0;

  void onSubmitted(String keyword) {
    if (keyword.trim().isEmpty) {
      MyToast.showText(text: 'qsrgjz'.tr());
      return;
    }
    final searchHistory = _homeConfigNotifier.getSearchHistory(key: dspSearchHistoryKey);

    final title = keyword.replaceAll('/', '|');
    if (!searchHistory.contains(keyword)) {
      _homeConfigNotifier.upsertSearchHistory(key: dspSearchHistoryKey, searchHistory: searchHistory..add(keyword));
    }

    if (_searchTextEditController.text.isEmpty) return;
    final currentIndex = _tabController.index;
    _refreshNotifier.value = SearchData(type: currentIndex, word: title);
  }

  @override
  void initState() {
    super.initState();
    _initialIndex = 0;
    _tabController = TabController(length: _tabTitles.length, vsync: this);
    _searchTextEditController.text = widget.word;
    _tabController.addListener(() {
      if (_searchTextEditController.text.isEmpty) return;
      final currentIndex = _tabController.index;
      final title = _searchTextEditController.text.replaceAll('/', '|');
      _refreshNotifier.value = SearchData(type: currentIndex, word: title);
    });
  }

  @override
  void dispose() {
    _refreshNotifier.dispose();
    _searchTextEditController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Theme(
            data: Theme.of(context).copyWith(scaffoldBackgroundColor: Colors.black),
            child: Scaffold(
              appBar: _SearchBar(
                textEditingController: _searchTextEditController,
                onSubmitted: onSubmitted,
              ),
              body: TabBarWithView.line(
                tabController: _tabController,
                initialIndex: _initialIndex,
                tabBarHeight: 40.h,
                linearColors: const [MyTheme.tiktok51AppPrimaryColor, MyTheme.tiktok51AppPrimaryColor],
                labelStyle: TextStyle(color: MyTheme.tiktok51AppPrimaryColor, fontSize: 18.sp, fontWeight: FontWeight.w600),
                unselectedLabelStyle: TextStyle(
                  color: const Color.fromRGBO(255, 255, 255, 1),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
                titles: _tabTitles,
                views: [
                  KeepAliveWrapper(child: _DspView(initialWord: _searchTextEditController.text, refreshNotifier: _refreshNotifier)),
                  KeepAliveWrapper(child: _HlView(initialWord: _searchTextEditController.text, refreshNotifier: _refreshNotifier)),
                ],
              ),
            ),
          ),
        ],
      ),
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
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 8.w),
                decoration: ShapeDecoration(
                  color: const Color.fromRGBO(31, 28, 29, 0.7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.w),
                    side: BorderSide(color: const Color.fromRGBO(45, 45, 45, 0.6), width: 0.5.w),
                  ),
                ),
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

class _DspView extends StatefulWidget {
  const _DspView({
    required this.initialWord,
    required this.refreshNotifier,
  });

  final String initialWord;
  final ValueNotifier<SearchData?> refreshNotifier;

  @override
  State<_DspView> createState() => _DspViewState();
}

class _DspViewState extends State<_DspView> {
  late final _domain = context.read<VlogDomain>();
  String _word = '';

  List<VlogModel> array = [];
  int _page = 1;
  int _limit = 15;

  @override
  void initState() {
    super.initState();
    _word = widget.initialWord;
    widget.refreshNotifier.addListener(_onSearchRefresh);
  }

  @override
  void dispose() {
    widget.refreshNotifier.removeListener(_onSearchRefresh);
    super.dispose();
  }

  void _onSearchRefresh() {
    final value = widget.refreshNotifier.value;
    if (value == null) return;

    if (value.type == 0 && value.word.isNotEmpty && value.word != _word) {
      _word = value.word;

      // ⭐ 搜索词变化 = 全量重置
      _page = 1;
      array.clear();

      setState(() {}); // 通知 MyListView 重建
    }
  }

  Future<List<VlogModel>?> _getData({
    int page = 1,
    int pageSize = 16,
  }) async {
    _page = page;
    _limit = pageSize;

    final result = await _domain.vlogSearchList(
      word: _word,
      page: page,
      limit: pageSize,
    );

    if (!result.isValid) return null;
    final tp = List<VlogModel>.from(result.data ?? []);
    if (page == 1) {
      array = tp;
    } else {
      array.addAll(tp);
    }

    return tp;
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.grid(
      key: ValueKey(_word),
      // ⭐ 非常关键：搜索词变化 → 重建列表
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
      childAspectRatio: UILayerConst.vlogVideoRatio,
      crossAxisSpacing: 10.w,
      itemBuilder: (_, item, index) => VlogCard(
          data: item,
          onTapFunc: (type) {
            if (type == 1) {
              //点击短视频视频
              AppGlobal.shortVideosInfo = {
                'list': array,
                'page': _page,
                'index': index,
                'api': 'vlog/search',
                'params': {
                  'limit': _limit,
                  'word': _word,
                }
              };
              const VlogSecondRoute().push(context);
            } else {
              //广告类型
              CommonUtils.openRoute(context, item.toJson());
            }
          }).withSearchReport({
        "event": "keyword_click",
        "keyword": _word,
        "click_item_id": item.id,
        "click_item_type_key": "vlog",
        "click_item_type_name": "短视频",
        "click_ position": index,
      }),
      onFetchingMore: (currentPage, pageSize) => _getData(page: currentPage, pageSize: pageSize),
    );
  }
}

class _HlView extends StatefulWidget {
  const _HlView({
    required this.initialWord,
    required this.refreshNotifier,
  });

  final String initialWord;
  final ValueNotifier<SearchData?> refreshNotifier;

  @override
  State<_HlView> createState() => _HlViewState();
}

class _HlViewState extends State<_HlView> {
  late final _blockDomain = context.read<BlackDomain>();
  late final _screenUtils = ScreenUtil();

  String _word = '';

  @override
  void initState() {
    super.initState();
    _word = widget.initialWord;
    widget.refreshNotifier.addListener(_onSearchRefresh);
  }

  @override
  void dispose() {
    widget.refreshNotifier.removeListener(_onSearchRefresh);
    super.dispose();
  }

  void _onSearchRefresh() {
    final value = widget.refreshNotifier.value;
    if (value == null) return;

    if (value.type == 1 && value.word.isNotEmpty && value.word != _word) {
      _word = value.word;
      setState(() {}); // 通知 MyListView 重建
    }
  }

  Future<List<BlackListItemModel>?> _getData({
    int page = 1,
    int pageSize = 16,
  }) async {
    final result = await _blockDomain.searchList(page: page, limit: pageSize, word: _word);
    if (!result.isValid) return null;

    final list = result.data?.list;
    return list;
  }

  @override
  Widget build(BuildContext context) {
    // return Text('设置什么', style: MyTheme.white255_13_M,);
    return MyListView.list(
      key: ValueKey(_word),
      // ⭐ 非常关键：搜索词变化 → 重建列表
      contentPadding: 15.w,
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
      itemBuilder: (context, item, index) => BlackItemWidget(
        item: item,
        itemWidth: (_screenUtils.screenWidth - MyTheme.pagePadding * 2),
      ).withSearchReport(
        {
          "event": "keyword_click",
          "keyword": _word,
          "click_item_id": item.id,
          "click_item_type_key": "black",
          "click_item_type_name": "黑料",
          "click_ position": index,
        },
      ),
      onFetchingMore: (currentPage, pageSize) => _getData(page: currentPage, pageSize: pageSize),
    );
  }
}

extension EventClick on Widget {
  Widget withSearchReport(Map data) {
    return ReportSearchClick(
      data: data,
      child: this,
    );
  }
}
