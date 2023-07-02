import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/model_book.dart';
import '../../../../base/color_data.dart';

var f = NumberFormat('###,###,###,###');

GestureDetector buildBookListItem(ModelBook modelBook, BuildContext context, int index, Function function) {
  return GestureDetector(
    onTap: () {
      function();
    },
    child: Container(
      height: FetchPixels.getPixelHeight(100),
      margin: EdgeInsets.only(
        bottom: FetchPixels.getPixelHeight(5),
        left: FetchPixels.getPixelHeight(5),
        right: FetchPixels.getPixelHeight(5),
        // right: FetchPixels.getDefaultHorSpace(context)
      ),
      padding: EdgeInsets.symmetric(vertical: FetchPixels.getPixelHeight(2), horizontal: FetchPixels.getPixelWidth(15)),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 3, offset: Offset(0.0, 2.0)),
          ],
          borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(5))),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  height: FetchPixels.getPixelHeight(70),
                  width: FetchPixels.getPixelHeight(70),
                  decoration: BoxDecoration(
                    image: getDecorationAssetImage(context, modelBook.logo ?? "grgr2.png", fit: BoxFit.cover),
                  ),
                ),
                getHorSpace(FetchPixels.getPixelWidth(16)),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: getHorSpace(0),
                      ),
                      getCustomFont(modelBook.name ?? "", 13, Colors.black, 1, fontWeight: FontWeight.w900),
                      getVerSpace(FetchPixels.getPixelHeight(2)),
                      getCustomFont(
                        modelBook.publisherName ?? "그레이트북스",
                        12,
                        textColor,
                        1,
                        fontWeight: FontWeight.w400,
                      ),
                      getVerSpace(FetchPixels.getPixelHeight(5)),
                      Row(
                        children: [
                          getSvgImage("star.svg",
                              height: FetchPixels.getPixelHeight(12), width: FetchPixels.getPixelHeight(12)),
                          getHorSpace(FetchPixels.getPixelWidth(6)),
                          getCustomFont(modelBook.reviewScore ?? "", 12, Colors.black, 1, fontWeight: FontWeight.w400),
                        ],
                      ),
                      Expanded(
                        flex: 1,
                        child: getHorSpace(0),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // GestureDetector(
                    //   onTap: () {
                    //     funDelete();
                    //   },
                    //   child: getSvgImage("trash.svg",
                    //       width: FetchPixels.getPixelHeight(20),
                    //       height: FetchPixels.getPixelHeight(20)),
                    // ),
                    getPaddingWidget(
                        EdgeInsets.only(bottom: FetchPixels.getPixelHeight(10)),
                        getCustomFont(
                          "${f.format(modelBook.amount ?? 0)} 원",
                          12,
                          Colors.grey,
                          1,
                          fontWeight: FontWeight.w900,
                        )),
                    // Row(
                    //   children: [
                    //     getSvgImage("star.svg",
                    //         height: FetchPixels.getPixelHeight(16),
                    //         width: FetchPixels.getPixelHeight(16)),
                    //     getHorSpace(FetchPixels.getPixelWidth(6)),
                    //     getCustomFont(
                    //         modelBooking.rating ?? "", 14, Colors.black, 1,
                    //         fontWeight: FontWeight.w400),
                    //   ],
                    // )
                  ],
                )
              ],
            ),
          ),
          // getVerSpace(FetchPixels.getPixelHeight(16)),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: [
          //     Row(
          //       children: [
          //         getAssetImage("dot.png", FetchPixels.getPixelHeight(8),
          //             FetchPixels.getPixelHeight(8)),
          //         getHorSpace(FetchPixels.getPixelWidth(8)),
          //         getCustomFont(modelBooking.owner ?? "", 14, textColor, 1,
          //             fontWeight: FontWeight.w400),
          //       ],
          //     ),
          //     Wrap(
          //       children: [
          //         getButton(
          //             context,
          //             Color(modelBooking.bgColor!.toInt()),
          //             modelBooking.tag ?? "",
          //             modelBooking.textColor!,
          //             () {},
          //             16,
          //             weight: FontWeight.w600,
          //             borderRadius:
          //                 BorderRadius.circular(FetchPixels.getPixelHeight(37)),
          //             insetsGeometrypadding: EdgeInsets.symmetric(
          //                 vertical: FetchPixels.getPixelHeight(6),
          //                 horizontal: FetchPixels.getPixelWidth(12)))
          //       ],
          //     )
          //   ],
          // )
        ],
      ),
    ),
  );
}
