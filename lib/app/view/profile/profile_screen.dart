
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../base/color_data.dart';
import '../../../base/constant.dart';
import '../../../base/widget_utils.dart';
import '../../routes/app_pages.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: backGroundColor,
          bottomNavigationBar: editProfileButton(context),
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: FetchPixels.getDefaultHorSpace(context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getVerSpace(FetchPixels.getPixelHeight(20)),
                  buildToolbarMenu(context),
                  buildBottomList(context)
                ],
              ),
            ),
          ),
        ),
        onWillPop: () async {
          Constant.backToPrev(context);
          return false;
        });
  }

  Expanded buildBottomList(BuildContext context) {
    return Expanded(
      flex: 1,
      child: ListView(
        children: [
          getVerSpace(FetchPixels.getPixelHeight(30)),
          profilePicture(context),
          getVerSpace(FetchPixels.getPixelHeight(40)),
          getCustomFont("First Name", 16, textColor, 1, fontWeight: FontWeight.w400),
          getVerSpace(FetchPixels.getPixelHeight(6)),
          getCustomFont(
            "Alena",
            16,
            Colors.black,
            1,
            fontWeight: FontWeight.w400,
          ),
          getVerSpace(FetchPixels.getPixelHeight(20)),
          getDivider(dividerColor, 0, 1),
          getVerSpace(FetchPixels.getPixelHeight(20)),
          getCustomFont("Last Name", 16, textColor, 1, fontWeight: FontWeight.w400),
          getVerSpace(FetchPixels.getPixelHeight(6)),
          getCustomFont(
            "Gomez",
            16,
            Colors.black,
            1,
            fontWeight: FontWeight.w400,
          ),
          getVerSpace(FetchPixels.getPixelHeight(20)),
          getDivider(dividerColor, 0, 1),
          getVerSpace(FetchPixels.getPixelHeight(20)),
          getCustomFont("Email", 16, textColor, 1, fontWeight: FontWeight.w400),
          getVerSpace(FetchPixels.getPixelHeight(6)),
          getCustomFont(
            "alenagomez23@gmail.com",
            16,
            Colors.black,
            1,
            fontWeight: FontWeight.w400,
          ),
          getVerSpace(FetchPixels.getPixelHeight(20)),
          getDivider(dividerColor, 0, 1),
          getVerSpace(FetchPixels.getPixelHeight(20)),
          getCustomFont("Phone No", 16, textColor, 1, fontWeight: FontWeight.w400),
          getVerSpace(FetchPixels.getPixelHeight(6)),
          getCustomFont(
            "(907) 555-0101",
            16,
            Colors.black,
            1,
            fontWeight: FontWeight.w400,
          ),
        ],
      ),
    );
  }

  Widget buildToolbarMenu(BuildContext context) {
    return gettoolbarMenu(context, "back.svg", () {
      Constant.backToPrev(context);
    }, istext: true, title: "Profile", weight: FontWeight.w900, fontsize: 24, textColor: Colors.black);
  }

  Align profilePicture(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        height: FetchPixels.getPixelHeight(100),
        width: FetchPixels.getPixelHeight(100),
        decoration: BoxDecoration(
          image: getDecorationAssetImage(context, "profile_picture.png"),
        ),
      ),
    );
  }

  Container editProfileButton(BuildContext context) {
    return Container(
      color: backGroundColor,
      padding: EdgeInsets.only(
          left: FetchPixels.getPixelWidth(20),
          right: FetchPixels.getPixelWidth(20),
          bottom: FetchPixels.getPixelHeight(30)),
      child: getButton(context, blueColor, "Edit Profile", Colors.white, () {
        Get.toNamed(Routes.editProfilePath);
      }, 18,
          weight: FontWeight.w600,
          buttonHeight: FetchPixels.getPixelHeight(60),
          borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(14))),
    );
  }
}
