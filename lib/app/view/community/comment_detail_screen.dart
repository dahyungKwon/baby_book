import 'package:baby_book/app/controller/CommnetDetailController.dart';
import 'package:baby_book/app/controller/CommunityDetailController.dart';
import 'package:baby_book/app/repository/comment_repository.dart';
import 'package:baby_book/app/view/community/comment_bottom_sheet.dart';
import 'package:baby_book/app/view/dialog/re_confirm_dialog.dart';
import 'package:baby_book/base/skeleton.dart';
import 'package:baby_book/base/color_data.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../base/pref_data.dart';
import '../../../base/uuid_util.dart';
import '../../models/model_comment_response.dart';
import '../../routes/app_pages.dart';
import '../dialog/error_dialog.dart';

class CommentDetailScreen extends GetView<CommentDetailController> {
  FocusNode commentFocusNode = FocusNode();
  late final String? postId;
  late final String? commentId;
  late final String? title;
  late final String? uniqueTag;

  CommentDetailScreen({super.key}) {
    postId = Get.parameters['postId']!;
    commentId = Get.parameters['commentId']!;
    title = Get.parameters['title']!;
    uniqueTag = getUuid();
    // Get.delete<CommentDetailController>();
    Get.put(
        CommentDetailController(
            commentRepository: CommentRepository(), postId: postId!, commentId: commentId!, title: title!),
        tag: uniqueTag);
  }

  @override
  String? get tag => uniqueTag;

  @override
  Widget build(BuildContext context) {
    EdgeInsets edgeInsets = EdgeInsets.symmetric(
      horizontal: FetchPixels.getDefaultHorSpace(context),
    );
    FetchPixels(context);
    return WillPopScope(
        onWillPop: () async {
          if (controller.modifyCommentMode) {
            await Get.dialog(ReConfirmDialog("댓글 수정을 종료하시겠습니까?", "네", "아니오", () async {
              controller.exitModifyCommentMode();
              Get.back();
              Future.delayed(const Duration(milliseconds: 500), () {
                commentKeyboardDown(context);
              });
            }));
          } else {
            try {
              await Get.find<CommunityDetailController>().getComment();
            } catch (e) {
              print(e);
            }
            Get.back();
          }
          return false;
        },
        child: Obx(() => Scaffold(
            resizeToAvoidBottomInset: false,
            // backgroundColor: backGroundColor,
            bottomNavigationBar: controller.loading
                ? Container(
                    height: 10,
                  )
                : Padding(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: buildBottom(context)),
            body: SafeArea(
                child: controller.loading
                    ? const FullSizeSkeleton()
                    : RefreshIndicator(
                        color: Colors.black87,
                        backgroundColor: Colors.white,
                        onRefresh: () async {
                          controller.init();
                        },
                        child: Column(children: [buildTop(context), buildBody(context, controller.commentList)]))))));
  }

