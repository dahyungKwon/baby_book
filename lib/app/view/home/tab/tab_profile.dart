import 'package:baby_book/app/models/model_baby.dart';
import 'package:baby_book/base/constant.dart';
import 'package:baby_book/base/pref_data.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../base/color_data.dart';
import '../../../../base/widget_utils.dart';
import '../../../controller/TabProfileController.dart';
import '../../../repository/baby_repository.dart';
import '../../../repository/member_repository.dart';
import '../../../routes/app_pages.dart';

class TabProfile extends GetView<TabProfileController> {
  TabProfile({super.key}) {
    Get.put(TabProfileController(
        memberRepository: MemberRepository(), babyRepository: BabyRepository(), targetMemberId: null));
  }

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backGroundColor,
      body: Obx(() => Column(children: [
            buildToolbarWidget(context),
            Expanded(
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
                    child: buildProfileWidget(context)))
          ])),
    );
  }

  Widget buildToolbarWidget(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
        color: Colors.white,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          controller.myProfile
              ? SizedBox(width: FetchPixels.getPixelHeight(50), height: FetchPixels.getPixelHeight(50))
              : getSimpleImageButton("back_outline.svg", FetchPixels.getPixelHeight(50), FetchPixels.getPixelHeight(50),
                  Colors.white, FetchPixels.getPixelHeight(26), FetchPixels.getPixelHeight(26), () async {
                  Get.back();
                }),
          controller.myProfile
              ? getSimpleImageButton("setting.svg", FetchPixels.getPixelHeight(50), FetchPixels.getPixelHeight(50),
                  Colors.white, FetchPixels.getPixelHeight(26), FetchPixels.getPixelHeight(26), () {},
                  containerPadding: EdgeInsets.only(right: FetchPixels.getPixelHeight(0)))
              : SizedBox(width: FetchPixels.getPixelHeight(50), height: FetchPixels.getPixelHeight(50)),
        ]));
  }

  ListView buildProfileWidget(BuildContext context) {
    return ListView(
      children: [
        buildProfile(context),
        getVerSpace(FetchPixels.getPixelHeight(20)),
        buildContents(context),
        getVerSpace(FetchPixels.getPixelHeight(20)),
        bookCaseButton(context),
        getVerSpace(FetchPixels.getPixelHeight(20)),
        communityWritingButton(context),
        getVerSpace(FetchPixels.getPixelHeight(20)),
        // bookReportButton(context),
        // getVerSpace(FetchPixels.getPixelHeight(20)),
        // settingButton(context),
        getVerSpace(FetchPixels.getPixelHeight(30)),
        logoutButton(context)
      ],
    );
  }

  Widget buildProfile(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        children: [
          profilePictureView(context),
          getHorSpace(FetchPixels.getPixelHeight(20)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getCustomFont(controller.member.nickName ?? "", 18, Colors.black, 1, fontWeight: FontWeight.w500),
              getVerSpace(FetchPixels.getPixelHeight(10)),
              getCustomFont(controller.member.gender!.adult ?? "", 14, Colors.black38, 1, fontWeight: FontWeight.w500),
              getVerSpace(FetchPixels.getPixelHeight(10)),
              buildBabyList(),
            ],
          )
        ],
      ),
      getVerSpace(FetchPixels.getPixelHeight(10)),
      controller.myProfile
          ? getSimpleTextButton("프로필 수정", 12, Colors.black54, Colors.black, FontWeight.w400,
              FetchPixels.getPixelWidth(double.infinity), FetchPixels.getPixelHeight(30), () {
              Get.toNamed(Routes.editProfilePath);
            },
              boxDecoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(12)),
                  boxShadow: [
                    const BoxShadow(color: Colors.black12, blurRadius: 1, offset: Offset(0.0, 0.0)),
                  ]))
          : Container()
    ]);
  }

  Widget buildBabyList() {
    return SizedBox(
        width: FetchPixels.getPixelWidth(200),
        child: getCustomFont(controller.getBabyToString(), 12, Colors.black, 5, fontWeight: FontWeight.w500));
  }

  Widget buildContents(BuildContext context) {
    return Container(
      height: 100,
      padding: EdgeInsets.all(FetchPixels.getPixelHeight(20)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(12)),
        boxShadow: [
          const BoxShadow(color: Colors.black12, blurRadius: 1, offset: Offset(0.0, 0.0)),
        ],
      ),
      child: getCustomFont(
          controller.member.contents == null || controller.member.contents!.isEmpty
              ? "소개글이 없습니다."
              : controller.member.contents!,
          14,
          Colors.black87,
          5,
          fontWeight: FontWeight.w400),
    );
  }

  Widget bookCaseButton(BuildContext context) {
    return getButtonWithIcon(context, Colors.white, "책장", Colors.black, () {
      Get.toNamed(Routes.profilePath);
    }, 16,
        weight: FontWeight.w400,
        buttonHeight: FetchPixels.getPixelHeight(60),
        borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(12)),
        boxShadow: [
          const BoxShadow(color: Colors.black12, blurRadius: 1, offset: Offset(0.0, 0.0)),
        ],
        prefixIcon: true,
        prefixImage: "book.svg",
        sufixIcon: true,
        suffixImage: "arrow_right.svg");
  }

  Widget communityWritingButton(BuildContext context) {
    return getButtonWithIcon(context, Colors.white, "북마크 / 작성글 / 작성댓글", Colors.black, () {
      Get.toNamed(Routes.cardPath);
    }, 16,
        weight: FontWeight.w400,
        buttonHeight: FetchPixels.getPixelHeight(60),
        borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(12)),
        boxShadow: [
          const BoxShadow(color: Colors.black12, blurRadius: 1, offset: Offset(0.0, 0.0)),
        ],
        prefixIcon: true,
        prefixImage: "chatbubbles.svg",
        sufixIcon: true,
        suffixImage: "arrow_right.svg");
  }

  Widget bookReportButton(BuildContext context) {
    return getButtonWithIcon(context, Colors.white, "신규책 제보", Colors.black, () {
      Get.toNamed(Routes.myAddressPath);
    }, 16,
        weight: FontWeight.w400,
        buttonHeight: FetchPixels.getPixelHeight(60),
        borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(12)),
        boxShadow: [
          const BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0.0, 4.0)),
        ],
        prefixIcon: true,
        prefixImage: "new_book_report.svg",
        sufixIcon: true,
        suffixImage: "arrow_right.svg");
  }

  Widget logoutButton(BuildContext context) {
    return controller.myProfile
        ? getButton(context, secondMainColor, "로그아웃", Colors.white, () {
            PrefData.setLogIn(false);
            Get.toNamed(Routes.loginPath);
            // Constant.closeApp();
          }, 18,
            weight: FontWeight.w600,
            borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(14)),
            buttonHeight: FetchPixels.getPixelHeight(60))
        : Container();
  }

  Widget settingButton(BuildContext context) {
    return getButtonWithIcon(context, Colors.white, "Settings", Colors.black, () {
      Get.toNamed(Routes.settingPath);
    }, 16,
        weight: FontWeight.w400,
        buttonHeight: FetchPixels.getPixelHeight(60),
        borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(12)),
        boxShadow: [
          const BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0.0, 4.0)),
        ],
        prefixIcon: true,
        prefixImage: "setting.svg",
        sufixIcon: true,
        suffixImage: "arrow_right.svg");
  }

  Stack profilePictureView(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: FetchPixels.getPixelHeight(90),
          width: FetchPixels.getPixelHeight(90),
          decoration: BoxDecoration(
            image: getDecorationAssetImage(context, "profile_image.png"),
            color: Colors.white,
          ),
        ),
        // Positioned(
        //     top: FetchPixels.getPixelHeight(68),
        //     left: FetchPixels.getPixelHeight(70),
        //     child: Container(
        //       height: FetchPixels.getPixelHeight(46),
        //       width: FetchPixels.getPixelHeight(46),
        //       padding: EdgeInsets.symmetric(
        //           vertical: FetchPixels.getPixelHeight(10), horizontal: FetchPixels.getPixelHeight(10)),
        //       decoration: BoxDecoration(
        //           color: Colors.white,
        //           boxShadow: const [
        //             BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0.0, 4.0)),
        //           ],
        //           borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(35))),
        //       child: getSvgImage("camera.svg",
        //           height: FetchPixels.getPixelHeight(24), width: FetchPixels.getPixelHeight(24)),
        //     ))
      ],
    );
  }
}
