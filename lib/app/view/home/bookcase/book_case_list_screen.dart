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
import 'package:pull_to_refresh/pull_to_refresh.dart';

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
  late HoldType holdType;
  late RefreshController refreshController;
  int pageNumber = 1;

  BookCaseListScreen({required String? memberId, required this.holdType, super.key}) {
    uniqueTag = getUuid();
    Get.put(
        BookCaseListController(
            myBookRepository: MyBookRepository(),
            memberRepository: MemberRepository(),
            babyRepository: BabyRepository(),
            memberId: memberId),
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
              : draw()),
    );
  }

  SmartRefresher draw() {
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
            return buildBookCaseItem(modelMyBookResponse, context, index, () {
              Get.toNamed(Routes.bookDetailPath, parameters: {
                'bookSetId': modelMyBookResponse.myBook.bookSetId.toString(),
                'babyId': modelMyBookResponse.myBook.babyId
              });
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

  GestureDetector buildBookCaseItem(
      ModelMyBookResponse modelMyBookResponse, BuildContext context, int index, Function function, Function funDelete) {
    return GestureDetector(
      onTap: () {
        function();
      },
      child: Container(
        height: FetchPixels.getPixelHeight(100),
        margin: EdgeInsets.only(bottom: FetchPixels.getPixelHeight(1)),
        padding:
            EdgeInsets.symmetric(vertical: FetchPixels.getPixelHeight(10), horizontal: FetchPixels.getPixelWidth(20)),
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
              width: FetchPixels.getPixelHeight(80),
              height: FetchPixels.getPixelHeight(80),
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
            getHorSpace(FetchPixels.getPixelWidth(16)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      getCustomFont(
                        modelMyBookResponse.myBook.holdType.desc,
                        11,
                        modelMyBookResponse.myBook.holdType.color,
                        1,
                        fontWeight: FontWeight.w500,
                      ),
                      getHorSpace(FetchPixels.getPixelHeight(3)),
                    ],
                  ),
                  getVerSpace(FetchPixels.getPixelHeight(5)),
                  getCustomFont(modelMyBookResponse.modelBookResponse.modelBook.name ?? "", 18, Colors.black, 1,
                      fontWeight: FontWeight.w500),
                  getVerSpace(FetchPixels.getPixelHeight(7)),
                  Row(
                    children: [
                      modelMyBookResponse.myBook.reviewType == ReviewType.none
                          ? Container()
                          : getCustomFont(
                              "#${modelMyBookResponse.myBook.reviewType.desc}  " ?? "", 11, Colors.black87, 1,
                              fontWeight: FontWeight.w600),
                      modelMyBookResponse.myBook.usedType == UsedType.none
                          ? Container()
                          : getCustomFont("#${modelMyBookResponse.myBook.usedType.desc}구매", 11, Colors.black87, 1,
                              fontWeight: FontWeight.w600),
                    ],
                  ),
                  getVerSpace(FetchPixels.getPixelHeight(7)),
                  modelMyBookResponse.myBook.inMonth == 0
                      ? Container()
                      : Column(children: [
                          // getVerSpace(FetchPixels.getPixelHeight(10)),
                          Row(
                            children: [
                              modelMyBookResponse.myBook.inMonth != 0
                                  ? Row(
                                      children: [
                                        getCustomFont("시작", 11, secondMainColor, 1, fontWeight: FontWeight.w600),
                                        getCustomFont(" ${modelMyBookResponse.myBook.inMonth}개월", 11, Colors.black87, 1,
                                            fontWeight: FontWeight.w600),
                                      ],
                                    )
                                  : Container(),
                              modelMyBookResponse.myBook.outMonth != 0
                                  ? Row(
                                      children: [
                                        getCustomFont("   종료", 11, secondMainColor, 1, fontWeight: FontWeight.w600),
                                        getCustomFont(
                                            " ${modelMyBookResponse.myBook.outMonth}개월", 11, Colors.black87, 1,
                                            fontWeight: FontWeight.w600)
                                      ],
                                    )
                                  : Container(),
                            ],
                          ),
                          // getVerSpace(FetchPixels.getPixelHeight(7)),
                        ]),
                  modelMyBookResponse.needDetailReview()
                      ? getCustomFont("책경험을 입력해주세요.", 11, Colors.black45, 1, fontWeight: FontWeight.w500)
                      : Container(),
                  // getVerSpace(FetchPixels.getPixelHeight(3)),
                  // modelMyBookResponse.myBook.reviewRating == null || modelMyBookResponse.myBook.reviewRating! == 0
                  //     ? Container()
                  //     : RatingBar.builder(
                  //         initialRating: modelMyBookResponse.myBook.reviewRating!.toDouble(),
                  //         minRating: 1,
                  //         direction: Axis.horizontal,
                  //         allowHalfRating: false,
                  //         itemCount: 5,
                  //         itemSize: 16,
                  //         ignoreGestures: true,
                  //         itemPadding: EdgeInsets.symmetric(horizontal: 0),
                  //         itemBuilder: (context, _) => Icon(
                  //           Icons.star_rounded,
                  //           color: Colors.amber,
                  //         ),
                  //         unratedColor: Colors.white,
                  //         onRatingUpdate: (rating) {
                  //           print(rating);
                  //         },
                  //       ),
                  // getVerSpace(FetchPixels.getPixelHeight(3)),
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
}
