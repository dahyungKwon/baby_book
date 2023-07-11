import 'package:baby_book/app/repository/member_repository.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../../../base/color_data.dart';
import '../../../../base/skeleton.dart';
import '../../controller/JoinController.dart';
import '../../routes/app_pages.dart';
import 'gender_type.dart';
import 'gender_type_bottom_sheet.dart';

class JoinScreen extends GetView<JoinController> {
  FocusNode nickNameFocusNode = FocusNode();

  JoinScreen({super.key}) {
    Get.delete<JoinController>();
    Get.put(JoinController(memberRepository: MemberRepository()));
  }

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
            body: Obx(
              () => SafeArea(
                child: controller.loading
                    ? const FullSizeSkeleton()
                    : Column(
                        children: [
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
        padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              getSimpleImageButton("back_outline.svg", FetchPixels.getPixelHeight(50), FetchPixels.getPixelHeight(50),
                  Colors.white, FetchPixels.getPixelHeight(26), FetchPixels.getPixelHeight(26), () async {
                Get.back();
              }),
              getCustomFont(
                "프로필 설정",
                22,
                Colors.black,
                1,
                fontWeight: FontWeight.w600,
              ),
            ]),
            getSimpleTextButton("완료", 18, controller.canJoin ? Colors.redAccent : Colors.grey.shade400, Colors.white,
                FontWeight.w500, FetchPixels.getPixelWidth(75), FetchPixels.getPixelHeight(25), () {
              controller.confirm();
            }),
          ],
        ));
  }

  Expanded buildMainArea(BuildContext context, EdgeInsets edgeInsets, double defHorSpace) {
    return Expanded(
        flex: 1,
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(10)),
            child: ListView(primary: true, shrinkWrap: true, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: getDefaultTextFiledWithLabel2(
                    context,
                    "닉네임을 입력해주세요.",
                    Colors.black45.withOpacity(0.3),
                    controller.nickNameController,
                    Colors.grey,
                    FetchPixels.getPixelHeight(20),
                    FontWeight.w500,
                    function: () {},
                    isEnable: false,
                    withprefix: false,
                    minLines: true,
                    height: FetchPixels.getPixelHeight(50),
                    alignmentGeometry: Alignment.center,
                    boxColor: backGroundColor,
                    myFocusNode: nickNameFocusNode,
                    autofocus: true,
                  )),
                  controller.validNickName
                      ? getSimpleImageButton(
                          "confirm_mark.svg",
                          FetchPixels.getPixelHeight(40),
                          FetchPixels.getPixelHeight(40),
                          Colors.white,
                          FetchPixels.getPixelHeight(24),
                          FetchPixels.getPixelHeight(24),
                          () {})
                      : getSimpleTextButton(
                          "중복체크하기",
                          16,
                          controller.canCheckNickName ? Colors.redAccent : Colors.grey.shade400,
                          Colors.white,
                          FontWeight.w500,
                          FetchPixels.getPixelWidth(100),
                          FetchPixels.getPixelHeight(25), () {
                          nickNameKeyboardDown(context);
                          controller.confirmNickName();
                        }),
                  getHorSpace(FetchPixels.getPixelWidth(12))
                ],
              ),
              getDefaultTextFiledWithLabel2(
                  context,
                  controller.gender == GenderType.none ? "성별을 선택해주세요." : controller.gender.desc,
                  controller.gender == GenderType.none ? Colors.black45.withOpacity(0.3) : Colors.black,
                  controller.genderController,
                  Colors.black87,
                  FetchPixels.getPixelHeight(20),
                  boxColor: backGroundColor,
                  controller.gender == GenderType.none ? FontWeight.w400 : FontWeight.w600, function: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => GenderTypeBottomSheet(genderType: controller.gender!)).then((selectedGender) {
                  if (selectedGender != null) {
                    controller.changeGender(selectedGender);
                  }
                });
              },
                  isEnable: false,
                  withprefix: false,
                  minLines: true,
                  height: FetchPixels.getPixelHeight(50),
                  withSufix: true,
                  suffiximage: controller.gender == GenderType.none ? "down_arrow.svg" : "confirm_mark.svg",
                  enableEditing: false),
              getVerSpace(FetchPixels.getPixelHeight(40)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  getHorSpace(FetchPixels.getPixelWidth(16)),
                  Expanded(
                      child: GestureDetector(
                    onTap: () async {
                      Get.toNamed(Routes.servicePolicyPath);
                    },
                    child: getCustomFont("서비스 이용약관 동의", FetchPixels.getPixelHeight(15), Colors.blueAccent, 1,
                        fontWeight: FontWeight.w400),
                  )),
                  getSimpleImageButton(
                      controller.serviceAgreed ? "checkbox_check.svg" : "checkbox_uncheck.svg",
                      FetchPixels.getPixelHeight(50),
                      FetchPixels.getPixelHeight(50),
                      Colors.white,
                      FetchPixels.getPixelHeight(24),
                      FetchPixels.getPixelHeight(24), () {
                    controller.clickServiceAgreed();
                  }),
                  // getHorSpace(FetchPixels.getPixelWidth(12))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  getHorSpace(FetchPixels.getPixelWidth(16)),
                  Expanded(
                      child: GestureDetector(
                    onTap: () async {
                      Get.toNamed(Routes.privacyPolicyPath);
                    },
                    child: getCustomFont("개인정보 취급방침 동의", FetchPixels.getPixelHeight(15), Colors.blueAccent, 1,
                        fontWeight: FontWeight.w400),
                  )),
                  getSimpleImageButton(
                      controller.privacyAgreed ? "checkbox_check.svg" : "checkbox_uncheck.svg",
                      FetchPixels.getPixelHeight(50),
                      FetchPixels.getPixelHeight(50),
                      Colors.white,
                      FetchPixels.getPixelHeight(24),
                      FetchPixels.getPixelHeight(24), () {
                    controller.clickPrivacyAgreed();
                  })
                ],
              )
            ])));
  }

  nickNameKeyboardDown(BuildContext context) {
    FocusScope.of(context).unfocus();
  }
}
