import 'package:baby_book/app/models/model_book_response.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/model_book.dart';
import '../../../../base/color_data.dart';

var f = NumberFormat('###,###,###,###');

GestureDetector buildBookListItem(
    ModelBookResponse modelBookResponse, BuildContext context, int index, Function function) {
  return GestureDetector(
    onTap: () {
      function();
    },
    child: Container(
      height: FetchPixels.getPixelHeight(100),
      margin: EdgeInsets.only(bottom: FetchPixels.getPixelHeight(1)),
      padding:
          EdgeInsets.symmetric(vertical: FetchPixels.getPixelHeight(12), horizontal: FetchPixels.getPixelWidth(20)),
      decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Color(0xFFEDEBE8), blurRadius: 3, offset: Offset(0.0, 1.0)),
          ],
          borderRadius: BorderRadius.zero),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                getCustomFont((index + 1).toString(), 18, Colors.black, 1, fontWeight: FontWeight.w500),
                getHorSpace(FetchPixels.getPixelWidth(20)),
                Container(
                    // width: FetchPixels.getPixelHeight(80),
                    // height: FetchPixels.getPixelHeight(80),
                    child: FadeInImage(
                  fit: BoxFit.fitHeight,
                  width: FetchPixels.getPixelHeight(80),
                  height: FetchPixels.getPixelHeight(80),
                  image: NetworkImage(modelBookResponse.getFirstImg()),
                  placeholder: AssetImage(modelBookResponse.getPlaceHolderImg()),
                )),
                getHorSpace(FetchPixels.getPixelWidth(20)),
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
                      // getCustomFont(modelBookResponse.getCategoryType().desc ?? "", 12,
                      //     modelBookResponse.getCategoryType().color, 1,
                      //     fontWeight: FontWeight.w400),
                      // getVerSpace(FetchPixels.getPixelHeight(10)),
                      getCustomFont(modelBookResponse.modelBook.name ?? "", 18, Colors.black, 1,
                          fontWeight: FontWeight.w500),
                      getVerSpace(FetchPixels.getPixelHeight(10)),
                      getCustomFont(
                        modelBookResponse.modelPublisher.publisherName,
                        14,
                        textColor,
                        1,
                        fontWeight: FontWeight.w400,
                      ),
                      getVerSpace(FetchPixels.getPixelHeight(10)),
                      getCustomFont(
                        "${f.format(modelBookResponse.modelBook.amount ?? 0)} 원",
                        14,
                        Colors.black87,
                        1,
                        fontWeight: FontWeight.w600,
                      ),
                      Expanded(
                        flex: 1,
                        child: getHorSpace(0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
