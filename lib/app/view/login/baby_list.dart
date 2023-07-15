import 'package:baby_book/app/models/model_baby.dart';
import 'package:baby_book/app/view/login/gender_type.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../base/color_data.dart';

var f = NumberFormat('###,###,###,###');
var order = ["첫째", "둘째", "셋째", "넷째"];

GestureDetector buildBabyListItem(
  ModelBaby modelBaby,
  BuildContext context,
  int index,
  int representBabyIndex,
  Function changeRepresentBabyIndex,
  Function openModifyBabyDialogFunction,
  Function deleteFunction,
) {
  return GestureDetector(
    onTap: () {
      changeRepresentBabyIndex(index);
    },
    child: Container(
      height: FetchPixels.getPixelHeight(60),
      margin: EdgeInsets.only(bottom: FetchPixels.getPixelHeight(1)),
      padding:
          EdgeInsets.symmetric(vertical: FetchPixels.getPixelHeight(12), horizontal: FetchPixels.getPixelWidth(15)),
      decoration: BoxDecoration(
          color: index == representBabyIndex ? Colors.grey.shade100 : Colors.white,
          boxShadow: [
            BoxShadow(color: Color(0xFFEDEBE8), blurRadius: 3, offset: Offset(0.0, 1.0)),
          ],
          borderRadius: BorderRadius.zero),
      child: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Row(children: [
                  SizedBox(
                      width: FetchPixels.getPixelWidth(35),
                      child: index == representBabyIndex
                          ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                              getCustomFont("대표", 14, secondMainColor, 1, fontWeight: FontWeight.w600),
                              getVerSpace(FetchPixels.getPixelWidth(5)),
                              getCustomFont(index < 4 ? order[index] : "${index + 1}", 14, Colors.black38, 1,
                                  fontWeight: FontWeight.w400)
                            ])
                          : Center(
                              child: getCustomFont(index < 4 ? order[index] : "${index + 1}", 14, Colors.black38, 1,
                                  fontWeight: FontWeight.w400))),
                  getHorSpace(FetchPixels.getPixelWidth(10)),
                  getAssetImage(modelBaby.gender == GenderType.man ? "baby_bear.png" : "baby_bear_woman.png",
                      FetchPixels.getPixelWidth(40), FetchPixels.getPixelWidth(40)),
                  getHorSpace(FetchPixels.getPixelWidth(15)),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: getHorSpace(0),
                        ),
                        Row(children: [
                          Expanded(
                              child: getCustomFont(modelBaby.name ?? "", 14, Colors.black, 1,
                                  fontWeight: FontWeight.w500)),
                          Expanded(
                            flex: 1,
                            child: getHorSpace(0),
                          ),
                        ]),
                        getVerSpace(FetchPixels.getPixelHeight(5)),
                        getCustomFont(
                          modelBaby.getBirthdayToString(),
                          12,
                          Colors.black38,
                          1,
                          fontWeight: FontWeight.w400,
                        ),
                        Expanded(
                          flex: 1,
                          child: getHorSpace(0),
                        ),
                      ],
                    ),
                  ),
                ])),
                getSimpleTextButton(
                    "수정",
                    14,
                    Colors.black54,
                    index == representBabyIndex ? Colors.grey.shade100 : Colors.white,
                    FontWeight.w400,
                    FetchPixels.getPixelWidth(50),
                    FetchPixels.getPixelHeight(30), () {
                  openModifyBabyDialogFunction(index);
                }),
                getSimpleTextButton(
                    "삭제",
                    14,
                    Colors.black54,
                    index == representBabyIndex ? Colors.grey.shade100 : Colors.white,
                    FontWeight.w400,
                    FetchPixels.getPixelWidth(50),
                    FetchPixels.getPixelHeight(30), () {
                  deleteFunction(index);
                }),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
