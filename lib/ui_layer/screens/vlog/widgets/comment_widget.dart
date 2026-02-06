import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jycrpj/domain/domain.dart';
import 'package:provider/provider.dart';

import '../../../../domain/api_validator.dart';
import '../../../../domain/model/video_comment_model.dart';
import '../../../../report/ui_layer/report_gesture_detector.dart';
import '../../../const.dart';
import '../../../utils/common_utils.dart';
import '../../../utils/my_toast.dart';
import '../../common_widgets/member_vip.dart';
import '../../common_widgets/my_avatar.dart';
import '../../common_widgets/my_list_view.dart';
import '../../common_widgets/post/comment_input.dart';
import '../../theme.dart';

class CommentView extends StatefulWidget {
  const CommentView({super.key, required this.id});

  final String id;

  @override
  State<CommentView> createState() => _CommentViewState();
}

class _CommentViewState extends State<CommentView> {
  /// 文本框控制器
  final textEditingController = TextEditingController();

  /// 文本框焦点
  final inputFocusNode = FocusNode();

  final hintNotifier = ValueNotifier('wyddxf'.tr());

  String _lastIx = '';

  late final mvDomain = context.read<MvDomain>();

  Future<List<VideoCommentListModel>> _getData({
    required int currentPage,
    required int limit,
  }) async {
    final result = await mvDomain.cartoonListCommentMv(
      id: widget.id,
      lastIx: currentPage == 1 ? '' : _lastIx,
      page: currentPage,
      limit: limit,
    );

    _lastIx = result.data?.lastIx ?? '';

    if (result.msg case final msg? when !result.isValid) {
      MyToast.showText(text: msg);
    }

    return result.data!.list!;
  }

  Future<void> _sendComment({required String text}) async {
    if (text.trim().isEmpty) {
      MyToast.showText(text: 'qsrnr'.tr(context: context));
      return;
    }
    MyToast.showLoading(text: 'fbioz'.tr(context: context));
    final result = await mvDomain.cartoonCreateCommentMv(
      content: text,
      id: widget.id,
    );

    BotToast.closeAllLoading();
    MyToast.showText(text: result.msg ?? '');
    inputFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return ReportGestureDetector(
      onTap: () {
        inputFocusNode.unfocus();
      },
      child: Column(
        children: [
          Expanded(
            child: MyListView.list(
              padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
              itemBuilder: (context, item, index) => CommentTile(data: item, type: 1, secondaryCommentCallback: (commentId) {}),
              onFetchingMore: (currentPage, pageSize) => _getData(currentPage: currentPage, limit: pageSize),
            ),
          ),
          CommentInput(
            controller: textEditingController,
            focusNode: inputFocusNode,
            hintNotifier: hintNotifier,
            onSubmitted: () async {
              await _sendComment(text: textEditingController.text);
              textEditingController.clear();
            },
          ),
        ],
      ),
    );
  }
}

typedef SecondaryCommentCallback = void Function(int commentId);

class CommentTile extends StatelessWidget {
  const CommentTile({super.key, required this.data, required this.type, required this.secondaryCommentCallback});

  final VideoCommentListModel data;
  final SecondaryCommentCallback secondaryCommentCallback;
  final int type;

  @override
  Widget build(BuildContext context) {
    final member = data.member;
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.w),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyAvatar(thumb: member?.thumb ?? '', size: 30.w),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ConstrainedBox(
                                  constraints: BoxConstraints(maxWidth: 180.w),
                                  child: Text(member?.nickname ?? '', style: MyTheme.white23_12),
                                ),
                                SizedBox(width: 2.w),
                                if (member?.agent == 1)
                                  Icon(
                                    Icons.verified_sharp,
                                    size: 11.w,
                                    color: const Color.fromRGBO(247, 208, 93, 1),
                                  )
                              ],
                            ),
                            SizedBox(height: 4.w),
                            Row(
                              children: [
                                MemberVipWidget(vipImage: member?.vipImg, height: 14, margin: 5),
                                Text(RelativeDateFormat.format(date: DateTime.parse(data.createdAt ?? '')), style: MyTheme.gray163_11),
                              ],
                            ),
                            SizedBox(height: 2.w),
                          ],
                        ),
                      ),
                      // StatefulBuilder(builder: (_, setState) {
                      //   final isLike = data.isLike == 1;
                      //   return ReportGestureDetector(
                      //     behavior: HitTestBehavior.translucent,
                      //     onTap: () async {
                      //       if (data.id case final id?) {
                      //         final domain = context.read<VlogDomain>();
                      //         final res = await domain.vlogCommentLike(id: id);
                      //         if (res.isValid) {
                      //           data.isLike = isLike ? 0 : 1;
                      //           if (type == 1) {
                      //             int likeCount = data.likeCount ?? 0;
                      //             isLike ? likeCount-- : likeCount++;
                      //             data.likeCount = likeCount;
                      //           } else {
                      //             int likeCount = data.likeFct ?? 0;
                      //             isLike ? likeCount-- : likeCount++;
                      //             data.likeFct = likeCount;
                      //           }
                      //           setState(() {});
                      //         } else if (res.msg case final msg?) {
                      //           MyToast.showText(text: msg);
                      //         }
                      //       }
                      //     },
                      //     child: SizedBox(
                      //       width: 40.w,
                      //       child: Column(
                      //         children: [
                      //           MyImage.asset(
                      //             isLike ? MyImagePaths.appCommReviewH : MyImagePaths.appCommReviewN,
                      //             width: 20.w,
                      //             height: 20.w,
                      //           ),
                      //           SizedBox(height: 1.w),
                      //           Text(
                      //             CommonUtils.renderFixedNumber(type == 1
                      //                 ? CommonUtils.renderFixedLikeCount(data.likeCount ?? 0, data.isLike ?? 0)
                      //                 : CommonUtils.renderFixedLikeCount(data.likeFct ?? 0, data.isLike ?? 0)),
                      //             style: MyTheme.gray203_12,
                      //           )
                      //         ],
                      //       ),
                      //     ),
                      //   );
                      // })
                    ],
                  ),
                  SizedBox(height: 10.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 40.w),
                        child: Text(
                          CommonUtils.convertEmojiAndHtml(data.content ?? data.text ?? ''),
                          style: MyTheme.gray208_13,
                          textAlign: TextAlign.left,
                          maxLines: UILayerConst.maxLine,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 40.w, top: 8.w),
                        child: Text(
                          data.createdAt ?? '',
                          textAlign: TextAlign.left,
                          style: MyTheme.white255_10.copyWith(color: const Color.fromRGBO(255, 255, 255, 0.4)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.w),
                ],
              ),
            ),
            SizedBox(width: 10.w),
            ReportGestureDetector(
              onTap: () {
                if (data.id != null) {
                  secondaryCommentCallback.call(data.id!);
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 4.5.w, horizontal: 10.w),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromRGBO(255, 27, 57, 1),
                      Color.fromRGBO(255, 71, 145, 1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14.w),
                ),
                child: Text('hf'.tr(context: context), style: MyTheme.white255_10),
              ),
            ),
          ],
        ),
        if (data.comments == null || data.comments!.isEmpty) Container(height: 0.5.w, color: MyTheme.white008Color),
        _ReplyListView(data: data, secondaryCommentCallback: secondaryCommentCallback),
      ],
    );
  }

  List<Widget> _buildReply(BuildContext context, VideoCommentListModel data) {
    return [
      if (data.comments != null && data.comments!.isNotEmpty) SizedBox(height: 10.w),
      if (data.comments != null && data.comments!.isNotEmpty)
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: data.comments!.length,
            itemBuilder: (context, index) {
              final item = data.comments![index];
              return CommentTile(
                data: item,
                type: 2,
                secondaryCommentCallback: (commentId) {
                  // _commentId = commentId;
                  // FocusScope.of(context).requestFocus(inputFocusNode);
                },
              );
            }),
    ];
  }
}

