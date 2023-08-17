import 'package:baby_book/app/controller/CommunityTagAddController.dart';
import 'package:baby_book/app/models/model_book_response.dart';
import 'package:baby_book/app/view/home/home_screen.dart';
import 'package:baby_book/base/constant.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../base/color_data.dart';
import '../../controller/CommunityAddController.dart';
import '../../models/model_book.dart';
import '../../routes/app_pages.dart';
import '../search/search_type.dart';
import 'error_dialog.dart';

class TagDialog extends GetView<CommunityTagAddController> {
  TagDialog(List<ModelBookResponse> selectedBookTagList, {Key? key}) : super(key: key) {
    Get.put(CommunityTagAddController());
    controller.tagController.text = "";
    controller.selectedBookTagList = <ModelBookResponse>[];
    controller.selectedBookTagList.addAll(selectedBookTagList);
  }

  SizedBox selectedTagList() {
    return SizedBox(
        height: FetchPixels.getPixelHeight(160),
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: controller.selectedBookTagList.length,
          itemBuilder: (context, index) {
            ModelBookResponse bookResponse = controller.selectedBookTagList[index];
            ModelBook book = bookResponse.modelBook;
            return GestureDetector(
                onTap: () {
                  controller.removeBookTag(index);
                },
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFFF5F6F8),
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                          child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    width: FetchPixels.getPixelWidth(210),
                                    child: Text(
                                      "#${book.name}",
                                      maxLines: 1,
                                      style: TextStyle(fontSize: 15, overflow: TextOverflow.ellipsis),
                                    )),
                                getHorSpace(FetchPixels.getPixelHeight(10)),
                                getSvgImage("close_outline.svg", width: 15, height: 15),
                              ])),
                      getVerSpace(FetchPixels.getPixelHeight(16))
                    ]));
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return WillPopScope(
        onWillPop: () async {
          Get.back();
          return false;
        },
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(20))),
          backgroundColor: backGroundColor,
          content: SizedBox(
            width: 100.w,
            child: Builder(
              builder: (context) {
                return Obx(() => Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        getVerSpace(FetchPixels.getPixelHeight(10)),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            // mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                  child: getDefaultTextFiledWithLabel2(
                                context,
                                "태그할 책이름을 입력해주세요.",
                                Colors.black45.withOpacity(0.3),
                                controller.tagController,
                                Colors.grey,
                                FetchPixels.getPixelHeight(14),
                                FontWeight.w400,
                                function: () {},
                                isEnable: false,
                                withprefix: false,
                                minLines: true,
                                height: FetchPixels.getPixelHeight(50),
                                alignmentGeometry: Alignment.center,
                                boxColor: Color(0xFFF5F6F8),
                              )),
                              getHorSpace(FetchPixels.getPixelHeight(5)),
                              getButton(context, Color(0xFFF5F6F8), "검색", Colors.black, () {
                                controller.searchBook();
                                // controller.addTag();
                              }, 15,
                                  weight: FontWeight.w500,
                                  buttonWidth: FetchPixels.getPixelHeight(50),
                                  buttonHeight: FetchPixels.getPixelHeight(50),
                                  borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(8)))
                            ]),
                        getVerSpace(FetchPixels.getPixelHeight(15)),
                        selectedTagList(),
                        getVerSpace(FetchPixels.getPixelHeight(15)),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              getButton(context, Colors.transparent, "취소", Colors.black, () {
                                Get.back();
                              }, 15,
                                  weight: FontWeight.w500,
                                  buttonWidth: FetchPixels.getPixelHeight(60),
                                  buttonHeight: FetchPixels.getPixelHeight(40),
                                  borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(8))),
                              getHorSpace(FetchPixels.getPixelHeight(20)),
                              getButton(context, Colors.transparent, "완료", Colors.black, () {
                                // Get.find<CommunityAddController>().selectedBookTagList = <String>[];
                                // Get.find<CommunityAddController>()
                                //     .selectedBookTagList
                                //     .addAll(controller.selectedBookTagList);
                                Get.back(result: controller.selectedBookTagList);
                              }, 15,
                                  weight: FontWeight.w500,
                                  buttonWidth: FetchPixels.getPixelHeight(60),
                                  buttonHeight: FetchPixels.getPixelHeight(40),
                                  borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(8)))
                            ])
                      ],
                    ));
              },
            ),
          ),
        ));
  }
}
