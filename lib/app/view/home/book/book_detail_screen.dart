import 'package:baby_book/app/controller/BookDetailController.dart';
import 'package:baby_book/app/models/model_my_book.dart';
import 'package:baby_book/app/models/model_post.dart';
import 'package:baby_book/app/repository/my_book_repository.dart';
import 'package:baby_book/app/repository/post_repository.dart';
import 'package:baby_book/app/view/home/book/book_experience_bottom_sheet.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:intl/intl.dart';
import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../base/color_data.dart';
import '../../../../base/pref_data.dart';
import '../../../../base/skeleton.dart';
import '../../../../base/uuid_util.dart';
import '../../../models/model_comment_response.dart';
import '../../../models/model_kakao_link_template.dart';
import '../../../repository/book_repository.dart';
import '../../../repository/comment_repository.dart';
import '../../../routes/app_pages.dart';
import '../../dialog/error_dialog.dart';
import '../../dialog/re_confirm_dialog.dart';
import '../home_screen.dart';
import 'HoldType.dart';
import 'UsedType.dart';
import 'book_detail_bottom_sheet.dart';
import 'package:flutter/foundation.dart' as foundation;

class BookDetailScreen extends GetView<BookDetailController> {
  late final int? bookSetId;
  late final String? babyId;
  late final String? uniqueTag;

  late bool sharedMode;
  var f = NumberFormat('###,###,###,###');

  BookDetailScreen({super.key}) {
    bookSetId = int.parse(Get.parameters['bookSetId']!);
    babyId = Get.parameters['babyId'];
    uniqueTag = getUuid();

    Get.put(
        BookDetailController(
            bookRepository: BookRepository(),
            myBookRepository: MyBookRepository(),
            commentRepository: CommentRepository(),
            postRepository: PostRepository(),
            bookSetId: bookSetId!,
            babyId: babyId),
        tag: uniqueTag);
    sharedMode = Get.parameters['sharedType'] != null;
    print("AppSchemeImpl BookDetailScreen : $bookSetId sharedType  : ${Get.parameters['sharedType']}");
  }

