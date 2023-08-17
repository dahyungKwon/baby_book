import 'package:baby_book/app/models/model_member.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../base/color_data.dart';
import '../../../base/kakao_login_util.dart';
import '../../../base/resizer/fetch_pixels.dart';
import '../../../base/skeleton.dart';
import '../../../base/widget_utils.dart';
import '../../routes/app_pages.dart';

Widget buildProfileLayout(BuildContext context, bool loading, ModelMember member, bool myProfile, String babyToString) {
  return loading
      ? const FullSizeSkeleton()
      : Column(children: [
          _buildToolbarWidget(context, myProfile),
          Expanded(
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
                  child: ListView(children: [
                    _buildProfile(context, member, myProfile, babyToString),
                    getVerSpace(FetchPixels.getPixelHeight(20)),
                    _buildContents(context, member),
                    getVerSpace(FetchPixels.getPixelHeight(20)),
                    _bookCaseButton(context, member, myProfile),
                    getVerSpace(FetchPixels.getPixelHeight(20)),
                    _communityWritingButton(context, member, myProfile),
                    getVerSpace(FetchPixels.getPixelHeight(20)),
                    _bookReportButton(context, myProfile),
                    getVerSpace(FetchPixels.getPixelHeight(20)),
                    // settingButton(context),
                    getVerSpace(FetchPixels.getPixelHeight(30)),
                    _logoutButton(context, myProfile)
                  ])))
        ]);
}

Widget _buildToolbarWidget(BuildContext context, bool myProfile) {
  return Container(
      padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
      color: Colors.white,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        myProfile
            ? SizedBox(width: FetchPixels.getPixelHeight(50), height: FetchPixels.getPixelHeight(50))
            : getSimpleImageButton("back_outline.svg", FetchPixels.getPixelHeight(50), FetchPixels.getPixelHeight(50),
                Colors.white, FetchPixels.getPixelHeight(26), FetchPixels.getPixelHeight(26), () async {
                Get.back();
              }),
        myProfile
            ? getSimpleImageButton("setting.svg", FetchPixels.getPixelHeight(50), FetchPixels.getPixelHeight(50),
                Colors.white, FetchPixels.getPixelHeight(26), FetchPixels.getPixelHeight(26), () {
                Get.toNamed(Routes.settingPath);
              }, containerPadding: EdgeInsets.only(right: FetchPixels.getPixelHeight(0)))
            : SizedBox(width: FetchPixels.getPixelHeight(50), height: FetchPixels.getPixelHeight(50)),
      ]));
}

Widget _buildProfile(BuildContext context, ModelMember member, bool myProfile, String babyToString) {
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Row(
      children: [
        _profilePictureView(context),
        getHorSpace(FetchPixels.getPixelHeight(20)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getCustomFont(member.nickName ?? "", 18, Colors.black, 1, fontWeight: FontWeight.w500),
            getVerSpace(FetchPixels.getPixelHeight(10)),
            getCustomFont(member.gender!.adult ?? "", 14, Colors.black38, 1, fontWeight: FontWeight.w500),
            getVerSpace(FetchPixels.getPixelHeight(10)),
            _buildBabyList(babyToString),
          ],
        )
      ],
    ),
    getVerSpace(FetchPixels.getPixelHeight(10)),
    myProfile
        ? getSimpleTextButton("프로필 수정", 12, Colors.black54, Colors.black, FontWeight.w400,
            FetchPixels.getPixelWidth(double.infinity), FetchPixels.getPixelHeight(30), () {
            Get.toNamed(Routes.editProfilePath);
          },
            boxDecoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(12)),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 1, offset: Offset(0.0, 0.0)),
                ]))
        : Container()
  ]);
}

Widget _buildBabyList(String babyToString) {
  return SizedBox(
      width: FetchPixels.getPixelWidth(200),
      child: getCustomFont(babyToString, 12, Colors.black, 5, fontWeight: FontWeight.w500));
}

Widget _buildContents(BuildContext context, ModelMember member) {
  return Container(
    height: 100,
    padding: EdgeInsets.all(FetchPixels.getPixelHeight(20)),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(12)),
      boxShadow: const [
        BoxShadow(color: Colors.black12, blurRadius: 1, offset: Offset(0.0, 0.0)),
      ],
    ),
    child: getCustomFont(
        member.contents == null || member.contents!.isEmpty ? "소개글이 없습니다." : member.contents!, 14, Colors.black87, 5,
        fontWeight: FontWeight.w400),
  );
}

Widget _bookCaseButton(BuildContext context, ModelMember member, bool myProfile) {
  return getButtonWithIcon(context, Colors.white, "책장", Colors.black, () {
    if (myProfile) {
      Get.offAllNamed(Routes.tabBookCasePath);
    } else {
      Get.toNamed(Routes.bookCasePath, parameters: {'memberId': member.memberId!});
    }
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

Widget _communityWritingButton(BuildContext context, ModelMember member, bool myProfile) {
  return getButtonWithIcon(context, Colors.white, myProfile ? "작성글 / 작성댓글 / 북마크" : "작성글 / 작성댓글", Colors.black, () {
    Get.toNamed(Routes.memberCommunityPath,
        parameters: {'memberId': member.memberId!, 'myProfile': myProfile.toString()});
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

Widget _bookReportButton(BuildContext context, bool myProfile) {
  return myProfile
      ? getButtonWithIcon(context, Colors.white, "신규책 제보", Colors.black, () {
          Get.toNamed(Routes.reportNewBookAddPath);
        }, 16,
          weight: FontWeight.w400,
          buttonHeight: FetchPixels.getPixelHeight(60),
          borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(12)),
          boxShadow: [
            const BoxShadow(color: Colors.black12, blurRadius: 1, offset: Offset(0.0, 0.0)),
          ],
          prefixIcon: true,
          prefixImage: "new_book_report.svg",
          sufixIcon: true,
          suffixImage: "arrow_right.svg")
      : Container();
}

Widget _logoutButton(BuildContext context, bool myProfile) {
  return myProfile
      ? getButton(context, secondMainColor, "로그아웃", Colors.white, () {
          logout();
          Get.toNamed(Routes.loginPath);
          // Constant.closeApp();
        }, 18,
          weight: FontWeight.w600,
          borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(14)),
          buttonHeight: FetchPixels.getPixelHeight(60))
      : Container();
}

Stack _profilePictureView(BuildContext context) {
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
