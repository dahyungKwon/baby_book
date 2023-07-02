import 'package:baby_book/app/controller/CommunityTagAddController.dart';
import 'package:baby_book/app/view/home/home_screen.dart';
import 'package:baby_book/base/constant.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../base/color_data.dart';
import '../../controller/CommunityAddController.dart';
import 'error_dialog.dart';

class TagDialog extends GetView<CommunityTagAddController> {
  TagDialog(List<String> selectedTagList, {Key? key}) : super(key: key) {
    Get.put(CommunityTagAddController());
    controller.tagController.text = "";
    controller.selectedTagList = <String>[];
    controller.selectedTagList.addAll(selectedTagList);
  }

  SizedBox selectedTagList() {
    return SizedBox(
        height: 120,
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: controller.selectedTagList.length,
          itemBuilder: (context, index) {
            String tag = controller.selectedTagList[index];
            return GestureDetector(
                onTap: () {
                  controller.removeTag(index);
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
                          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
                          child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "#$tag",
                                  style: TextStyle(fontSize: 15),
                                ),
                                getHorSpace(FetchPixels.getPixelHeight(10)),
                                getSvgImage("close_outline.svg", width: 15, height: 15),
                              ])),
                      getVerSpace(FetchPixels.getPixelHeight(10))
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
        content: Builder(
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
                            "태그를 입력해주세요.",
                            Colors.black45.withOpacity(0.3),
                            controller.tagController,
                            Colors.grey,
                            FetchPixels.getPixelHeight(15),
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
                          getButton(context, Color(0xFFF5F6F8), "추가", Colors.black, () {
                            controller.addTag();
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
                            Get.find<CommunityAddController>().selectedTagList = <String>[];
                            Get.find<CommunityAddController>().selectedTagList.addAll(controller.selectedTagList);
                            Get.back();
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
    );
  }
}