  @override
  String? get tag => uniqueTag;

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    double defHorSpace = FetchPixels.getDefaultHorSpace(context);
    EdgeInsets edgeInsets = EdgeInsets.symmetric(horizontal: defHorSpace);
    return WillPopScope(
        onWillPop: () async {
          if (sharedMode) {
            print("AppSchemeImpl BookDetailScreen sharedMode :$sharedMode get off");
            Get.off(() => HomeScreen(0));
          } else {
            Get.back(result: controller.myBookResponse);
          }
          return false;
        },
        child: Obx(() => controller.loading
            ? const FullSizeSkeleton()
            : Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: backGroundColor,
                bottomNavigationBar: Container(
                    height: FetchPixels.getPixelHeight(65),
                    padding: EdgeInsets.only(
                        top: FetchPixels.getPixelHeight(8),
                        bottom: FetchPixels.getPixelHeight(8),
                        left: FetchPixels.getPixelWidth(10),
                        right: FetchPixels.getPixelWidth(10)),
                    margin: EdgeInsets.only(
                        bottom: FetchPixels.getPixelHeight(
                            foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS ? 20 : 0)),
                    decoration: const BoxDecoration(
                        color: Colors.white, border: Border(top: BorderSide(color: Color(0xffd3d3d3), width: 0.8))),
                    child: Container(
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                              onTap: () async {
                                if (controller.like) {
                                  bool result = await controller.clickCancelLike();
                                  if (result) {
                                    controller.like = false;
                                    controller.likeCount -= 1;
                                  }
                                } else {
                                  bool result = await controller.clickLike();
                                  if (result) {
                                    controller.like = true;
                                    controller.likeCount += 1;
                                  }
                                }
                              },
                              child: Container(
                                  color: Colors.transparent,
                                  width: FetchPixels.getPixelWidth(80),
                                  padding: EdgeInsets.only(right: FetchPixels.getPixelWidth(10)),
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        controller.likeCount > 0
                                            ? getSvgImage(controller.like ? "heart_selected.svg" : "heart.svg",
                                                height: FetchPixels.getPixelHeight(20),
                                                width: FetchPixels.getPixelHeight(20))
                                            : getSvgImage(controller.like ? "heart_selected.svg" : "heart.svg",
                                                height: FetchPixels.getPixelHeight(25),
                                                width: FetchPixels.getPixelHeight(25)),
                                        getVerSpace(FetchPixels.getPixelWidth(5)),
                                        controller.likeCount > 0
                                            ? getCustomFont(controller.getLikeCount(), 14,
                                                controller.like ? const Color(0xFFF65E5E) : Colors.black54, 1,
                                                fontWeight: FontWeight.w400)
                                            : Container(),
                                      ]))),
                          Expanded(
                            child: GestureDetector(
                                onTap: () {
                                  buildBookExperience(context);
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: controller.myBookResponse.myBook.holdType.color,
                                      borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(6)),
                                      boxShadow: const [
                                        BoxShadow(color: Colors.black12, blurRadius: 1, offset: Offset(0.0, 0.0)),
                                      ],
                                    ),
                                    height: FetchPixels.getPixelHeight(80),
                                    // color: controller.myBookResponse.myBook.holdType.color,
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        // crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          getSvgImage(
                                              controller.myBook
                                                  ? controller.myBookResponse.myBook.holdType.image
                                                  : "add_bookcase.svg",
                                              width: FetchPixels.getPixelHeight(15),
                                              height: FetchPixels.getPixelHeight(20)),
                                          getHorSpace(FetchPixels.getPixelHeight(10)),
                                          getCustomFont(
                                              controller.myBook
                                                  ? controller.myBookResponse.myBook.holdType.desc
                                                  : "책장에 담기",
                                              16,
                                              Colors.white,
                                              1,
                                              fontWeight: FontWeight.w500),
                                        ]))),
                          )
                        ],
                      ),
                    )),
                body: SafeArea(
                  child: Column(
                    children: [
                      // getVerSpace(FetchPixels.getPixelHeight(20)),
                      buildToolbar(context),
                      getVerSpace(FetchPixels.getPixelHeight(10)),
                      buildMainArea(context, edgeInsets, defHorSpace)
                    ],
                  ),
                ),
              )));
  }

  buildBookExperience(BuildContext context) {
    ///책장에 있는 상태에서 빼려고하다가 취소한경우 원복하기 위한 용도
    controller.lastHoldType = controller.myBookResponse.myBook.holdType;
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => BookExperienceBottomSheet(
              mybook: controller.myBookResponse.myBook,
            )).then((obj) {
      // ModelMyBook mybook = Get.find<BookExperienceBottomSheetController>(
      //         tag: controller.bookSetId.toString())
      //     .mybook;
      ModelMyBook mybook = controller.myBookResponse.myBook;
      if (mybook == null) {
        return;
      }
      if (mybook.myBookId != "" && mybook.holdType == HoldType.none) {
        /// 책 경험 있었는데 없어진 경우 (책경험 제거하려는 목적)
        _clickedRemoveBook();
      } else if (mybook.myBookId == "" && mybook.holdType != HoldType.none) {
        ///책경험이 없었는데 신규로 추가된 경우
        controller.addMyBook(mybook);
      } else if (mybook.myBookId == "" && mybook.holdType == HoldType.none) {
        ///아무것도 안한경우
        print("선택안함");
      } else {
        mybook.changedHoldType();

        ///그외는 모두 수정
        controller.modifyMyBook(mybook);
      }
    }).whenComplete(() => {print("end")});
  }

  Widget buildToolbar(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(5, 10, 0, 0),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            getSimpleImageButton("back_outline.svg", FetchPixels.getPixelHeight(50), FetchPixels.getPixelHeight(50),
                Colors.white, FetchPixels.getPixelHeight(26), FetchPixels.getPixelHeight(26), () {
              if (sharedMode) {
                print("AppSchemeImpl BookDetailScreen sharedMode :$sharedMode get off");
                Get.off(() => HomeScreen(0));
              } else {
                Get.back();
              }
            }),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // getVerSpace(FetchPixels.getPixelHeight(20)),
                getSimpleImageButton(
                    "ellipsis_horizontal_outline.svg",
                    FetchPixels.getPixelHeight(60),
                    FetchPixels.getPixelHeight(40),
                    Colors.white,
                    FetchPixels.getPixelHeight(26),
                    FetchPixels.getPixelHeight(26), () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => BookDetailBottomSheet(myBook: controller.myBook)).then((menu) {
                    if (menu != null) {
                      switch (menu) {
                        case "책 공유하기":
                          {
                            print("공유하기.......");
                            _share();
                            break;
                          }
                        case "책경험 수정하기":
                          {
                            buildBookExperience(context);
                            // clickedModifyComment(context, comment);
                            // Get.toNamed("${Routes.communityAddPath}?postId=${controller.postId}");
                            break;
                          }
                        case "책장에서 삭제하기":
                          {
                            _clickedRemoveBook();
                            break;
                          }
                      }
                    }
                  });
                }, containerPadding: EdgeInsets.only(right: FetchPixels.getPixelHeight(15))),
              ],
            )
          ],
        ));
  }

  _clickedRemoveBook() async {
    bool? result = await Get.dialog(ReConfirmDialog("책장에서 삭제하시겠습니까?", "삭제", "취소", () async {
      controller.removeMyBook().then((result) => Get.back(result: result));
    }));

    if (result == null) {
      ///취소선택
      controller.myBookResponse.myBook.holdType = controller.lastHoldType;
      return;
    } else if (result) {
      Get.reload();
    } else {
      Get.dialog(ErrorDialog("잠시 후 다시 시도해주세요."));
    }
  }

  _share() async {
    bool isKakaoTalkSharingAvailable = await ShareClient.instance.isKakaoTalkSharingAvailable();

    String template =
        "\"${controller.book.modelPublisher.publisherName} ${controller.book.modelBook.name}\" 책 보신적 있으세요?\n아기곰 책육아에서 책을 확인해보세요.";
    if (isKakaoTalkSharingAvailable) {
      print('카카오톡으로 공유 가능');
      try {
        Uri uri = await ShareClient.instance.shareDefault(
            template: ModelKakaoLinkTemplate.getTextTemplateForBook(
                template, ModelKakaoLinkTemplate.sharedTypeBook, controller.bookSetId));
        await ShareClient.instance.launchKakaoTalk(uri);
        print('카카오톡 공유 완료');
      } catch (error) {
        print('카카오톡 공유 실패 $error');
      }
    } else {
      print('카카오톡 미설치: 웹 공유 기능 사용 권장');
      try {
        Uri shareUrl = await WebSharerClient.instance.makeDefaultUrl(
            template: ModelKakaoLinkTemplate.getTextTemplateForBook(
                template, ModelKakaoLinkTemplate.sharedTypeBook, controller.bookSetId));
        await launchBrowserTab(shareUrl, popupOpen: true);
      } catch (error) {
        print('카카오톡 공유 실패 $error');
      }
      // 지원안할려고함 카톡 설치해야 공유가능하다고
    }
  }

  Widget buildTop(BuildContext context, EdgeInsets edgeInsets) {
    return Obx(() => Container(
          padding: EdgeInsets.only(
              top: FetchPixels.getPixelHeight(0),
              bottom: FetchPixels.getPixelHeight(5),
              left: FetchPixels.getPixelWidth(20),
              right: FetchPixels.getPixelWidth(20)),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                    child: controller.book.existFirstImg()
                        ? ExtendedImage.network(controller.book.getFirstImg(),
                            width: FetchPixels.getPixelHeight(double.infinity),
                            height: FetchPixels.getPixelHeight(150),
                            fit: BoxFit.fitHeight,
                            cache: true, loadStateChanged: (ExtendedImageState state) {
                            switch (state.extendedImageLoadState) {
                              case LoadState.loading:
                                return Image.asset(controller.book.getPlaceHolderImg(), fit: BoxFit.fill);
                              case LoadState.completed:
                                break;
                              case LoadState.failed:
                                return Image.asset(controller.book.getPlaceHolderImg(), fit: BoxFit.fill);
                            }
                          })
                        : Container()),
              ),
              getVerSpace(FetchPixels.getPixelHeight(30)),
              Column(
                children: [
                  GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.publisherPath, parameters: {
                          'publisherId': controller.book.modelPublisher.publisherId.toString(),
                          'publisherName': controller.book.modelPublisher.publisherName
                        });
                      },
                      child: getCustomFont(controller.book.modelPublisher.publisherName ?? "", 16, textColor, 1,
                          fontWeight: FontWeight.w400)),
                  getVerSpace(FetchPixels.getPixelHeight(5)),
                  getCustomFont(controller.book.modelBook.name ?? "", 24, Colors.black, 1, fontWeight: FontWeight.w700),

                  // getSvgImage("question.svg",
                  //     width: FetchPixels.getPixelHeight(24), height: FetchPixels.getPixelHeight(24))
                ],
              ),
              getVerSpace(FetchPixels.getPixelHeight(30)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.bookMemberPath, parameters: {
                          'bookId': controller.book.modelBook.id.toString(),
                          'bookName': controller.book.modelBook.name,
                        });
                      },
                      child: Container(
                          width: FetchPixels.getPixelHeight(100),
                          height: FetchPixels.getPixelHeight(80),
                          color: Colors.white,
                          child: Column(
                            children: [
                              getSvgImage("book.svg",
                                  width: FetchPixels.getPixelHeight(25), height: FetchPixels.getPixelHeight(25)),
                              getVerSpace(FetchPixels.getPixelHeight(5)),
                              getCustomFont(
                                "읽는중" ?? "",
                                12,
                                Colors.black54,
                                1,
                                fontWeight: FontWeight.w500,
                              ),
                              getVerSpace(FetchPixels.getPixelHeight(5)),
                              getCustomFont(
                                "${controller.bookMember.count}명" ?? "",
                                16,
                                Colors.black,
                                1,
                                fontWeight: FontWeight.w600,
                              )
                            ],
                          ))),
                  GestureDetector(
                      onTap: () async {
                        bool changed = await Get.toNamed(Routes.bookCommentDetailPath, parameters: {
                          'commentTargetId': controller.bookSetCommentId!,
                          'bookName': controller.book.modelBook.name,
                          'isCommentFocus': false.toString()
                        });
                        if (changed) {
                          controller.requestComment();
                        }
                      },
                      child: Container(
                          width: FetchPixels.getPixelHeight(100),
                          height: FetchPixels.getPixelHeight(80),
                          color: Colors.white,
                          child: Column(
                            children: [
                              getSvgImage("one_comment_black.svg",
                                  width: FetchPixels.getPixelHeight(25), height: FetchPixels.getPixelHeight(25)),
                              getVerSpace(FetchPixels.getPixelHeight(5)),
                              getCustomFont(
                                "한줄 코멘트" ?? "",
                                12,
                                Colors.black54,
                                1,
                                fontWeight: FontWeight.w500,
                              ),
                              getVerSpace(FetchPixels.getPixelHeight(5)),
                              getCustomFont(
                                "${controller.commentList.length}개" ?? "",
                                16,
                                Colors.black,
                                1,
                                fontWeight: FontWeight.w600,
                              )
                            ],
                          ))),
                  GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.bookCommunityPath, parameters: {
                          'bookId': controller.book.modelBook.id.toString(),
                          'bookName': controller.book.modelBook.name
                        });
                      },
                      child: Container(
                          width: FetchPixels.getPixelHeight(100),
                          height: FetchPixels.getPixelHeight(80),
                          color: Colors.white,
                          child: Column(
                            children: [
                              getSvgImage("chatbubbles.svg",
                                  width: FetchPixels.getPixelHeight(25), height: FetchPixels.getPixelHeight(25)),
                              getVerSpace(FetchPixels.getPixelHeight(5)),
                              getCustomFont(
                                "커뮤니티글" ?? "",
                                12,
                                Colors.black54,
                                1,
                                fontWeight: FontWeight.w500,
                              ),
                              getVerSpace(FetchPixels.getPixelHeight(5)),
                              getCustomFont(
                                "${controller.postTag.count}개" ?? "",
                                16,
                                Colors.black,
                                1,
                                fontWeight: FontWeight.w600,
                              )
                            ],
                          )))
                ],
              ),
              getVerSpace(FetchPixels.getPixelHeight(10)),
            ],
          ),
        ));
  }

  Expanded buildMainArea(BuildContext context, EdgeInsets edgeInsets, double defHorSpace) {
    return Expanded(
      flex: 1,
      child: ListView(
        primary: true,
        shrinkWrap: true,
        children: [
          buildTop(context, edgeInsets),
          Container(height: FetchPixels.getPixelHeight(15), color: Color(0xFFF5F6F8)),
          controller.myBook ? buildMyBook(context, edgeInsets) : Container(),
          controller.myBook ? Container(height: FetchPixels.getPixelHeight(15), color: Color(0xFFF5F6F8)) : Container(),
          controller.hasAward ? buildAward(context, edgeInsets) : Container(),
          controller.hasAward
              ? Container(height: FetchPixels.getPixelHeight(15), color: Color(0xFFF5F6F8))
              : Container(),
          buildBookInfo(context, edgeInsets),
          Container(height: FetchPixels.getPixelHeight(15), color: Color(0xFFF5F6F8)),
          buildOneComment(context, edgeInsets),
          Container(height: FetchPixels.getPixelHeight(15), color: Color(0xFFF5F6F8)),
          buildCommunity(context, edgeInsets),
          Container(height: FetchPixels.getPixelHeight(15), color: Color(0xFFF5F6F8)),
          // buildDown(edgeInsets, context),
        ],
      ),
    );
  }

  Widget buildMyBook(BuildContext context, EdgeInsets edgeInsets) {
    return Obx(() =>
        Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
          GestureDetector(
              onTap: () {
                if (controller.myBookContainerSwitch) {
                  controller.myBookContainerSwitch = false;
                } else {
                  controller.myBookContainerSwitch = true;
                }
              },
              child: Container(
                  margin: EdgeInsets.only(top: FetchPixels.getPixelHeight(5), bottom: FetchPixels.getPixelHeight(5)),
                  padding: EdgeInsets.only(
                      top: FetchPixels.getPixelHeight(10),
                      bottom: FetchPixels.getPixelHeight(10),
                      left: FetchPixels.getPixelWidth(20),
                      right: FetchPixels.getPixelWidth(20)),
                  color: Colors.white,
                  height: FetchPixels.getPixelHeight(50),
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          getCustomFont(
                            "책경험",
                            20,
                            Colors.black,
                            1,
                            fontWeight: FontWeight.w500,
                          ),
                          getHorSpace(FetchPixels.getPixelHeight(5)),
                        ],
                      ),
                      getSvgImage(controller.myBookContainerSwitch ? "down_arrow.svg" : "up_arrow.svg",
                          height: FetchPixels.getPixelHeight(20), width: FetchPixels.getPixelHeight(20)),
                    ],
                  )))),
          controller.myBookContainerSwitch
              ? GestureDetector(
                  onTap: () {
                    buildBookExperience(context);
                  },
                  child: Container(
                      padding: EdgeInsets.only(
                          top: FetchPixels.getPixelHeight(0),
                          bottom: FetchPixels.getPixelHeight(10),
                          left: FetchPixels.getPixelWidth(20),
                          right: FetchPixels.getPixelWidth(20)),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildBookInfoRow("상태", controller.myBookResponse.myBook.holdType.desc,
                                      valueColor: controller.myBookResponse.myBook.holdType.color),
                                  getVerSpace(FetchPixels.getPixelHeight(15)),
                                  if (controller.myBookResponse.myBook.holdType == HoldType.plan) ...[
                                    buildBookInfoRow("기대평점", "", tempRating: true),
                                    getVerSpace(FetchPixels.getPixelHeight(15)),
                                    buildBookInfoRow("한줄메모", controller.myBookResponse.myBook.comment),
                                    getVerSpace(FetchPixels.getPixelHeight(15)),
                                  ] else if (controller.myBookResponse.myBook.holdType == HoldType.read ||
                                      controller.myBookResponse.myBook.holdType == HoldType.end) ...[
                                    buildBookInfoRow(
                                        "구매방식",
                                        controller.myBookResponse.myBook.usedType == UsedType.none
                                            ? ""
                                            : "${controller.myBookResponse.myBook.usedType.desc}구매"),
                                    getVerSpace(FetchPixels.getPixelHeight(15)),
                                    buildBookInfoRow(
                                        "날짜",
                                        controller.myBookResponse.myBook.inMonth == 0
                                            ? ""
                                            : controller.myBookResponse.myBook.holdType != HoldType.end ||
                                                    controller.myBookResponse.myBook.outMonth == 0
                                                ? "${controller.myBookResponse.myBook.inMonth}개월 ~"
                                                : "${controller.myBookResponse.myBook.inMonth}개월 ~ ${controller.myBookResponse.myBook.outMonth}개월"),
                                    getVerSpace(FetchPixels.getPixelHeight(15)),
                                    buildBookInfoRow("평점", "", rating: true),
                                    getVerSpace(FetchPixels.getPixelHeight(15)),
                                    buildBookInfoRow("한줄메모", controller.myBookResponse.myBook.comment),
                                    getVerSpace(FetchPixels.getPixelHeight(15)),
                                  ]
                                ],
                              ),
                            ],
                          )
                        ],
                      )))
              : Container(),
        ]));
  }

  Widget buildAward(BuildContext context, EdgeInsets edgeInsets) {
    return Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
      GestureDetector(
          onTap: () {
            // if (controller.myBookContainerSwitch) {
            //   controller.myBookContainerSwitch = false;
            // } else {
            //   controller.myBookContainerSwitch = true;
            // }
          },
          child: Container(
              margin: EdgeInsets.only(top: FetchPixels.getPixelHeight(5), bottom: FetchPixels.getPixelHeight(5)),
              padding: EdgeInsets.only(
                  top: FetchPixels.getPixelHeight(10),
                  bottom: FetchPixels.getPixelHeight(10),
                  left: FetchPixels.getPixelWidth(20),
                  right: FetchPixels.getPixelWidth(20)),
              color: Colors.white,
              height: FetchPixels.getPixelHeight(50),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      getCustomFont(
                        "수상",
                        20,
                        Colors.black,
                        1,
                        fontWeight: FontWeight.w500,
                      ),
                      getHorSpace(FetchPixels.getPixelHeight(5)),
                    ],
                  ),
                  // getSvgImage(controller.myBookContainerSwitch ? "down_arrow.svg" : "up_arrow.svg",
                  //     height: FetchPixels.getPixelHeight(20), width: FetchPixels.getPixelHeight(20)),
                ],
              )))),
      Container(
          padding: EdgeInsets.only(
              top: FetchPixels.getPixelHeight(0),
              bottom: FetchPixels.getPixelHeight(10),
              left: FetchPixels.getPixelWidth(20),
              right: FetchPixels.getPixelWidth(20)),
          child: Column(
            children: [
              Column(
                children: [
                  Row(children: [
                    getSvgImage("award.svg",
                        width: FetchPixels.getPixelHeight(15), height: FetchPixels.getPixelHeight(15)),
                    getHorSpace(FetchPixels.getPixelHeight(5)),
                    getCustomFont(
                      "18개월 최고 추천책" ?? "",
                      16,
                      Colors.black,
                      1,
                      fontWeight: FontWeight.w400,
                    ),
                  ]),
                  getVerSpace(FetchPixels.getPixelHeight(10))
                ],
              )
            ],
          ))
    ]);
  }

  Widget buildBookInfo(BuildContext context, EdgeInsets edgeInsets) {
    return Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
      GestureDetector(
          onTap: () {
            if (controller.bookInfoContainer) {
              controller.bookInfoContainer = false;
            } else {
              controller.bookInfoContainer = true;
            }
          },
          child: Container(
              margin: EdgeInsets.only(top: FetchPixels.getPixelHeight(5), bottom: FetchPixels.getPixelHeight(5)),
              padding: EdgeInsets.only(
                  top: FetchPixels.getPixelHeight(10),
                  bottom: FetchPixels.getPixelHeight(10),
                  left: FetchPixels.getPixelWidth(20),
                  right: FetchPixels.getPixelWidth(20)),
              color: Colors.white,
              height: FetchPixels.getPixelHeight(50),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      getCustomFont(
                        "책소개",
                        20,
                        Colors.black,
                        1,
                        fontWeight: FontWeight.w500,
                      ),
                      getHorSpace(FetchPixels.getPixelHeight(5)),
                    ],
                  ),
                  getSvgImage(controller.bookInfoContainer ? "down_arrow.svg" : "up_arrow.svg",
                      height: FetchPixels.getPixelHeight(20), width: FetchPixels.getPixelHeight(20)),
                ],
              )))),
      controller.bookInfoContainer
          ? Container(
              padding: EdgeInsets.only(
                  top: FetchPixels.getPixelHeight(0),
                  bottom: FetchPixels.getPixelHeight(10),
                  left: FetchPixels.getPixelWidth(20),
                  right: FetchPixels.getPixelWidth(20)),
              child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // getVerSpace(FetchPixels.getPixelHeight(5)),
                      buildBookInfoRow("정가", "${f.format(controller.book.modelBook.amount ?? 0)}원"),
                      getVerSpace(FetchPixels.getPixelHeight(15)),
                      controller.book.modelBook.saleAmount > 0
                          ? buildBookInfoRow("공구가", "${f.format(controller.book.modelBook.saleAmount ?? 0)}원")
                          : buildBookInfoRow("공구가", "올해 공구 정보가 없습니다."),
                      getVerSpace(FetchPixels.getPixelHeight(15)),
                      buildBookInfoRow("카테고리", controller.book.getCategoryType().desc),
                      getVerSpace(FetchPixels.getPixelHeight(15)),
                      // buildBookInfoRow("카테고리랭킹", "1위"),
                      // getVerSpace(FetchPixels.getPixelHeight(10)),
                      (controller.book.getWebUrl() == null || controller.book.getWebUrl()!.isEmpty)
                          ? buildBookInfoRow("홈페이지", "제공되는 홈페이지가 없습니다.")
                          : buildBookInfoRow("홈페이지", "바로가기", link: controller.book.getWebUrl()),
                      getVerSpace(FetchPixels.getPixelHeight(15)),
                      buildBookInfoRow("구성", controller.book.modelBook.configuration,
                          valueTextSize: 14, valueLength: 8),
                      getVerSpace(FetchPixels.getPixelHeight(15)),
                    ],
                  )
                ],
              ))
          : Container()
    ]);
  }

  Widget buildBookInfoRow(String title, String value,
      {String? link,
      double? titleTextSize,
      int? titleLength,
      double? valueTextSize,
      int? valueLength,
      Color? valueColor,
      bool? tempRating,
      bool? rating}) {
    return Row(
      children: [
        SizedBox(
          width: 25.w,
          child: getCustomFont(
            title ?? "",
            titleTextSize ?? 14,
            Colors.black54,
            titleLength ?? 1,
            fontWeight: FontWeight.w400,
          ),
        ),
        getHorSpace(FetchPixels.getPixelHeight(10)),
        if (rating == true) ...[
          controller.myBookResponse.myBook.reviewRating == null || controller.myBookResponse.myBook.reviewRating! == 0
              ? Container()
              : RatingBar.builder(
                  initialRating: controller.myBookResponse.myBook.reviewRating!.toDouble(),
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 16,
                  ignoreGestures: true,
                  itemPadding: EdgeInsets.symmetric(horizontal: 0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star_rounded,
                    color: Colors.amber,
                  ),
                  unratedColor: Colors.amber.withAlpha(40),
                  onRatingUpdate: (rating) {
                    print(rating);
                  },
                ),
        ] else if (tempRating == true) ...[
          controller.myBookResponse.myBook.tempReviewRating == null ||
                  controller.myBookResponse.myBook.tempReviewRating! == 0
              ? Container()
              : RatingBar.builder(
                  initialRating: controller.myBookResponse.myBook.tempReviewRating!.toDouble(),
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 16,
                  ignoreGestures: true,
                  itemPadding: EdgeInsets.symmetric(horizontal: 0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star_rounded,
                    color: Colors.amber,
                  ),
                  unratedColor: Colors.amber.withAlpha(40),
                  onRatingUpdate: (rating) {
                    print(rating);
                  },
                ),
        ] else ...[
          link != null
              ? GestureDetector(
                  onTap: () async {
                    final url = Uri.parse(
                      link,
                    );
                    if (await canLaunchUrl(url)) {
                      launchUrl(url);
                    } else {
                      // ignore: avoid_print
                      Get.dialog(ErrorDialog("네트워크 오류가 발생했습니다. 다시 시도해주세요."));
                    }
                  },
                  child: SizedBox(
                      width: 55.w,
                      child: getCustomFont(
                        value ?? "",
                        valueTextSize ?? 16,
                        Colors.blueAccent,
                        valueLength ?? 3,
                        fontWeight: FontWeight.w400,
                      )),
                )
              : SizedBox(
                  width: 55.w,
                  child: getCustomFont(
                    value ?? "",
                    valueTextSize ?? 16,
                    valueColor ?? Colors.black,
                    valueLength ?? 3,
                    fontWeight: FontWeight.w400,
                  ))
        ]
      ],
    );
  }

  Widget buildOneComment(BuildContext context, EdgeInsets edgeInsets) {
    return Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
      GestureDetector(
          onTap: () async {
            print("comment tab");
            bool changed = await Get.toNamed(Routes.bookCommentDetailPath, parameters: {
              'commentTargetId': controller.bookSetCommentId!,
              'bookName': controller.book.modelBook.name,
              'isCommentFocus': false.toString()
            });

            if (changed) {
              controller.requestComment();
            }
          },
          child: Container(
              margin: EdgeInsets.only(top: FetchPixels.getPixelHeight(5), bottom: FetchPixels.getPixelHeight(5)),
              padding: EdgeInsets.only(
                  top: FetchPixels.getPixelHeight(10),
                  bottom: FetchPixels.getPixelHeight(0),
                  left: FetchPixels.getPixelWidth(20),
                  right: FetchPixels.getPixelWidth(20)),
              color: Colors.white,
              height: FetchPixels.getPixelHeight(50),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      getCustomFont(
                        "한줄 코멘트",
                        20,
                        Colors.black,
                        1,
                        fontWeight: FontWeight.w500,
                      ),
                      getHorSpace(FetchPixels.getPixelHeight(5)),
                      controller.commentList.length > 0
                          ? getCustomFont(
                              "${controller.commentList.length}개",
                              20,
                              Colors.black,
                              1,
                              fontWeight: FontWeight.w500,
                            )
                          : Container(),
                    ],
                  ),
                  getSvgImage("more_comment.svg",
                      height: FetchPixels.getPixelHeight(20), width: FetchPixels.getPixelHeight(20)),
                ],
              )))),
      if (controller.commentList.isEmpty) ...[
        nullComment(context)
      ] else ...[
        buildComment(context, controller.commentList),
        getVerSpace(FetchPixels.getPixelHeight(20)),
        getButton(context, secondMainColor, "한줄 코멘트 쓰기", Colors.white, () async {
          bool changed = await Get.toNamed(Routes.bookCommentDetailPath, parameters: {
            'commentTargetId': controller.bookSetCommentId!,
            'bookName': controller.book.modelBook.name,
            'isCommentFocus': true.toString()
          });
          if (changed) {
            controller.requestComment();
          }
        }, 14,
            weight: FontWeight.w600,
            buttonHeight: FetchPixels.getPixelHeight(40),
            insetsGeometry: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
            borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(14)),
            isBorder: true,
            borderColor: secondMainColor,
            borderWidth: 1.5),
        getVerSpace(FetchPixels.getPixelHeight(20)),
      ]
    ]);
  }

  Wrap buildComment(BuildContext context, List<ModelCommentResponse> commentList) {
    List<ModelCommentResponse> list = commentList.length > 3 ? commentList.sublist(0, 3) : commentList;
    return Wrap(
        direction: Axis.vertical,
        // 정렬 방향
        alignment: WrapAlignment.start,
        children: list
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
      getVerSpace(FetchPixels.getPixelHeight(20)),
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
            getCustomFont(comment.commentWriterNickName ?? "", 12, Colors.black54, 1, fontWeight: FontWeight.w500),
            getCustomFont(comment.myComment ? "*" : "", 12, Colors.red, 1, fontWeight: FontWeight.w400),
            getHorSpace(FetchPixels.getPixelHeight(5)),
            getCustomFont(DateFormat('yyyy.MM.dd').format(comment.comment.updatedAt!), 12, Colors.black54, 1,
                fontWeight: FontWeight.w400),
          ])),
      getVerSpace(FetchPixels.getPixelHeight(10)),
      getCustomFont(comment.comment.body ?? "", 16, comment.deleted ? Colors.black45 : Colors.black, 20,
          fontWeight: FontWeight.w400),
      getVerSpace(FetchPixels.getPixelHeight(20))
    ]);
  }

  Column nullComment(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // getSvgImage("clipboard.svg", height: FetchPixels.getPixelHeight(124), width: FetchPixels.getPixelHeight(124)),
        getVerSpace(FetchPixels.getPixelHeight(20)),
        getCustomFont("한줄 코멘트를 등록해주세요.", 16, Colors.black, 1, fontWeight: FontWeight.w600),
        getVerSpace(FetchPixels.getPixelHeight(10)),
        getCustomFont(
          "여러분의 소중한 경험을 공유해주세요.",
          14,
          Colors.black45,
          1,
          fontWeight: FontWeight.w400,
        ),
        getVerSpace(FetchPixels.getPixelHeight(10)),
        getButton(context, secondMainColor, "한줄 코멘트 쓰기", Colors.white, () async {
          bool changed = await Get.toNamed(Routes.bookCommentDetailPath, parameters: {
            'commentTargetId': controller.bookSetCommentId!,
            'bookName': controller.book.modelBook.name,
            'isCommentFocus': true.toString()
          });
          if (changed) {
            controller.requestComment();
          }
        }, 14,
            weight: FontWeight.w600,
            buttonHeight: FetchPixels.getPixelHeight(40),
            insetsGeometry: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
            borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(14)),
            isBorder: true,
            borderColor: secondMainColor,
            borderWidth: 1.5),
        getVerSpace(FetchPixels.getPixelHeight(20)),
      ],
    );
  }

  clickedModifyComment(BuildContext context, ModelCommentResponse comment) async {
    if (comment.deleted) {
      Get.dialog(ErrorDialog("삭제된 댓글은 수정할 수 없습니다."));
      return;
    }
    // controller.commentModify(comment);
    // controller.executeModifyCommentMode(comment).then((value) => commentKeyboardUp(context));
  }

  clickedRemoveComment(ModelCommentResponse comment) async {
    if (comment.deleted) {
      Get.dialog(ErrorDialog("이미 삭제된 댓글입니다."));
      return;
    }

    // bool result = await Get.dialog(ReConfirmDialog("댓글을 삭제 하시겠습니까?", "삭제", "취소", () async {
    //   controller.removeComment(comment.comment.commentId).then((result) => Get.back(result: result));
    // }));
    //
    // if (result) {
    //   controller.getComment();
    // } else {
    //   Get.dialog(ErrorDialog("잠시 후 다시 시도해주세요."));
    // }
  }

  Widget buildCommunity(BuildContext context, EdgeInsets edgeInsets) {
    List<ModelPost> list = controller.postTag.postList.length > 3
        ? controller.postTag.postList.sublist(0, 3)
        : controller.postTag.postList;
    return Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
      GestureDetector(
          onTap: () {
            print("community tab");
            Get.toNamed(Routes.bookCommunityPath, parameters: {
              'bookId': controller.book.modelBook.id.toString(),
              'bookName': controller.book.modelBook.name
            });
          },
          child: Container(
              margin: EdgeInsets.only(top: FetchPixels.getPixelHeight(5)),
              padding: EdgeInsets.only(
                  top: FetchPixels.getPixelHeight(10),
                  bottom: FetchPixels.getPixelHeight(0),
                  left: FetchPixels.getPixelWidth(20),
                  right: FetchPixels.getPixelWidth(20)),
              color: Colors.white,
              height: FetchPixels.getPixelHeight(50),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      getCustomFont(
                        "커뮤니티글",
                        20,
                        Colors.black,
                        1,
                        fontWeight: FontWeight.w500,
                      ),
                      getHorSpace(FetchPixels.getPixelHeight(5)),
                      controller.postTag.count > 0
                          ? getCustomFont(
                              "${controller.postTag.count}개",
                              20,
                              Colors.black,
                              1,
                              fontWeight: FontWeight.w500,
                            )
                          : Container(),
                    ],
                  ),
                  getSvgImage("more_comment.svg",
                      height: FetchPixels.getPixelHeight(20), width: FetchPixels.getPixelHeight(20)),
                ],
              )))),
      list.isEmpty
          ? nullPost(context)
          : SizedBox(
              height: FetchPixels.getPixelHeight(220),
              child: ListView.builder(
                padding: EdgeInsets.symmetric(
                    horizontal: FetchPixels.getPixelWidth(10), vertical: FetchPixels.getPixelWidth(10)),
                scrollDirection: Axis.horizontal,
                itemCount: list.length,
                primary: false,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  ModelPost post = list[index];
                  return buildPostItem(post, context, index, () {
                    Get.toNamed("${Routes.communityDetailPath}", parameters: {'postId': post.postId!, 'tag': 'book'});
                  }, () {});
                },
              ),
            ),
    ]);
  }

  Widget nullPost(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // getSvgImage("clipboard.svg", height: FetchPixels.getPixelHeight(124), width: FetchPixels.getPixelHeight(124)),
        getVerSpace(FetchPixels.getPixelHeight(20)),
        getCustomFont("글이 없습니다.", 16, Colors.black, 1, fontWeight: FontWeight.w600),
        getVerSpace(FetchPixels.getPixelHeight(10)),
        getCustomFont(
          "관련된 커뮤니티 글이 없습니다.",
          14,
          Colors.black45,
          1,
          fontWeight: FontWeight.w400,
        ),
        // getVerSpace(FetchPixels.getPixelHeight(10)),
        // getButton(context, secondMainColor, "한줄 코멘트 쓰기", Colors.white, () {
        //   Get.toNamed(Routes.bookCommentDetailPath, parameters: {
        //     'commentTargetId': controller.bookSetCommentId!,
        //     'bookName': controller.book.modelBook.name,
        //     'isCommentFocus': true.toString()
        //   });
        // }, 14,
        //     weight: FontWeight.w600,
        //     buttonHeight: FetchPixels.getPixelHeight(40),
        //     insetsGeometry: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
        //     borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(14)),
        //     isBorder: true,
        //     borderColor: secondMainColor,
        //     borderWidth: 1.5),
        getVerSpace(FetchPixels.getPixelHeight(20)),
      ],
    ));
  }

  GestureDetector buildPostItem(
      ModelPost modelPost, BuildContext context, int index, Function function, Function funDelete) {
    return GestureDetector(
      onTap: () {
        function();
      },
      child: Container(
        width: FetchPixels.getPixelHeight(300),
        height: FetchPixels.getPixelHeight(200),
        margin: EdgeInsets.all(FetchPixels.getPixelWidth(10)),
        // left: FetchPixels.getPixelWidth(10),
        // right: FetchPixels.getPixelWidth(10)),
        padding:
            EdgeInsets.symmetric(vertical: FetchPixels.getPixelHeight(20), horizontal: FetchPixels.getPixelWidth(20)),
        decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Color(0xFFEDEBE8), blurRadius: 3, offset: Offset(1.0, 1.0)),
            ],
            borderRadius: BorderRadius.zero),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                getCustomFont(modelPost.postType.desc ?? "", 11, modelPost.postType.color, 1,
                    fontWeight: FontWeight.w500),
                // getVerSpace(FetchPixels.getPixelHeight(6)),
                getCustomFont(" · ${modelPost.nickName} · ${modelPost.timeDiffForUi}" ?? "", 10, Colors.black45, 1,
                    fontWeight: FontWeight.w500)
              ]),
              getVerSpace(FetchPixels.getPixelHeight(14)),
              getCustomFont(modelPost.title ?? "", 20, Colors.black, 1, fontWeight: FontWeight.w600),
              getVerSpace(FetchPixels.getPixelHeight(8)),
              getCustomFont(
                modelPost.contents ?? "",
                14,
                Colors.black54,
                2,
                fontWeight: FontWeight.w400,
              ),
              getVerSpace(FetchPixels.getPixelHeight(25)),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, //Center Row contents horizontally,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        getSvgImage(modelPost.liked ? "heart_selected.svg" : "heart.svg",
                            height: FetchPixels.getPixelHeight(18), width: FetchPixels.getPixelHeight(18)),
                        getHorSpace(FetchPixels.getPixelWidth(6)),
                        getCustomFont(numberFormat.format(modelPost.likeCount), 14,
                            modelPost.liked ? const Color(0xFFF65E5E) : Colors.black54, 1,
                            fontWeight: FontWeight.w400),
                        getHorSpace(FetchPixels.getPixelHeight(30))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        getSvgImage("chatbox_ellipses_outline.svg",
                            height: FetchPixels.getPixelHeight(18), width: FetchPixels.getPixelHeight(18)),
                        getHorSpace(FetchPixels.getPixelWidth(6)),
                        getCustomFont(numberFormat.format(modelPost.commentCount), 14, Colors.black54, 1,
                            fontWeight: FontWeight.w400),
                        getHorSpace(FetchPixels.getPixelHeight(30))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        getSvgImage("eye_outline.svg",
                            height: FetchPixels.getPixelHeight(18), width: FetchPixels.getPixelHeight(18)),
                        getHorSpace(FetchPixels.getPixelWidth(6)),
                        getCustomFont(numberFormat.format(modelPost.viewCount), 14, Colors.black54, 1,
                            fontWeight: FontWeight.w400),
                        getHorSpace(FetchPixels.getPixelHeight(30))
                      ],
                    ),
                  ]),
            ]),
      ),
    );
  }

  commentKeyboardUp(BuildContext context) {
    // FocusScope.of(context)?.requestFocus(commentFocusNode);
  }

  commentKeyboardDown(BuildContext context) {
    FocusScope.of(context).unfocus();
  }
}
