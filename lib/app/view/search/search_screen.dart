import 'package:baby_book/app/data/data_file.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:flutter/material.dart';

import '../../../base/color_data.dart';
import '../../../base/constant.dart';
import '../../../base/widget_utils.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  List<String> searchLists = DataFile.searchList;
  List<String> popularSearchLists = DataFile.popularSearchList;
  int? select;

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: backGroundColor,
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: FetchPixels.getPixelWidth(20)),
              child: Column(
                children: [
                  getVerSpace(FetchPixels.getPixelHeight(20)),
                  gettoolbarMenu(context, "back.svg", () {
                    Constant.backToPrev(context);
                  },
                      istext: true,
                      title: "Search",
                      weight: FontWeight.w900,
                      fontsize: 24,
                      textColor: Colors.black),
                  getVerSpace(FetchPixels.getPixelHeight(30)),
                  getTopSearchWidget(context),
                  (searchLists.isEmpty)
                      ? getEmptyWidget(context)
                      : getSearchList()
                ],
              ),
            ),
          ),
        ),
        onWillPop: () async {
          Constant.backToPrev(context);
          return false;
        });
  }

  Expanded getSearchList() {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getVerSpace(FetchPixels.getPixelHeight(21)),
          ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: searchLists.length,
            primary: true,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(bottom: FetchPixels.getPixelHeight(20)),
                child: Row(
                  children: [
                    getSvgImage("refresh.svg",
                        height: FetchPixels.getPixelHeight(24),
                        width: FetchPixels.getPixelHeight(24)),
                    getHorSpace(FetchPixels.getPixelWidth(10)),
                    getCustomFont(searchLists[index], 16, Colors.black, 1,
                        fontWeight: FontWeight.w400)
                  ],
                ),
              );
            },
          ),
          getDivider(dividerColor, 0, 1),
          getVerSpace(FetchPixels.getPixelHeight(20)),
          getCustomFont(
            "Popular Searches",
            16,
            Colors.black,
            1,
            fontWeight: FontWeight.w900,
          ),
          getVerSpace(FetchPixels.getPixelHeight(20)),
          Wrap(
            children: [
              for (final i
                  in List.generate(popularSearchLists.length, (i) => i))
                getPaddingWidget(
                  EdgeInsets.only(
                      right: FetchPixels.getPixelWidth(11),
                      bottom: FetchPixels.getPixelHeight(10)),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        select = i;
                        searchController.text = popularSearchLists[i];
                      });
                    },
                    child: Container(
                      height: FetchPixels.getPixelHeight(38),
                      decoration: BoxDecoration(
                          color: select == i ? blueColor : backGroundColor,
                          borderRadius: BorderRadius.circular(
                              FetchPixels.getPixelHeight(12)),
                          border: select == i
                              ? null
                              : Border.all(
                                  color: const Color(0xFFDEE0E6), width: 1)),
                      child: Chip(
                        padding: EdgeInsets.symmetric(
                            vertical: FetchPixels.getPixelHeight(7)),
                        backgroundColor:
                            select == i ? blueColor : Colors.transparent,
                        label: Container(
                          child: getCustomFont(popularSearchLists[i], 16,
                              select == i ? Colors.white : Colors.black, 1,
                              fontWeight: FontWeight.w400),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              FetchPixels.getPixelHeight(12)),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }

  Expanded getEmptyWidget(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: FetchPixels.getPixelHeight(108),
            width: FetchPixels.getPixelHeight(108),
            decoration: BoxDecoration(
              image: getDecorationAssetImage(context, "search_screen.png"),
            ),
          ),
          getVerSpace(FetchPixels.getPixelHeight(40)),
          getCustomFont("No Searches", 22, Colors.black, 1,
              fontWeight: FontWeight.w900, textAlign: TextAlign.center),
          getVerSpace(FetchPixels.getPixelHeight(10)),
          getCustomFont("You have no recent searches.", 16, Colors.black, 1,
              fontWeight: FontWeight.w400, textAlign: TextAlign.center)
        ],
      ),
    );
  }

  Widget getTopSearchWidget(BuildContext context) {
    return getSearchWidget(context, searchController, () {}, (value) {},
        onSubmit: (submit) {
      if (!searchLists.contains(submit)) {
        searchLists.add(submit);
      }
    });
  }
}
