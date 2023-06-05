import 'package:baby_book/app/IsLoadingController.dart';
import 'package:baby_book/app/data/data_file.dart';
import 'package:baby_book/app/models/model_book.dart';
import 'package:baby_book/app/models/model_category.dart';
import 'package:baby_book/app/models/model_popular_service.dart';
import 'package:baby_book/app/repository/book_list_repository.dart';
import 'package:baby_book/app/routes/app_routes.dart';
import 'package:baby_book/app/view/home/age_agoup_bottom_sheet.dart';
import 'package:baby_book/base/book_list_utils.dart';
import 'package:baby_book/base/color_data.dart';
import 'package:baby_book/base/constant.dart';
import 'package:baby_book/base/pref_data.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:flutter/material.dart';

import '../../../../base/color_data.dart';
import '../../../../base/color_data.dart';
import '../../../../base/color_data.dart';
import '../../../exception/exception_invalid_member.dart';

class TabHome extends StatefulWidget {
  const TabHome({Key? key}) : super(key: key);

  @override
  State<TabHome> createState() => _TabHomeState();
}

class _TabHomeState extends State<TabHome> {
  List<ModelBook> bookLists = [
    ModelBook(),
    ModelBook(),
    ModelBook(),
    ModelBook(),
    ModelBook(),
    ModelBook(),
    ModelBook(),
    ModelBook(),
    ModelBook(),
    ModelBook()
  ];
  TextEditingController searchController = TextEditingController();
  static List<ModelCategory> categoryLists = DataFile.categoryList;
  List<ModelPopularService> popularServiceLists = DataFile.popularServiceList;
  ValueNotifier selectedPage = ValueNotifier(0);
  final _controller = PageController();
  int? ageGroupId;

  @override
  void initState() {
    super.initState();
    ageGroupId = 2;

    getBookList();
  }

  Future getBookList() async {
    IsLoadingController.to.isLoading = true;
    try {
      List<ModelBook> bookList = await BookListRepository.fetchData(
        categoryList: 'MATH,LIFE',
      );
      setState(() {
        bookLists = [];
        bookLists.addAll(bookList);
      });
      IsLoadingController.to.isLoading = false;
    } on InvalidMemberException {
      Constant.sendToNext(context, Routes.loginRoute);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets edgeInsets = EdgeInsets.symmetric(
      horizontal: FetchPixels.getDefaultHorSpace(context),
    );

    return Column(
      children: [
        getVerSpace(FetchPixels.getPixelHeight(21)),
        getPaddingWidget(
          EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // getSvgImage(
              //   "menu.svg",
              // ),
              Row(
                children: [
                  getHorSpace(FetchPixels.getPixelWidth(4)),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (_) => AgeGroupBottomSheet(ageGroupId: ageGroupId!)).then((selectedId) {
                        if (selectedId != null) {
                          setState(() {
                            ageGroupId = selectedId;
                          });
                        }
                      });
                    },
                    child: getCustomFont(
                      DataFile.ageGroupList[ageGroupId!].minAge.toString() +
                          " ~ " +
                          DataFile.ageGroupList[ageGroupId!].maxAge.toString() +
                          "개월 ν",
                      18,
                      Colors.black,
                      1,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Constant.sendToNext(context, Routes.searchRoute);
                    },
                    child: getSvgImage(
                      "search.svg",
                    ),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      Constant.sendToNext(context, Routes.notificationRoutes);
                    },
                    child: getSvgImage(
                      "notification.svg",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // getVerSpace(FetchPixels.getPixelHeight(10)),
        // getPaddingWidget(
        //     EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
        //     getSearchWidget(context, searchController, () {
        //       Constant.sendToNext(context, Routes.searchRoute);
        //     }, (value) {})),
        getVerSpace(FetchPixels.getPixelHeight(20)),
        Expanded(
          child: ListView(
            primary: true,
            shrinkWrap: true,
            children: [
              SizedBox(
                height: FetchPixels.getPixelHeight(40),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  primary: false,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    ModelCategory modelCategory = categoryLists[index];
                    return GestureDetector(
                      onTap: () {
                        PrefData.setDefIndex(1);
                        Constant.sendToNext(context, Routes.detailRoute);
                      },
                      child: Container(
                        width: FetchPixels.getPixelWidth(91),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                color: Color(0xFFE0E0E0),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15.0),
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
                              child: Text(modelCategory.name ?? ""),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                color: backGroundColor,
                child: bookLists.isEmpty ? getPaddingWidget(edgeInsets, nullListView(context)) : allBookingList(),
              ),
            ],
          ),
        )
      ],
    );
  }

  ListView allBookingList() {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: bookLists.length,
      itemBuilder: (context, index) {
        ModelBook modelBook = bookLists[index];
        return buildBookListItem(modelBook, context, index, () {
          Constant.sendToNext(context, Routes.bookingRoute, arguments: {'modelBook': modelBook});
        });
      },
    );
  }

  Column nullListView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        getVerSpace(FetchPixels.getPixelHeight(40)),
        getCustomFont("조건에 해당하는 책이 없습니다!", 20, Colors.black, 1, fontWeight: FontWeight.w900),
        getVerSpace(FetchPixels.getPixelHeight(25)),
        getButton(context, backGroundColor, "책 등록 요청하기", blueColor, () {}, 18,
            weight: FontWeight.w600,
            buttonHeight: FetchPixels.getPixelHeight(60),
            insetsGeometry: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(106)),
            borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(14)),
            isBorder: true,
            borderColor: blueColor,
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
            controller: _controller,
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
