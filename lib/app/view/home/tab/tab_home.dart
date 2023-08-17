import 'package:baby_book/app/models/model_age_group.dart';
import 'package:baby_book/app/repository/book_repository.dart';

import 'package:baby_book/app/view/home/book/age_group_bottom_sheet.dart';
import 'package:baby_book/app/view/home/book/book_list.dart';
import 'package:baby_book/app/view/home/book/category_type.dart';
import 'package:baby_book/base/color_data.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../base/skeleton.dart';
import '../../../../base/widget_utils.dart';
import '../../../controller/TabHomeController.dart';
import '../../../models/model_book_response.dart';
import '../../../models/model_member.dart';
import '../../../repository/paging_request.dart';
import '../../../routes/app_pages.dart';
import 'book_list_sort_type_bottom_sheet.dart';

class TabHome extends GetView<TabHomeController> {
  TextEditingController searchController = TextEditingController();
  List<CategoryType> categoryLists = CategoryType.findListViewList();
  ValueNotifier selectedPage = ValueNotifier(0);
  late RefreshController refreshController;
  int pageNumber = 1;

  TabHome({super.key}) {
    // Get.delete<TabHomeController>();
    Get.put(TabHomeController(0, bookListRepository: BookRepository()));
    refreshController = RefreshController(initialRefresh: false);
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets edgeInsets = EdgeInsets.symmetric(
      horizontal: FetchPixels.getDefaultHorSpace(context),
    );

    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getVerSpace(FetchPixels.getPixelHeight(10)),
            getPaddingWidget(
              EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(10)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      width: FetchPixels.getPixelWidth(170),
                      height: FetchPixels.getPixelHeight(50),
                      child: getDefaultTextFiledWithLabel2(
                          context,
                          ModelAgeGroup.ageGroupList[controller.selectedAgeGroupId!].title,
                          Colors.black,
                          controller.ageGroupTextEditingController,
                          Colors.black87,
                          FetchPixels.getPixelHeight(18),
                          boxColor: backGroundColor,
                          FontWeight.w700, function: () {
                        showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (_) => AgeGroupBottomSheet(
                                    selectedAgeGroup: ModelAgeGroup.ageGroupList[controller.selectedAgeGroupId!]))
                            .then((selectedAgeGroup) async {
                          if (selectedAgeGroup != null) {
                            await FirebaseAnalytics.instance.logScreenView(
                                screenName: "home_ageChangeBtn_${selectedAgeGroup.title}_screenName",
                                screenClass: "home_ageChangeBtn_${selectedAgeGroup.title}_screenClass");

                            ///age를 바꾸면 캐시 다 날리고, 선택된 카테고리로 재조회
                            initPageNumber();
                            controller.selectedAgeGroupId = selectedAgeGroup.groupId;
                            controller.initCache();
                            controller.getAllForInit(controller.selectedCategoryType);
                          }
                        });
                      },
                          isEnable: false,
                          withprefix: false,
                          minLines: true,
                          height: FetchPixels.getPixelHeight(50),
                          withSufix: true,
                          suffiximage: "down_arrow.svg",
                          enableEditing: false)),
                  Row(
                    children: [
                      // getSimpleImageButton(
                      //     "notification.svg",
                      //     FetchPixels.getPixelHeight(50),
                      //     FetchPixels.getPixelHeight(50),
                      //     Colors.white,
                      //     FetchPixels.getPixelHeight(26),
                      //     FetchPixels.getPixelHeight(26), () {
                      //   Get.toNamed(Routes.searchPath);
                      // }),
                      // getHorSpace(FetchPixels.getPixelWidth(10)),
                      getSimpleImageButton("search.svg", FetchPixels.getPixelHeight(50), FetchPixels.getPixelHeight(50),
                          Colors.white, FetchPixels.getPixelHeight(26), FetchPixels.getPixelHeight(26), () async {
                        await FirebaseAnalytics.instance.logScreenView(
                            screenName: "home_searchBtn_screenName", screenClass: "home_searchBtn_screenClass");
                        Get.toNamed(Routes.searchPath);
                      }),
                    ],
                  ),
                ],
              ),
            ),
            getVerSpace(FetchPixels.getPixelHeight(10)),
            SizedBox(
              // width: 70.w,
              height: FetchPixels.getPixelHeight(50),
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(15)),
                scrollDirection: Axis.horizontal,
                itemCount: categoryLists.length,
                primary: false,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) => Obx(() {
                  CategoryType categoryType = categoryLists[index];
                  return GestureDetector(
                    onTap: () async {
                      await FirebaseAnalytics.instance.logScreenView(
                          screenName: "home_categoryChangeBtn_${categoryType.code}_screenName",
                          screenClass: "home_categoryChangeBtn_${categoryType.code}_screenClass");

                      ///책 타입 변경하면 새로 조회 (캐시 있으면 캐시 보여줌)
                      initPageNumber();
                      controller.selectedCategoryIdx = index;
                      // controller.selectedCategoryType = categoryType;
                      controller.getAllForInit(categoryType);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          decoration: BoxDecoration(
                            color: index == controller.selectedCategoryIdx ? const Color(0xFF464646) : Colors.white,
                            border: Border.all(
                              width: 1,
                              color: Colors.black12,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
                          child: Text(
                            categoryType.desc ?? "",
                            style: TextStyle(
                              color: index == controller.selectedCategoryIdx ? Colors.white : Colors.black,
                              fontWeight: index == controller.selectedCategoryIdx ? FontWeight.w600 : FontWeight.w400,
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }),
              ),
            ),
            getVerSpace(FetchPixels.getPixelHeight(5)),
            sortFilter(context),
            // getDefaultTextFiledWithLabel2(
            //     context,
            //     controller.selectedBookListSortType.desc,
            //     const Color(0xFF666666),
            //     controller.bookListSortTextEditingController,
            //     const Color(0xFF666666),
            //     14,
            //     boxColor: backGroundColor,
            //     FontWeight.w500, function: () {
            //   controller.showBookListSortTypeBottomSheet(context);
            // },
            //     isEnable: false,
            //     withprefix: true,
            //     image: "sort.svg",
            //     minLines: true,
            //     height: FetchPixels.getPixelHeight(22),
            //     withSufix: false,
            //     // suffiximage: "sort.svg",
            //     enableEditing: false,
            //     textAlign: TextAlign.left),
            // getVerSpace(FetchPixels.getPixelHeight(10)),
            controller.loading
                ? const Expanded(child: ListSkeleton())
                : controller.bookList.length < 1
                    ? Expanded(child: getPaddingWidget(edgeInsets, nullListView(context)))
                    : Expanded(child: draw())
          ],
        ));
  }

  Widget sortFilter(BuildContext context) {
    return GestureDetector(
        onTap: () {
          showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => BookListSortTypeBottomSheet(bookListSortType: controller.selectedBookListSortType!))
              .then((sortType) {
            if (sortType != null) {
              controller.selectedBookListSortType = sortType;
              controller.initCache();
              onRefresh();
            }
          });
        },
        child: Container(
          color: Colors.white,
          // margin: EdgeInsets.symmetric(vertical: FetchPixels.getPixelWidth(10)),
          padding:
              EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(15), vertical: FetchPixels.getPixelWidth(10)),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              getSvgImage("sort.svg", height: FetchPixels.getPixelHeight(18), width: FetchPixels.getPixelHeight(18)),
              getHorSpace(FetchPixels.getPixelHeight(5)),
              getCustomFont(controller.selectedBookListSortType.desc, 12, Color(0xFF666666), 1,
                  fontWeight: FontWeight.w500),
            ],
          ),
        ));
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
    await FirebaseAnalytics.instance
        .logScreenView(screenName: "home_refreshBookList_screenName", screenClass: "home_refreshBookList_screenClass");

    await controller.getAllForPullToRefresh();
    initPageNumber(); //순서중요

    await Future.delayed(Duration(milliseconds: 500));

    refreshController.refreshCompleted();
  }

  void onLoading() async {
    await FirebaseAnalytics.instance.logScreenView(
      screenName: "home_onLoadingBooklist_${pageNumber}_screenName",
      screenClass: "home_onLoadingBooklist_${pageNumber}_screenName",
    );

    List<ModelBookResponse>? list = await controller.getAllForLoading(PagingRequest.create(pageNumber + 1));
    if (list != null && list.isNotEmpty) {
      plusPageNumber();
    }

    await Future.delayed(Duration(milliseconds: 500));
    refreshController.loadComplete();
  }

  void initPageNumber() {
    print("initPageNumber.... start...... ${controller.selectedCategoryType.code}");

    ///캐시된게 있으면 맨 마지막 number를 넣어야함
    if (controller.map.containsKey(controller.selectedCategoryType)) {
      // 1 12345 -1 01234 /5 = 0 +1 => 1
      // 2 678910 -1 56789 / 5 = 1 +1 => 2
      pageNumber = (controller.map[controller.selectedCategoryType]!.length - 1) ~/ PagingRequest.defaultPageSize + 1;
    } else {
      pageNumber = 1;
    }
    print("initPageNumber.... end...pageNumber...$pageNumber...${controller.selectedCategoryType.code}");
  }

  void plusPageNumber() {
    print("plusPageNumber.... start.....${controller.selectedCategoryType.code}");
    pageNumber++;
    print("plusPageNumber.... end...pageNumber...$pageNumber...${controller.selectedCategoryType.code}");
  }

  ListView buildBookList(List<ModelBookResponse> bookList, ModelMember member) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        // shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: bookList.length,
        itemBuilder: (context, index) {
          ModelBookResponse modelBookResponse = bookList[index];
          return buildBookListItem(modelBookResponse, context, index, () async {
            await FirebaseAnalytics.instance.logScreenView(
                screenName: "home_click_book_${modelBookResponse.modelBook.id}_screenName",
                screenClass: "home_click_book_${modelBookResponse.modelBook.id}_screenClass");

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
        getButton(context, backGroundColor, "책 제보 하러가기", Colors.black87, () async {
          await FirebaseAnalytics.instance.logScreenView(
              screenName: "home_recommendBook_screenName", screenClass: "home_recommendBook_screenClass");
          Get.toNamed(Routes.reportNewBookAddPath);
          // Get.toNamed("${Routes.communityAddPath}?postType=${postType.code}");
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
