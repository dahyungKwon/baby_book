import 'dart:async';

import 'package:baby_book/app/models/model_my_book.dart';
import 'package:baby_book/app/models/model_my_book_response.dart';
import 'package:baby_book/app/repository/baby_repository.dart';
import 'package:baby_book/app/repository/member_repository.dart';
import 'package:baby_book/app/repository/my_book_repository.dart';
import 'package:baby_book/app/view/home/book/UsedType.dart';
import 'package:baby_book/app/view/home/book/book_detail_bottom_sheet.dart';
import 'package:baby_book/base/color_data.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../base/skeleton.dart';
import '../../../../base/uuid_util.dart';
import '../../../controller/BookCaseListController.dart';
import '../../../repository/paging_request.dart';
import '../../../routes/app_pages.dart';
import '../../dialog/error_dialog.dart';
import '../../dialog/re_confirm_dialog.dart';
import '../book/HoldType.dart';
import '../book/ReviewType.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class BookCaseListScreen extends GetView<BookCaseListController> {
  late final String? uniqueTag;
  late final String memberId;
  late HoldType holdType;
  late RefreshController refreshController;
  int pageNumber = 1;
  var f = NumberFormat('###,###,###,###');

  BookCaseListScreen({required String? memberId, required this.holdType, super.key}) {
    uniqueTag = memberId;
    Get.put(
        BookCaseListController(
            myBookRepository: MyBookRepository(),
            memberRepository: MemberRepository(),
            babyRepository: BabyRepository(),
            memberId: memberId,
            holdType: holdType),
        tag: uniqueTag);
    refreshController = RefreshController(initialRefresh: false);
  }

  @override
  String? get tag => uniqueTag;

  void initPageNumber() {
    ///캐시된게 있으면 맨 마지막 number를 넣어야함
    if (controller.map.containsKey(holdType)) {
      // 1 12345 -1 01234 /5 = 0 +1 => 1
      // 2 678910 -1 56789 / 5 = 1 +1 => 2
      pageNumber = (controller.map[holdType]!.length - 1) ~/ PagingRequest.defaultPageSize + 1;
    } else {
      pageNumber = 1;
    }
  }

  void plusPageNumber() {
    pageNumber++;
  }

  void onRefresh() async {
    await controller.getAllForPullToRefresh(holdType);
    initPageNumber(); //순서중요

    await Future.delayed(Duration(milliseconds: 500));

    refreshController.refreshCompleted();
  }

  void onLoading() async {
    List<ModelMyBookResponse>? list = await controller.getAllForLoading(holdType, PagingRequest.create(pageNumber + 1));
    if (list != null && list.isNotEmpty) {
      plusPageNumber();
    }

    await Future.delayed(Duration(milliseconds: 500));
    refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets edgeInsets = EdgeInsets.symmetric(
      horizontal: FetchPixels.getDefaultHorSpace(context),
    );
    return Container(
      color: backGroundColor,
      child: Obx(() => controller.loading
          ? const ListSkeleton()
          : controller.myBookResponseList.isEmpty
              ? getPaddingWidget(edgeInsets, nullListView(context))
              : draw(edgeInsets)),
    );
  }

  SmartRefresher draw(EdgeInsets edgeInsets) {
    return SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: const MaterialClassicHeader(
          color: Colors.black,
        ),
        footer: const ClassicFooter(
            loadStyle: LoadStyle.ShowWhenLoading,
            loadingText: "Loading...",
            idleText: "Loading...",
            canLoadingText: "Loading..."),
        controller: refreshController,
        onRefresh: onRefresh,
        onLoading: onLoading,
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: controller.myBookResponseList.length,
          itemBuilder: (context, index) {
            ModelMyBookResponse modelMyBookResponse = controller.myBookResponseList[index];
            return buildBookCaseItem(context, edgeInsets, modelMyBookResponse, index, () async {
              if (controller.myBookCase) {
                ModelMyBookResponse result = await Get.toNamed(Routes.bookDetailPath, parameters: {
                  'bookSetId': modelMyBookResponse.myBook.bookSetId.toString(),
                  'babyId': modelMyBookResponse.myBook.babyId
                });

                controller.updateMyBook(index, result);
              }
            }, () {});
          },
        ));
  }

  Column nullListView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // getSvgImage("clipboard.svg", height: FetchPixels.getPixelHeight(124), width: FetchPixels.getPixelHeight(124)),
        // getVerSpace(FetchPixels.getPixelHeight(40)),
        holdType == HoldType.all
            ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                // getCustomFont("'${holdType.desc}'", 20, holdType.color, 1, fontWeight: FontWeight.w600),
                getCustomFont("책장에 책이 없습니다.", 20, Colors.black, 1, fontWeight: FontWeight.w500),
              ])
            : Container(),
        holdType == HoldType.plan
            ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                getCustomFont("구매 예정", 20, holdType.color, 1, fontWeight: FontWeight.w600),
                getCustomFont(" 중인 책이 없습니다.", 20, Colors.black, 1, fontWeight: FontWeight.w500),
              ])
            : Container(),

        holdType == HoldType.read
            ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                getCustomFont("읽고 있는", 20, holdType.color, 1, fontWeight: FontWeight.w600),
                getCustomFont(" 책이 없습니다.", 20, Colors.black, 1, fontWeight: FontWeight.w500),
              ])
            : Container(),
        holdType == HoldType.end
            ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                getCustomFont("${holdType.desc}", 20, holdType.color, 1, fontWeight: FontWeight.w600),
                getCustomFont("한 책이 없습니다.", 20, Colors.black, 1, fontWeight: FontWeight.w500),
              ])
            : Container(),
        getVerSpace(FetchPixels.getPixelHeight(10)),
        getCustomFont(
          controller.myBookCase ? "책장에 책을 추가하여 히스토리 관리해보세요." : "다른 곰들의 책장을 구경해보세요.",
          16,
          Colors.black45,
          1,
          fontWeight: FontWeight.w400,
        ),
        getVerSpace(FetchPixels.getPixelHeight(30)),
        controller.myBookCase
            ? getButton(context, backGroundColor, "책 추가 하러가기", Colors.black87, () {
                Get.offAllNamed(Routes.homescreenPath);
              }, 18,
                weight: FontWeight.w600,
                buttonHeight: FetchPixels.getPixelHeight(60),
                insetsGeometry: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(100)),
                borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(14)),
                isBorder: true,
                borderColor: Colors.grey,
                borderWidth: 1.5)
            : Container()
      ],
    );
  }

  GestureDetector buildBookCaseItem(BuildContext context, EdgeInsets edgeInsets,
      ModelMyBookResponse modelMyBookResponse, int index, Function function, Function funDelete) {
    return GestureDetector(
      onTap: () {
        function();
      },
      child: Container(
        height: FetchPixels.getPixelHeight(120),
        margin: EdgeInsets.only(bottom: FetchPixels.getPixelHeight(1)),
        padding:
            EdgeInsets.symmetric(vertical: FetchPixels.getPixelHeight(0), horizontal: FetchPixels.getPixelWidth(20)),
        decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Color(0xFFEDEBE8), blurRadius: 3, offset: Offset(0.0, 1.0)),
            ],
            borderRadius: BorderRadius.zero),
        child: Row(
          children: [
            ExtendedImage.network(
              modelMyBookResponse.modelBookResponse.getFirstImg(),
              width: FetchPixels.getPixelHeight(90),
              height: FetchPixels.getPixelHeight(90),
              fit: BoxFit.fitHeight,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(9)),
              // border: Border(top: BorderSide(color: Color(0xffd3d3d3), width: 0.8)),
              cache: true,
              // shape: BoxShape.circle,
              loadStateChanged: (ExtendedImageState state) {
                switch (state.extendedImageLoadState) {
                  case LoadState.loading:
                    return Image.asset(modelMyBookResponse.modelBookResponse.getPlaceHolderImg(), fit: BoxFit.fill);
                  case LoadState.completed:
                    break;
                  case LoadState.failed:
                    return Image.asset(modelMyBookResponse.modelBookResponse.getPlaceHolderImg(), fit: BoxFit.fill);
                }
              },
            ),
            getHorSpace(FetchPixels.getPixelWidth(20)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      getCustomFont(
                        modelMyBookResponse.myBook.holdType.desc,
                        13,
                        modelMyBookResponse.myBook.holdType.color,
                        1,
                        fontWeight: FontWeight.w600,
                      ),
                      // getHorSpace(FetchPixels.getPixelHeight(3)),
                    ],
                  ),
                  getVerSpace(FetchPixels.getPixelHeight(5)),
                  getCustomFont(modelMyBookResponse.modelBookResponse.modelBook.name ?? "", 18, Colors.black, 1,
                      fontWeight: FontWeight.w500),
                  getVerSpace(FetchPixels.getPixelHeight(10)),
                  buildMyBookV1(context, edgeInsets, modelMyBookResponse)
                  // buildMyBook(context, edgeInsets, modelMyBookResponse),
                ],
              ),
            ),
            // Column(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     // getVerSpace(FetchPixels.getPixelHeight(20)),
            //     getSimpleImageButton(
            //         "ellipsis_horizontal_outline.svg",
            //         FetchPixels.getPixelHeight(60),
            //         FetchPixels.getPixelHeight(40),
            //         Colors.white,
            //         FetchPixels.getPixelHeight(26),
            //         FetchPixels.getPixelHeight(26), () {
            //       showModalBottomSheet(
            //           context: context, isScrollControlled: true, builder: (_) => BookCaseBottomSheet()).then((menu) {
            //         if (menu != null) {
            //           switch (menu) {
            //             case "수정하기":
            //               {
            //                 // clickedModifyComment(context, comment);
            //                 // Get.toNamed("${Routes.communityAddPath}?postId=${controller.postId}");
            //                 break;
            //               }
            //             case "삭제하기":
            //               {
            //                 clickedRemoveBook(modelMyBookResponse);
            //                 break;
            //               }
            //           }
            //         }
            //       });
            //     }, containerPadding: EdgeInsets.only(left: FetchPixels.getPixelHeight(15))),
            //   ],
            // )
          ],
        ),
      ),
    );
  }

  Widget buildMyBookV1(BuildContext context, EdgeInsets edgeInsets, ModelMyBookResponse modelMyBookResponse) {
    if (modelMyBookResponse.needDetailReview()) {
      return getCustomFont(modelMyBookResponse.myBook.holdType == HoldType.plan ? "기대평점을 입력해주세요." : "책경험을 입력해주세요.", 11,
          Colors.black45, 1,
          fontWeight: FontWeight.w500);
    } else {
      if (modelMyBookResponse.myBook.holdType == HoldType.plan) {
        return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // getCustomFont("기대평점", 11, Colors.black45, 1, fontWeight: FontWeight.w500),
              // getVerSpace(FetchPixels.getPixelHeight(5)),
              modelMyBookResponse.myBook.tempReviewRating == null || modelMyBookResponse.myBook.tempReviewRating! == 0
                  ? Container()
                  : RatingBar.builder(
                      initialRating: modelMyBookResponse.myBook.tempReviewRating!.toDouble(),
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
                    )
            ]);
      } else if (modelMyBookResponse.myBook.holdType == HoldType.read ||
          modelMyBookResponse.myBook.holdType == HoldType.end) {
        return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // modelMyBookResponse.myBook.usedType == UsedType.none
              //     ? Container()
              //     : getCustomFont("${modelMyBookResponse.myBook.usedType.desc}구매", 11, Colors.black87, 1,
              //         fontWeight: FontWeight.w600),
              // getVerSpace(FetchPixels.getPixelHeight(5)),

              if (modelMyBookResponse.myBook.reviewRating != null &&
                  modelMyBookResponse.myBook.reviewRating! > 0.0) ...[
                RatingBar.builder(
                  initialRating: modelMyBookResponse.myBook.reviewRating!.toDouble(),
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
                getVerSpace(FetchPixels.getPixelHeight(10))
              ],
              modelMyBookResponse.myBook.inMonth == 0
                  ? Container()
                  : Column(children: [
                      Row(
                        children: [
                          modelMyBookResponse.myBook.inMonth != 0
                              ? Row(
                                  children: [
                                    getCustomFont("시작", 12, secondMainColor, 1, fontWeight: FontWeight.w600),
                                    getCustomFont(" ${modelMyBookResponse.myBook.inMonth}개월", 12, Colors.black87, 1,
                                        fontWeight: FontWeight.w500),
                                  ],
                                )
                              : Container(),
                          modelMyBookResponse.myBook.holdType == HoldType.end &&
                                  modelMyBookResponse.myBook.outMonth != 0
                              ? Row(
                                  children: [
                                    getCustomFont("   종료", 12, secondMainColor, 1, fontWeight: FontWeight.w600),
                                    getCustomFont(" ${modelMyBookResponse.myBook.outMonth}개월", 12, Colors.black87, 1,
                                        fontWeight: FontWeight.w500)
                                  ],
                                )
                              : Container(),
                        ],
                      ),
                      // getVerSpace(FetchPixels.getPixelHeight(7)),
                    ]),

              // getVerSpace(FetchPixels.getPixelHeight(5)),
            ]);
      } else {
        return Container();
      }
    }
  }

  Widget buildMyBook(BuildContext context, EdgeInsets edgeInsets, ModelMyBookResponse modelMyBookResponse) {
    return Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
      modelMyBookResponse.needDetailReview()
          ? getCustomFont("책경험을 입력해주세요.", 14, Colors.black45, 1, fontWeight: FontWeight.w400)
          : Column(
              children: [
                Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildBookInfoRow("상태", modelMyBookResponse.myBook.holdType.desc,
                            valueColor: modelMyBookResponse.myBook.holdType.color),
                        getVerSpace(FetchPixels.getPixelHeight(5)),
                        if (modelMyBookResponse.myBook.holdType == HoldType.plan) ...[
                          buildBookInfoRow("기대평점", "", tempRating: true, mybook: modelMyBookResponse.myBook),
                          getVerSpace(FetchPixels.getPixelHeight(5)),
                          buildBookInfoRow("한줄메모", modelMyBookResponse.myBook.comment ?? ""),
                          getVerSpace(FetchPixels.getPixelHeight(5)),
                        ] else if (modelMyBookResponse.myBook.holdType == HoldType.read ||
                            modelMyBookResponse.myBook.holdType == HoldType.end) ...[
                          buildBookInfoRow(
                              "날짜",
                              modelMyBookResponse.myBook.inMonth == 0
                                  ? ""
                                  : modelMyBookResponse.myBook.holdType != HoldType.end ||
                                          modelMyBookResponse.myBook.outMonth == 0
                                      ? "${modelMyBookResponse.myBook.inMonth}개월 ~"
                                      : "${modelMyBookResponse.myBook.inMonth}개월 ~ ${modelMyBookResponse.myBook.outMonth}개월"),
                          getVerSpace(FetchPixels.getPixelHeight(5)),
                          buildBookInfoRow("평점", "", rating: true, mybook: modelMyBookResponse.myBook),
                          getVerSpace(FetchPixels.getPixelHeight(5)),
                          buildBookInfoRow(
                              "구매방식",
                              modelMyBookResponse.myBook.usedType == UsedType.none
                                  ? ""
                                  : "${modelMyBookResponse.myBook.usedType.desc}구매"),
                          getVerSpace(FetchPixels.getPixelHeight(5)),
                          if (controller.myBookCase) ...[
                            buildBookInfoRow("한줄메모", modelMyBookResponse.myBook.comment ?? ""),
                            getVerSpace(FetchPixels.getPixelHeight(5))
                          ]
                        ]
                      ],
                    ),
                  ],
                )
              ],
            )
    ]);
  }

  clickedModifyComment(BuildContext context, ModelMyBookResponse mybook) async {
    // if (comment.deleted) {
    //   Get.dialog(ErrorDialog("삭제된 댓글은 수정할 수 없습니다."));
    //   return;
    // }
    // // controller.commentModify(comment);
    // controller.executeModifyCommentMode(comment).then((value) => commentKeyboardUp(context));
  }

  clickedRemoveBook(ModelMyBookResponse mybook) async {
    bool? result = await Get.dialog(ReConfirmDialog("삭제 하시겠습니까?", "삭제", "취소", () async {
      controller.removeBook(holdType, mybook).then((result) => Get.back(result: result));
    }));

    if (result == null) {
      ///취소선택
      return;
    } else if (result) {
      onRefresh();
    } else {
      Get.dialog(ErrorDialog("잠시 후 다시 시도해주세요."));
    }
  }

  Widget buildBookInfoRow(String title, String value,
      {String? link,
      double? titleTextSize,
      int? titleLength,
      double? valueTextSize,
      int? valueLength,
      Color? valueColor,
      bool? tempRating,
      bool? rating,
      ModelMyBook? mybook}) {
    return Row(
      children: [
        SizedBox(
          width: 15.w,
          child: getCustomFont(
            title ?? "",
            titleTextSize ?? 11,
            Colors.black45,
            titleLength ?? 1,
            fontWeight: FontWeight.w500,
          ),
        ),
        getHorSpace(FetchPixels.getPixelHeight(5)),
        if (rating == true) ...[
          mybook!.reviewRating == null || mybook!.reviewRating! == 0
              ? Container()
              : RatingBar.builder(
                  initialRating: mybook!.reviewRating!.toDouble(),
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
          mybook!.tempReviewRating == null || mybook!.tempReviewRating! == 0
              ? Container()
              : RatingBar.builder(
                  initialRating: mybook.tempReviewRating!.toDouble(),
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
                  child: Expanded(
                      child: SizedBox(
                          // width: 55.w,
                          child: getCustomFont(
                    value ?? "",
                    valueTextSize ?? 13,
                    Colors.blueAccent,
                    valueLength ?? 3,
                    fontWeight: FontWeight.w400,
                  ))),
                )
              : Expanded(
                  child: SizedBox(
                      // width: 55.w,
                      child: getCustomFont(
                  value ?? "",
                  valueTextSize ?? 13,
                  valueColor ?? Colors.black,
                  valueLength ?? 1,
                  fontWeight: FontWeight.w400,
                )))
        ]
      ],
    );
  }
}
