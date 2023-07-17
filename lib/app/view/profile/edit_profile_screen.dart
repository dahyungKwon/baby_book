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
import '../../controller/EditProfileController.dart';
import '../../models/model_baby.dart';
import '../login/baby_dialog.dart';
import '../login/baby_list.dart';
import '../login/gender_type.dart';

class EditProfileScreen extends GetView<EditProfileController> {
  FocusNode nickNameFocusNode = FocusNode();
  FocusNode contentsFocusNode = FocusNode();

  EditProfileScreen({super.key}) {
    Get.delete<EditProfileController>();
    Get.put(EditProfileController(memberRepository: MemberRepository(), babyRepository: BabyRepository()));
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
            resizeToAvoidBottomInset: true,
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
                "프로필 수정",
                18,
                Colors.black,
                1,
                fontWeight: FontWeight.w500,
              ),
            ]),
            getSimpleTextButton("변경", 18, secondMainColor, Colors.white, FontWeight.w500, FetchPixels.getPixelWidth(75),
                FetchPixels.getPixelHeight(25), () {
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
              getVerSpace(15),
              buildNickname(context),
              getVerSpace(30),
              buildGener(context),
              getVerSpace(30),
              buildContents(context),
              getVerSpace(30),
              buildBaby(context),
            ])));
  }

  Widget buildNickname(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
          padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelHeight(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getCustomFont("닉네임" ?? "", 14, Colors.black38, 1, fontWeight: FontWeight.w600),
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
            "닉네임을 입력해주세요.",
            Colors.black45.withOpacity(0.3),
            controller.nickNameController,
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
            myFocusNode: nickNameFocusNode,
            autofocus: false,
          )),
          controller.validNickName
              ? getSimpleImageButton("confirm_mark.svg", FetchPixels.getPixelHeight(40), FetchPixels.getPixelHeight(40),
                  Colors.white, FetchPixels.getPixelHeight(24), FetchPixels.getPixelHeight(24), () {})
              : controller.canCheckNickName
                  ? getSimpleTextButton(
                      "중복체크",
                      16,
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
      )
    ]);
  }

  Widget buildGener(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
          padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelHeight(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getCustomFont("성별" ?? "", 14, Colors.black38, 1, fontWeight: FontWeight.w600),
              // getVerSpace(10),
              // getCustomFont("입력하신 모든 정보는 추후에 수정이 가능합니다." ?? "", 13, Colors.black38, 1, fontWeight: FontWeight.w400),
              // getVerSpace(30),
            ],
          )),
      getDefaultTextFiledWithLabel2(
          context,
          controller.gender == GenderType.none ? "성별을 선택해주세요." : controller.gender.adult,
          controller.gender == GenderType.none ? Colors.black45.withOpacity(0.3) : Colors.black,
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
          suffiximage: controller.gender == GenderType.none ? "down_arrow.svg" : "confirm_mark.svg",
          enableEditing: false)
    ]);
  }

  Widget buildContents(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
          padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelHeight(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getCustomFont("소개글" ?? "", 14, Colors.black38, 1, fontWeight: FontWeight.w600),
              // getVerSpace(10),
            ],
          )),
      getVerSpace(FetchPixels.getPixelHeight(15)),
      Container(
          padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelHeight(12)),
          child: getDefaultTextFiledWithLabel2(
            context,
            "소개글을 입력해주세요.",
            Colors.black45.withOpacity(0.3),
            controller.contentsController,
            Colors.grey,
            FetchPixels.getPixelHeight(16),
            FontWeight.w400,
            function: () {},
            isEnable: false,
            withprefix: false,
            minLines: true,
            height: FetchPixels.getPixelHeight(100),
            alignmentGeometry: Alignment.topLeft,
            boxColor: backGroundColor,
            myFocusNode: contentsFocusNode,
            autofocus: false,
            boxDecoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(12)),
              boxShadow: [
                const BoxShadow(color: Colors.black12, blurRadius: 1, offset: Offset(0.0, 0.0)),
              ],
            ),
          )),
    ]);
  }

  Widget buildBaby(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
          padding: EdgeInsets.only(left: FetchPixels.getPixelHeight(16), right: FetchPixels.getPixelHeight(0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              getCustomFont("아기곰들" ?? "", 14, Colors.black38, 1, fontWeight: FontWeight.w600),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // getHorSpace(FetchPixels.getPixelWidth(16)),

                  GestureDetector(
                    onTap: () {
                      Get.dialog(BabyDialog(null, null, BabyDialogController.callerEditProfile));
                    },
                    child: getCustomFont(
                      "추가하기",
                      FetchPixels.getPixelHeight(15),
                      Colors.black38,
                      1,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  getSimpleImageButton(
                      "add_baby_bear.svg",
                      FetchPixels.getPixelHeight(40),
                      FetchPixels.getPixelHeight(40),
                      Colors.white,
                      FetchPixels.getPixelHeight(22),
                      FetchPixels.getPixelHeight(22), () async {
                    Get.dialog(BabyDialog(null, null, BabyDialogController.callerEditProfile));
                  }),
                  // getHorSpace(FetchPixels.getPixelWidth(12))
                ],
              ),
            ],
          )),
      getVerSpace(FetchPixels.getPixelHeight(10)),
      buildBabyList(controller.selectedBabyList)
    ]);
  }

  SizedBox buildBabyList(List<ModelBaby> babyList) {
    return SizedBox(
        height: FetchPixels.getPixelHeight(200),
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
