import 'package:baby_book/app/repository/comment_repository.dart';
import 'package:baby_book/app/view/community/comment_bottom_sheet.dart';
import 'package:baby_book/app/view/dialog/re_confirm_dialog.dart';
import 'package:baby_book/base/skeleton.dart';
import 'package:baby_book/base/color_data.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../../base/pref_data.dart';
import '../../../../base/uuid_util.dart';
import '../../../controller/BookCommnetDetailController.dart';
import '../../../models/model_comment_response.dart';
import '../../../routes/app_pages.dart';
import '../../dialog/error_dialog.dart';
import 'package:flutter/foundation.dart' as foundation;

class BookCommentDetailScreen extends GetView<BookCommentDetailController> {
  FocusNode commentFocusNode = FocusNode();
  late final int? bookSetId;
  late final String? commentTargetId;
  late final String? uniqueTag;
  late final String? bookName;
  late final bool isCommentFocus;

  BookCommentDetailScreen({super.key}) {
    bookSetId = int.tryParse(Get.parameters['bookSetId']!);
    commentTargetId = Get.parameters['commentTargetId']!;
    bookName = Get.parameters['bookName']!;
    isCommentFocus = Get.parameters['isCommentFocus'] == "true";
    uniqueTag = getUuid();
    // Get.delete<CommentDetailController>();
    Get.put(
        BookCommentDetailController(
            commentRepository: CommentRepository(), bookSetId: bookSetId!, commentTargetId: commentTargetId!),
        tag: uniqueTag);
  }

  @override
  String? get tag => uniqueTag;

  backBtn(BuildContext context) async {
    EasyLoading.dismiss();

    if (controller.modifyCommentMode) {
      await Get.dialog(ReConfirmDialog("코멘트 수정을 종료하시겠습니까?", "네", "아니오", () async {
        controller.exitModifyCommentMode();
        Get.back();
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets edgeInsets = EdgeInsets.symmetric(
      horizontal: FetchPixels.getDefaultHorSpace(context),
    );
    FetchPixels(context);
    return Obx(() => WillPopScope(
        onWillPop: controller.modifyCommentMode
            ? () async {
                backBtn(context);
                return false;
              }
            : null,
        child: Scaffold(
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
                child: RefreshIndicator(
                    color: Colors.black87,
                    backgroundColor: Colors.white,
                    onRefresh: () async {
                      if (controller.modifyCommentMode) {
                        return;
                      }
                      controller.init();
                    },
                    child: Column(children: [buildTop(context), buildBody(context, controller.commentList)]))))));
  }

  Widget buildTop(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(5, 10, 0, 0),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            getSimpleImageButton("back_outline.svg", FetchPixels.getPixelHeight(50), FetchPixels.getPixelHeight(50),
                Colors.white, FetchPixels.getPixelHeight(26), FetchPixels.getPixelHeight(26), () async {
              backBtn(context);
            }),
            getCustomFont(
              "${bookName!}",
              18,
              Colors.black,
              1,
              fontWeight: FontWeight.w600,
            ),
          ],
        ));
  }

  Widget buildBody(BuildContext context, List<ModelCommentResponse> commentList) {
    EdgeInsets edgeInsets = EdgeInsets.symmetric(
      horizontal: FetchPixels.getDefaultHorSpace(context),
    );

    return controller.loading
        ? const Expanded(child: ListSkeleton())
        : commentList.isEmpty
            ? Expanded(child: getPaddingWidget(edgeInsets, nullListView(context)))
            : Expanded(
                child: Container(
                    color: Color(0xFFF5F6F8),
                    child: Scrollbar(
                      controller: controller.scrollController,
                      child: ListView(
                        controller: controller.scrollController,
                        scrollDirection: Axis.vertical,
                        physics: const AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        // primary: true,
                        children: [buildComment(context, commentList)],
                      ),
                    )));
  }

