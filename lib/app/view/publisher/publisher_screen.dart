import 'package:baby_book/app/repository/search_repository.dart';

import 'package:baby_book/app/view/home/book/book_list.dart';
import 'package:baby_book/base/color_data.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../base/skeleton.dart';
import '../../../../base/widget_utils.dart';
import '../../controller/PublisherController.dart';
import '../../models/model_book_response.dart';
import '../../models/model_member.dart';
import '../../repository/paging_request.dart';
import '../../routes/app_pages.dart';

class PublisherScreen extends GetView<PublisherController> {
  late RefreshController refreshController;
  int pageNumber = 1;

  PublisherScreen({super.key}) {
    Get.delete<PublisherController>();
    Get.put(PublisherController(
        searchRepository: SearchRepository(),
        publisherId: int.parse(Get.parameters['publisherId']!),
        publisherName: Get.parameters['publisherName']!));
    refreshController = RefreshController(initialRefresh: false);
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets edgeInsets = EdgeInsets.symmetric(
      horizontal: FetchPixels.getDefaultHorSpace(context),
    );

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: backGroundColor,
        body: SafeArea(
            child: Obx(() => Column(
                  children: [
                    buildToolbar(context),
                    getVerSpace(FetchPixels.getPixelHeight(10)),
                    controller.loading
                        ? const Expanded(child: ListSkeleton())
                        : controller.bookList.length < 1
                            ? Expanded(child: getPaddingWidget(edgeInsets, nullListView(context)))
                            : Expanded(child: draw())
                  ],
                ))));
  }

  Widget buildToolbar(BuildContext context) {
    return Container(
        // width: FetchPixels.getPixelHeight(50),
        // height: FetchPixels.getPixelHeight(50),
        // padding: const EdgeInsets.fromLTRB(5, 10, 0, 0),
        color: Colors.white,
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          getSimpleImageButton("back_outline.svg", FetchPixels.getPixelHeight(50), FetchPixels.getPixelHeight(50),
              Colors.white, FetchPixels.getPixelHeight(26), FetchPixels.getPixelHeight(26), () async {
            Get.back();
          }),
          getCustomFont(
            controller.publisherName,
            18,
            Colors.black,
            1,
            fontWeight: FontWeight.w500,
          ),
        ]));
  }

  SmartRefresher draw() {
    return SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: const MaterialClassicHeader(
          color: Colors.black,
        ),
        footer: const ClassicFooter(
            loadStyle: LoadStyle.ShowWhenLoading,
            loadingText: "Loading...",
            idleText: "Loading...",
            canLoadingText: "Loading..."),
        controller: refreshController,
        onRefresh: onRefresh,
        onLoading: onLoading,
        child: buildBookList(controller.bookList, controller.member));
  }

  void onRefresh() async {
    await controller.getAllForPullToRefresh();
    initPageNumber(); //순서중요

    await Future.delayed(Duration(milliseconds: 500));

    refreshController.refreshCompleted();
  }

  void onLoading() async {
    List<ModelBookResponse>? list = await controller.getAllForLoading(PagingRequest.create(pageNumber + 1));
    if (list != null && list.isNotEmpty) {
      plusPageNumber();
    }

    await Future.delayed(Duration(milliseconds: 500));
    refreshController.loadComplete();
  }

  void initPageNumber() {
    pageNumber = 1;
  }

  void plusPageNumber() {
    pageNumber++;
  }

  ListView buildBookList(List<ModelBookResponse> bookList, ModelMember member) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        // shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: bookList.length,
        itemBuilder: (context, index) {
          ModelBookResponse modelBookResponse = bookList[index];
          return buildBookListItem(modelBookResponse, context, index, () {
            Get.toNamed(Routes.bookDetailPath, parameters: {
              'bookSetId': modelBookResponse.modelBook.id.toString(),
              'babyId': member.selectedBabyId ?? ""
            });
          });
        });
  }

  Column nullListView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // getSvgImage("clipboard.svg", height: FetchPixels.getPixelHeight(124), width: FetchPixels.getPixelHeight(124)),
        // getVerSpace(FetchPixels.getPixelHeight(40)),
        getCustomFont("해당 조건의 책이 존재 하지 않습니다.", 20, Colors.black, 1, fontWeight: FontWeight.w600),
        getVerSpace(FetchPixels.getPixelHeight(10)),
        getCustomFont(
          "여러분의 소중한 경험을 공유해주세요.",
          16,
          Colors.black45,
          1,
          fontWeight: FontWeight.w400,
        ),
        getVerSpace(FetchPixels.getPixelHeight(30)),
        getButton(context, backGroundColor, "책 제보 하러가기", Colors.black87, () {
          Get.toNamed(Routes.reportNewBookAddPath);
        }, 18,
            weight: FontWeight.w600,
            buttonHeight: FetchPixels.getPixelHeight(60),
            insetsGeometry: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(100)),
            borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(14)),
            isBorder: true,
            borderColor: Colors.grey,
            borderWidth: 1.5)
      ],
    );
  }
}
