import 'package:flutter/material.dart';
import 'package:baby_book/app/data/data_file.dart';
import 'package:baby_book/app/models/model_category.dart';
import 'package:baby_book/base/constant.dart';
import 'package:baby_book/base/device_util.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:get/get.dart';

import '../../../base/color_data.dart';
import '../../routes/app_pages.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  static List<ModelCategory> categoryLists = DataFile.categoryList;

  var noOfGrid = 3;

  @override
  Widget build(BuildContext context) {
    if (DeviceUtil.isTablet) {
      noOfGrid = 5;
    }
    FetchPixels(context);
    double setVal = FetchPixels.getDefaultHorSpace(context);
    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: backGroundColor,
          body: SafeArea(
            child: Column(
              children: [
                getVerSpace(FetchPixels.getPixelHeight(20)),
                getPaddingWidget(
                    EdgeInsets.symmetric(horizontal: setVal),
                    gettoolbarMenu(context, "back.svg", () {
                      Constant.backToPrev(context);
                    },
                        istext: true,
                        title: "Categories",
                        fontsize: 24,
                        weight: FontWeight.w900,
                        textColor: Colors.black)),
                getVerSpace(FetchPixels.getPixelHeight(32)),
                Expanded(child: categoryView())
              ],
            ),
          ),
        ),
        onWillPop: () async {
          Constant.backToPrev(context);
          return false;
        });
  }

  categoryView() {
    return Container(
      child: GridView.builder(
        itemCount: categoryLists.length,
        padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: noOfGrid,
            crossAxisSpacing: FetchPixels.getPixelWidth(19),
            mainAxisSpacing: FetchPixels.getPixelHeight(20),
            mainAxisExtent: FetchPixels.getPixelHeight(121)),
        itemBuilder: (BuildContext context, int index) {
          ModelCategory modelCategory = categoryLists[index];
          return GestureDetector(
            onTap: () {
              Get.toNamed(Routes.detailPath);
            },
            child: Container(
              padding: EdgeInsets.only(top: FetchPixels.getPixelHeight(24), bottom: FetchPixels.getPixelHeight(16)),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0.0, 4.0)),
                  ],
                  borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(12))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // getSvgImage(modelCategory.image ?? "",
                  //     width: FetchPixels.getPixelHeight(44),
                  //     height: FetchPixels.getPixelHeight(44)),
                  // getVerSpace(FetchPixels.getPixelHeight(15)),
                  getCustomFont(modelCategory.name ?? '', 14, Colors.black, 1, fontWeight: FontWeight.w400)
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
