import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/ui_layer/screens/vlog/widgets/comment_widget.dart';
import 'package:provider/provider.dart';
import 'package:jycrpj/domain/api_validator.dart';
import 'package:jycrpj/domain/model/video_comment_model.dart';
import 'package:jycrpj/domain/remote_domain/domains/vlog.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jycrpj/ui_layer/screens/common_widgets/post/comment_input.dart';
import 'package:jycrpj/ui_layer/screens/theme.dart';
import 'package:jycrpj/ui_layer/utils/my_toast.dart';

import '../../../../report/ui_layer/report_gesture_detector.dart';

class VlogCommentSheet extends StatefulWidget {
  const VlogCommentSheet({super.key, this.id = 0, this.onClose, this.commentCount = 0});

  final int id;
  final int commentCount;
  final Function? onClose;

  @override
  State<VlogCommentSheet> createState() => VlogCommentSheetState();
}

class VlogCommentSheetState extends State<VlogCommentSheet> {
  /// 文本框控制器
  final textEditingController = TextEditingController();

  /// 文本框焦点
  final inputFocusNode = FocusNode();
  final hintNotifier = ValueNotifier('qsrnxsdh'.tr());

  late final domain = context.read<VlogDomain>();

  int _commentId = -1;

  @override
  void initState() {
    super.initState();
    _commentId = -1;
  }

  @override
  void didUpdateWidget(covariant VlogCommentSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (MediaQuery.of(context).viewInsets.bottom == 0) {
        inputFocusNode.unfocus();
      } else {}
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<VideoCommentListModel>?> _getData({
    required int currentPage,
    required int limit,
  }) async {
    final result = await domain.vlogCommentList(
      id: widget.id,
      page: currentPage,
      limit: limit,
    );
    if (result.msg case final msg? when !result.isValid) {
      MyToast.showText(text: msg);
    }
    return result.data;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets,
      duration: const Duration(milliseconds: 100),
      child: Container(
        height: ScreenUtil().screenHeight * 0.5,
        decoration: BoxDecoration(
          color: MyTheme.bgColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.w),
            topRight: Radius.circular(10.w),
          ),
        ),
        child: ReportGestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            Navigator.pop(context);
          },
          child: configContentView(context),
        ),
      ),
    );
  }

  Widget configContentView(BuildContext context) {
    return ReportGestureDetector(
      onTap: () {
        inputFocusNode.unfocus();
      },
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.w),
            child: Text('${'pl'.tr(context: context)}(${widget.commentCount})', style: MyTheme.white255_16_M),
          ),
          Expanded(
            child: MyListView.list(
              padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
              itemBuilder: (context, item, index) => CommentTile(
                data: item,
                type: 2,
                secondaryCommentCallback: (commentId) {
                  _commentId = commentId;
                  FocusScope.of(context).requestFocus(inputFocusNode);
                },
              ),
              onFetchingMore: (currentPage, pageSize) => _getData(currentPage: currentPage, limit: pageSize),
            ),
          ),
          CommentInput(
            showAvatar: false,
            focusNode: inputFocusNode,
            hintNotifier: hintNotifier,
            controller: textEditingController,
            onSubmitted: () async {
              if (_commentId != -1) {
                // 回复评论
                await _sendSecondaryComment(context, text: textEditingController.text);
              } else {
                // 回复帖子
                await _sendComment(context, text: textEditingController.text);
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _sendComment(BuildContext context, {required String text}) async {
    if (text.trim().isEmpty) {
      MyToast.showText(text: 'qsrnr'.tr(context: context));
      return;
    }
    MyToast.showLoading(text: 'fbioz'.tr(context: context));
    final result = await domain.vlogComment(
      id: widget.id,
      text: text,
    );
    MyToast.closeAllLoading();
    MyToast.showText(text: result.msg ?? '');

    textEditingController.clear();
    inputFocusNode.unfocus();
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> _sendSecondaryComment(BuildContext context, {required String text}) async {
    if (text.trim().isEmpty) {
      MyToast.showText(text: 'qsrnr'.tr(context: context));
      return;
    }
    MyToast.showLoading(text: 'fbioz'.tr(context: context));
    final result = await domain.vlogSecondaryComment(
      commentId: _commentId,
      text: text,
    );
    _commentId = -1;
    MyToast.closeAllLoading();
    MyToast.showText(text: result.msg ?? '');

    textEditingController.clear();
    inputFocusNode.unfocus();
    if (context.mounted) {
      Navigator.pop(context);
    }
  }
}
