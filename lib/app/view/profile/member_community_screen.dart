import 'package:baby_book/base/color_data.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../base/uuid_util.dart';
import '../../controller/MemberCommunityController.dart';
import '../../repository/post_repository.dart';

class MemberCommunityScreen extends GetView<MemberCommunityController> {
  late final String? memberId;
  late final bool? myProfile;
  late final String? uniqueTag;

  MemberCommunityScreen({super.key}) {
    memberId = Get.parameters["memberId"];
    myProfile = bool.tryParse(Get.parameters["myProfile"]!);
    myProfile ??= false;

    uniqueTag = getUuid();
  }

  @override
  String? get tag => uniqueTag;

  @override
  Widget build(BuildContext context) {
    Get.delete<MemberCommunityController>(tag: uniqueTag);
    Get.put(MemberCommunityController(postRepository: PostRepository(), memberId: memberId!, myProfile: myProfile!),
        tag: uniqueTag);

    FetchPixels(context);
    double defHorSpace = FetchPixels.getDefaultHorSpace(context);
    EdgeInsets edgeInsets = EdgeInsets.symmetric(horizontal: defHorSpace);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: backGroundColor,
        body: Obx(() => SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildToolbar(context, edgeInsets),
                  getVerSpace(FetchPixels.getPixelHeight(15)),
                  pageViewer()
                ],
              ),
            )));
  }

  Widget buildToolbar(BuildContext context, EdgeInsets edgeInsets) {
    return Container(
        padding: EdgeInsets.fromLTRB(FetchPixels.getPixelHeight(5), FetchPixels.getPixelHeight(10), 0, 0),
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
            labelPadding: EdgeInsets.fromLTRB(0, FetchPixels.getPixelHeight(15), FetchPixels.getPixelHeight(20), 0),
            // labelStyle: TextStyle(fontSize: 5),
            onTap: (index) {
              print("tabBar onTap index : $index");
              controller.pageController.jumpToPage(index);
              controller.position = index;
            },
            labelColor: controller.memberPostTypeList[controller.position].color,
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
          controller.widgetList[index].controller.getAllForInit(controller.memberPostTypeList[index]);
          controller.tabController.animateTo(index);
          controller.position = index;
        },
      ),
    );
  }
}
