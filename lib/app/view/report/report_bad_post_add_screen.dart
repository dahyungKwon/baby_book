import 'package:baby_book/app/repository/report_bad_post_repository.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../base/color_data.dart';
import '../../../base/skeleton.dart';
import '../../../base/widget_utils.dart';
import '../../controller/ReportBadPostAddController.dart';

class ReportBadPostAddScreen extends GetView<ReportBadPostAddController> {
  FocusNode titleFocusNode = FocusNode();
  FocusNode contentsFocusNode = FocusNode();

  ReportBadPostAddScreen({super.key}) {
    Get.delete<ReportBadPostAddController>();
    Get.put(ReportBadPostAddController(
        reportBadPostRepository: ReportBadPostRepository(),
        postId: Get.parameters['postId']!,
        postTitle: Get.parameters['postTitle']!,
        writerName: Get.parameters['writerName']!));
    int? reportId = Get.parameters['reportId'] != null ? int.parse(Get.parameters['reportId']!) : null;
    if (reportId != null) {
      controller.initModifyMode(reportId!);
    } else {
      controller.titleController.text = "";
      controller.contentsController.text = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets edgeInsets = EdgeInsets.symmetric(
      horizontal: FetchPixels.getDefaultHorSpace(context),
    );

    FetchPixels(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: backGroundColor,
      body: SafeArea(
          child: Obx(
        () => Container(
          color: Colors.white,
          // padding: EdgeInsets.symmetric(horizontal: FetchPixels.getDefaultHorSpace(context)),
          child: controller.loading
              ? const FullSizeSkeleton()
              : Column(
                  children: [buildToolbar(context), buildExpand(context)],
                ),
        ),
      )),
    );
  }

  Expanded buildExpand(BuildContext context) {
    return Expanded(
        flex: 1,
        child: ListView(physics: const BouncingScrollPhysics(), shrinkWrap: true, primary: true, children: [
          getDefaultTextFiledWithLabel2(context, "신고 제목을 입력해주세요.", Colors.black45.withOpacity(0.3),
              controller.titleController, Colors.grey, FetchPixels.getPixelHeight(22), FontWeight.w500,
              function: () {},
              isEnable: false,
              withprefix: false,
              minLines: true,
              height: FetchPixels.getPixelHeight(70),
              alignmentGeometry: Alignment.center,
              boxColor: backGroundColor,
              myFocusNode: titleFocusNode),
          getVerSpace(FetchPixels.getPixelHeight(0)),
          getDefaultTextFiledWithLabel2(context, "신고 상세 내용을 입력해주세요.", Colors.black45.withOpacity(0.3),
              controller.contentsController, Colors.grey, FetchPixels.getPixelHeight(16), FontWeight.w400,
              function: () {},
              isEnable: false,
              withprefix: false,
              minLines: true,
              height: FetchPixels.getPixelHeight(400),
              alignmentGeometry: Alignment.topLeft,
              boxColor: backGroundColor,
              myFocusNode: contentsFocusNode),
          // getVerSpace(FetchPixels.getPixelHeight(10)),
        ]));
  }

  Container buildToolbar(BuildContext context) {
    return Container(
        color: backGroundColor,
        child: Column(children: [
          getToolbarMenuWithoutImg(
              context,
              "취소",
              Colors.black54,
              () {
                Get.back();
              },
              istext: false,
              isRight: true,
              weight: FontWeight.w500,
              fontsize: 18,
              rightText: controller.modifyMode ? "수정" : "신고",
              rightTextColor: controller.canRegister ? secondMainColor : Colors.grey.shade400,
              rightFunction: () async {
                commentKeyboardDown(context);

                bool result = await controller.add();

                if (result) {
                  Get.back(result: true);
                  Get.snackbar('', '',
                      colorText: Colors.white,
                      backgroundColor: secondMainColor,
                      snackPosition: SnackPosition.BOTTOM,
                      titleText: getCustomFont("신고 완료", FetchPixels.getPixelHeight(18), Colors.white, 1,
                          fontWeight: FontWeight.w600),
                      messageText: getCustomFont(
                          "신고 감사드립니다. 빠르게 검토하고 처리하겠습니다.", FetchPixels.getPixelHeight(14), Colors.white, 1,
                          fontWeight: FontWeight.w500),
                      margin: EdgeInsets.symmetric(
                          vertical: FetchPixels.getPixelHeight(20), horizontal: FetchPixels.getPixelHeight(20)));
                }
              }),
          // getVerSpace(FetchPixels.getPixelHeight(10))
        ]));
  }

  commentKeyboardDown(BuildContext context) {
    FocusScope.of(context).unfocus();
  }
}
