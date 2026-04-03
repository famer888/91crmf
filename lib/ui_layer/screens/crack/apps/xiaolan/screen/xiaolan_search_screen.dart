import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jycrpj/data_layer/repo/repo.dart';
import 'package:jycrpj/domain/type_def.dart';
import 'package:jycrpj/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jycrpj/ui_layer/utils/common_utils.dart';
import 'package:provider/provider.dart';

import '../../../../../../domain/async_value.dart';
import '../../../../../../domain/domain.dart';
import '../../../../../../domain/model/feed/feed_model.dart';
import '../../../../../router/routes.dart';
import '../../../../../utils/my_toast.dart';
import '../../../../common_widgets/my_app_bar.dart';
import '../../../../common_widgets/screen_background.dart';
import '../../../../common_widgets/status/loading.dart';
import '../../../../common_widgets/status/network_error.dart';
import '../widget/xiaolan_list_build.dart';

class XiaolanSearchScreen extends StatefulWidget {
  const XiaolanSearchScreen({super.key});

  @override
  State<XiaolanSearchScreen> createState() => _XiaolanSearchScreenState();
}

class _XiaolanSearchScreenState extends State<XiaolanSearchScreen> {
  AsyncValue<dynamic> _asyncValue = const AsyncInit();
  late final _appDomain = context.read<AppDomain>();
  late final _homeConfigNotifier = context.read<HomeConfigNotifier>();
  final TextEditingController _searchController = TextEditingController();

  Future<dynamic?> _getData() async {
    if (_asyncValue.isLoading) return;

    if (!mounted) {
      setState(() {
        _asyncValue = const AsyncLoading();
      });
    }

    final param = Map.from({});

    final result = await _appDomain.getConstructByApiLink(
      apiLink: "/api/searchxiaolan/index",
      params: param,
    );

    if (result.status == 1) {
      dynamic data = result.data;
      setState(() {
        _asyncValue = AsyncData(data);
      });
      return data;
    } else {
      setState(() {
        _asyncValue = const AsyncError();
      });
      MyToast.showText(text: result.msg ?? '');
    }
    return [];
  }

