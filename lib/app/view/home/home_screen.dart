import 'package:baby_book/app/view/home/tab/tab_book_case.dart';
import 'package:baby_book/app/view/home/tab/tab_community.dart';
import 'package:baby_book/app/view/home/tab/tab_home.dart';
import 'package:baby_book/app/view/home/tab/tab_profile.dart';
import 'package:baby_book/app/view/home/tab/tab_schedule.dart';
import 'package:baby_book/base/color_data.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../base/constant.dart';
import '../../controller/HomeScreenController.dart';

class HomeScreen extends GetView<HomeScreenController> {
  List<String> bottomBarNoSelectedImgList = ["home.svg", "book.svg", "chatbubbles.svg", "person.svg"];
  List<String> bottomBarSelectedImgList = [
    "home_selected.svg",
    "book_selected.svg",
    "chatbubbles_selected.svg",
    "person_selected.svg"
  ];
  List<String> bottomBarStringList = ["홈", "책장", "커뮤니티", "프로필"];

  List<Widget> tabList = [
    TabHome(),
    const TabBookCase(),
    TabCommunity(),
    const TabProfile(),
  ];

  HomeScreen(int tabIndex, {super.key}) {
    Get.put(HomeScreenController(tabIndex));
  }

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    double size = FetchPixels.getPixelHeight(50);
    double iconSize = FetchPixels.getPixelHeight(26);
    return WillPopScope(
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
                height: FetchPixels.getPixelHeight(55),
                color: Colors.white,
                child: Row(
                    children: List.generate(bottomBarNoSelectedImgList.length, (selectedTabIndex) {
                  return Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        controller.tabIndex = selectedTabIndex;
                      },
                      child: Center(
                        child: Container(
                          width: size,
                          height: size,
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
                                      width: iconSize,
                                      height: iconSize),
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
                }))))),
        onWillPop: () async {
          Constant.closeApp();
          return false;
        });
  }
}
