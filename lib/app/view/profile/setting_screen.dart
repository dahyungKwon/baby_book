import 'package:baby_book/app/repository/member_repository.dart';
import 'package:baby_book/base/color_data.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../base/skeleton.dart';
import '../../../base/uuid_util.dart';
import '../../controller/SettingController.dart';
import '../../routes/app_pages.dart';

class SettingScreen extends GetView<SettingController> {
  late final String? uniqueTag;

  SettingScreen({super.key}) {
    uniqueTag = getUuid();

    Get.put(SettingController(memberRepository: MemberRepository()), tag: uniqueTag);
  }

  @override
  String? get tag => uniqueTag;

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    double defHorSpace = FetchPixels.getDefaultHorSpace(context);
    EdgeInsets edgeInsets = EdgeInsets.symmetric(horizontal: defHorSpace);

    return WillPopScope(
        onWillPop: () async {
          Get.back();
          return false;
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: backGroundColor,
            body: Obx(() => SafeArea(
                  child: controller.loading
                      ? const FullSizeSkeleton()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildToolbar(context, edgeInsets),
                            getVerSpace(FetchPixels.getPixelHeight(5)),
                            buildBody(context, edgeInsets),
                            // buildBody(context, edgeInsets)
                          ],
                        ),
                ))));
  }

  Widget buildToolbar(BuildContext context, EdgeInsets edgeInsets) {
    return Container(
        padding: const EdgeInsets.fromLTRB(5, 10, 0, 0),
        color: Colors.white,
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          getSimpleImageButton("back_outline.svg", FetchPixels.getPixelHeight(50), FetchPixels.getPixelHeight(50),
              Colors.white, FetchPixels.getPixelHeight(26), FetchPixels.getPixelHeight(26), () async {
            Get.back();
          }),
          getCustomFont(
            "설정",
            18,
            Colors.black,
            1,
            fontWeight: FontWeight.w500,
          ),
        ]));
  }

  Widget buildBody(BuildContext context, EdgeInsets edgeInsets) {
    return Container(
      width: 100.w,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            // POINT
            color: Color(0xFFEDEBE8),
            width: 1.0,
          ),
        ),
      ),
      // margin: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
      margin: EdgeInsets.only(bottom: FetchPixels.getPixelHeight(1)),
      padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20), vertical: FetchPixels.getPixelWidth(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // getCustomFont(
          //   "계정",
          //   14,
          //   Colors.black,
          //   1,
          //   fontWeight: FontWeight.w700,
          // ),
          // getVerSpace(FetchPixels.getPixelHeight(30)),
          getSimpleTextButton(
              "회원 탈퇴", 18, Colors.black87, Colors.white, FontWeight.w400, 100.w, FetchPixels.getPixelHeight(25), () {
            controller.deleteMember();
          }, alignment: Alignment.centerLeft),
          getVerSpace(FetchPixels.getPixelHeight(30)),
          getSimpleTextButton(
              "서비스 이용약관", 18, Colors.black87, Colors.white, FontWeight.w400, 100.w, FetchPixels.getPixelHeight(25), () {
            Get.toNamed(Routes.servicePolicyPath);
          }, alignment: Alignment.centerLeft),
          getVerSpace(FetchPixels.getPixelHeight(30)),
          getSimpleTextButton(
              "개인정보 처리방침", 18, Colors.black87, Colors.white, FontWeight.w400, 100.w, FetchPixels.getPixelHeight(25),
              () {
            Get.toNamed(Routes.privacyPolicyPath);
          }, alignment: Alignment.centerLeft)
        ],
      ),
    );
  }
}