  void _onSearch(String keyword) {
    final k = keyword.trim();
    if (k.isEmpty) return;
    _homeConfigNotifier.upsertSearchHistory(
        key: xiaolanSearchHistoryKey, searchWord: k);
    XiaolanSearchResultRoute(kwy: k).push(context);
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      bgColor: Colors.white,
      child: Stack(
        children: [
          Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: Image.asset('assets/images/xiaolan_top_navi_bg.png',
                  width: double.infinity, fit: BoxFit.cover)),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: MyAppBar(
                titleWidget: Align(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 30.w,
                      ),
                      Expanded(
                          child: Container(
                        height: 35.w,
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [Color(0xFFEBF4FF), Color(0xFFFFFFFF)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight),
                            border: Border.all(color: Colors.white, width: 1.w),
                            borderRadius: BorderRadius.circular(35.w)),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Icon(
                              Icons.search,
                              color: Colors.black,
                              size: 24.sp,
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Expanded(
                                child: TextField(
                                    controller: _searchController,
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        color: const Color(0xFF151515),
                                        fontWeight: FontWeight.w500),
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.zero,
                                        isDense: true,
                                        border: InputBorder.none,
                                        hintText: '吃瓜/男同/猎奇',
                                        hintStyle: TextStyle(
                                            fontSize: 14.sp,
                                            color: const Color(0xFF666666)))))
                          ],
                        ),
                      )),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          // 获取输入框内容
                          String keyword = _searchController.text.trim();
                          if (keyword.isNotEmpty) {
                            _onSearch(keyword);
                          }
                        },
                        child: Text(
                          '搜索',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
                backIconColor: Color(0xFF151515),
                titleColor: Color(0xFF151515),
                backgroundColor: Colors.transparent),
            body: _asyncValue.maybeWhen(
              data: (data) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildSearchHistory(),
                      SizedBox(
                        height: 7.w,
                      ),
                      if (data['rank_list'] != null &&
                          data['rank_list'] is List &&
                          (data['rank_list'] as List).isNotEmpty) ...[
                        _buildHotSearch(data['rank_list'] as List),
                        SizedBox(
                          height: 7.w,
                        ),
                      ],
                      if (data['hotSearch'] != null &&
                          data['hotSearch'] is List &&
                          (data['hotSearch'] as List).isNotEmpty)
                        _buildHotTag(data['hotSearch'] as List? ?? [])
                    ],
                  ),
                );
              },
              error: (_, __) => NetworkErrorView(onTap: _getData),
              orElse: () => const LoadingView(),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSearchHistory() {
    return Selector<HomeConfigNotifier, List<String>>(
      selector: (_, n) => n.getSearchHistory(key: xiaolanSearchHistoryKey),
      builder: (context, history, _) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12.5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '搜索历史',
                    style: TextStyle(
                        fontSize: 16.sp,
                        color: const Color(0xFF151515),
                        fontWeight: FontWeight.w500),
                  ),
                  if (history.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _homeConfigNotifier.clearSearchHistory(
                            key: xiaolanSearchHistoryKey);
                      },
                      child: Image.asset(
                        "assets/images/app_asmr_del.png",
                        width: 14.w,
                        color: Colors.black.withValues(alpha: .5),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 10.w),
              if (history.isNotEmpty)
                Wrap(
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children: history
                      .map((text) => _buildHistoryItem(
                            text,
                            onTap: () {
                              _searchController.text = text;
                              _onSearch(text);
                            },
                          ))
                      .toList(),
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/xiaolan_search_empty.png",
                            width: 105.w),
                        Text("您还没有搜索过哟~",
                            style: TextStyle(
                                color: const Color(0xFF727272),
                                fontSize: 14.sp))
                      ],
                    )
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHistoryItem(String text, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.w),
        margin: EdgeInsets.only(right: 5.w, bottom: 7.5.w),
        decoration: BoxDecoration(
            color: const Color(0xFFE6F4FF),
            borderRadius: BorderRadius.circular(20.w)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(text,
                style:
                    TextStyle(fontSize: 12.sp, color: const Color(0xFF3DA7FD))),
            SizedBox(width: 4.w),
          ],
        ),
      ),
    );
  }

  Widget _buildHotSearch(List data) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '热搜排行',
            style: TextStyle(
                fontSize: 16.sp,
                color: const Color(0xFF151515),
                fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 10.w,
          ),
          Column(
            children: List.generate(data.length,
                (int index) => _buildHotSearchItem(data[index], index)),
          )
        ],
      ),
    );
  }

  Widget _buildHotSearchItem(dynamic item, int index) {
    return GestureDetector(
      onTap: () {
        _onSearch("${item['work'] ?? ""}");
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.5.w),
        child: Row(
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              alignment: Alignment.center,
              child: index <= 2
                  ? Image.asset("assets/images/xiaolan_hotsearch${index}.png",
                      width: 20.w)
                  : Text(
                      "${index}",
                      style: TextStyle(
                          color: Color(0xFF005DAE),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600),
                    ),
            ),
            SizedBox(
              width: 4.w,
            ),
            Expanded(
                child: Text(
              "${item['work'] ?? ""}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13.sp, color: const Color(0xFF2C2C2C)),
            )),
            SizedBox(
              width: 14.w,
            ),
            Text(
              "${CommonUtils.renderEnFixedNumber(item['num'] ?? 0)}次",
              style: TextStyle(
                  color: Color(0xFFFFAA00),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHotTag(List data) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '热搜标签',
                style: TextStyle(
                    fontSize: 16.sp,
                    color: const Color(0xFF151515),
                    fontWeight: FontWeight.w500),
              ),
              GestureDetector(
                onTap: () {
                  _getData();
                },
                child: Image.asset(
                  "assets/images/xiaolan_search_refresh.png",
                  width: 14.w,
                  color: Colors.black.withValues(alpha: .3),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.w,
          ),
          if (data.isNotEmpty)
            Wrap(
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: [
                for (var item in data)
                  if ("${item}".isNotEmpty)
                    _buildHistoryItem("${item ?? ""}",
                        onTap: () => _onSearch("${item ?? ""}")),
              ],
            ),
        ],
      ),
    );
  }
}
