import 'package:baby_book/app/models/model_book_response.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
                SizedBox(
                    width: FetchPixels.getPixelWidth(35),
                    child: Center(
                        child:
                            getCustomFont((index + 1).toString(), 18, Colors.black, 1, fontWeight: FontWeight.w500))),
                getHorSpace(FetchPixels.getPixelWidth(20)),
                ExtendedImage.network(
                  modelBookResponse.getFirstImg(),
                  width: FetchPixels.getPixelHeight(80),
                  height: FetchPixels.getPixelHeight(80),
                  fit: BoxFit.fitHeight,
                  cache: true,
                  loadStateChanged: (ExtendedImageState state) {
                    switch (state.extendedImageLoadState) {
                      case LoadState.loading:
                        return Image.asset(modelBookResponse.getPlaceHolderImg(), fit: BoxFit.fill);
                      case LoadState.completed:
                        break;
                      case LoadState.failed:
                        return Image.asset(modelBookResponse.getPlaceHolderImg(), fit: BoxFit.fill);
                    }
                  },
                ),
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
