import 'package:baby_book/app/models/model_my_book.dart';
import 'package:baby_book/app/view/home/book/HoldType.dart';
import 'package:baby_book/app/view/home/book/UsedType.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../../../base/color_data.dart';
import '../../../../base/resizer/fetch_pixels.dart';
import '../../../controller/BookExperienceBottomSheetController.dart';
import '../../../repository/my_book_repository.dart';
import 'package:flutter/foundation.dart' as foundation;

class BookExperienceBottomSheet extends GetView<BookExperienceBottomSheetController> {
  FocusNode tempReviewFocusNode = FocusNode();
  FocusNode memoFocusNode = FocusNode();
  late ModelMyBook mybook;

  // late final String? uniqueTag;

  BookExperienceBottomSheet({super.key, required this.mybook}) {
    Get.delete<BookExperienceBottomSheetController>(tag: mybook.bookSetId.toString());
    // uniqueTag = getUuid();
    Get.put(BookExperienceBottomSheetController(myBookRepository: MyBookRepository(), mybook: mybook),
        tag: mybook.bookSetId.toString());
  }

  @override
  String? get tag => mybook.bookSetId.toString();

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Obx(() => Container(
        color: Colors.white,
        margin: EdgeInsets.only(
            bottom:
            FetchPixels.getPixelHeight(foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS ? 20 : 0)),
        padding: EdgeInsets.only(
            left: FetchPixels.getPixelHeight(10),
            right: FetchPixels.getPixelHeight(10),
            top: FetchPixels.getPixelHeight(15),
            bottom: FetchPixels.getPixelHeight(15)),
        child: Padding(
            padding: EdgeInsets.only(bottom: bottomInset),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (controller.mybook.holdType == HoldType.plan) ...[
                    buildHoldType(),
                    getVerSpace(FetchPixels.getPixelHeight(20)),
                    buildTempInMonth(context),
                    getVerSpace(FetchPixels.getPixelHeight(20)),
                    buildTempReviewType(context),
                    getVerSpace(FetchPixels.getPixelHeight(20)),
                    buildMemo(context),
                    buildModifyBtn(context)
                  ] else if (controller.mybook.holdType == HoldType.read) ...[
                    buildHoldType(),
                    getVerSpace(FetchPixels.getPixelHeight(20)),
                    buildUsedType(context),
                    getVerSpace(FetchPixels.getPixelHeight(20)),
                    buildInMonth(context),
                    getVerSpace(FetchPixels.getPixelHeight(20)),
                    buildReviewType(context),
                    getVerSpace(FetchPixels.getPixelHeight(20)),
                    buildMemo(context),
                    buildModifyBtn(context)
                  ] else if (controller.mybook.holdType == HoldType.end) ...[
                    buildHoldType(),
                    getVerSpace(FetchPixels.getPixelHeight(20)),
                    buildUsedType(context),
                    getVerSpace(FetchPixels.getPixelHeight(20)),
                    buildInMonth(context),
                    getVerSpace(FetchPixels.getPixelHeight(20)),
                    buildOutMonth(context),
                    getVerSpace(FetchPixels.getPixelHeight(20)),
                    buildReviewType(context),
                    getVerSpace(FetchPixels.getPixelHeight(20)),
                    buildMemo(context),
                    buildModifyBtn(context)
                  ] else ...[
                    // getVerSpace(FetchPixels.getPixelHeight(20)),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelHeight(16)),
                      child: getCustomFont("책을 읽고 계신가요?" ?? "", 18, Colors.black, 1, fontWeight: FontWeight.w600),
                    ),
                    getVerSpace(FetchPixels.getPixelHeight(20)),
                    buildHoldType(),
                    getVerSpace(FetchPixels.getPixelHeight(20)),
                    // buildModifyBtn(context)
                  ],
                ],
              ),
            ))));
  }

  Widget buildModifyBtn(BuildContext context) {
    return getSimpleTextButton("확인", 18, Colors.black, Colors.white, FontWeight.w500,
        FetchPixels.getPixelHeight(double.infinity), FetchPixels.getPixelHeight(50), () {
      Navigator.pop(context, controller.mybook);
    });
  }

  Widget buildHoldType() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
            onTap: () {
              print("plan tab");
              if (controller.mybook.holdType == HoldType.plan) {
                controller.changeHoldType(HoldType.none);
              } else {
                controller.changeHoldType(HoldType.plan);
              }
            },
            child: Container(
              width: FetchPixels.getPixelHeight(110),
              height: FetchPixels.getPixelHeight(80),
              decoration: BoxDecoration(
                  color: controller.mybook.holdType == HoldType.plan ? HoldType.plan.color : Colors.black12,
                  borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(12)),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 1, offset: Offset(0.0, 0.0)),
                  ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      getSvgImage(HoldType.plan.image,
                          width: FetchPixels.getPixelHeight(15), height: FetchPixels.getPixelHeight(20)),
                      getHorSpace(FetchPixels.getPixelHeight(5)),
                      getCustomFont(HoldType.plan.desc, 16, Colors.white, 1, fontWeight: FontWeight.w500),
                    ],
                  )
                ],
              ),
            )),
        GestureDetector(
            onTap: () {
              if (controller.mybook.holdType == HoldType.read) {
                controller.changeHoldType(HoldType.none);
              } else {
                controller.changeHoldType(HoldType.read);
              }
            },
            child: Container(
              width: FetchPixels.getPixelHeight(110),
              height: FetchPixels.getPixelHeight(80),
              decoration: BoxDecoration(
                  color: controller.mybook.holdType == HoldType.read ? HoldType.read.color : Colors.black12,
                  borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(12)),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 1, offset: Offset(0.0, 0.0)),
                  ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      getSvgImage(HoldType.read.image,
                          width: FetchPixels.getPixelHeight(15), height: FetchPixels.getPixelHeight(20)),
                      getHorSpace(FetchPixels.getPixelHeight(5)),
                      getCustomFont(HoldType.read.desc, 16, Colors.white, 1, fontWeight: FontWeight.w500),
                    ],
                  )
                ],
              ),
            )),
        GestureDetector(
            onTap: () {
              if (controller.mybook.holdType == HoldType.end) {
                controller.changeHoldType(HoldType.none);
              } else {
                controller.changeHoldType(HoldType.end);
              }
            },
            child: Container(
              width: FetchPixels.getPixelHeight(110),
              height: FetchPixels.getPixelHeight(80),
              decoration: BoxDecoration(
                  color: controller.mybook.holdType == HoldType.end ? HoldType.end.color : Colors.black12,
                  borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(12)),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 1, offset: Offset(0.0, 0.0)),
                  ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      getSvgImage(HoldType.end.image,
                          width: FetchPixels.getPixelHeight(15), height: FetchPixels.getPixelHeight(20)),
                      getHorSpace(FetchPixels.getPixelHeight(5)),
                      getCustomFont(HoldType.end.desc, 16, Colors.white, 1, fontWeight: FontWeight.w500),
                    ],
                  )
                ],
              ),
            )),
      ],
    );
  }

  Widget buildTempReviewType(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelHeight(16)),
            child: getCustomFont("기대 평점" ?? "", 14, Colors.black38, 1, fontWeight: FontWeight.w600)),
        getVerSpace(10),
        Container(
            padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelHeight(10)),
            child: RatingBar.builder(
              initialRating: controller.mybook.tempReviewRating,
              minRating: 0,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 35,
              ignoreGestures: false,
              itemPadding: EdgeInsets.symmetric(horizontal: 0),
              itemBuilder: (context, _) => Icon(
                Icons.star_rounded,
                color: Colors.amber,
              ),
              unratedColor: Colors.amber.withAlpha(40),
              onRatingUpdate: (rating) {
                controller.mybook.tempReviewRating = rating;
              },
            ))
      ],
    );
    // return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    //   Container(
    //       padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelHeight(16)),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           getCustomFont("기대지수" ?? "", 14, Colors.black38, 1, fontWeight: FontWeight.w600),
    //           // getVerSpace(10),
    //           // getCustomFont("입력하신 모든 정보는 추후에 수정이 가능합니다." ?? "", 13, Colors.black38, 1, fontWeight: FontWeight.w400),
    //           // getVerSpace(30),
    //         ],
    //       )),
    //   getDefaultTextFiledWithLabel2(
    //       context,
    //       controller.mybook.tempReviewType == ReviewType.none ? "기대지수를 선택해주세요." : controller.mybook.tempReviewType.desc,
    //       controller.mybook.tempReviewType == ReviewType.none ? Colors.black45.withOpacity(0.3) : Colors.black,
    //       controller.tempReviewTypeTextEditing,
    //       Colors.black87,
    //       FetchPixels.getPixelHeight(20),
    //       boxColor: backGroundColor,
    //       FontWeight.w400, function: () {
    //     controller.showTempReviewTypeBottomSheet(context);
    //   },
    //       isEnable: false,
    //       withprefix: false,
    //       minLines: true,
    //       height: FetchPixels.getPixelHeight(45),
    //       withSufix: true,
    //       suffiximage: "down_arrow.svg",
    //       enableEditing: false)
    // ]);
  }

  Widget buildReviewType(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
          padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelHeight(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getCustomFont("평점" ?? "", 14, Colors.black38, 1, fontWeight: FontWeight.w600),
              // getVerSpace(10),
              // getCustomFont("입력하신 모든 정보는 추후에 수정이 가능합니다." ?? "", 13, Colors.black38, 1, fontWeight: FontWeight.w400),
              // getVerSpace(30),
            ],
          )),
      getVerSpace(10),
      Container(
          padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelHeight(10)),
          child: RatingBar.builder(
            initialRating: controller.mybook.reviewRating,
            minRating: 0,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemSize: 35,
            ignoreGestures: false,
            itemPadding: EdgeInsets.symmetric(horizontal: 0),
            itemBuilder: (context, _) => Icon(
              Icons.star_rounded,
              color: Colors.amber,
            ),
            unratedColor: Colors.amber.withAlpha(40),
            onRatingUpdate: (rating) {
              controller.mybook.reviewRating = rating;
            },
          ))
      // getDefaultTextFiledWithLabel2(
      //     context,
      //     controller.mybook.reviewType == ReviewType.none ? "책 평점을 선택 해주세요." : controller.mybook.reviewType.desc,
      //     controller.mybook.reviewType == ReviewType.none ? Colors.black45.withOpacity(0.3) : Colors.black,
      //     controller.reviewTypeTextEditing,
      //     Colors.black87,
      //     FetchPixels.getPixelHeight(20),
      //     boxColor: backGroundColor,
      //     FontWeight.w400, function: () {
      //   controller.showReviewTypeBottomSheet(context);
      // },
      //     isEnable: false,
      //     withprefix: false,
      //     minLines: true,
      //     height: FetchPixels.getPixelHeight(45),
      //     withSufix: true,
      //     suffiximage: "down_arrow.svg",
      //     enableEditing: false)
    ]);
  }

  Widget buildUsedType(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
          padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelHeight(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getCustomFont("구매 방식" ?? "", 14, Colors.black38, 1, fontWeight: FontWeight.w600),
              // getVerSpace(10),
              // getCustomFont("입력하신 모든 정보는 추후에 수정이 가능합니다." ?? "", 13, Colors.black38, 1, fontWeight: FontWeight.w400),
              // getVerSpace(30),
            ],
          )),
      getDefaultTextFiledWithLabel2(
          context,
          controller.mybook.usedType == UsedType.none ? "구매방식을 선택해주세요." : controller.mybook.usedType.desc,
          controller.mybook.usedType == UsedType.none ? Colors.black45.withOpacity(0.3) : Colors.black,
          controller.usedTypeTextEditing,
          Colors.black87,
          FetchPixels.getPixelHeight(20),
          boxColor: backGroundColor,
          FontWeight.w400, function: () {
        controller.showUsedTypeBottomSheet(context);
      },
          isEnable: false,
          withprefix: false,
          minLines: true,
          height: FetchPixels.getPixelHeight(45),
          withSufix: true,
          suffiximage: "down_arrow.svg",
          enableEditing: false)
    ]);
  }

  Widget buildTempInMonth(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
          padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelHeight(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getCustomFont("예정" ?? "", 14, Colors.black38, 1, fontWeight: FontWeight.w600),
              // getVerSpace(10),
              // getCustomFont("입력하신 모든 정보는 추후에 수정이 가능합니다." ?? "", 13, Colors.black38, 1, fontWeight: FontWeight.w400),
              // getVerSpace(30),
            ],
          )),
      getDefaultTextFiledWithLabel2(
          context,
          controller.mybook.tempInMonth == null || controller.mybook.tempInMonth == 0
              ? "구매예정 개월수를 선택해주세요."
              : "${controller.mybook.tempInMonth}개월 (만${calAge(controller.mybook.tempInMonth)}세)",
          controller.mybook.tempInMonth == null || controller.mybook.tempInMonth == 0
              ? Colors.black45.withOpacity(0.3)
              : Colors.black,
          controller.inMonthTextEditing,
          Colors.black87,
          FetchPixels.getPixelHeight(20),
          boxColor: backGroundColor,
          FontWeight.w400, function: () {
        controller.showTempInMonthBottomSheet(context);
      },
          isEnable: false,
          withprefix: false,
          minLines: true,
          height: FetchPixels.getPixelHeight(45),
          withSufix: true,
          suffiximage: "down_arrow.svg",
          enableEditing: false)
    ]);
  }

  Widget buildInMonth(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
          padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelHeight(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getCustomFont("시작" ?? "", 14, Colors.black38, 1, fontWeight: FontWeight.w600),
              // getVerSpace(10),
              // getCustomFont("입력하신 모든 정보는 추후에 수정이 가능합니다." ?? "", 13, Colors.black38, 1, fontWeight: FontWeight.w400),
              // getVerSpace(30),
            ],
          )),
      getDefaultTextFiledWithLabel2(
          context,
          controller.mybook.inMonth == null || controller.mybook.inMonth == 0
              ? "시작 개월수를 선택해주세요."
              : "${controller.mybook.inMonth}개월 (만${calAge(controller.mybook.inMonth)}세)",
          controller.mybook.inMonth == null || controller.mybook.inMonth == 0
              ? Colors.black45.withOpacity(0.3)
              : Colors.black,
          controller.inMonthTextEditing,
          Colors.black87,
          FetchPixels.getPixelHeight(20),
          boxColor: backGroundColor,
          FontWeight.w400, function: () {
        controller.showInMonthBottomSheet(context);
      },
          isEnable: false,
          withprefix: false,
          minLines: true,
          height: FetchPixels.getPixelHeight(45),
          withSufix: true,
          suffiximage: "down_arrow.svg",
          enableEditing: false)
    ]);
  }

  Widget buildOutMonth(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
          padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelHeight(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getCustomFont("종료" ?? "", 14, Colors.black38, 1, fontWeight: FontWeight.w600),
              // getVerSpace(10),
              // getCustomFont("입력하신 모든 정보는 추후에 수정이 가능합니다." ?? "", 13, Colors.black38, 1, fontWeight: FontWeight.w400),
              // getVerSpace(30),
            ],
          )),
      getDefaultTextFiledWithLabel2(
          context,
          controller.mybook.outMonth == null || controller.mybook.outMonth == 0
              ? "종료 개월수를 선택해주세요."
              : "${controller.mybook.outMonth}개월 (만${calAge(controller.mybook.outMonth)}세)",
          controller.mybook.outMonth == null || controller.mybook.outMonth == 0
              ? Colors.black45.withOpacity(0.3)
              : Colors.black,
          controller.outMonthTextEditing,
          Colors.black87,
          FetchPixels.getPixelHeight(20),
          boxColor: backGroundColor,
          FontWeight.w400, function: () {
        controller.showOutMonthBottomSheet(context, controller.mybook.inMonth);
      },
          isEnable: false,
          withprefix: false,
          minLines: true,
          height: FetchPixels.getPixelHeight(45),
          withSufix: true,
          suffiximage: "down_arrow.svg",
          enableEditing: false)
    ]);
  }

  Widget buildMemo(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
          padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelHeight(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getCustomFont("한줄 메모 (${controller.memoTypeTextEditing.text.length} / 15)" ?? "", 14, Colors.black38, 1,
                  fontWeight: FontWeight.w600),
              // getVerSpace(10),
            ],
          )),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: getDefaultTextFiledWithLabel2(context, "한줄 메모를 입력해주세요.", Colors.black45.withOpacity(0.3),
                  controller.memoTypeTextEditing, Colors.grey, FetchPixels.getPixelHeight(20), FontWeight.w400,
                  function: () {},
                  isEnable: false,
                  withprefix: false,
                  minLines: true,
                  // height: FetchPixels.getPixelHeight(50),
                  alignmentGeometry: Alignment.center,
                  boxColor: backGroundColor,
                  myFocusNode: memoFocusNode,
                  autofocus: false,
                  maxLength: 15)),
        ],
      )
    ]);
  }

  int calAge(int month) {
    ///0~11 => 만 0세 month / 12
    ///12~23 => 만 1세
    ///24~36 => 만 2세
    return month ~/ 12;
  }
}
