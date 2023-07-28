import 'package:baby_book/app/controller/BookDetailController.dart';
import 'package:baby_book/app/models/model_post.dart';
import 'package:baby_book/app/models/model_post_tag.dart';
import 'package:baby_book/app/repository/my_book_repository.dart';
import 'package:baby_book/app/repository/post_repository.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:intl/intl.dart';
import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../base/color_data.dart';
import '../../../../base/pref_data.dart';
import '../../../../base/skeleton.dart';
import '../../../../base/uuid_util.dart';
import '../../../controller/BookDetailController.dart';
import '../../../models/model_book_state.dart';
import '../../../models/model_comment_response.dart';
import '../../../models/model_kakao_link_template.dart';
import '../../../models/model_my_book_response.dart';
import '../../../repository/book_repository.dart';
import '../../../repository/comment_repository.dart';
import '../../../routes/app_pages.dart';
import '../../community/comment_bottom_sheet.dart';
import '../../dialog/error_dialog.dart';
import '../../dialog/re_confirm_dialog.dart';
import '../home_screen.dart';
import 'ReviewType.dart';
import 'UsedType.dart';
import 'book_detail_bottom_sheet.dart';

class BookDetailScreen extends GetView<BookDetailController> {
  late final int? bookSetId;
  late final String? babyId;
  late final String? uniqueTag;

