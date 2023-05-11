import 'package:baby_book/app/routes/app_routes.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:flutter/material.dart';

import '../../../base/color_data.dart';
import '../../../base/constant.dart';
import '../../../base/widget_utils.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    Widget defVerSpace = getVerSpace(FetchPixels.getPixelHeight(20));
    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: backGroundColor,
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: FetchPixels.getDefaultHorSpace(context)),
              child: Column(
                children: [
                  getVerSpace(FetchPixels.getPixelHeight(20)),
                  buildToolbar(context),
                  getVerSpace(FetchPixels.getPixelHeight(30)),
                  buildSettingList(context, defVerSpace)
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

  Widget buildToolbar(BuildContext context) {
    return gettoolbarMenu(context, "back.svg", () {
                  Constant.backToPrev(context);
                },
                    istext: true,
                    title: "Settings",
                    weight: FontWeight.w900,
                    fontsize: 24,
                    textColor: Colors.black);
  }

  Expanded buildSettingList(BuildContext context, Widget defVerSpace) {
    return Expanded(
                  flex: 1,
                  child: ListView(
                    primary: true,
                    shrinkWrap: true,
                    children: [
                      notificationButton(context),
                      defVerSpace,
                      helpButton(context),
                      defVerSpace,
                      privacyButton(context),
                      defVerSpace,
                      securityButton(context),
                      defVerSpace,
                      termOfServiceButton(context),
                    ],
                  ),
                );
  }

  Widget termOfServiceButton(BuildContext context) {
    return getButtonWithIcon(
        context, Colors.white, "Terms of Service", Colors.black, () {
      Constant.sendToNext(context, Routes.termOfServiceRoute);
    }, 16,
        weight: FontWeight.w400,
        buttonHeight: FetchPixels.getPixelHeight(60),
        borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(12)),
        boxShadow: [
          const BoxShadow(
              color: Colors.black12, blurRadius: 10, offset: Offset(0.0, 4.0)),
        ],
        prefixIcon: true,
        prefixImage: "documnet.svg",
        sufixIcon: true,
        suffixImage: "arrow_right.svg");
  }

  Widget securityButton(BuildContext context) {
    return getButtonWithIcon(context, Colors.white, "Security", Colors.black,
        () {
      Constant.sendToNext(context, Routes.securityRoute);
    }, 16,
        weight: FontWeight.w400,
        buttonHeight: FetchPixels.getPixelHeight(60),
        borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(12)),
        boxShadow: [
          const BoxShadow(
              color: Colors.black12, blurRadius: 10, offset: Offset(0.0, 4.0)),
        ],
        prefixIcon: true,
        prefixImage: "lock.svg",
        sufixIcon: true,
        suffixImage: "arrow_right.svg");
  }

  Widget privacyButton(BuildContext context) {
    return getButtonWithIcon(
        context, Colors.white, "Privacy Policy", Colors.black, () {
      Constant.sendToNext(context, Routes.privacyRoute);
    }, 16,
        weight: FontWeight.w400,
        buttonHeight: FetchPixels.getPixelHeight(60),
        borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(12)),
        boxShadow: [
          const BoxShadow(
              color: Colors.black12, blurRadius: 10, offset: Offset(0.0, 4.0)),
        ],
        prefixIcon: true,
        prefixImage: "privacy.svg",
        sufixIcon: true,
        suffixImage: "arrow_right.svg");
  }

  Widget helpButton(BuildContext context) {
    return getButtonWithIcon(
        context, Colors.white, "Help & Support", Colors.black, () {
      Constant.sendToNext(context, Routes.helpRoute);
    }, 16,
        weight: FontWeight.w400,
        buttonHeight: FetchPixels.getPixelHeight(60),
        borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(12)),
        boxShadow: [
          const BoxShadow(
              color: Colors.black12, blurRadius: 10, offset: Offset(0.0, 4.0)),
        ],
        prefixIcon: true,
        prefixImage: "info.svg",
        sufixIcon: true,
        suffixImage: "arrow_right.svg");
  }

  Widget notificationButton(BuildContext context) {
    return getButtonWithIcon(
        context, Colors.white, "Notifications", Colors.black, () {
      Constant.sendToNext(context, Routes.notificationRoutes);
    }, 16,
        weight: FontWeight.w400,
        buttonHeight: FetchPixels.getPixelHeight(60),
        borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(12)),
        boxShadow: [
          const BoxShadow(
              color: Colors.black12, blurRadius: 10, offset: Offset(0.0, 4.0)),
        ],
        prefixIcon: true,
        prefixImage: "notification_unselected.svg",
        sufixIcon: true,
        suffixImage: "arrow_right.svg");
  }
}
