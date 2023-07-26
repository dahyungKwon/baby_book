import 'package:baby_book/app/controller/BookDetailController.dart';
import 'package:baby_book/app/repository/my_book_repository.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:intl/intl.dart';
import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../base/color_data.dart';
import '../../../../base/skeleton.dart';
import '../../../../base/uuid_util.dart';
import '../../../controller/BookDetailController.dart';
import '../../../models/model_book_state.dart';
import '../../../models/model_kakao_link_template.dart';
import '../../../models/model_my_book_response.dart';
import '../../../repository/book_repository.dart';
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
                  getCustomFont(controller.book.modelBook.name ?? "", 22, Colors.black, 1, fontWeight: FontWeight.w700),
                  getVerSpace(FetchPixels.getPixelHeight(10)),
                  getCustomFont(controller.book.modelPublisher.publisherName ?? "", 16, textColor, 1,
                      fontWeight: FontWeight.w400),
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
                  Container(
                      width: FetchPixels.getPixelHeight(100),
                      height: FetchPixels.getPixelHeight(80),
                      color: Colors.white,
                      child: Column(
                        children: [
                          getSvgImage("one_comment_black.svg",
                              width: FetchPixels.getPixelHeight(25), height: FetchPixels.getPixelHeight(25)),
                          getVerSpace(FetchPixels.getPixelHeight(5)),
                          getCustomFont(
                            "한줄코멘트" ?? "",
                            12,
                            Colors.black54,
                            1,
                            fontWeight: FontWeight.w500,
                          ),
                          getVerSpace(FetchPixels.getPixelHeight(5)),
                          getCustomFont(
                            "24개" ?? "",
                            16,
                            Colors.black,
                            1,
                            fontWeight: FontWeight.w600,
                          )
                        ],
                      )),
                  Container(
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
                            "10개" ?? "",
                            16,
                            Colors.black,
                            1,
                            fontWeight: FontWeight.w600,
                          )
                        ],
                      ))
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
          buildDown(edgeInsets, context),
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
                  height: FetchPixels.getPixelHeight(45),
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
                          getCustomFont(
                            "(${controller.myBookResponse.myBook.holdType.desc})",
                            20,
                            controller.myBookResponse.myBook.holdType.color,
                            1,
                            fontWeight: FontWeight.w600,
                          ),
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
                              // getVerSpace(FetchPixels.getPixelHeight(10)),
                              // getCustomFont(
                              //   controller.myBookResponse.myBook.holdType.desc,
                              //   18,
                              //   controller.myBookResponse.myBook.holdType.color,
                              //   1,
                              //   fontWeight: FontWeight.w500,
                              // ),
                              getVerSpace(FetchPixels.getPixelHeight(10)),
                              Row(children: [
                                getSvgImage("detail_noti.svg",
                                    width: FetchPixels.getPixelHeight(15), height: FetchPixels.getPixelHeight(15)),
                                getHorSpace(FetchPixels.getPixelHeight(2)),
                                getCustomFont(
                                  "상세" ?? "",
                                  14,
                                  Colors.black54,
                                  1,
                                  fontWeight: FontWeight.w500,
                                ),
                              ]),
                              getVerSpace(FetchPixels.getPixelHeight(5)),
                              controller.myBookResponse.myBook.inMonth == 0
                                  ? Container()
                                  : Column(children: [
                                      // getVerSpace(FetchPixels.getPixelHeight(10)),
                                      Row(
                                        children: [
                                          controller.myBookResponse.myBook.inMonth != 0
                                              ? Row(
                                                  children: [
                                                    getCustomFont("시작", 16, secondMainColor, 1,
                                                        fontWeight: FontWeight.w600),
                                                    getCustomFont(" ${controller.myBookResponse.myBook.inMonth}개월", 16,
                                                        Colors.black87, 1,
                                                        fontWeight: FontWeight.w600),
                                                  ],
                                                )
                                              : Container(),
                                          controller.myBookResponse.myBook.outMonth != 0
                                              ? Row(
                                                  children: [
                                                    getCustomFont("   종료", 16, secondMainColor, 1,
                                                        fontWeight: FontWeight.w600),
                                                    getCustomFont(" ${controller.myBookResponse.myBook.outMonth}개월", 16,
                                                        Colors.black87, 1,
                                                        fontWeight: FontWeight.w600)
                                                  ],
                                                )
                                              : Container(),
                                        ],
                                      ),
                                      // getVerSpace(FetchPixels.getPixelHeight(7)),
                                    ]),
                              getVerSpace(FetchPixels.getPixelHeight(5)),
                              Row(
                                children: [
                                  controller.myBookResponse.myBook.reviewType == ReviewType.none
                                      ? Container()
                                      : getCustomFont("#${controller.myBookResponse.myBook.reviewType.desc}  " ?? "",
                                          16, Colors.black87, 1,
                                          fontWeight: FontWeight.w600),
                                  controller.myBookResponse.myBook.usedType == UsedType.none
                                      ? Container()
                                      : getCustomFont(
                                          "#${controller.myBookResponse.myBook.usedType.desc}구매", 16, Colors.black87, 1,
                                          fontWeight: FontWeight.w600),
                                ],
                              ),
                              getVerSpace(FetchPixels.getPixelHeight(30)),
                              Row(children: [
                                getSvgImage("one_comment_black_a2a2a2.svg",
                                    width: FetchPixels.getPixelHeight(15), height: FetchPixels.getPixelHeight(15)),
                                getHorSpace(FetchPixels.getPixelHeight(2)),
                                getCustomFont(
                                  "한줄 코멘트" ?? "",
                                  14,
                                  Colors.black54,
                                  1,
                                  fontWeight: FontWeight.w500,
                                ),
                              ]),
                              getVerSpace(FetchPixels.getPixelHeight(5)),
                              getCustomFont(
                                "${controller.myBookResponse.myBook.comment}  " ?? "",
                                16,
                                Colors.black87,
                                1,
                                fontWeight: FontWeight.w600,
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

  Widget buildDown(EdgeInsets edgeInsets, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getVerSpace(FetchPixels.getPixelHeight(20)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                // if (!isDetailMenu!) {
                //   setState(() {
                //     isDetailMenu = true;
                //   });
                // }
              },
              child: getCustomFont(
                "상세정보",
                18,
                isDetailMenu! ? Colors.black : textColor,
                1,
                fontWeight: isDetailMenu! ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
            GestureDetector(
              onTap: () {
                // if (isDetailMenu!) {
                //   setState(() {
                //     isDetailMenu = false;
                //   });
                // }
              },
              child: getCustomFont(
                "게시글",
                18,
                isDetailMenu! ? textColor : Colors.black,
                1,
                fontWeight: isDetailMenu! ? FontWeight.w500 : FontWeight.w600,
              ),
            ),
          ],
        ),
        getVerSpace(FetchPixels.getPixelHeight(10)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            AnimatedContainer(
              height: 1.0,
              width: FetchPixels.width / 2,
              decoration: BoxDecoration(
                color: isDetailMenu! ? Colors.black : Colors.black26,
              ),
              duration: const Duration(milliseconds: 300),
            ),
            AnimatedContainer(
              height: 1.0,
              width: FetchPixels.width / 2,
              curve: Curves.decelerate,
              decoration: BoxDecoration(
                color: isDetailMenu! ? Colors.black26 : Colors.black,
              ),
              duration: const Duration(milliseconds: 300),
            ),
          ],
        ),
        isDetailMenu! ? renderDetailMenu() : renderPostMenu(),
      ],
    );
  }

  Widget renderBookState(ModelBookState state, bool isSelected) {
    return Container(
      child: getCustomFont(
        state.name(),
        18,
        isSelected ? success : textColor,
        1,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget renderDetailMenu() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            renderDetailRow("정가", "${f.format(controller.book.modelBook.amount ?? 0)} 원"),
            renderDetailRow("공구가", "${f.format(controller.book.modelBook.saleAmount ?? 0)} 원"),
            renderDetailRow("트렌드랭킹", "1위"),
            renderDetailRow("카테고리", controller.book.getCategoryType().desc),
            renderDetailRow("구성", controller.book.modelBook.configuration),
            renderDetailRow("공식페이지", controller.book.modelPublisher.publisherWebUrl, isLink: true),
            // renderDetailRow("비교전집", "영아다중(프뢰벨), 핀덴베베(한솔)"),
            // renderDetailRow("개정판별 히스토리", ""),
            // Align(
            //   alignment: Alignment.centerLeft,
            //   child: getCustomFont("소개영상", 16, Colors.black54, 1, fontWeight: FontWeight.w600),
            // ),
            getVerSpace(FetchPixels.getPixelHeight(10)),
            // YoutubePlayer(
            //   key: ObjectKey(youtubeController),
            //   controller: youtubeController,
            //   bottomActions: [
            //     CurrentPosition(),
            //     const SizedBox(width: 10.0),
            //     ProgressBar(isExpanded: true),
            //     const SizedBox(width: 10.0),
            //     RemainingDuration(),
            //     FullScreenButton(),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  Widget renderPostMenu() {
    return Container();
  }

  Widget renderDetailRow(String name, String value, {bool isLink = false}) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: (FetchPixels.width - 36) * 0.3,
              child: getCustomFont(name, 16, Colors.black54, 1, fontWeight: FontWeight.w600),
            ),
            if (!isLink)
              Container(
                width: (FetchPixels.width - 36) * 0.7,
                child: getCustomFont(value, 16, Colors.black, 1, fontWeight: FontWeight.w600),
              ),
            if (isLink)
              Expanded(
                child: TextButton(
                  onPressed: () async {
                    final url = Uri.parse(
                      value,
                    );
                    if (await canLaunchUrl(url)) {
                      launchUrl(url);
                    } else {
                      // ignore: avoid_print
                      print("Can't launch $url");
                    }
                  },
                  child: Text(
                    overflow: TextOverflow.ellipsis,
                    value,
                  ),
                ),
              ),
          ],
        ),
        getVerSpace(FetchPixels.getPixelHeight(10)),
      ],
    );
  }
}
