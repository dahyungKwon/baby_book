import 'package:baby_book/app/repository/paging_request.dart';
import 'package:baby_book/app/view/search/search_type.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';

import '../../../base/color_data.dart';
import '../../../base/constant.dart';
import '../../../base/skeleton.dart';
import '../../../base/widget_utils.dart';
import '../../controller/CommunityTagAddController.dart';
import '../../controller/SearchScreenController.dart';
import '../../models/model_book_response.dart';
import '../../models/model_member.dart';
import '../../repository/search_repository.dart';
import '../../routes/app_pages.dart';
import '../home/book/book_list.dart';

class SearchScreen extends GetView<SearchScreenController> {
  late RefreshController refreshController;
  int pageNumber = 1;
  bool searched = false;
  FocusNode keywordFocusNode = FocusNode();
  SearchType searchType = SearchType.none;

  SearchScreen({super.key}) {
    searchType = SearchType.findByCode(Get.parameters['searchType']);
    Get.put(SearchScreenController(
        searchRepository: SearchRepository(), searchType: searchType, keyword: Get.parameters['keyword']));
    refreshController = RefreshController(initialRefresh: false);
  }

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: backGroundColor,
          body: SafeArea(
            child: Container(
              // padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(15)),
              child: Obx(() => Column(
                    children: [
                      buildToolbar(context),
                      controller.loading
                          ? const Expanded(child: ListSkeleton())
                          : Expanded(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                  // Container(height: 1.h, color: Color(0xFFF5F6F8)),
                                  // Container(height: 1.h, color: Color(0xFFF5F6F8)),
                                  if (controller.publisherList.length > 0) ...[
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: FetchPixels.getPixelHeight(15),
                                          top: FetchPixels.getPixelHeight(15),
                                          bottom: FetchPixels.getPixelHeight(10)),
                                      // height: 2.h,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          getCustomFont(
                                            "출판사 검색 결과",
                                            16,
                                            Colors.black,
                                            1,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          GestureDetector(
                                              onTap: () {
                                                Get.toNamed(Routes.publisherListPath,
                                                    parameters: {"keyword": controller.keyword!});
                                              },
                                              child: Container(
                                                  width: FetchPixels.getPixelHeight(100),
                                                  height: FetchPixels.getPixelHeight(30),
                                                  // color: Colors.black12,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      getCustomFont(
                                                        "더보기",
                                                        14,
                                                        Colors.black,
                                                        1,
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                      getSvgImage("arrow_right.svg",
                                                          width: FetchPixels.getPixelHeight(16),
                                                          height: FetchPixels.getPixelHeight(16)),
                                                      getHorSpace(FetchPixels.getPixelHeight(15))
                                                    ],
                                                  )))
                                        ],
                                      ),
                                    ),
                                    Wrap(
                                        direction: Axis.vertical,
                                        // 정렬 방향
                                        alignment: WrapAlignment.start,
                                        children: controller.publisherList
                                            .map<Widget>((publisher) => GestureDetector(
                                                onTap: () {
                                                  Get.toNamed(Routes.publisherPath, parameters: {
                                                    'publisherId': publisher.publisherId.toString(),
                                                    'publisherName': publisher.publisherName
                                                  });
                                                },
                                                child: Container(
                                                    width: 100.w,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        border: Border(
                                                            bottom: BorderSide(color: Colors.black26, width: 0.5))),
                                                    padding: EdgeInsets.symmetric(
                                                        vertical: FetchPixels.getPixelHeight(10),
                                                        horizontal: FetchPixels.getPixelHeight(15)),
                                                    child: Row(
                                                      children: [
                                                        ExtendedImage.network(
                                                          publisher.publisherLogoUrl ?? "",
                                                          width: FetchPixels.getPixelHeight(25),
                                                          height: FetchPixels.getPixelHeight(25),
                                                          fit: BoxFit.fitHeight,
                                                          cache: true,
                                                          loadStateChanged: (ExtendedImageState state) {
                                                            switch (state.extendedImageLoadState) {
                                                              case LoadState.loading:
                                                                return Image.asset("assets/images/book_placeholder.png",
                                                                    fit: BoxFit.fill);
                                                              case LoadState.completed:
                                                                break;
                                                              case LoadState.failed:
                                                                return Image.asset("assets/images/book_placeholder.png",
                                                                    fit: BoxFit.fill);
                                                            }
                                                          },
                                                        ),
                                                        getHorSpace(FetchPixels.getPixelWidth(18)),
                                                        getCustomFont(publisher.publisherName, 16, Colors.black, 1,
                                                            fontWeight: FontWeight.w400, textAlign: TextAlign.center),
                                                      ],
                                                    ))))
                                            .toList()),
                                    Container(height: 1.h, color: Color(0xFFF5F6F8)),
                                  ],

                                  if (controller.bookList.length > 0) ...[
                                    Expanded(child: drawBookSearchResult())
                                  ] else ...[
                                    if (controller.firstSearched) ...[getEmptyWidget(context)]
                                  ]
                                ]))
                    ],
                  )),
            ),
          ),
        ),
        onWillPop: () async {
          Get.back();
          return false;
        });
  }

  Widget buildToolbar(BuildContext context) {
    return Container(
        // width: FetchPixels.getPixelHeight(50),
        // height: FetchPixels.getPixelHeight(50),
        decoration:
            BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: Colors.black26, width: 1.0))),
        padding: const EdgeInsets.fromLTRB(5, 10, 0, 0),
        // color: Colors.white,
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          getSimpleImageButton("back_outline.svg", FetchPixels.getPixelHeight(50), FetchPixels.getPixelHeight(50),
              Colors.white, FetchPixels.getPixelHeight(26), FetchPixels.getPixelHeight(26), () async {
            Get.back();
          }),
          Expanded(child: getTopSearchWidget(context)),
        ]));
  }

  Widget getTopSearchWidget(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(right: FetchPixels.getPixelWidth(15), top: FetchPixels.getPixelHeight(0)),
        child: getSearchWidget(context, controller.searchController, () {}, (value) {
          // if (searched) {
          //   // controller.clearSearchResult();
          //   searched = false;
          // }
        }, onSubmit: (submit) {
          // searched = true;
          search();
        }, clickSearch: () {
          // searched = true;
          search();
          keywordKeyboardDown(context);
        }, focusNode: keywordFocusNode, isAutoFocus: controller.searchType != SearchType.community));
  }

  search() {
    ///첫 검색임으로 paging의 경우 디폴트로 잡혀서 조회 시작
    initPageNumber();
    controller.search(controller.searchController.text, PagingRequest.createDefault());
  }

  Widget getSearchWidget(BuildContext context, TextEditingController searchController, Function filterClick,
      ValueChanged<String> onChanged,
      {bool withPrefix = true,
      ValueChanged<String>? onSubmit,
      Function? clickSearch,
      FocusNode? focusNode,
      bool? isAutoFocus}) {
    double height = FetchPixels.getPixelHeight(60);

    final mqData = MediaQuery.of(context);
    final mqDataNew = mqData.copyWith(textScaleFactor: FetchPixels.getTextScale());

    double iconSize = FetchPixels.getPixelHeight(26);

    return Container(
      width: double.infinity,
      height: height,
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          // getHorSpace(FetchPixels.getPixelWidth(16)),

          getHorSpace(FetchPixels.getPixelWidth(18)),
          Expanded(
            flex: 1,
            child: MediaQuery(
                data: mqDataNew,
                child: IntrinsicHeight(
                  child: TextField(
                    onTap: () {
                      filterClick();
                    },
                    controller: searchController,
                    onChanged: onChanged,
                    decoration: const InputDecoration(
                        isDense: true,
                        hintText: "검색어를 입력해주세요.",
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                            fontFamily: Constant.fontsFamily,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Colors.black26)),
                    style: const TextStyle(
                        fontFamily: Constant.fontsFamily,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    onSubmitted: onSubmit,
                    autofocus: isAutoFocus ?? false,
                    focusNode: focusNode,
                  ),
                )),
          ),
          GestureDetector(
              onTap: () {
                if (clickSearch != null) {
                  clickSearch();
                }
              },
              child: Container(
                  width: FetchPixels.getPixelHeight(50),
                  height: FetchPixels.getPixelHeight(50),
                  child: Center(child: getSvgImageWithSize(context, "search.svg", iconSize, iconSize)))),

          getHorSpace(FetchPixels.getPixelWidth(0)),
        ],
      ),
    );
  }

  SmartRefresher drawBookSearchResult() {
    return SmartRefresher(
        enablePullDown: false,
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
        // onRefresh: onRefresh,
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
            if (searchType == SearchType.community) {
              ///CommunityTagAddController에 데이터 넣는식이 되야함
              Get.back(result: modelBookResponse);
            } else {
              Get.toNamed(Routes.bookDetailPath, parameters: {
                'bookSetId': modelBookResponse.modelBook.id.toString(),
                'babyId': member.selectedBabyId ?? ""
              });
            }
          });
        });
  }

  Expanded getEmptyWidget(BuildContext context) {
    return Expanded(
        child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          getCustomFont("검색 결과가 없습니다.", 18, Colors.black, 1, fontWeight: FontWeight.w400, textAlign: TextAlign.center),
        ],
      ),
    ));
  }

  keywordKeyboardDown(BuildContext context) {
    FocusScope.of(context).unfocus();
  }
}
