import 'package:baby_book/app/routes/app_routes.dart';
import 'package:baby_book/base/color_data.dart';
import 'package:baby_book/base/constant.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:flutter/material.dart';

class CategoryDialog extends StatefulWidget {
  const CategoryDialog({Key? key}) : super(key: key);

  @override
  State<CategoryDialog> createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<CategoryDialog> {
  int select = 1;

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return Wrap(
      children: [
        Container(
          child: getPaddingWidget(
            EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
            Column(
              children: [
                getVerSpace(FetchPixels.getPixelHeight(34)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    getCustomFont("Salon for", 20, Colors.black, 1,
                        fontWeight: FontWeight.w900, ),
                    GestureDetector(
                      onTap: () {
                        Constant.backToPrev(context);
                      },
                      child: getSvgImage("close.svg",
                          height: FetchPixels.getPixelHeight(24),
                          width: FetchPixels.getPixelHeight(24)),
                    )
                  ],
                ),
                getVerSpace(FetchPixels.getPixelHeight(20)),
                Row(
                  children: [
                    menSection(),
                    getHorSpace(FetchPixels.getPixelWidth(20)),
                    womenSection(),
                  ],
                ),
                getVerSpace(FetchPixels.getPixelHeight(29)),
                continueButton(context),
                getVerSpace(FetchPixels.getPixelHeight(30))
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget continueButton(BuildContext context) {
    return getButton(context, blueColor, "Continue", Colors.white, () {
      Constant.backToPrev(context);
      Constant.sendToNext(context, Routes.detailRoute);
    }, 18,
        weight: FontWeight.w600,
        buttonHeight: FetchPixels.getPixelHeight(60),
        borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(14)));
  }

  Expanded womenSection() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0.0, 4.0)),
            ],
            borderRadius:
                BorderRadius.circular(FetchPixels.getPixelHeight(12))),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            GestureDetector(
              onTap: () {
                select = 2;
                setState(() {});
              },
              child: Container(
                padding: EdgeInsets.only(
                    top: FetchPixels.getPixelHeight(30),
                    bottom: FetchPixels.getPixelHeight(27)),
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    getSvgImage("woman.svg",
                        width: FetchPixels.getPixelHeight(80),
                        height: FetchPixels.getPixelHeight(80)),
                    getVerSpace(FetchPixels.getPixelHeight(20)),
                    getCustomFont("Women", 16, Colors.black, 1,
                         fontWeight: FontWeight.w900)
                  ],
                ),
              ),
            ),
            Positioned(
                child: getPaddingWidget(
              EdgeInsets.only(
                  right: FetchPixels.getPixelHeight(12),
                  top: FetchPixels.getPixelHeight(12)),
              Container(
                child: getSvgImage(
                    select == 2 ? "selected.svg" : "unselected.svg",
                    height: FetchPixels.getPixelHeight(24),
                    width: FetchPixels.getPixelHeight(24)),
              ),
            ))
          ],
        ),
      ),
    );
  }

  Expanded menSection() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0.0, 4.0)),
            ],
            borderRadius:
                BorderRadius.circular(FetchPixels.getPixelHeight(12))),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            GestureDetector(
              onTap: () {
                select = 1;
                setState(() {});
              },
              child: Container(
                padding: EdgeInsets.only(
                    top: FetchPixels.getPixelHeight(30),
                    bottom: FetchPixels.getPixelHeight(27)),
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    getSvgImage("man.svg",
                        width: FetchPixels.getPixelHeight(80),
                        height: FetchPixels.getPixelHeight(80)),
                    getVerSpace(FetchPixels.getPixelHeight(20)),
                    getCustomFont("Men", 16, Colors.black, 1,
                         fontWeight: FontWeight.w900)
                  ],
                ),
              ),
            ),
            Positioned(
                child: getPaddingWidget(
              EdgeInsets.only(
                  right: FetchPixels.getPixelHeight(12),
                  top: FetchPixels.getPixelHeight(12)),
              Container(
                child: getSvgImage(
                    select == 1 ? "selected.svg" : "unselected.svg",
                    height: FetchPixels.getPixelHeight(24),
                    width: FetchPixels.getPixelHeight(24)),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
