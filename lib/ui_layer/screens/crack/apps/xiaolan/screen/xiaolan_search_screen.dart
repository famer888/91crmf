import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../domain/async_value.dart';
import '../../../../../../domain/domain.dart';
import '../../../../../../domain/model/feed/feed_model.dart';
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
  AsyncValue<List<FeedModel>> _asyncValue = const AsyncInit();
  late final _appDomain = context.read<AppDomain>();

  @override
  void initState() {
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
              child: Image.asset('assets/images/xiaolan_top_navi_bg.png', width: double.infinity, fit: BoxFit.cover)),
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
                                    style: TextStyle(
                                        fontSize: 14.sp, color: const Color(0xFF151515), fontWeight: FontWeight.w500),
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.zero,
                                        isDense: true,
                                        border: InputBorder.none,
                                        hintText: '吃瓜/男同/猎奇',
                                        hintStyle: TextStyle(fontSize: 14.sp, color: const Color(0xFF666666)))))
                          ],
                        ),
                      )),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          '搜索',
                          style: TextStyle(color: Colors.black, fontSize: 15.sp, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
                backIconColor: Color(0xFF151515),
                titleColor: Color(0xFF151515),
                backgroundColor: Colors.transparent),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  _buildSearchHistory(),
                  SizedBox(
                    height: 7.w,
                  ),
                  _buildHotSearch(),
                  SizedBox(
                    height: 7.w,
                  ),
                  _buildHotTag()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSearchHistory() {
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
                style: TextStyle(fontSize: 16.sp, color: const Color(0xFF151515), fontWeight: FontWeight.w500),
              ),
              GestureDetector(
                onTap: () {},
                child: Image.asset(
                  "assets/images/app_asmr_del.png",
                  width: 14.w,
                  color: Color(0xFFD5D5D5),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.w,
          ),
          Wrap(
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: [
              _buildHistoryItem('吃瓜'),
              _buildHistoryItem('男同'),
              _buildHistoryItem('猎奇'),
              _buildHistoryItem('吃瓜'),
              _buildHistoryItem('男同'),
              _buildHistoryItem('猎奇'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/xiaolan_search_empty.png",
                    width: 105.w,
                  ),
                  Text(
                    "您还没有搜索过哟~",
                    style: TextStyle(color: Color(0xFF727272), fontSize: 14.sp),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildHistoryItem(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.w),
      margin: EdgeInsets.only(right: 5.w, bottom: 7.5.w),
      decoration: BoxDecoration(color: const Color(0xFFE6F4FF), borderRadius: BorderRadius.circular(20.w)),
      child: Text(
        text,
        style: TextStyle(fontSize: 12.sp, color: const Color(0xFF3DA7FD)),
      ),
    );
  }

  Widget _buildHotSearch() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '热门搜索',
            style: TextStyle(fontSize: 16.sp, color: const Color(0xFF151515), fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 10.w,
          ),
          Column(
            children: List.generate(20, (int index) => _buildHotSearchItem('吃瓜${index + 1}', index)),
          )
        ],
      ),
    );
  }

  Widget _buildHotSearchItem(String text, int index) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.5.w),
      child: Row(
        children: [
          Container(
            width: 20.w,
            height: 20.w,
            alignment: Alignment.center,
            child: index <= 2
                ? Image.asset("assets/images/xiaolan_hotsearch${index}.png", width: 20.w)
                : Text(
                    "${index}",
                    style: TextStyle(color: Color(0xFF005DAE), fontSize: 12.sp, fontWeight: FontWeight.w600),
                  ),
          ),
          SizedBox(
            width: 4.w,
          ),
          Expanded(
              child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 13.sp, color: const Color(0xFF2C2C2C)),
          )),
          SizedBox(
            width: 14.w,
          ),
          Text(
            "91.00w",
            style: TextStyle(color: Color(0xFFFFAA00), fontSize: 12.sp, fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }

  Widget _buildHotTag() {
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
                style: TextStyle(fontSize: 16.sp, color: const Color(0xFF151515), fontWeight: FontWeight.w500),
              ),
              GestureDetector(
                onTap: () {},
                child: Image.asset(
                  "assets/images/xiaolan_search_refresh.png",
                  width: 14.w,
                  color: Color(0xFFD5D5D5),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.w,
          ),
          Wrap(
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: [
              _buildHistoryItem('吃瓜'),
              _buildHistoryItem('男同'),
              _buildHistoryItem('猎奇'),
              _buildHistoryItem('吃瓜'),
              _buildHistoryItem('男同'),
              _buildHistoryItem('猎奇'),
            ],
          ),
        ],
      ),
    );
  }
}
