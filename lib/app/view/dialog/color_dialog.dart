import 'package:baby_book/app/data/data_file.dart';
import 'package:baby_book/app/models/model_color.dart';
import 'package:baby_book/app/routes/app_routes.dart';
import 'package:baby_book/base/constant.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:flutter/material.dart';

import '../../../base/color_data.dart';
import '../../../base/widget_utils.dart';
import '../../models/model_cart.dart';

class ColorDialog extends StatefulWidget {
  const ColorDialog({Key? key}) : super(key: key);

  @override
  State<ColorDialog> createState() => _ColorDialogState();
}

class _ColorDialogState extends State<ColorDialog> {
  var total = 0.00;
  static List<ModelColor> hairColorLists = DataFile.hairColorList;

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
                    getCustomFont("Hair Color", 20, Colors.black, 1,
                         fontWeight: FontWeight.w900),
                    GestureDetector(
                        onTap: () {
                          Constant.backToPrev(context);
                        },
                        child: getSvgImage("close.svg",
                            height: FetchPixels.getPixelHeight(24),
                            width: FetchPixels.getPixelHeight(24)))
                  ],
                ),
                getVerSpace(FetchPixels.getPixelHeight(20)),
                colorList(),
                getVerSpace(FetchPixels.getPixelHeight(10)),
                totalContainer(),
                doneButton(context),
                getVerSpace(FetchPixels.getPixelHeight(30))
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget doneButton(BuildContext context) {
    return getButton(context, blueColor, "Done", Colors.white, () {
      Constant.backToPrev(context);
      Constant.sendToNext(context, Routes.cartRoute);
    }, 18,
        weight: FontWeight.w600,
        buttonHeight: FetchPixels.getPixelHeight(60),
        borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(14)));
  }

  Container totalContainer() {
    return Container(
      child: total == 0.00
          ? Container()
          : Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    getCustomFont("Total", 24, Colors.black, 1,
                         fontWeight: FontWeight.w900),
                    getCustomFont("\$$total", 24, Colors.black, 1,
                        fontWeight: FontWeight.w900, )
                  ],
                ),
                getVerSpace(FetchPixels.getPixelHeight(30)),
              ],
            ),
    );
  }

  ListView colorList() {
    return ListView.builder(
      shrinkWrap: true,
      primary: true,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.zero,
      scrollDirection: Axis.vertical,
      itemCount: hairColorLists.length,
      itemBuilder: (context, index) {
        ModelColor modelColor = hairColorLists[index];
        return Container(
          margin: EdgeInsets.only(bottom: FetchPixels.getPixelHeight(20)),
          width: FetchPixels.getPixelWidth(374),
          padding: EdgeInsets.only(
              left: FetchPixels.getPixelWidth(16),
              right: FetchPixels.getPixelWidth(16),
              top: FetchPixels.getPixelHeight(16),
              bottom: FetchPixels.getPixelHeight(16)),
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
          child: Row(
            children: [
              Container(
                height: FetchPixels.getPixelHeight(104),
                width: FetchPixels.getPixelHeight(104),
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(FetchPixels.getPixelHeight(10)),
                    image: getDecorationAssetImage(
                        context, modelColor.image ?? "")),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: FetchPixels.getPixelWidth(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getCustomFont(modelColor.name ?? '', 16, Colors.black, 1,
                          fontWeight: FontWeight.w900, ),
                      getVerSpace(FetchPixels.getPixelHeight(4)),
                      getCustomFont(
                          modelColor.productName ?? "", 14, textColor, 1,
                           fontWeight: FontWeight.w400),
                      getVerSpace(FetchPixels.getPixelHeight(6)),
                      Row(
                        children: [
                          getSvgImage("star.svg",
                              height: FetchPixels.getPixelHeight(16),
                              width: FetchPixels.getPixelHeight(16)),
                          getHorSpace(FetchPixels.getPixelWidth(6)),
                          getCustomFont(
                              modelColor.rating ?? "", 14, Colors.black, 1,
                              fontWeight: FontWeight.w400,
                             )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (modelColor.quantity == 0)
                    getButton(context, Colors.transparent, "Add", blueColor,
                        () {
                      modelColor.quantity = (modelColor.quantity! + 1);
                      total = total + (modelColor.price! * 1);
                      DataFile.cartList[index.toString()] = ModelCart(
                          modelColor.image,
                          modelColor.name,
                          modelColor.productName,
                          modelColor.rating,
                          modelColor.price,
                          modelColor.quantity);

                      setState(() {});
                    }, 14,
                        weight: FontWeight.w600,
                        insetsGeometrypadding: EdgeInsets.symmetric(
                            horizontal: FetchPixels.getPixelWidth(20),
                            vertical: FetchPixels.getPixelHeight(12)),
                        borderColor: blueColor,
                        borderWidth: 1.5,
                        isBorder: true,
                        borderRadius: BorderRadius.circular(
                            FetchPixels.getPixelHeight(10)))
                  else
                    Row(
                      children: [
                        GestureDetector(
                          child: getSvgImage("add1.svg",
                              width: FetchPixels.getPixelHeight(30),
                              height: FetchPixels.getPixelHeight(30)),
                          onTap: () {
                            modelColor.quantity = (modelColor.quantity! + 1);
                            total = total + (modelColor.price! * 1);
                            DataFile.cartList[index.toString()]!.quantity =
                                modelColor.quantity;
                            setState(() {});
                          },
                        ),
                        getHorSpace(FetchPixels.getPixelWidth(10)),
                        getCustomFont(modelColor.quantity.toString(), 14,
                            Colors.black, 1,
                            fontWeight: FontWeight.w400,
                            ),
                        getHorSpace(FetchPixels.getPixelWidth(10)),
                        GestureDetector(
                          child: getSvgImage("minus.svg",
                              width: FetchPixels.getPixelHeight(30),
                              height: FetchPixels.getPixelHeight(30)),
                          onTap: () {
                            modelColor.quantity = (modelColor.quantity! - 1);
                            total = total - (modelColor.price! * 1);
                            if (modelColor.quantity! > 0) {
                              DataFile.cartList[index.toString()]!.quantity =
                                  modelColor.quantity;
                            } else {
                              DataFile.cartList.remove(index.toString());
                            }
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  getVerSpace(FetchPixels.getPixelHeight(40)),
                  getCustomFont("\$${modelColor.price}", 16, blueColor, 1,
                       fontWeight: FontWeight.w900)
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
