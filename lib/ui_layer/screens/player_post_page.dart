import 'package:flutter/material.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_app_bar.dart';
import 'package:jycrpj/ui_layer/screens/theme.dart';
import 'package:jycrpj/ui_layer/utils/common_utils.dart';

///
///
/// @description 帖子视频播放入口
///
class PostPlayerPage extends StatelessWidget {
  /// Map {url : '', img : ''}
  final dynamic args;
  const PostPlayerPage(this.args, {super.key});

  @override
  Widget build(BuildContext context) {
    CommonUtils.log('帖子视频播页面');
    // Widget current = WebpagePlayerWidget(sourceType: 'post', sourcesMap: args);
    return const Scaffold(
      backgroundColor: Color.fromRGBO(11, 11, 22, 1),
      body: Stack(fit: StackFit.expand, children: [
        Positioned(left: 0, right: 0, top: 0, child: Text('这是加在组件...', style: TextStyle(color: MyTheme.blueColor63, fontSize: 16),)),
        Positioned(
          left: 0,
          top: 0,
          right: 0,
          child: MyAppBar(backgroundColor: Colors.transparent),
        ),
      ]),
    );
  }
}
