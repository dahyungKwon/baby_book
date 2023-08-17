import 'package:baby_book/app/models/model_post.dart';
import 'package:baby_book/app/models/model_post_file.dart';
import 'package:baby_book/app/repository/book_repository.dart';
import 'package:baby_book/app/repository/comment_repository.dart';
import 'package:baby_book/app/repository/post_feedback_repository.dart';
import 'package:baby_book/app/view/community/comment_bottom_sheet.dart';
import 'package:baby_book/app/view/community/post_detail_bottom_sheet.dart';
import 'package:baby_book/app/view/community/post_type.dart';
import 'package:baby_book/app/view/dialog/re_confirm_dialog.dart';
import 'package:baby_book/app/view/home/home_screen.dart';
import 'package:baby_book/base/pref_data.dart';
import 'package:baby_book/base/skeleton.dart';
import 'package:baby_book/base/color_data.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';
import 'package:sizer/sizer.dart';

import '../../../base/uuid_util.dart';
import '../../controller/CommunityDetailController.dart';
import '../../controller/CommunityListController.dart';
import '../../controller/TabCommunityController.dart';
import '../../models/model_comment_response.dart';
import '../../models/model_kakao_link_template.dart';
import '../../repository/post_repository.dart';
import '../../routes/app_pages.dart';
import '../dialog/error_dialog.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class CommunityDetailScreen extends GetView<CommunityDetailController> {
  FocusNode commentFocusNode = FocusNode();
  late final String? postId;
  late final String? uniqueTag;
  late final bool sharedMode;

  CommunityDetailScreen({super.key}) {
    // Get.delete<CommunityDetailController>();
    postId = Get.parameters['postId']!;
    uniqueTag = getUuid();
    sharedMode = Get.parameters['sharedType'] != null;

    Get.put(
        CommunityDetailController(
            postRepository: PostRepository(),
            commentRepository: CommentRepository(),
            postFeedbackRepository: PostFeedbackRepository(),
            bookRepository: BookRepository(),
            postId: postId!),
        tag: uniqueTag);
    print("AppSchemeImpl CommunityDetailScreen sharedType : ${Get.parameters['sharedType']}");
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
              // Future.delayed(const Duration(milliseconds: 500), () {
              //   commentKeyboardDown(context);
              // });
            }));
          } else if (sharedMode) {
            print("AppSchemeImpl sharedMode :$sharedMode get off");
            Get.off(() => HomeScreen(2));
          } else {
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
                        child: Column(children: [
                          buildTop(context, controller.post),
                          buildBody(context, controller.post, controller.commentList)
                        ]))))));
  }

  Widget buildTop(BuildContext context, ModelPost post) {
    return Container(
        padding: const EdgeInsets.fromLTRB(5, 10, 0, 0),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            getSimpleImageButton("back_outline.svg", FetchPixels.getPixelHeight(50), FetchPixels.getPixelHeight(50),
                Colors.white, FetchPixels.getPixelHeight(26), FetchPixels.getPixelHeight(26), () async {
              if (controller.modifyCommentMode) {
                await Get.dialog(ReConfirmDialog("댓글 수정을 종료하시겠습니까?", "네", "아니오", () async {
                  controller.exitModifyCommentMode();
                  Get.back();
                  // Future.delayed(const Duration(milliseconds: 500), () {
                  //   commentKeyboardDown(context);
                  // });
                }));
              } else if (sharedMode) {
                print("AppSchemeImpl sharedMode :$sharedMode get off");
                Get.off(() => HomeScreen(2));
              } else {
                Get.back();
              }
            }),
            Row(children: [
              // getSimpleImageButton("notification.svg", FetchPixels.getPixelHeight(50), FetchPixels.getPixelHeight(50),
              //     FetchPixels.getPixelHeight(26), FetchPixels.getPixelHeight(26), () {
              //   Get.toNamed(Routes.notificationPath);
              // }),
              // getHorSpace(FetchPixels.getPixelHeight(5)),
              getSimpleImageButton(
                  controller.bookmark ? "bookmark_checked.svg" : "bookmark_unchecked.svg",
                  FetchPixels.getPixelHeight(50),
                  FetchPixels.getPixelHeight(50),
                  Colors.white,
                  FetchPixels.getPixelHeight(26),
                  FetchPixels.getPixelHeight(26), () {
                controller.clickBookmark();
              }),
              getHorSpace(FetchPixels.getPixelHeight(5)),
              getSimpleImageButton(
                  "ellipsis_horizontal_outline.svg",
                  FetchPixels.getPixelHeight(60),
                  FetchPixels.getPixelHeight(50),
                  Colors.white,
                  FetchPixels.getPixelHeight(26),
                  FetchPixels.getPixelHeight(26), () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => PostDetailBottomSheet(controller.post, controller.myPost)).then((menu) async {
                  if (menu != null) {
                    switch (menu) {
                      case "공유하기":
                        {
                          print("공유하기.......");
                          _share();
                          break;
                        }
                      case "수정하기":
                        {
                          bool result =
                              await Get.toNamed(Routes.communityAddPath, parameters: {"postId": controller.postId});
                          if (result) {
                            controller.init();
                          }
                          break;
                        }
                      case "삭제하기":
                        {
                          _clickedRemovePost();
                          break;
                        }
                    }
                    print(menu);
                    // controller.postType = selectedPostType;
                  }
                });
              }, containerPadding: EdgeInsets.only(right: FetchPixels.getPixelHeight(15))),
              getHorSpace(FetchPixels.getPixelHeight(0)),
            ])
          ],
        ));
  }

  _share() async {
    bool isKakaoTalkSharingAvailable = await ShareClient.instance.isKakaoTalkSharingAvailable();

    String template = "\"${controller.post.title}\" 글 보신적 있으세요?\n아기곰 책육아에서 글을 확인해보세요.";
    if (isKakaoTalkSharingAvailable) {
      print('카카오톡으로 공유 가능');
      try {
        Uri uri = await ShareClient.instance.shareDefault(
            template: ModelKakaoLinkTemplate.getTextTemplateForPost(
                template, ModelKakaoLinkTemplate.sharedTypeCommunity, controller.postId));
        await ShareClient.instance.launchKakaoTalk(uri);
        print('카카오톡 공유 완료');
      } catch (error) {
        print('카카오톡 공유 실패 $error');
      }
    } else {
      print('카카오톡 미설치: 웹 공유 기능 사용 권장');
      try {
        Uri shareUrl = await WebSharerClient.instance.makeDefaultUrl(
            template: ModelKakaoLinkTemplate.getTextTemplateForPost(
                template, ModelKakaoLinkTemplate.sharedTypeCommunity, controller.postId));
        await launchBrowserTab(shareUrl, popupOpen: true);
      } catch (error) {
        print('카카오톡 공유 실패 $error');
      }
      // 지원안할려고함 카톡 설치해야 공유가능하다고
    }
  }

  _clickedRemovePost() async {
    bool result = await Get.dialog(ReConfirmDialog("게시글을 삭제 하시겠습니까?", "삭제", "취소", () async {
      controller.removePost().then((result) => Get.back(result: result));
    }));

    if (result) {
      await Get.find<CommunityListController>().getAllForPullToRefresh(PostType.all);
      await Get.find<TabCommunityController>().changePosition(PostType.all);
      Get.back();
    } else {
      Get.dialog(ErrorDialog("잠시 후 다시 시도해주세요."));
    }
  }

  Widget buildBody(BuildContext context, ModelPost modelPost, List<ModelCommentResponse> commentList) {
    return Expanded(
        child: Scrollbar(
            controller: controller.scrollController,
            child: Container(
              color: Color(0xFFF5F6F8),
              child: ListView(
                controller: controller.scrollController,
                scrollDirection: Axis.vertical,
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                // primary: true,
                children: [
                  post(context, modelPost),
                  Container(height: FetchPixels.getPixelHeight(25), color: Color(0xFFF5F6F8)),
                  commentList.isEmpty
                      ? Container(height: 3.h, color: Color(0xFFF5F6F8))
                      : buildComment(context, commentList)
                ],
              ),
            )));
  }

  Widget post(BuildContext context, ModelPost modelPost) {
    return Container(
        // height: 50.h,
        // margin: EdgeInsets.only(bottom: FetchPixels.getPixelHeight(15)),
        padding:
            EdgeInsets.symmetric(vertical: FetchPixels.getPixelHeight(20), horizontal: FetchPixels.getPixelWidth(20)),
        decoration: const BoxDecoration(
            color: Colors.white, border: Border(bottom: BorderSide(color: Color(0xfff1f1f1), width: 0.8))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(children: [
              getCustomFont(modelPost.postType.desc ?? "", 14, modelPost.postType.color, 1,
                  fontWeight: FontWeight.w500),
              // getVerSpace(FetchPixels.getPixelHeight(6)),
              GestureDetector(
                  onTap: () async {
                    String? myId = await PrefData.getMemberId();
                    if (myId == modelPost.memberId) {
                      Get.offAllNamed(Routes.tabProfilePath);
                    } else {
                      Get.toNamed(Routes.profilePath, parameters: {'memberId': modelPost.memberId});
                    }
                  },
                  child: getCustomFont(
                      " · ${modelPost.nickName} · ${modelPost.timeDiffForUi}" ?? "", 13, Colors.black45, 1,
                      fontWeight: FontWeight.w500))
            ]),
            getVerSpace(FetchPixels.getPixelHeight(20)),
            getCustomFont(modelPost.title ?? "", 24, Colors.black, 3, fontWeight: FontWeight.w600),
            getVerSpace(FetchPixels.getPixelHeight(8)),
            getCustomFont(modelPost.contents ?? "", 17, Colors.black87, 10000,
                fontWeight: FontWeight.w400, txtHeight: 1.5),
            getVerSpace(FetchPixels.getPixelHeight(20)),
            selectedLinkList(modelPost),
            getVerSpace(FetchPixels.getPixelHeight(20)),
            selectedBookTagList(modelPost),
            getVerSpace(FetchPixels.getPixelHeight(20)),
            selectedImageList(modelPost),
            getVerSpace(FetchPixels.getPixelHeight(30)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, //Center Row contents horizontally,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () {
                      controller.clickLiked();
                    },
                    child: Container(
                        height: FetchPixels.getPixelHeight(50),
                        color: Colors.white,
                        child: Row(children: [
                          getSvgImage(controller.liked ? "heart_selected.svg" : "heart.svg",
                              height: FetchPixels.getPixelHeight(25), width: FetchPixels.getPixelHeight(25)),
                          getHorSpace(FetchPixels.getPixelWidth(2)),
                          getCustomFont(numberFormat.format(modelPost.likeCount), 16,
                              controller.liked ? const Color(0xFFF65E5E) : Colors.black87, 1,
                              fontWeight: FontWeight.w400),
                          getHorSpace(FetchPixels.getPixelHeight(30))
                        ]))),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    getSimpleImageButton(
                        "chatbox_ellipses_outline.svg",
                        FetchPixels.getPixelHeight(40),
                        FetchPixels.getPixelHeight(50),
                        Colors.white,
                        FetchPixels.getPixelHeight(25),
                        FetchPixels.getPixelHeight(25),
                        () {}),
                    getHorSpace(FetchPixels.getPixelWidth(2)),
                    getCustomFont(numberFormat.format(modelPost.commentCount), 16, Colors.black87, 1,
                        fontWeight: FontWeight.w400),
                    getHorSpace(FetchPixels.getPixelHeight(30))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    getSimpleImageButton(
                        "eye_outline.svg",
                        FetchPixels.getPixelHeight(40),
                        FetchPixels.getPixelHeight(50),
                        Colors.white,
                        FetchPixels.getPixelHeight(25),
                        FetchPixels.getPixelHeight(25),
                        () {}),
                    getHorSpace(FetchPixels.getPixelWidth(2)),
                    getCustomFont(numberFormat.format(modelPost.viewCount), 16, Colors.black87, 1,
                        fontWeight: FontWeight.w400),
                    getHorSpace(FetchPixels.getPixelHeight(30))
                  ],
                ),
              ],
            ),
            getVerSpace(FetchPixels.getPixelHeight(10)),
          ],
        ));
  }

  GestureDetector selectedLinkList(ModelPost post) {
    return GestureDetector(
      onTap: () {
        if (post.existExternalLink()) {
          print("post externalLink:${post.externalLink}");
        }
      },
      child: SizedBox(
          child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              // scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              itemCount: post.existExternalLink() ? 1 : 0,
              itemBuilder: (context, index) {
                String link = post.externalLink!;
                return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // getVerSpace(FetchPixels.getPixelHeight(10)),
                      Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFFF5F6F8),
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                        ),
                        // margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
                        child: Text(link, style: TextStyle(fontSize: 13, color: Colors.blueAccent)),
                        // getVerSpace(FetchPixels.getPixelHeight(10)),
                        // getSvgImage("close_outline.svg", width: 15, height: 15),
                      ),
                      getVerSpace(FetchPixels.getPixelHeight(5))
                    ]);
              })),
    );
  }

  Wrap selectedBookTagList(ModelPost modelPost) {
    return Wrap(
        direction: Axis.horizontal,
        // 정렬 방향
        alignment: WrapAlignment.start,
        // 정렬 방식
        spacing: 1,
        // 상하(좌우) 공간
        runSpacing: 5,
        // 좌우(상하) 공간
        children: controller.selectedBookTagList
            .map<Widget>((e) => GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.bookDetailPath, parameters: {
                    'bookSetId': e.modelBook.id.toString(),
                    'babyId': controller.member.selectedBabyId ?? ""
                  });
                },
                child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFF5F6F8),
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
                    child: Text("#${e.modelBook.name}", style: TextStyle(fontSize: 15, color: Colors.blueAccent)))))
            .toList());
  }

  SizedBox selectedImageList(ModelPost post) {
    return SizedBox(
      child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          // scrollDirection: Axis.horizontal,
          padding: EdgeInsets.zero,
          itemCount: post.postFileList?.length,
          itemBuilder: (context, index) {
            ModelPostFile image = post.postFileList[index];
            return Stack(children: [
              // getVerSpace(FetchPixels.getPixelHeight(10)),
              Container(
                  constraints: BoxConstraints(
                    minHeight: 100, //minimum height
                    minWidth: 100.w, // minimum width

                    maxHeight: 800,
                    //maximum height set to 100% of vertical height

                    maxWidth: 100.w,
                    //maximum width set to 100% of width
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F6F8),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15.0),
                    ),
                  ),
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: ExtendedImage.network(image.postFileUrl,
                        // width: FetchPixels.getPixelHeight(double.infinity),
                        // height: FetchPixels.getPixelHeight(150),
                        fit: BoxFit.fill,
                        cache: true, loadStateChanged: (ExtendedImageState state) {
                      switch (state.extendedImageLoadState) {
                        case LoadState.loading:
                          return Image.asset("assets/images/img_placeholder.png", fit: BoxFit.fill);
                        case LoadState.completed:
                          break;
                        case LoadState.failed:
                          return Image.asset("assets/images/img_placeholder.png", fit: BoxFit.fill);
                      }
                    }),
                  )),
              getVerSpace(FetchPixels.getPixelHeight(5)),
            ]);
          }),
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
      getVerSpace(FetchPixels.getPixelHeight(10)),
      GestureDetector(
          onTap: () async {
            String? myId = await PrefData.getMemberId();
            if (myId == comment.comment.memberId) {
              Get.offAllNamed(Routes.tabProfilePath);
            } else {
              Get.toNamed(Routes.profilePath, parameters: {'memberId': comment.comment.memberId});
            }
          },
          child: Row(children: [
            getCustomFont(comment.commentWriterNickName ?? "", 13, Colors.blueGrey, 1, fontWeight: FontWeight.w500),
            getCustomFont(comment.myComment ? "*" : "", 13, Colors.red, 1, fontWeight: FontWeight.w400)
          ])),
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
          getSimpleTextButton("답글 쓰기", 12, Colors.black54, commentMenuBtnColor, FontWeight.w400,
              FetchPixels.getPixelWidth(75), FetchPixels.getPixelHeight(25), () async {
            bool changed = await Get.toNamed(Routes.commentDetailPath, parameters: {
              "postId": controller.postId,
              "commentId": comment.comment.commentParentId != null
                  ? comment.comment.commentParentId!
                  : comment.comment.commentId!,
              "title": controller.post.title
            });
            if (changed) {
              controller.getComment();
            }
          })
        ]),
        comment.deleted || !comment.myComment
            ? Container()
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
                      print(menu);
                      // controller.postType = selectedPostType;
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
            controller.modifyCommentMode ? "댓글을 수정 해주세요." : "댓글을 남겨주세요.",
            Colors.black45.withOpacity(0.3),
            controller.commentController,
            Colors.grey,
            FetchPixels.getPixelHeight(16),
            FontWeight.w400,
            function: () {},
            isEnable: false,
            withprefix: false,
            minLines: true,
            height: FetchPixels.getPixelHeight(60),
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
