import 'package:baby_book/app/data/data_file.dart';
import 'package:baby_book/app/models/model_age_group.dart';
import 'package:baby_book/app/models/model_book.dart';
import 'package:baby_book/app/models/model_category.dart';
import 'package:baby_book/app/models/model_popular_service.dart';
import 'package:baby_book/app/repository/book_list_repository.dart';

import 'package:baby_book/app/view/home/book/age_group_bottom_sheet.dart';
import 'package:baby_book/app/view/home/book/book_list.dart';
import 'package:baby_book/app/view/home/book/category_type.dart';
import 'package:baby_book/base/color_data.dart';
import 'package:baby_book/base/pref_data.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../../base/skeleton.dart';
import '../../../../base/widget_utils.dart';
import '../../../controller/TabHomeController.dart';
import '../../../models/model_book_response.dart';
import '../../../routes/app_pages.dart';

class TabHome extends GetView<TabHomeController> {
  TextEditingController searchController = TextEditingController();
  List<CategoryType> categoryLists = CategoryType.findListViewList();
  List<ModelPopularService> popularServiceLists = DataFile.popularServiceList;
  ValueNotifier selectedPage = ValueNotifier(0);
  final _pageController = PageController();

  TabHome({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(TabHomeController(0, bookListRepository: BookListRepository()));
    controller.getBookList();

    EdgeInsets edgeInsets = EdgeInsets.symmetric(
      horizontal: FetchPixels.getDefaultHorSpace(context),
    );

    return Obx(() => Column(
          children: [
            getVerSpace(FetchPixels.getPixelHeight(10)),
            getPaddingWidget(
              EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(10)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      width: FetchPixels.getPixelWidth(165),
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
                            .then((selectedAgeGroup) {
                          if (selectedAgeGroup != null) {
                            controller.selectedAgeGroupId = selectedAgeGroup.groupId;
                            controller.getBookList();
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
                  const Row(
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
                      // getSimpleImageButton("search.svg", FetchPixels.getPixelHeight(50), FetchPixels.getPixelHeight(50),
                      //     Colors.white, FetchPixels.getPixelHeight(26), FetchPixels.getPixelHeight(26), () {
                      //   Get.toNamed(Routes.searchPath);
                      // }),
                    ],
                  ),
                ],
              ),
            ),
            getVerSpace(FetchPixels.getPixelHeight(10)),
            SizedBox(
              height: FetchPixels.getPixelHeight(40),
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
                      controller.selectedCategoryIdx = index;
                      controller.selectedCategoryType = categoryType;
                      controller.getBookList();
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
            getVerSpace(FetchPixels.getPixelHeight(10)),
            controller.loading
                ? const Expanded(child: ListSkeleton())
                : controller.bookList.length < 1
                    ? Expanded(child: getPaddingWidget(edgeInsets, nullListView(context)))
                    : allBookingList(controller.bookList)
          ],
        ));
  }

  Expanded allBookingList(List<ModelBookResponse> bookList) {
    return Expanded(
        child: ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: bookList.length,
      itemBuilder: (context, index) {
        ModelBook modelBook = bookList[index].modelBook;
        return buildBookListItem(modelBook, context, index, () {
          Get.toNamed(Routes.bookingPath, arguments: {'modelBook': modelBook});
        });
      },
    ));
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
          Colors.black,
          1,
          fontWeight: FontWeight.w400,
        ),
        getVerSpace(FetchPixels.getPixelHeight(30)),
        getButton(context, backGroundColor, "책 추천 하러가기", Colors.black87, () {
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

  Column pageView() {
    return Column(
      children: [
        SizedBox(
          height: FetchPixels.getPixelHeight(184),
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (value) {
              selectedPage.value = value;
            },
            itemCount: 3,
            itemBuilder: (context, index) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: FetchPixels.getPixelWidth(374),
                    decoration: BoxDecoration(
                        color: const Color(0xFFD0DDFF),
                        borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(20)),
                        image: getDecorationAssetImage(context, "maskgroup.png", fit: BoxFit.fill)),
                    alignment: Alignment.center,
                  ),
                  Positioned(
                      child: SizedBox(
                    height: FetchPixels.getPixelHeight(180),
                    width: FetchPixels.getPixelWidth(374),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        getPaddingWidget(
                          EdgeInsets.only(
                              left: FetchPixels.getPixelWidth(20),
                              top: FetchPixels.getPixelHeight(20),
                              bottom: FetchPixels.getPixelHeight(20)),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                  width: FetchPixels.getPixelHeight(130),
                                  child: getMultilineCustomFont("Wall Painting Service", 20, Colors.black,
                                      fontWeight: FontWeight.w900, txtHeight: 1.3)),
                              // getVerSpace(FetchPixels.getPixelHeight(6)),
                              getCustomFont(
                                "Make your wall stylish",
                                14,
                                Colors.black,
                                1,
                                fontWeight: FontWeight.w400,
                              ),
                              // getVerSpace(FetchPixels.getPixelHeight(16)),
                              getButton(context, blueColor, "Book Now", Colors.white, () {}, 14,
                                  weight: FontWeight.w600,
                                  buttonWidth: FetchPixels.getPixelWidth(108),
                                  borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(12)),
                                  insetsGeometrypadding:
                                      EdgeInsets.symmetric(vertical: FetchPixels.getPixelHeight(12))),
                            ],
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(right: FetchPixels.getPixelWidth(21)),
                            height: FetchPixels.getPixelHeight(175),
                            width: FetchPixels.getPixelHeight(142),
                            color: Colors.transparent,
                            child: getAssetImage(
                                "washer.png", FetchPixels.getPixelHeight(142), FetchPixels.getPixelHeight(175)))
                      ],
                    ),
                  ))
                ],
              );
            },
          ),
        ),
        getVerSpace(FetchPixels.getPixelHeight(14)),
        ValueListenableBuilder(
          valueListenable: selectedPage,
          builder: (context, value, child) {
            return Container(
              height: FetchPixels.getPixelHeight(8),
              width: FetchPixels.getPixelWidth(44),
              alignment: Alignment.center,
              child: ListView.builder(
                itemCount: 3,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return getPaddingWidget(
                    EdgeInsets.only(right: FetchPixels.getPixelWidth(10)),
                    getAssetImage(
                      "dot.png",
                      FetchPixels.getPixelHeight(8),
                      FetchPixels.getPixelHeight(8),
                      color: selectedPage.value == index ? blueColor : blueColor.withOpacity(0.2),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