  Widget nullListView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // getSvgImage("clipboard.svg", height: FetchPixels.getPixelHeight(124), width: FetchPixels.getPixelHeight(124)),
        // getVerSpace(FetchPixels.getPixelHeight(40)),
        getCustomFont("한줄 코멘트를 등록해주세요.", FetchPixels.getPixelHeight(20), Colors.black, 1, fontWeight: FontWeight.w600),
        getVerSpace(FetchPixels.getPixelHeight(10)),
        getCustomFont(
          "여러분의 소중한 경험을 공유해주세요.",
          16,
          Colors.black45,
          1,
          fontWeight: FontWeight.w400,
        ),
        getVerSpace(FetchPixels.getPixelHeight(30)),
        //   getButton(context, backGroundColor, "글쓰러가기", Colors.black87, () {
        //     Get.toNamed("${Routes.communityAddPath}?postType=${memberPostType.code}");
        //   }, 18,
        //       weight: FontWeight.w600,
        //       buttonHeight: FetchPixels.getPixelHeight(60),
        //       insetsGeometry: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(120)),
        //       borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(14)),
        //       isBorder: true,
        //       borderColor: Colors.grey,
        //       borderWidth: 1.5)
      ],
    );
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
      getVerSpace(FetchPixels.getPixelHeight(15)),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(
          children: [
            GestureDetector(
                onTap: () async {
                  String? myId = await PrefData.getMemberId();
                  if (myId == comment.comment.memberId) {
                    Get.offAllNamed(Routes.tabProfilePath);
                  } else {
                    Get.toNamed(Routes.profilePath, parameters: {'memberId': comment.comment.memberId});
                  }
                },
                child: getCustomFont(comment.commentWriterNickName ?? "", 12, Colors.black54, 1,
                    fontWeight: FontWeight.w500)),
            getCustomFont(comment.myComment ? "*" : "", 12, Colors.red, 1, fontWeight: FontWeight.w400),
            getHorSpace(FetchPixels.getPixelHeight(5)),
            getCustomFont(DateFormat('yyyy.MM.dd').format(comment.comment.updatedAt!), 12, Colors.black54, 1,
                fontWeight: FontWeight.w400),
          ],
        ),
        comment.deleted || !comment.myComment
            ? Container(width: FetchPixels.getPixelHeight(50), height: FetchPixels.getPixelHeight(30))
            : getSimpleImageButton(
                "ellipsis_horizontal_outline_comment.svg",
                FetchPixels.getPixelHeight(50),
                FetchPixels.getPixelHeight(30),
                commentMenuBtnColor,
                FetchPixels.getPixelHeight(15),
                FetchPixels.getPixelHeight(15),
                () async {
                  if (controller.modifyCommentMode) {
                    await Get.dialog(ReConfirmDialog("코멘트 수정을 종료하시겠습니까?", "네", "아니오", () async {
                      controller.exitModifyCommentMode();
                      Get.back();
                      Future.delayed(const Duration(milliseconds: 500), () {
                        commentKeyboardDown(context);
                      });
                    }));
                  } else {
                    showModalBottomSheet(
                        context: context, isScrollControlled: true, builder: (_) => CommentBottomSheet()).then((menu) {
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
                  }
                },
              )
      ]),
      getVerSpace(FetchPixels.getPixelHeight(5)),
      getCustomFont(comment.comment.body ?? "", 17, comment.deleted ? Colors.black45 : Colors.black, 20,
          fontWeight: FontWeight.w400),
      getVerSpace(FetchPixels.getPixelHeight(20)),
    ]);
  }

  Container buildBottom(BuildContext context) {
    double size = FetchPixels.getPixelHeight(50);
    double iconSize = FetchPixels.getPixelHeight(26);

    return Container(
        height: FetchPixels.getPixelHeight(65),
        // color: Colors.white,
        margin: EdgeInsets.only(
            bottom:
                FetchPixels.getPixelHeight(foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS ? 20 : 0)),
        decoration: const BoxDecoration(
            color: Colors.white, border: Border(top: BorderSide(color: Color(0xffd3d3d3), width: 0.8))),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Expanded(
              child: getDefaultTextFiledWithLabel2(
            context,
            controller.modifyCommentMode ? "한줄 코멘트를 수정 해주세요." : "한줄 코멘트를 등록해주세요.",
            Colors.black45.withOpacity(0.3),
            controller.commentController,
            Colors.grey,
            16,
            FontWeight.w400,
            function: () {},
            isEnable: false,
            withprefix: false,
            minLines: true,
            height: FetchPixels.getPixelHeight(60),
            alignmentGeometry: Alignment.center,
            myFocusNode: commentFocusNode,
            autofocus: isCommentFocus ? true : false,
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
      Get.dialog(ErrorDialog("삭제된 코멘트는 수정할 수 없습니다."));
      return;
    }
    // controller.commentModify(comment);
    controller.executeModifyCommentMode(comment).then((value) => commentKeyboardUp(context));
  }

  clickedRemoveComment(ModelCommentResponse comment) async {
    if (comment.deleted) {
      Get.dialog(ErrorDialog("이미 삭제된 코멘트입니다."));
      return;
    }

    bool result = await Get.dialog(ReConfirmDialog("한줄 코멘트를 삭제 하시겠습니까?", "삭제", "취소", () async {
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