  Widget buildTop(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(5, 10, 0, 0),
        color: Colors.white,
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            getSimpleImageButton("back_outline.svg", FetchPixels.getPixelHeight(50), FetchPixels.getPixelHeight(50),
                Colors.white, FetchPixels.getPixelHeight(26), FetchPixels.getPixelHeight(26), () async {
              await Get.find<CommunityDetailController>().getComment();
              Get.back();
            }),
            getCustomFont(
              controller.title,
              18,
              Colors.black,
              1,
              fontWeight: FontWeight.w600,
            ),
          ],
        ));
  }

  Widget buildBody(BuildContext context, List<ModelCommentResponse> commentList) {
    return Expanded(
        child: Container(
            color: Color(0xffe3e2e2),
            child: Scrollbar(
              controller: controller.scrollController,
              child: ListView(
                controller: controller.scrollController,
                scrollDirection: Axis.vertical,
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                // primary: true,
                children: [
                  commentList.isEmpty
                      ? Container(height: 3.h, color: backGroundColor)
                      : buildComment(context, commentList)
                ],
              ),
            )));
  }

  Wrap buildComment(BuildContext context, List<ModelCommentResponse> commentList) {
    return Wrap(
        direction: Axis.vertical,
        // 정렬 방향
        alignment: WrapAlignment.start,
        children: commentList
            .map<Widget>((comment) => Wrap(
                direction: Axis.vertical,
                // 정렬 방향
                alignment: WrapAlignment.start,
                children: [mainComment(context, comment), replyComment(context, comment)]))
            .toList());
  }

  Container mainComment(BuildContext context, ModelCommentResponse comment) {
    return Container(
        width: 100.w,
        padding:
            EdgeInsets.symmetric(vertical: FetchPixels.getPixelHeight(0), horizontal: FetchPixels.getPixelWidth(20)),
        decoration: const BoxDecoration(
            color: Colors.white, border: Border(bottom: BorderSide(color: Color(0xfff1f1f1), width: 0.8))),
        child: innerComment(context, comment, Colors.white));
  }

  Container replyComment(BuildContext context, ModelCommentResponse parentComment) {
    return Container(
        color: parentComment.childComments.isEmpty ? backGroundColor : Color(0xfff4f4f4),
        child: Column(
            children: parentComment.childComments
                .map<Widget>((comment) => Container(
                    width: 100.w,
                    margin: EdgeInsets.only(left: FetchPixels.getPixelWidth(40)),
                    padding: EdgeInsets.only(right: FetchPixels.getPixelWidth(60)),
                    decoration: const BoxDecoration(
                        color: Color(0xfff4f4f4),
                        border: Border(bottom: BorderSide(color: Color(0xffe5e4e4), width: 0.8))),
                    child: innerComment(context, comment, const Color(0xfff4f4f4))))
                .toList()));
  }

  Column innerComment(BuildContext context, ModelCommentResponse comment, Color commentMenuBtnColor) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
      getVerSpace(FetchPixels.getPixelHeight(10)),
      Row(children: [
        GestureDetector(
            onTap: () async {
              String? myId = await PrefData.getMemberId();
              if (myId == comment.comment.memberId) {
                Get.offAllNamed(Routes.tabProfilePath);
              } else {
                Get.toNamed(Routes.profilePath, parameters: {'memberId': comment.comment.memberId});
              }
            },
            child: getCustomFont(comment.commentWriterNickName ?? "", 13, Colors.blueGrey, 1,
                fontWeight: FontWeight.w500)),
        getCustomFont(comment.myComment ? "*" : "", 13, Colors.red, 1, fontWeight: FontWeight.w400)
      ]),
      getVerSpace(FetchPixels.getPixelHeight(7)),
      getCustomFont(comment.comment.body ?? "", 15, comment.deleted ? Colors.black45 : Colors.black, 20,
          fontWeight: FontWeight.w400, txtHeight: 1.5),
      getVerSpace(FetchPixels.getPixelHeight(5)),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(children: [
          getCustomFont(
              "${DateFormat('yyyy.MM.dd. HH:mm').format(comment.comment.updatedAt!)}      ${comment.timeDiffForUi}",
              12,
              Colors.black54,
              1,
              fontWeight: FontWeight.w400),
          getHorSpace(FetchPixels.getPixelHeight(10)),
          // getSimpleTextButton("답글 쓰기", 12, Colors.black54, commentMenuBtnColor, FontWeight.w400,
          //     FetchPixels.getPixelWidth(75), FetchPixels.getPixelHeight(25), () {
          //   print("답글쓰기 버튼 클릭");
          // })
        ]),
        comment.deleted || !comment.myComment
            ? Container(width: FetchPixels.getPixelHeight(50), height: FetchPixels.getPixelHeight(30))
            : getSimpleImageButton(
                "ellipsis_horizontal_outline_comment.svg",
                FetchPixels.getPixelHeight(50),
                FetchPixels.getPixelHeight(30),
                commentMenuBtnColor,
                FetchPixels.getPixelHeight(15),
                FetchPixels.getPixelHeight(15),
                () {
                  showModalBottomSheet(context: context, isScrollControlled: true, builder: (_) => CommentBottomSheet())
                      .then((menu) {
                    if (menu != null) {
                      switch (menu) {
                        case "수정하기":
                          {
                            clickedModifyComment(context, comment);
                            // Get.toNamed("${Routes.communityAddPath}?postId=${controller.postId}");
                            break;
                          }
                        case "삭제하기":
                          {
                            clickedRemoveComment(comment);
                            break;
                          }
                      }
                    }
                  });
                },
              )
      ]),
      getVerSpace(FetchPixels.getPixelHeight(10))
    ]);
  }

  Container buildBottom(BuildContext context) {
    double size = FetchPixels.getPixelHeight(50);
    double iconSize = FetchPixels.getPixelHeight(26);

    return Container(
        height: FetchPixels.getPixelHeight(55),
        // color: Colors.white,
        decoration: const BoxDecoration(
            color: Colors.white, border: Border(top: BorderSide(color: Color(0xffd3d3d3), width: 0.8))),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Expanded(
              child: getDefaultTextFiledWithLabel2(
            context,
            controller.modifyCommentMode ? "답글을 수정 해주세요." : "답글을 남겨주세요.",
            Colors.black45.withOpacity(0.3),
            controller.commentController,
            Colors.grey,
            16,
            FontWeight.w400,
            function: () {},
            isEnable: false,
            withprefix: false,
            minLines: true,
            height: FetchPixels.getPixelHeight(50),
            alignmentGeometry: Alignment.center,
            myFocusNode: commentFocusNode,
            boxColor: backGroundColor,
          )),
          getSimpleTextButton(
              controller.modifyCommentMode ? "수정" : "등록",
              16,
              controller.canRegisterComment ? secondMainColor : Colors.grey.shade400,
              Colors.white,
              FontWeight.w400,
              FetchPixels.getPixelHeight(80),
              FetchPixels.getPixelHeight(50), () async {
            if (controller.modifyCommentMode) {
              controller.modifyComment().then((value) => commentKeyboardDown(context));
            } else {
              controller.addComment().then((value) => commentKeyboardDown(context));
            }
          })
        ]));
  }

  clickedModifyComment(BuildContext context, ModelCommentResponse comment) async {
    if (comment.deleted) {
      Get.dialog(ErrorDialog("삭제된 댓글은 수정할 수 없습니다."));
      return;
    }
    // controller.commentModify(comment);
    controller.executeModifyCommentMode(comment).then((value) => commentKeyboardUp(context));
  }

  clickedRemoveComment(ModelCommentResponse comment) async {
    if (comment.deleted) {
      Get.dialog(ErrorDialog("이미 삭제된 댓글입니다."));
      return;
    }

    bool result = await Get.dialog(ReConfirmDialog("댓글을 삭제 하시겠습니까?", "삭제", "취소", () async {
      controller.removeComment(comment.comment.commentId).then((result) => Get.back(result: result));
    }));

    if (result) {
      controller.getComment();
    } else {
      Get.dialog(ErrorDialog("잠시 후 다시 시도해주세요."));
    }
  }

  commentKeyboardUp(BuildContext context) {
    FocusScope.of(context)?.requestFocus(commentFocusNode);
  }

  commentKeyboardDown(BuildContext context) {
    FocusScope.of(context).unfocus();
  }
}
