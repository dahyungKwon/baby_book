import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../base/resizer/fetch_pixels.dart';
import '../../../../base/skeleton.dart';
import '../../../../base/widget_utils.dart';
import '../../../controller/BookCaseController.dart';

Widget buildBookCaseLayout(BuildContext context, BookCaseController controller) {
  return controller.loading
      ? const FullSizeSkeleton()
      : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          buildToolbar(context, controller),
          getVerSpace(FetchPixels.getPixelHeight(25)),
          pageViewer(controller)
        ]);
}

Widget buildToolbar(BuildContext context, BookCaseController controller) {
  return Container(
      // width: FetchPixels.getPixelHeight(50),
      // height: FetchPixels.getPixelHeight(50),
      // padding: const EdgeInsets.fromLTRB(5, 10, 0, 0),
      color: Colors.white,
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        controller.myBookCase
            ? Container()
            : getSimpleImageButton("back_outline.svg", FetchPixels.getPixelHeight(50), FetchPixels.getPixelHeight(50),
                Colors.white, FetchPixels.getPixelHeight(26), FetchPixels.getPixelHeight(26), () async {
                Get.back();
              }),
        tabBar(context, controller),
        // getCustomFont(
        //   controller.myProfile ? "북마크 / 작성글 / 작성댓글" : "작성글 / 작성댓글",
        //   18,
        //   Colors.black,
        //   1,
        //   fontWeight: FontWeight.w500,
        // ),
      ]));
}

Widget tabBar(BuildContext context, BookCaseController controller) {
  return getPaddingWidget(
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
      labelPadding: controller.myBookCase ? EdgeInsets.fromLTRB(10, 25, 10, 0) : EdgeInsets.fromLTRB(0, 0, 20, 0),
      // labelStyle: TextStyle(fontSize: 5),
      onTap: (index) {
        controller.pageController.jumpToPage(index);
        controller.position = index;
      },
      labelColor: Colors.black,
      unselectedLabelColor: Colors.black.withOpacity(0.3),
      labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, overflow: TextOverflow.visible),
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
  );
}

Expanded pageViewer(BookCaseController controller) {
  return Expanded(
    child: PageView(
      physics: const BouncingScrollPhysics(),
      controller: controller.pageController,
      scrollDirection: Axis.horizontal,
      children: controller.bookCaseListScreenList,
      onPageChanged: (value) {
        controller.tabController.animateTo(value);
        controller.position = value;
      },
    ),
  );
}
