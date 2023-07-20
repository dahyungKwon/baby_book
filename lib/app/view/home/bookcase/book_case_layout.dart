import 'package:baby_book/app/view/home/book/HoldType.dart';
import 'package:baby_book/app/view/home/bookcase/book_case_list_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../base/resizer/fetch_pixels.dart';
import '../../../../base/skeleton.dart';
import '../../../../base/widget_utils.dart';
import '../../../controller/BookCaseController.dart';

Widget buildBookCaseLayout(BuildContext context, BookCaseController controller) {
  return controller.loading
      ? const FullSizeSkeleton()
      : Column(
          children: [tabBar(context, controller), getVerSpace(FetchPixels.getPixelHeight(25)), pageViewer(controller)]);
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
      isScrollable: false,
      indicatorColor: Colors.transparent,
      physics: const BouncingScrollPhysics(),
      controller: controller.tabController,
      labelPadding: EdgeInsets.fromLTRB(10, 25, 10, 0),
      // labelStyle: TextStyle(fontSize: 5),
      onTap: (index) {
        controller.pageController.jumpToPage(index);
        controller.position = index;
      },
      labelColor: Colors.black,
      unselectedLabelColor: Colors.black.withOpacity(0.3),
      labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, overflow: TextOverflow.visible),
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
      children: [
        BookCaseListScreen(memberId: controller.memberId!, holdType: null),
        BookCaseListScreen(memberId: controller.memberId!, holdType: HoldType.plan),
        BookCaseListScreen(memberId: controller.memberId!, holdType: HoldType.read),
        BookCaseListScreen(memberId: controller.memberId!, holdType: HoldType.end),
      ],
      onPageChanged: (value) {
        controller.tabController.animateTo(value);
        controller.position = value;
      },
    ),
  );
}
