import 'package:baby_book/app/data/data_file.dart';
import 'package:baby_book/app/models/model_country.dart';
import 'package:baby_book/base/pref_data.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:flutter/material.dart';
import '../../../base/color_data.dart';
import '../../../base/constant.dart';
import '../../../base/widget_utils.dart';

class SelectCountry extends StatefulWidget {
  const SelectCountry({Key? key}) : super(key: key);

  @override
  State<SelectCountry> createState() => _SelectCountryState();
}

class _SelectCountryState extends State<SelectCountry> {
  void finishView() {
    Constant.backToPrev(context);
  }

  TextEditingController searchController = TextEditingController();
  List<ModelCountry> newCountryList = List.from(DataFile.countryList);

  onItemChanged(String value) {
    setState(() {
      newCountryList =
          DataFile.countryList.where((string) => string.name!.toLowerCase().contains(value.toLowerCase())).toList();
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: backGroundColor,
          body: SafeArea(
            child: Column(
              children: [
                getVerSpace(FetchPixels.getPixelHeight(26)),
                buildCountryWidget(context),
                getVerSpace(FetchPixels.getPixelHeight(18)),
                // buildSearchWidget(context),
                getVerSpace(FetchPixels.getPixelHeight(30)),
                buildCountryList()
              ],
            ),
          ),
        ),
        onWillPop: () async {
          finishView();
          return false;
        });
  }

  // Widget buildSearchWidget(BuildContext context) {
  //   return getPaddingWidget(
  //     EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
  //     // getSearchWidget(context, searchController, () {}, onItemChanged,
  //     //     withPrefix: true),
  //   );
  // }

  Expanded buildCountryList() {
    return Expanded(
      flex: 1,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
        scrollDirection: Axis.vertical,
        itemCount: newCountryList.length,
        itemBuilder: (context, index) {
          ModelCountry modelCountry = newCountryList[index];
          return GestureDetector(
            onTap: () {
              PrefData.setDefCode(modelCountry.code ?? "");
              PrefData.setCountryName(newCountryList[index].image ?? "");

              finishView();
            },
            child: Container(
              margin: EdgeInsets.only(bottom: FetchPixels.getPixelHeight(20)),
              height: FetchPixels.getPixelHeight(56),
              padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(16)),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0.0, 4.0)),
                  ],
                  borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(15))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      getAssetImage(
                          modelCountry.image ?? '', FetchPixels.getPixelWidth(40), FetchPixels.getPixelHeight(28)),
                      getHorSpace(FetchPixels.getPixelWidth(12)),
                      getCustomFont(modelCountry.name ?? "", 14, Colors.black, 1, fontWeight: FontWeight.w900),
                    ],
                  ),
                  Row(
                    children: [
                      getCustomFont(
                        modelCountry.code ?? "",
                        14,
                        Colors.black,
                        1,
                        fontWeight: FontWeight.w900,
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildCountryWidget(BuildContext context) {
    return getPaddingWidget(
      EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
      gettoolbarMenu(context, "back.svg", () {
        finishView();
      }, istext: true, title: "Select Country", weight: FontWeight.w900, fontsize: 24, textColor: Colors.black),
    );
  }
}
