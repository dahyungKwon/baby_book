import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

import '../../../base/color_data.dart';
import '../../../base/constant.dart';

class CardDialog extends StatefulWidget {
  const CardDialog({Key? key}) : super(key: key);

  @override
  State<CardDialog> createState() => _CardDialogState();
}

class _CardDialogState extends State<CardDialog> {
  TextEditingController nameController = TextEditingController();
  TextEditingController cardController = TextEditingController();
  var dateController = MaskedTextController(mask: '00/00');
  TextEditingController cvvController = TextEditingController();
  bool agree = false;

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return Wrap(
      children: [
        buildContainer(context)
      ],
    );
  }

  Container buildContainer(BuildContext context) {
    return Container(
        child: getPaddingWidget(
          EdgeInsets.symmetric(horizontal: FetchPixels.getDefaultHorSpace(context)),
          Column(
            children: [
              getVerSpace(FetchPixels.getPixelHeight(34)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  getCustomFont("Add Card", 20, Colors.black, 1,
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
              getDefaultTextFiledWithLabel(
                  context, "Name On Card", nameController, Colors.grey,
                  function: () {},
                  height: FetchPixels.getPixelHeight(60),
                  isEnable: false,
                  withprefix: true,
                  image: "user.svg",
                  imageWidth: FetchPixels.getPixelWidth(19),
                  imageHeight: FetchPixels.getPixelHeight(17.66)),
              getVerSpace(FetchPixels.getPixelHeight(20)),
              getCardEditText(
                  context, "Card Number", cardController, Colors.grey,
                  function: () {},
                  height: FetchPixels.getPixelHeight(60),
                  isEnable: false,
                  withprefix: true,
                  image: "card.svg",
                  imageWidth: FetchPixels.getPixelWidth(19),
                  imageHeight: FetchPixels.getPixelHeight(17.66)),
              getVerSpace(FetchPixels.getPixelHeight(20)),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: getCardDateTextField(
                      context,
                      "MM/YY",
                      dateController,
                      Colors.grey,
                      function: () {},
                      height: FetchPixels.getPixelHeight(60),
                      isEnable: false,
                    ),
                  ),
                  getHorSpace(FetchPixels.getPixelWidth(20)),
                  Expanded(
                    flex: 1,
                    child: getCardDateTextField(
                      context,
                      "CVV",
                      cvvController,
                      Colors.grey,
                      function: () {},
                      height: FetchPixels.getPixelHeight(60),
                      isEnable: false,
                    ),
                  )
                ],
              ),
              getVerSpace(FetchPixels.getPixelHeight(20)),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        agree = !agree;
                      });
                    },
                    child: Container(
                      height: FetchPixels.getPixelHeight(24),
                      width: FetchPixels.getPixelHeight(24),
                      decoration: BoxDecoration(
                          color: (agree) ? blueColor : backGroundColor,
                          border: (agree)
                              ? null
                              : Border.all(color: Colors.grey, width: 2),
                          borderRadius: BorderRadius.circular(
                              FetchPixels.getPixelHeight(6))),
                      padding: EdgeInsets.symmetric(
                          vertical: FetchPixels.getPixelHeight(6),
                          horizontal: FetchPixels.getPixelWidth(4)),
                      child: (agree) ? getSvgImage("done.svg") : null,
                    ),
                  ),
                  getHorSpace(FetchPixels.getPixelWidth(10)),
                  Expanded(flex: 1,child: getCustomFont(
                      "Save Card", 16, Colors.black, 1,
                      fontWeight: FontWeight.w400),)
                ],
              ),
              getVerSpace(FetchPixels.getPixelHeight(30)),
              getButton(
                  context, blueColor, "Add", Colors.white, () {
                    Constant.backToPrev(context);
                // Constant.sendToNext(context, Routes.verifyRoute);
              }, 18,
                  weight: FontWeight.w600,
                  buttonHeight: FetchPixels.getPixelHeight(60),
                  borderRadius:
                  BorderRadius.circular(FetchPixels.getPixelHeight(14))),
              getVerSpace(FetchPixels.getPixelHeight(30)),
            ],
          ),
        ),
      );
  }
}
