import 'package:baby_book/app/view/community/community_list_screen.dart';
import 'package:baby_book/base/color_data.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/TabCommunityController.dart';
import '../../community/post_type.dart';

/// 여기선 position이 obs값이나 set만 하고 감지할 필요가 없기에 obx를 안 넣어줘도 됨
/// 참고 : https://annhee.tistory.com/82
class TabCommunity extends GetView<TabCommunityController> {
  TabCommunity({super.key}) {
    Get.put(TabCommunityController());
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets edgeInsets = EdgeInsets.symmetric(
      horizontal: FetchPixels.getDefaultHorSpace(context),
    );

    ///임시 더 좋은 방법이 있을지 고민 필요 (재현, 상단탭을 변경후 책장 -> 커뮤니티 다시 진입 시)
    controller.position = 0;
    controller.tabController.animateTo(0);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backGroundColor,
      body: Column(
        children: [tabBar(edgeInsets), getVerSpace(FetchPixels.getPixelHeight(25)), pageViewer()],
      ),
    );
  }

  Expanded pageViewer() {
    return Expanded(
      child: PageView(
        physics: const BouncingScrollPhysics(),
        controller: controller.pageController,
        scrollDirection: Axis.horizontal,
        children: PostType.values.map((e) => CommunityListScreen(e)).toList(),
        onPageChanged: (value) {
          controller.tabController.animateTo(value);
          controller.position = value;
        },
      ),
    );
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
            labelPadding: const EdgeInsets.fromLTRB(10, 25, 10, 0),
            // labelStyle: TextStyle(fontSize: 5),
            onTap: (index) {
              controller.pageController.jumpToPage(index);
              controller.position = index;
            },
            labelColor: controller.postTypeList[controller.position].color,
            unselectedLabelColor: Colors.black.withOpacity(0.3),
            labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, overflow: TextOverflow.visible),
            //For Selected tab
            tabs: List.generate(controller.tabsList.length, (index) {
              return Tab(
                height: 16.0,
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
}
