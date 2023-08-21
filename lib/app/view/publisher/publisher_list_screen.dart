import 'package:baby_book/app/models/model_publisher.dart';
import 'package:baby_book/app/repository/search_repository.dart';

import 'package:baby_book/base/color_data.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import '../../../../base/skeleton.dart';
import '../../../../base/widget_utils.dart';
import '../../controller/PublisherListController.dart';
import '../../models/model_member.dart';
import '../../repository/paging_request.dart';
import '../../routes/app_pages.dart';

class PublisherListScreen extends GetView<PublisherListController> {
  late RefreshController refreshController;
  int pageNumber = 1;

  PublisherListScreen({super.key}) {
    Get.delete<PublisherListController>();
    Get.put(PublisherListController(searchRepository: SearchRepository(), keyword: Get.parameters['keyword']!));
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
                        : controller.publisherList.length < 1
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
            "출판사 검색 결과 : " + controller.keyword,
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
        child: buildPublisherList(controller.publisherList, controller.member));
  }

  void onRefresh() async {
    await controller.getAllForPullToRefresh();
    initPageNumber(); //순서중요

    await Future.delayed(Duration(milliseconds: 500));

    refreshController.refreshCompleted();
  }

  void onLoading() async {
    List<ModelPublisher>? list = await controller.getAllForLoading(PagingRequest.create(pageNumber + 1));
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

  ListView buildPublisherList(List<ModelPublisher> publisherList, ModelMember member) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        // shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: publisherList.length,
        itemBuilder: (context, index) {
          ModelPublisher publisher = publisherList[index];
          return GestureDetector(
              onTap: () {
                Get.toNamed(Routes.publisherPath, parameters: {
                  'publisherId': publisher.publisherId.toString(),
                  'publisherName': publisher.publisherName
                });
              },
              child: Container(
                  width: 100.w,
                  decoration: BoxDecoration(
                      color: Colors.white, border: Border(bottom: BorderSide(color: Colors.black26, width: 0.5))),
                  padding: EdgeInsets.symmetric(
                      vertical: FetchPixels.getPixelHeight(15), horizontal: FetchPixels.getPixelHeight(15)),
                  child: Row(
                    children: [
                      ExtendedImage.network(
                        publisher.publisherLogoUrl ?? "",
                        width: FetchPixels.getPixelHeight(45),
                        height: FetchPixels.getPixelHeight(45),
                        fit: BoxFit.fitHeight,
                        cache: true,
                        loadStateChanged: (ExtendedImageState state) {
                          switch (state.extendedImageLoadState) {
                            case LoadState.loading:
                              return Image.asset("assets/images/book_placeholder.png", fit: BoxFit.fill);
                            case LoadState.completed:
                              break;
                            case LoadState.failed:
                              return Image.asset("assets/images/book_placeholder.png", fit: BoxFit.fill);
                          }
                        },
                      ),
                      getHorSpace(FetchPixels.getPixelWidth(18)),
                      getCustomFont(publisher.publisherName, 16, Colors.black, 1,
                          fontWeight: FontWeight.w400, textAlign: TextAlign.center),
                    ],
                  )));
        });
  }

  Column nullListView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        getCustomFont("검색 결과가 없습니다.", 18, Colors.black, 1, fontWeight: FontWeight.w400, textAlign: TextAlign.center),
      ],
    );
  }
}