class _ReplyListView extends StatefulWidget {
  const _ReplyListView({required this.data, required this.secondaryCommentCallback});

  final VideoCommentListModel data;
  final SecondaryCommentCallback secondaryCommentCallback;

  @override
  State<_ReplyListView> createState() => _ReplyListViewState();
}

class _ReplyListViewState extends State<_ReplyListView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 40.w),
      decoration: BoxDecoration(
        // color: MyTheme.blackColor25,
        borderRadius: BorderRadius.all(Radius.circular(6.w)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.data.comments != null && widget.data.comments!.isNotEmpty) SizedBox(height: 10.w),
          if (widget.data.comments != null && widget.data.comments!.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.data.comments!.length,
              itemBuilder: (context, index) {
                final item = widget.data.comments![index];
                return _ReplyCommentTile(data: item, secondaryCommentCallback: widget.secondaryCommentCallback);
              },
            ),
        ],
      ),
    );
  }
}

class _ReplyCommentTile extends StatelessWidget {
  const _ReplyCommentTile({required this.data, required this.secondaryCommentCallback});

  final VideoCommentListModel data;
  final SecondaryCommentCallback secondaryCommentCallback;

  @override
  Widget build(BuildContext context) {
    final member = data.member;
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.w),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyAvatar(thumb: member?.thumb ?? '', size: 30.w),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ConstrainedBox(
                                  constraints: BoxConstraints(maxWidth: 180.w),
                                  child: Text(member?.nickname ?? '', style: MyTheme.white23_12),
                                ),
                                SizedBox(width: 2.w),
                                if (member?.agent == 1)
                                  Icon(
                                    Icons.verified_sharp,
                                    size: 11.w,
                                    color: const Color.fromRGBO(247, 208, 93, 1),
                                  )
                              ],
                            ),
                            SizedBox(height: 4.w),
                            Row(
                              children: [
                                MemberVipWidget(vipImage: member?.vipImg, height: 14, margin: 5),
                                Text(
                                  RelativeDateFormat.format(date: DateTime.parse(data.createdAt ?? '')),
                                  style: MyTheme.gray163_11,
                                ),
                              ],
                            ),
                            SizedBox(height: 2.w),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 40.w),
                        child: Text(
                          CommonUtils.convertEmojiAndHtml(data.content ?? data.text ?? ''),
                          style: MyTheme.gray208_13,
                          textAlign: TextAlign.left,
                          maxLines: UILayerConst.maxLine,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 40.w, top: 8.w),
                        child: Text(
                          data.createdAt ?? '',
                          textAlign: TextAlign.left,
                          style: MyTheme.white255_10.copyWith(color: const Color.fromRGBO(255, 255, 255, 0.4)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.w),
                ],
              ),
            ),
            SizedBox(width: 10.w),
            ReportGestureDetector(
              onTap: () {
                if (data.id != null) {
                  secondaryCommentCallback.call(data.id!);
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 4.5.w, horizontal: 10.w),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromRGBO(255, 27, 57, 1),
                      Color.fromRGBO(255, 71, 145, 1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14.w),
                ),
                child: Text('hf'.tr(context: context), style: MyTheme.white255_10),
              ),
            ),
          ],
        ),
        Container(height: 0.5.w, color: MyTheme.white008Color),
      ],
    );
  }
}
