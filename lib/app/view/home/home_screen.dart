import 'dart:async';

import 'package:baby_book/app/view/dialog/re_confirm_dialog.dart';
import 'package:baby_book/app/view/home/tab/tab_book_case.dart';
import 'package:baby_book/app/view/home/tab/tab_community.dart';
import 'package:baby_book/app/view/home/tab/tab_home.dart';
import 'package:baby_book/app/view/home/tab/tab_profile.dart';
import 'package:baby_book/base/color_data.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../base/constant.dart';
import '../../controller/HomeScreenController.dart';
import 'package:flutter/foundation.dart' as foundation;

import '../../routes/app_pages.dart';

class HomeScreen extends GetView<HomeScreenController> {
  bool guestMode = false;
  DateTime? currentBackPressTime;
  List<String> bottomBarNoSelectedImgList = ["home.svg", "book.svg", "chatbubbles.svg", "person.svg"];
  List<String> bottomBarSelectedImgList = [
    "home_selected.svg",
    "book_selected.svg",
    "chatbubbles_selected.svg",
    "person_selected.svg"
  ];
  List<String> bottomBarStringList = ["홈", "책장", "커뮤니티", "프로필"];

  ///구글 애널리틱스 용
  List<String> bottomBarStringEnList = ["home", "bookcase", "community", "profile"];

  late List<Widget> tabList;

  HomeScreen(int tabIndex, {super.key}) {
    guestMode = Get.parameters["guestMode"] != null ? bool.tryParse(Get.parameters["guestMode"]!) ?? false : false;
    if (guestMode) {
      tabList = [TabHome(guestMode: true)];
    } else {
      tabList = [
        TabHome(
          guestMode: false,
        ),
        TabBookCase(),
        const TabCommunity(),
        TabProfile(),
      ];
    }
    Get.put(HomeScreenController(tabIndex));
  }

  @override
  Widget build(BuildContext context) {
    init();
    FetchPixels(context);
    return WillPopScope(
        onWillPop: onWillPop,
        child: Obx(() => Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: backGroundColor,
            body: Stack(
              children: [
                SafeArea(
                  child: tabList[controller.tabIndex!],
                ),
              ],
            ),
            bottomNavigationBar: Container(
                height: FetchPixels.getPixelHeight(60),
                // color: Colors.white,
                margin: EdgeInsets.only(
                    bottom: FetchPixels.getPixelHeight(
                        foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS ? 20 : 0)),
                decoration: const BoxDecoration(
                    color: Colors.white, border: Border(top: BorderSide(color: Color(0xffd3d3d3), width: 0.8))),
                child: Row(
                    children: List.generate(bottomBarNoSelectedImgList.length, (selectedTabIndex) {
                  return Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () async {
                        if (guestMode) {
                          openLoginPopup();
                          return;
                        }
                        await FirebaseAnalytics.instance.logScreenView(
                            screenName: "home_bottombtn_${bottomBarStringEnList[selectedTabIndex]}_screenName",
                            screenClass: "home_bottombtn_${bottomBarStringEnList[selectedTabIndex]}_screenClass");

                        controller.tabIndex = selectedTabIndex;
                      },
                      child: Center(
                        child: Container(
                          width: FetchPixels.getPixelHeight(60),
                          height: FetchPixels.getPixelHeight(60),
                          // decoration: BoxDecoration(
                          //     color: controller.tabIndex == selectedTabIndex ? Colors.black : Colors.transparent,
                          //     shape: BoxShape.circle),
                          child: Center(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  getSvgImage(
                                      controller.tabIndex == selectedTabIndex
                                          ? bottomBarSelectedImgList[selectedTabIndex]
                                          : bottomBarNoSelectedImgList[selectedTabIndex],
                                      width: FetchPixels.getPixelHeight(26),
                                      height: FetchPixels.getPixelHeight(26)),
                                  getVerSpace(FetchPixels.getPixelHeight(2)),
                                  Text(
                                    bottomBarStringList[selectedTabIndex],
                                    style: TextStyle(
                                        fontSize: 9,
                                        // fontStyle: FontStyle.normal,
                                        color: controller.tabIndex == selectedTabIndex
                                            ? Colors.black
                                            : Colors.black.withOpacity(0.8),
                                        // fontFamily: fontFamily,
                                        // height: txtHeight,
                                        fontWeight: controller.tabIndex == selectedTabIndex
                                            ? FontWeight.w500
                                            : FontWeight.w300),
                                  )
                                ]),
                          ),
                        ),
                      ),
                    ),
                  );
                }))))));
  }

  init() async {
    Timer(const Duration(seconds: 1), () async {
      String sharedType = Get.parameters['sharedType'] ?? "NONE";

      print("AppSchemeImpl HomeScreen switch : $sharedType");
      switch (sharedType) {
        case "BOOK":
          {
            print("AppSchemeImpl HomeScreen BOOK in : $sharedType");
            controller.tabIndex = 0;
            String? bookSetId = Get.parameters['bookSetId'];
            print("AppSchemeImpl HomeScreen bookSetId : $bookSetId");
            Get.toNamed(Routes.bookDetailPath, parameters: {'sharedType': sharedType!, 'bookSetId': bookSetId!});
            break;
          }
        case "COMMUNITY":
          {
            print("AppSchemeImpl HomeScreen COMMUNITY in : $sharedType");
            controller.tabIndex = 2;
            String? postId = Get.parameters['postId'];
            print("AppSchemeImpl HomeScreen postId : $postId");
            Get.toNamed(Routes.communityDetailPath,
                parameters: {'sharedType': sharedType!, 'postId': postId!, 'tag': 'share'});
            break;
          }
        default:
          {
            break;
          }
      }
    });
  }

  Future<bool> onWillPop() async {
    DateTime now = DateTime.now();

    if (currentBackPressTime == null || now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      final msg = "'뒤로' 버튼을 한 번 더 누르면 종료됩니다.";

      Fluttertoast.showToast(msg: msg);
      return Future.value(false);
    }

    await FirebaseAnalytics.instance.logScreenView(
        screenName: "home_backbtn_${bottomBarStringEnList[controller.tabIndex]}_screenName",
        screenClass: "home_backbtn_${bottomBarStringEnList[controller.tabIndex]}_screenClass");

    Constant.closeApp();
    return Future.value(true);
  }

  openLoginPopup() async {
    await Get.dialog(ReConfirmDialog("로그인이 필요한 기능입니다.\n로그인 하러 가시겠습니까?", "네", "아니오", () async {
      Get.offAllNamed(Routes.loginPath);
    }));
  }
}
