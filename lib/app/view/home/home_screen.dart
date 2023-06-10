import 'package:baby_book/app/view/home/tab/tab_bookings.dart';
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
  List<String> bottomBarList = ["home.svg", "documnet.svg", "calender.svg", "profile.svg"];

  List<Widget> tabList = [
    TabHome(),
    const TabBookings(),
    const TabSchedule(),
    const TabProfile(),
  ];

  HomeScreen(int tabIndex, {super.key}) {
    Get.put(HomeScreenController(tabIndex));
  }

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    double size = FetchPixels.getPixelHeight(45);
    double iconSize = FetchPixels.getPixelHeight(32);
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
                height: FetchPixels.getPixelHeight(100),
                color: Colors.white,
                child: Row(
                    children: List.generate(bottomBarList.length, (selectedTabIndex) {
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
                          decoration: BoxDecoration(
                              color: controller.tabIndex == selectedTabIndex ? blueColor : Colors.transparent,
                              shape: BoxShape.circle),
                          child: Center(
                            child: getSvgImage(bottomBarList[selectedTabIndex],
                                width: iconSize,
                                height: iconSize,
                                color: controller.tabIndex == selectedTabIndex ? Colors.white : null),
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
