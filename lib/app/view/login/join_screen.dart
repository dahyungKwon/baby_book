import 'package:baby_book/app/repository/baby_repository.dart';
import 'package:baby_book/app/repository/member_repository.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../../../base/color_data.dart';
import '../../../../base/skeleton.dart';
import '../../controller/BabyDialogController.dart';
import '../../controller/JoinController.dart';
import '../../models/model_baby.dart';
import '../../routes/app_pages.dart';
import 'baby_dialog.dart';
import 'baby_list.dart';
import 'gender_type.dart';
import 'gender_type_bottom_sheet.dart';

class JoinScreen extends GetView<JoinController> {
  FocusNode nickNameFocusNode = FocusNode();

  JoinScreen({super.key}) {
    Get.delete<JoinController>();
    Get.put(JoinController(memberRepository: MemberRepository(), babyRepository: BabyRepository()));
  }

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    double defHorSpace = FetchPixels.getDefaultHorSpace(context);
    EdgeInsets edgeInsets = EdgeInsets.symmetric(horizontal: defHorSpace);
    return WillPopScope(
        onWillPop: () async {
          controller.backStep();
          // Get.back();
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
                controller.backStep();
              }),
            ]),
            getSimpleTextButton(
                controller.currentStep == 4 ? "완료" : "다음",
                18,
                (controller.currentStep == 1 && controller.readyFirstStep) ||
                        (controller.currentStep == 2 && controller.readySecondStep) ||
                        (controller.currentStep == 3 && controller.readyThirdStep) ||
                        (controller.currentStep == 4 && controller.readyFourthStep)
                    ? secondMainColor
                    : Colors.grey.shade400,
                Colors.white,
                FontWeight.w500,
                FetchPixels.getPixelWidth(75),
                FetchPixels.getPixelHeight(25), () {
              controller.confirmStep(context);
            }),
          ],
        ));
  }

  Expanded buildMainArea(BuildContext context, EdgeInsets edgeInsets, double defHorSpace) {
    return Expanded(
        flex: 1,
        child: Container(
            height: FetchPixels.getPixelHeight(200),
            padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(10)),
            child: ListView(primary: true, shrinkWrap: true, children: [
              getVerSpace(15),
              controller.finishFirstStep == false ? buildFirstStep(context) : Container(),
              controller.finishFirstStep && controller.finishSecondStep == false
                  ? buildSecondStep(context)
                  : Container(),
              controller.finishSecondStep && controller.finishThirdStep == false
                  ? buildThirdStep(context)
                  : Container(),
              controller.finishThirdStep && controller.finishFourthStep == false
                  ? buildFourthStep(context)
                  : Container()
            ])));
  }

  Widget buildFirstStep(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
          padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelHeight(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getCustomFont("사용하실 닉네임을 입력해주세요." ?? "", FetchPixels.getPixelHeight(20), Colors.black, 1,
                  fontWeight: FontWeight.w600),
              getVerSpace(10),
              getCustomFont(
                  "닉네임은 커뮤니티나 책장등에서 사용되고, 추후 변경 가능합니다." ?? "", FetchPixels.getPixelHeight(13), Colors.black38, 1,
                  fontWeight: FontWeight.w400),
              getVerSpace(30),
            ],
          )),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: getDefaultTextFiledWithLabel2(
            context,
            "예) 아기곰맘",
            Colors.black45.withOpacity(0.3),
            controller.nickNameController,
            Colors.grey,
            FetchPixels.getPixelHeight(20),
            FontWeight.w400,
            function: () {},
            isEnable: false,
            withprefix: false,
            minLines: true,
            height: FetchPixels.getPixelHeight(100),
            alignmentGeometry: Alignment.center,
            boxColor: backGroundColor,
            myFocusNode: nickNameFocusNode,
            autofocus: true,
          )),
          controller.validNickName
              ? getSimpleImageButton("confirm_mark.svg", FetchPixels.getPixelHeight(40), FetchPixels.getPixelHeight(40),
                  Colors.white, FetchPixels.getPixelHeight(24), FetchPixels.getPixelHeight(24), () {})
              : controller.canCheckNickName
                  ? getSimpleTextButton(
                      "중복체크",
                      FetchPixels.getPixelHeight(16),
                      controller.canCheckNickName ? secondMainColor : Colors.grey.shade400,
                      Colors.white,
                      FontWeight.w500,
                      FetchPixels.getPixelWidth(100),
                      FetchPixels.getPixelHeight(25), () {
                      nickNameKeyboardDown(context);
                      controller.confirmNickName();
                    })
                  : Container(),
          controller.validNickName
              ? getHorSpace(FetchPixels.getPixelWidth(12))
              : getHorSpace(FetchPixels.getPixelWidth(0))
        ],
      ),
    ]);
  }

  Widget buildSecondStep(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
          padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelHeight(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getCustomFont("성별을 선택해주세요." ?? "", FetchPixels.getPixelHeight(20), Colors.black, 1,
                  fontWeight: FontWeight.w600),
              getVerSpace(10),
              getCustomFont("입력하신 모든 정보는 추후에 수정이 가능합니다." ?? "", FetchPixels.getPixelHeight(13), Colors.black38, 1,
                  fontWeight: FontWeight.w400),
              getVerSpace(30),
            ],
          )),
      getDefaultTextFiledWithLabel2(
          context,
          controller.gender == GenderType.nullType ? "성별을 선택해주세요." : controller.gender.adult,
          controller.gender == GenderType.nullType ? Colors.black45.withOpacity(0.3) : Colors.black,
          controller.genderController,
          Colors.black87,
          FetchPixels.getPixelHeight(20),
          boxColor: backGroundColor,
          FontWeight.w400, function: () {
        controller.showGenderBottomSheet(context);
      },
          isEnable: false,
          withprefix: false,
          minLines: true,
          height: FetchPixels.getPixelHeight(45),
          withSufix: true,
          suffiximage: controller.gender == GenderType.nullType ? "down_arrow.svg" : "confirm_mark.svg",
          enableEditing: false)
    ]);
  }

  Widget buildThirdStep(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
          padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelHeight(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getCustomFont("아기곰을 추가해주세요." ?? "", FetchPixels.getPixelHeight(20), Colors.black, 1,
                  fontWeight: FontWeight.w600),
              getVerSpace(10),
              getCustomFont("대표 아기곰은 한명만 선정가능하고, 추후 변경 가능합니다." ?? "", FetchPixels.getPixelHeight(13), Colors.black38, 2,
                  fontWeight: FontWeight.w400),
              getVerSpace(30),
            ],
          )),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          getHorSpace(FetchPixels.getPixelWidth(16)),

          GestureDetector(
            onTap: () {
              Get.dialog(BabyDialog(null, null, BabyDialogController.callerJoin));
            },
            child: getCustomFont(
              "추가하기",
              FetchPixels.getPixelHeight(20),
              Colors.black87,
              1,
              fontWeight: FontWeight.w400,
            ),
          ),
          getSimpleImageButton("add_baby_bear.svg", FetchPixels.getPixelHeight(40), FetchPixels.getPixelHeight(40),
              Colors.white, FetchPixels.getPixelHeight(22), FetchPixels.getPixelHeight(22), () async {
            Get.dialog(BabyDialog(null, null, BabyDialogController.callerJoin));
          }),
          // getHorSpace(FetchPixels.getPixelWidth(12))
        ],
      ),
      getVerSpace(FetchPixels.getPixelHeight(20)),
      buildBabyList(controller.selectedBabyList)
    ]);
  }

  Widget buildFourthStep(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
          padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelHeight(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getCustomFont("약관 동의 해주세요." ?? "", FetchPixels.getPixelHeight(20), Colors.black, 1,
                  fontWeight: FontWeight.w600),
              getVerSpace(10),
              getCustomFont("약관을 꼭 확인하시고 동의해주세요." ?? "", FetchPixels.getPixelHeight(13), Colors.black38, 2,
                  fontWeight: FontWeight.w400),
              getVerSpace(30),
            ],
          )),
      Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            getHorSpace(FetchPixels.getPixelWidth(16)),
            Expanded(
                child: GestureDetector(
              onTap: () async {
                controller.clickAllAgreed();
              },
              child: getCustomFont(
                "전체 동의",
                FetchPixels.getPixelHeight(20),
                Colors.black,
                1,
                fontWeight: FontWeight.w500,
              ),
            )),
            getSimpleImageButton(
                controller.allAgreed ? "checkbox_check.svg" : "checkbox_uncheck.svg",
                FetchPixels.getPixelHeight(60),
                FetchPixels.getPixelHeight(40),
                Colors.white,
                FetchPixels.getPixelHeight(24),
                FetchPixels.getPixelHeight(24), () {
              controller.clickAllAgreed();
            }),
            // getHorSpace(FetchPixels.getPixelWidth(12))
          ],
        ),
        getVerSpace(FetchPixels.getPixelWidth(10)),
        Container(
          margin: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(16)),
          // padding: EdgeInsets.symmetric(vertical: FetchPixels.getPixelWidth(16)),
          height: 1.0,
          // color: Colors.black38,
          decoration: BoxDecoration(
              color: Colors.grey.shade100,
              // boxShadow: [
              //   BoxShadow(color: Color(0xFFEDEBE8), blurRadius: 1, offset: Offset(0.0, 1.0)),
              // ],
              borderRadius: BorderRadius.zero),
        ),
        getVerSpace(FetchPixels.getPixelWidth(10)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            getHorSpace(FetchPixels.getPixelWidth(25)),
            Expanded(
                child: GestureDetector(
              onTap: () async {
                Get.toNamed(Routes.servicePolicyPath);
              },
              child: getCustomFont(
                "서비스 이용약관 동의",
                FetchPixels.getPixelHeight(16),
                Colors.blueAccent,
                1,
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.underline,
              ),
            )),
            getSimpleImageButton(
                controller.serviceAgreed ? "checkbox_check.svg" : "checkbox_uncheck.svg",
                FetchPixels.getPixelHeight(60),
                FetchPixels.getPixelHeight(40),
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
            getHorSpace(FetchPixels.getPixelWidth(25)),
            Expanded(
                child: GestureDetector(
              onTap: () async {
                Get.toNamed(Routes.privacyPolicyPath);
              },
              child: getCustomFont(
                "개인정보 처리방침 동의",
                FetchPixels.getPixelHeight(16),
                Colors.blueAccent,
                1,
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.underline,
              ),
            )),
            getSimpleImageButton(
                controller.privacyAgreed ? "checkbox_check.svg" : "checkbox_uncheck.svg",
                FetchPixels.getPixelHeight(60),
                FetchPixels.getPixelHeight(40),
                Colors.white,
                FetchPixels.getPixelHeight(24),
                FetchPixels.getPixelHeight(24), () {
              controller.clickPrivacyAgreed();
            })
          ],
        )
      ])
    ]);
  }

  SizedBox buildBabyList(List<ModelBaby> babyList) {
    return SizedBox(
        height: FetchPixels.getPixelHeight(270),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          // shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: babyList.length,
          itemBuilder: (context, index) {
            ModelBaby modelBaby = babyList[index];
            return buildBabyListItem(modelBaby, context, index, controller.representBabyId,
                controller.changeRepresentBaby, controller.openModifyBabyDialog, controller.deleteBaby);
          },
        ));
  }

  nickNameKeyboardDown(BuildContext context) {
    FocusScope.of(context).unfocus();
  }
}
