import 'package:baby_book/app/models/model_my_book_response.dart';
import 'package:baby_book/app/repository/baby_repository.dart';
import 'package:baby_book/app/repository/member_repository.dart';
import 'package:baby_book/app/repository/my_book_repository.dart';
import 'package:baby_book/base/color_data.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../base/skeleton.dart';
import '../../../../base/uuid_util.dart';
import '../../../controller/BookCaseListController.dart';
import '../../../routes/app_pages.dart';
import '../book/HoldType.dart';

class BookCaseListScreen extends GetView<BookCaseListController> {
  late final String? uniqueTag;

  BookCaseListScreen({required String memberId, required HoldType? holdType, super.key}) {
    uniqueTag = getUuid();
    Get.put(
        BookCaseListController(
            myBookRepository: MyBookRepository(),
            memberRepository: MemberRepository(),
            babyRepository: BabyRepository(),
            memberId: memberId,
            holdType: holdType),
        tag: uniqueTag);
  }

  @override
  String? get tag => uniqueTag;

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
              : allBookingList()),
    );
  }

  ListView allBookingList() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: controller.myBookResponseList.length,
      itemBuilder: (context, index) {
        ModelMyBookResponse modelMyBookResponse = controller.myBookResponseList[index];
        return buildBookCaseItem(modelMyBookResponse, context, index, () {}, () {});
      },
    );
  }

  Column nullListView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // getSvgImage("clipboard.svg", height: FetchPixels.getPixelHeight(124), width: FetchPixels.getPixelHeight(124)),
        // getVerSpace(FetchPixels.getPixelHeight(40)),
        getCustomFont("책이 없습니다.", 20, Colors.black, 1, fontWeight: FontWeight.w600),
        getVerSpace(FetchPixels.getPixelHeight(10)),
        getCustomFont(
          "책장에 책을 추가하여 히스토리 관리해보세요.",
          16,
          Colors.black45,
          1,
          fontWeight: FontWeight.w400,
        ),
        getVerSpace(FetchPixels.getPixelHeight(30)),
        getButton(context, backGroundColor, "책 추가 하러가기", Colors.black87, () {
          Get.toNamed(Routes.homescreenPath);
        }, 18,
            weight: FontWeight.w600,
            buttonHeight: FetchPixels.getPixelHeight(60),
            insetsGeometry: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(100)),
            borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(14)),
            isBorder: true,
            borderColor: Colors.grey,
            borderWidth: 1.5)
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
        height: FetchPixels.getPixelHeight(120),
        margin: EdgeInsets.only(
            bottom: FetchPixels.getPixelHeight(20),
            left: FetchPixels.getDefaultHorSpace(context),
            right: FetchPixels.getDefaultHorSpace(context)),
        padding:
            EdgeInsets.symmetric(vertical: FetchPixels.getPixelHeight(16), horizontal: FetchPixels.getPixelWidth(16)),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0.0, 4.0)),
            ],
            borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(12))),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  ExtendedImage.network(
                    modelMyBookResponse.modelBookResponse.getFirstImg(),
                    width: FetchPixels.getPixelHeight(80),
                    height: FetchPixels.getPixelHeight(80),
                    fit: BoxFit.fitHeight,
                    cache: true,
                    loadStateChanged: (ExtendedImageState state) {
                      switch (state.extendedImageLoadState) {
                        case LoadState.loading:
                          return Image.asset(modelMyBookResponse.modelBookResponse.getPlaceHolderImg(),
                              fit: BoxFit.fill);
                        case LoadState.completed:
                          break;
                        case LoadState.failed:
                          return Image.asset(modelMyBookResponse.modelBookResponse.getPlaceHolderImg(),
                              fit: BoxFit.fill);
                      }
                    },
                  ),
                  getHorSpace(FetchPixels.getPixelWidth(16)),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: getHorSpace(0),
                        ),
                        getCustomFont(modelMyBookResponse.modelBookResponse.modelBook.name ?? "", 16, Colors.black, 1,
                            fontWeight: FontWeight.w900),
                        getVerSpace(FetchPixels.getPixelHeight(12)),
                        getCustomFont(
                          modelMyBookResponse.modelBookResponse.modelPublisher.publisherName ?? "",
                          14,
                          textColor,
                          1,
                          fontWeight: FontWeight.w400,
                        ),
                        getVerSpace(FetchPixels.getPixelHeight(12)),
                        // Row(
                        //   children: [
                        //     getSvgImage("star.svg",
                        //         height: FetchPixels.getPixelHeight(16), width: FetchPixels.getPixelHeight(16)),
                        //     getHorSpace(FetchPixels.getPixelWidth(6)),
                        //     getCustomFont(modelBooking.rating ?? "", 14, Colors.black, 1, fontWeight: FontWeight.w400),
                        //   ],
                        // ),
                        Expanded(
                          flex: 1,
                          child: getHorSpace(0),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          funDelete();
                        },
                        child: getSvgImage("trash.svg",
                            width: FetchPixels.getPixelHeight(20), height: FetchPixels.getPixelHeight(20)),
                      ),
                      // getPaddingWidget(
                      //     EdgeInsets.only(bottom:FetchPixels.getPixelHeight(10) ),
                      //     getCustomFont("\$${modelBooking.price}",
                      //   16,
                      //   blueColor,
                      //   1,
                      //   fontWeight: FontWeight.w900,
                      // )),
                      //  Row(
                      //    children: [
                      //      getSvgImage("star.svg",
                      //          height: FetchPixels.getPixelHeight(16),
                      //          width: FetchPixels.getPixelHeight(16)),
                      //      getHorSpace(FetchPixels.getPixelWidth(6)),
                      //      getCustomFont(
                      //          modelBooking.rating ?? "", 14, Colors.black, 1,
                      //          fontWeight: FontWeight.w400),
                      //    ],
                      //  )
                    ],
                  )
                ],
              ),
            ),
            // getVerSpace(FetchPixels.getPixelHeight(16)),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   children: [
            //     Row(
            //       children: [
            //         getAssetImage("dot.png", FetchPixels.getPixelHeight(8),
            //             FetchPixels.getPixelHeight(8)),
            //         getHorSpace(FetchPixels.getPixelWidth(8)),
            //         getCustomFont(modelBooking.owner ?? "", 14, textColor, 1,
            //             fontWeight: FontWeight.w400),
            //       ],
            //     ),
            //     Wrap(
            //       children: [
            //         getButton(
            //             context,
            //             Color(modelBooking.bgColor!.toInt()),
            //             modelBooking.tag ?? "",
            //             modelBooking.textColor!,
            //             () {},
            //             16,
            //             weight: FontWeight.w600,
            //             borderRadius:
            //                 BorderRadius.circular(FetchPixels.getPixelHeight(37)),
            //             insetsGeometrypadding: EdgeInsets.symmetric(
            //                 vertical: FetchPixels.getPixelHeight(6),
            //                 horizontal: FetchPixels.getPixelWidth(12)))
            //       ],
            //     )
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
