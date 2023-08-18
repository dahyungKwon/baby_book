import 'package:baby_book/base/color_data.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/TabCommunityController.dart';
import '../../../routes/app_pages.dart';

/// 여기선 position이 obs값이나 set만 하고 감지할 필요가 없기에 obx를 안 넣어줘도 됨
/// 참고 : https://annhee.tistory.com/82
class TabCommunity extends GetView<TabCommunityController> {
  const TabCommunity({super.key});

  @override
  Widget build(BuildContext context) {
    Get.delete<TabCommunityController>();
    Get.put(TabCommunityController());

    EdgeInsets edgeInsets = EdgeInsets.symmetric(
      horizontal: FetchPixels.getDefaultHorSpace(context),
    );

    ///임시 더 좋은 방법이 있을지 고민 필요 (재현, 상단탭을 변경후 책장 -> 커뮤니티 다시 진입 시)

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: backGroundColor,
        body: Column(
          children: [tabBar(context), getVerSpace(FetchPixels.getPixelHeight(15)), pageViewer()],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: FloatingActionButton(
              child: Icon(Icons.add),
              backgroundColor: secondMainColor,
              onPressed: () async {
                try {
                  Get.toNamed(Routes.communityAddPath, parameters: {"postType": controller.selectedPostType().code});
                } catch (e) {
                  Get.delete<TabCommunityController>();
                  Get.put(TabCommunityController());
                }
              }),
        ));
  }

  Widget tabBar(BuildContext context) {
    return Obx(() => getPaddingWidget(
          EdgeInsets.symmetric(horizontal: FetchPixels.getDefaultHorSpace(context)),
          TabBar(
            overlayColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                return Colors.transparent;
              },
            ),
            isScrollable: true,
            indicatorColor: Colors.transparent,
            physics: const BouncingScrollPhysics(),
            controller: controller.tabController,
            labelPadding: EdgeInsets.fromLTRB(
                FetchPixels.getPixelHeight(10), FetchPixels.getPixelHeight(25), FetchPixels.getPixelHeight(15), 0),
            // labelStyle: TextStyle(fontSize: 5),
            onTap: (index) {
              print("tabBar onTap index : $index");
              controller.pageController.jumpToPage(index);
              controller.position = index;
            },
            labelColor: controller.postTypeList[controller.position].color,
            unselectedLabelColor: Colors.black.withOpacity(0.3),
            labelStyle: TextStyle(
                fontSize: FetchPixels.getPixelHeight(18), fontWeight: FontWeight.w600, overflow: TextOverflow.visible),
            //For Selected tab
            tabs: List.generate(controller.tabsList.length, (index) {
              return Tab(
                height: FetchPixels.getPixelHeight(35),
                child: Container(
                    alignment: Alignment.center,
                    child: Column(
                      children: [Text(controller.tabsList[index])],
                    )),
              );
            }),
          ),
        ));
  }

  Expanded pageViewer() {
    return Expanded(
      child: PageView(
        physics: const BouncingScrollPhysics(),
        controller: controller.pageController,
        scrollDirection: Axis.horizontal,
        children: controller.widgetList,
        onPageChanged: (index) {
          print("pageViewer onPageChanged pageIndex : $index");
          controller.widgetList[index].initPageNumber();
          controller.widgetList[index].controller.getAllForInit(controller.postTypeList[index]);
          controller.tabController.animateTo(index);
          controller.position = index;
        },
      ),
    );
  }
}
