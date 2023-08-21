import 'package:baby_book/app/repository/book_repository.dart';
import 'package:baby_book/base/color_data.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../base/skeleton.dart';
import '../../../../base/uuid_util.dart';
import '../../../controller/BookCommunityController.dart';
import '../../../repository/post_repository.dart';

class BookCommunityScreen extends GetView<BookCommunityController> {
  late final int? bookId;
  late final String? bookName;
  late final String? uniqueTag;

  BookCommunityScreen({super.key}) {
    bookId = int.parse(Get.parameters["bookId"]!);
    bookName = Get.parameters["bookName"]!;
    uniqueTag = getUuid();

    Get.put(
        BookCommunityController(
            postRepository: PostRepository(), bookRepository: BookRepository(), bookId: bookId!, bookName: bookName!),
        tag: uniqueTag);
  }

  @override
  String? get tag => uniqueTag;

  @override
  Widget build(BuildContext context) {
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
                  // getVerSpace(FetchPixels.getPixelHeight(5)),
                  pageViewer()
                ],
              ),
            )));
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
          getCustomFont(
            "${bookName!}",
            18,
            Colors.black,
            1,
            fontWeight: FontWeight.w600,
          ),
        ]));
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
          controller.widgetList[index].controller.getAllForInit();
          controller.tabController.animateTo(index);
          controller.position = index;
        },
      ),
    );
  }
}