  late YoutubePlayerController youtubeController;
  bool? isDetailMenu;
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
    initYoutubeController();
    sharedMode = Get.parameters['sharedType'] != null;
  }

  @override
  String? get tag => uniqueTag;

  initYoutubeController() {
    youtubeController = YoutubePlayerController(
      initialVideoId: "KuGPpecYc28",
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
        hideControls: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    isDetailMenu = isDetailMenu ?? true;
    FetchPixels(context);
    double defHorSpace = FetchPixels.getDefaultHorSpace(context);
    EdgeInsets edgeInsets = EdgeInsets.symmetric(horizontal: defHorSpace);
    return WillPopScope(
        onWillPop: () async {
          if (sharedMode) {
            print("AppSchemeImpl BookDetailScreen sharedMode :$sharedMode get off");
            Get.off(() => HomeScreen(0));
          } else {
            Get.back();
          }
          return false;
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: backGroundColor,
            body: Obx(
              () => SafeArea(
                child: controller.loading
                    ? const FullSizeSkeleton()
                    : Column(
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
      controller.removeBook().then((result) => Get.back(result: result));
    }));

    if (result == null) {
      ///취소선택
      return;
    } else if (result) {
      Get.back();
    } else {
      Get.dialog(ErrorDialog("잠시 후 다시 시도해주세요."));
    }
  }

  _share() async {
    bool isKakaoTalkSharingAvailable = await ShareClient.instance.isKakaoTalkSharingAvailable();

    if (isKakaoTalkSharingAvailable) {
      print('카카오톡으로 공유 가능');
      try {
        Uri uri = await ShareClient.instance.shareDefault(
            template: ModelKakaoLinkTemplate.getTextTemplateForBook("[아기곰 책육아]\n${controller.book.modelBook.name}",
                ModelKakaoLinkTemplate.sharedTypeBook, controller.bookSetId));
        await ShareClient.instance.launchKakaoTalk(uri);
        print('카카오톡 공유 완료');
      } catch (error) {
        print('카카오톡 공유 실패 $error');
      }
    } else {
      print('카카오톡 미설치: 웹 공유 기능 사용 권장');
      try {
        Uri shareUrl = await WebSharerClient.instance.makeDefaultUrl(
            template: ModelKakaoLinkTemplate.getTextTemplateForBook("[아기곰책육아]\n${controller.book.modelBook.name}",
                ModelKakaoLinkTemplate.sharedTypeBook, controller.bookSetId));
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
                  getCustomFont(controller.book.modelPublisher.publisherName ?? "", 16, textColor, 1,
                      fontWeight: FontWeight.w400),
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
                  Container(
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
                            "13명" ?? "",
                            16,
                            Colors.black,
                            1,
                            fontWeight: FontWeight.w600,
                          )
                        ],
                      )),
                  GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.bookCommentDetailPath, parameters: {
                          'commentTargetId': controller.bookSetCommentId!,
                          'bookName': controller.book.modelBook.name,
                          'isCommentFocus': false.toString()
                        });
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
          Container(height: FetchPixels.getPixelHeight(150), color: Color(0xFFF5F6F8)),
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
              ? Container(
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
                              getCustomFont(
                                controller.myBookResponse.myBook.holdType.desc,
                                16,
                                controller.myBookResponse.myBook.holdType.color,
                                1,
                                fontWeight: FontWeight.w500,
                              ),
                              getVerSpace(FetchPixels.getPixelHeight(5)),
                              Row(
                                children: [
                                  controller.myBookResponse.myBook.reviewType == ReviewType.none
                                      ? Container()
                                      : getCustomFont("#${controller.myBookResponse.myBook.reviewType.desc}  " ?? "",
                                          16, Colors.black, 1,
                                          fontWeight: FontWeight.w400),
                                  controller.myBookResponse.myBook.usedType == UsedType.none
                                      ? Container()
                                      : getCustomFont(
                                          "#${controller.myBookResponse.myBook.usedType.desc}구매", 16, Colors.black, 1,
                                          fontWeight: FontWeight.w400),
                                ],
                              ),
                              getVerSpace(FetchPixels.getPixelHeight(20)),
                              Row(
                                children: [
                                  getSvgImage("date.svg",
                                      width: FetchPixels.getPixelHeight(15), height: FetchPixels.getPixelHeight(15)),
                                  getHorSpace(FetchPixels.getPixelHeight(5)),
                                  getCustomFont("날짜", 14, Colors.black54, 1, fontWeight: FontWeight.w400),
                                ],
                              ),
                              getVerSpace(FetchPixels.getPixelHeight(5)),
                              controller.myBookResponse.myBook.inMonth == 0
                                  ? Container()
                                  : Column(children: [
                                      if (controller.myBookResponse.myBook.inMonth != 0) ...[
                                        Row(
                                          children: [
                                            controller.myBookResponse.myBook.inMonth != 0
                                                ? Row(
                                                    children: [
                                                      getCustomFont("시작", 16, secondMainColor, 1,
                                                          fontWeight: FontWeight.w500),
                                                      getCustomFont(" ${controller.myBookResponse.myBook.inMonth}개월",
                                                          16, Colors.black, 1,
                                                          fontWeight: FontWeight.w400),
                                                    ],
                                                  )
                                                : Container(),
                                            controller.myBookResponse.myBook.outMonth != 0
                                                ? Row(
                                                    children: [
                                                      getCustomFont("   종료", 16, secondMainColor, 1,
                                                          fontWeight: FontWeight.w500),
                                                      getCustomFont(" ${controller.myBookResponse.myBook.outMonth}개월",
                                                          16, Colors.black, 1,
                                                          fontWeight: FontWeight.w400)
                                                    ],
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                      ],
                                    ]),
                              getVerSpace(FetchPixels.getPixelHeight(20)),
                              Row(children: [
                                getSvgImage("memo.svg",
                                    width: FetchPixels.getPixelHeight(15), height: FetchPixels.getPixelHeight(15)),
                                getHorSpace(FetchPixels.getPixelHeight(5)),
                                getCustomFont(
                                  "메모" ?? "",
                                  14,
                                  Colors.black54,
                                  1,
                                  fontWeight: FontWeight.w400,
                                ),
                              ]),
                              getVerSpace(FetchPixels.getPixelHeight(5)),
                              getCustomFont(
                                "${controller.myBookResponse.myBook.comment}  " ?? "",
                                16,
                                Colors.black,
                                1,
                                fontWeight: FontWeight.w400,
                              ),
                              getVerSpace(FetchPixels.getPixelHeight(10)),
                            ],
                          ),
                        ],
                      )
                    ],
                  ))
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
                          ? buildBookInfoRow("공식페이지", "제공되는 홈페이지가 없습니다.")
                          : buildBookInfoRow("공식페이지", "바로가기", link: controller.book.getWebUrl()),
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
      {String? link, double? titleTextSize, int? titleLength, double? valueTextSize, int? valueLength}) {
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
                  Colors.black,
                  valueLength ?? 3,
                  fontWeight: FontWeight.w400,
                )),
      ],
    );
  }

  Widget buildOneComment(BuildContext context, EdgeInsets edgeInsets) {
    return Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
      GestureDetector(
          onTap: () {
            print("comment tab");
            Get.toNamed(Routes.bookCommentDetailPath, parameters: {
              'commentTargetId': controller.bookSetCommentId!,
              'bookName': controller.book.modelBook.name,
              'isCommentFocus': false.toString()
            });
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
        getButton(context, secondMainColor, "한줄 코멘트 쓰기", Colors.white, () {
          Get.toNamed(Routes.bookCommentDetailPath, parameters: {
            'commentTargetId': controller.bookSetCommentId!,
            'bookName': controller.book.modelBook.name,
            'isCommentFocus': true.toString()
          });
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
        getButton(context, secondMainColor, "한줄 코멘트 쓰기", Colors.white, () {
          Get.toNamed(Routes.bookCommentDetailPath, parameters: {
            'commentTargetId': controller.bookSetCommentId!,
            'bookName': controller.book.modelBook.name,
            'isCommentFocus': true.toString()
          });
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
        width: FetchPixels.getPixelHeight(270),
        // height: FetchPixels.getPixelHeight(170),
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
              getVerSpace(FetchPixels.getPixelHeight(35)),
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
