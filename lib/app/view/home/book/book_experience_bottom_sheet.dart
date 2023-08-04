import 'package:baby_book/app/models/model_my_book.dart';
import 'package:baby_book/app/view/home/book/HoldType.dart';
import 'package:baby_book/app/view/home/book/ReviewType.dart';
import 'package:baby_book/app/view/home/book/UsedType.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../../base/color_data.dart';
import '../../../../base/resizer/fetch_pixels.dart';
import '../../../controller/BookExperienceBottomSheetController.dart';
import '../../../repository/my_book_repository.dart';

class BookExperienceBottomSheet extends GetView<BookExperienceBottomSheetController> {
  FocusNode tempReviewFocusNode = FocusNode();
  FocusNode memoFocusNode = FocusNode();

  BookExperienceBottomSheet({super.key, required ModelMyBook mybook}) {
    Get.delete<BookExperienceBottomSheetController>();
    Get.put(BookExperienceBottomSheetController(myBookRepository: MyBookRepository(), mybook: mybook));
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SizedBox(
            height: 45.h,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.only(
                  left: FetchPixels.getPixelHeight(10),
                  right: FetchPixels.getPixelHeight(10),
                  top: FetchPixels.getPixelHeight(15),
                  bottom: FetchPixels.getPixelHeight(15)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildHoldType(),
                  getVerSpace(FetchPixels.getPixelHeight(20)),
                  if (controller.mybook.holdType == HoldType.plan) ...[
                    buildTempReviewType(context),
                    getVerSpace(FetchPixels.getPixelHeight(20))
                  ] else if (controller.mybook.holdType == HoldType.read) ...[
                    buildReviewType(context),
                    getVerSpace(FetchPixels.getPixelHeight(20)),
                    buildUsedType(context),
                    getVerSpace(FetchPixels.getPixelHeight(20)),
                  ] else if (controller.mybook.holdType == HoldType.end) ...[
                    buildReviewType(context),
                    getVerSpace(FetchPixels.getPixelHeight(20)),
                    buildUsedType(context),
                    getVerSpace(FetchPixels.getPixelHeight(20)),
                  ],
                  buildMemo(context),
                  getSimpleTextButton("확인", 18, Colors.black, Colors.white, FontWeight.w500,
                      FetchPixels.getPixelHeight(double.infinity), FetchPixels.getPixelHeight(50), () {
                    // Navigator.pop(context, birth);
                  })
                ],
              ),
            ))));
  }

  Widget buildHoldType() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
            onTap: () {
              print("plan tab");
              controller.changeHoldType(HoldType.plan);
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
              print("read tab");
              controller.changeHoldType(HoldType.read);
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
              print("end tab");
              controller.changeHoldType(HoldType.end);
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
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
          padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelHeight(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getCustomFont("기대지수" ?? "", 14, Colors.black38, 1, fontWeight: FontWeight.w600),
              // getVerSpace(10),
              // getCustomFont("입력하신 모든 정보는 추후에 수정이 가능합니다." ?? "", 13, Colors.black38, 1, fontWeight: FontWeight.w400),
              // getVerSpace(30),
            ],
          )),
      getDefaultTextFiledWithLabel2(
          context,
          controller.mybook.tempReviewType == ReviewType.none ? "기대지수를 선택해주세요." : controller.mybook.tempReviewType.desc,
          controller.mybook.tempReviewType == ReviewType.none ? Colors.black45.withOpacity(0.3) : Colors.black,
          controller.tempReviewTypeTextEditing,
          Colors.black87,
          FetchPixels.getPixelHeight(20),
          boxColor: backGroundColor,
          FontWeight.w400, function: () {
        controller.showTempReviewTypeBottomSheet(context);
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
      getDefaultTextFiledWithLabel2(
          context,
          controller.mybook.reviewType == ReviewType.none ? "책 평점을 선택 해주세요." : controller.mybook.reviewType.desc,
          controller.mybook.reviewType == ReviewType.none ? Colors.black45.withOpacity(0.3) : Colors.black,
          controller.reviewTypeTextEditing,
          Colors.black87,
          FetchPixels.getPixelHeight(20),
          boxColor: backGroundColor,
          FontWeight.w400, function: () {
        controller.showReviewTypeBottomSheet(context);
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

  Widget buildUsedType(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
          padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelHeight(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getCustomFont("새책여부" ?? "", 14, Colors.black38, 1, fontWeight: FontWeight.w600),
              // getVerSpace(10),
              // getCustomFont("입력하신 모든 정보는 추후에 수정이 가능합니다." ?? "", 13, Colors.black38, 1, fontWeight: FontWeight.w400),
              // getVerSpace(30),
            ],
          )),
      getDefaultTextFiledWithLabel2(
          context,
          controller.mybook.usedType == UsedType.none ? "새책여부를 선택해주세요." : controller.mybook.usedType.desc,
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

  Widget buildMemo(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
          padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelHeight(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getCustomFont("메모" ?? "", 14, Colors.black38, 1, fontWeight: FontWeight.w600),
              // getVerSpace(10),
            ],
          )),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: getDefaultTextFiledWithLabel2(
            context,
            "메모를 입력해주세요.",
            Colors.black45.withOpacity(0.3),
            controller.memoTypeTextEditing,
            Colors.grey,
            FetchPixels.getPixelHeight(20),
            FontWeight.w400,
            function: () {},
            isEnable: false,
            withprefix: false,
            minLines: true,
            height: FetchPixels.getPixelHeight(50),
            alignmentGeometry: Alignment.center,
            boxColor: backGroundColor,
            myFocusNode: memoFocusNode,
            autofocus: false,
          )),
        ],
      )
    ]);
  }
}
