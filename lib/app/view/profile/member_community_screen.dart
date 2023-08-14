import 'package:baby_book/base/color_data.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../base/skeleton.dart';
import '../../../base/uuid_util.dart';
import '../../controller/MemberCommunityController.dart';
import '../../repository/post_repository.dart';

class MemberCommunityScreen extends GetView<MemberCommunityController> {
  late final String? memberId;
  late final String? uniqueTag;

  MemberCommunityScreen({super.key}) {
    memberId = Get.parameters["memberId"];
    uniqueTag = getUuid();

    Get.put(MemberCommunityController(postRepository: PostRepository(), memberId: memberId!), tag: uniqueTag);
  }

  @override
  String? get tag => uniqueTag;

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
            resizeToAvoidBottomInset: false,
            backgroundColor: backGroundColor,
            body: Obx(() => SafeArea(
                  child: controller.loading
                      ? const FullSizeSkeleton()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildToolbar(context, edgeInsets),
                            // getVerSpace(FetchPixels.getPixelHeight(5)),
                            pageViewer()
                          ],
                        ),
                ))));
  }

  Widget buildToolbar(BuildContext context, EdgeInsets edgeInsets) {
    return Container(
        padding: const EdgeInsets.fromLTRB(5, 10, 0, 0),
        color: Colors.white,
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          getSimpleImageButton("back_outline.svg", FetchPixels.getPixelHeight(50), FetchPixels.getPixelHeight(50),
              Colors.white, FetchPixels.getPixelHeight(26), FetchPixels.getPixelHeight(26), () async {
            Get.back();
          }),
          tabBar(edgeInsets),
          // getCustomFont(
          //   controller.myProfile ? "북마크 / 작성글 / 작성댓글" : "작성글 / 작성댓글",
          //   18,
          //   Colors.black,
          //   1,
          //   fontWeight: FontWeight.w500,
          // ),
        ]));
  }

  Widget tabBar(var edgeInsets) {
    return Obx(() => getPaddingWidget(
          edgeInsets,
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
            labelPadding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
            // labelStyle: TextStyle(fontSize: 5),
            onTap: (index) {
              print("tabBar onTap index : $index");
              controller.pageController.jumpToPage(index);
              controller.position = index;
            },
            labelColor: controller.memberPostTypeList[controller.position].color,
            unselectedLabelColor: Colors.black.withOpacity(0.3),
            labelStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, overflow: TextOverflow.visible),
            //For Selected tab
            tabs: List.generate(controller.tabsList.length, (index) {
              return Tab(
                height: FetchPixels.getPixelHeight(25),
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
          controller.widgetList[index].controller.getAllForInit(controller.memberPostTypeList[index]);
          controller.tabController.animateTo(index);
          controller.position = index;
        },
      ),
    );
  }
}
