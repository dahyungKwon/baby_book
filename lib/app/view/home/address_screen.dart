import 'package:dotted_line/dotted_line.dart';
import 'package:baby_book/app/routes/app_routes.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:flutter/material.dart';

import '../../../base/color_data.dart';
import '../../../base/constant.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({Key? key}) : super(key: key);

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: backGroundColor,
          bottomNavigationBar: continueButton(context),
          body: SafeArea(
            child: Container(
              padding:
                  EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
              child: Column(
                children: [
                  getVerSpace(FetchPixels.getPixelHeight(20)),
                  gettoolbarMenu(context, "back.svg", () {
                    Constant.backToPrev(context);
                  },
                      title: "Proceed",
                      
                      weight: FontWeight.w900,
                      istext: true,
                      fontsize: 24,
                      textColor: Colors.black),
                  getVerSpace(FetchPixels.getPixelHeight(30)),
                  processTracker(),
                  getVerSpace(FetchPixels.getPixelHeight(30)),
                  addressList(),
                  getVerSpace(FetchPixels.getPixelHeight(30)),
                  newAddressButton(context)
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

  Container continueButton(BuildContext context) {
    return Container(
      color: backGroundColor,
      padding: EdgeInsets.only(
          left: FetchPixels.getPixelWidth(20),
          right: FetchPixels.getPixelWidth(20),
          bottom: FetchPixels.getPixelHeight(30)),
      child: getButton(context, blueColor, "Continue", Colors.white, () {
        Constant.sendToNext(context, Routes.dateTimeRoute);
      }, 18,
          weight: FontWeight.w600,
          buttonHeight: FetchPixels.getPixelHeight(60),
          borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(14))),
    );
  }

  Widget newAddressButton(BuildContext context) {
    return getButton(
        context, const Color(0xFFF2F4F8), "+ Add New Address", blueColor, () {
          Constant.sendToNext(context, Routes.editAddressRoute);
    }, 18,
        weight: FontWeight.w600,
        buttonWidth: FetchPixels.getPixelWidth(224),
        buttonHeight: FetchPixels.getPixelHeight(60),
        borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(14)));
  }

  Column addressList() {
    return Column(
      children: [
        Container(
          width: FetchPixels.getPixelWidth(374),
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
              Container(
                padding: EdgeInsets.symmetric(
                    vertical: FetchPixels.getPixelHeight(16),
                    horizontal: FetchPixels.getPixelWidth(16)),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: getCustomFont("Alena Gomez", 16, Colors.black, 1,
                           fontWeight: FontWeight.w900),
                    ),
                    getVerSpace(FetchPixels.getPixelHeight(10)),
                    Align(
                      alignment: Alignment.topLeft,
                      child: SizedBox(
                          width: FetchPixels.getPixelWidth(280),
                          child: getMultilineCustomFont(
                              "3891 Ranchview Dr. Richardson, California 62639",
                              16,
                              Colors.black,
                              fontWeight: FontWeight.w400,

                              txtHeight: 1.4)),
                    ),
                    getVerSpace(FetchPixels.getPixelHeight(10)),
                    Align(
                      alignment: Alignment.topLeft,
                      child: getCustomFont(
                          "(907) 555-0101", 16, Colors.black, 1,
                           fontWeight: FontWeight.w400),
                    )
                  ],
                ),
              ),
              Positioned(
                child: getPaddingWidget(
                  EdgeInsets.only(
                      right: FetchPixels.getPixelHeight(16),
                      top: FetchPixels.getPixelHeight(16)),
                  getSvgImage("selected.svg",
                      width: FetchPixels.getPixelHeight(24),
                      height: FetchPixels.getPixelHeight(24)),
                ),
              ),
            ],
          ),
        ),
        getVerSpace(FetchPixels.getPixelHeight(20)),
        Container(
          width: FetchPixels.getPixelWidth(374),
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
              Container(
                padding: EdgeInsets.symmetric(
                    vertical: FetchPixels.getPixelHeight(16),
                    horizontal: FetchPixels.getPixelWidth(16)),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: getCustomFont("Alena Gomez", 16, Colors.black, 1,
                           fontWeight: FontWeight.w900),
                    ),
                    getVerSpace(FetchPixels.getPixelHeight(10)),
                    Align(
                      alignment: Alignment.topLeft,
                      child: SizedBox(
                          width: FetchPixels.getPixelWidth(280),
                          child: getMultilineCustomFont(
                              "4140 Parker Rd. Allentown, New Mexico 31134",
                              16,
                              Colors.black,
                              fontWeight: FontWeight.w400,

                              txtHeight: 1.4)),
                    ),
                    getVerSpace(FetchPixels.getPixelHeight(10)),
                    Align(
                      alignment: Alignment.topLeft,
                      child: getCustomFont(
                          "(907) 555-0101", 16, Colors.black, 1,
                           fontWeight: FontWeight.w400),
                    )
                  ],
                ),
              ),
              Positioned(
                child: getPaddingWidget(
                  EdgeInsets.only(
                      right: FetchPixels.getPixelHeight(16),
                      top: FetchPixels.getPixelHeight(16)),
                  getSvgImage("unselected.svg",
                      width: FetchPixels.getPixelHeight(24),
                      height: FetchPixels.getPixelHeight(24)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Row processTracker() {
    return Row(
      children: [
        Container(
          height: FetchPixels.getPixelHeight(52),
          width: FetchPixels.getPixelHeight(52),
          padding: EdgeInsets.all(FetchPixels.getPixelHeight(14)),
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0.0, 4.0)),
              ],
              borderRadius:
                  BorderRadius.circular(FetchPixels.getPixelHeight(50))),
          child: getSvgImage("location.svg"),
        ),
        Expanded(
          child: DottedLine(
            dashColor: const Color(0xFFBEC4D3),
            lineThickness: FetchPixels.getPixelHeight(1),
          ),
        ),
        Container(
          height: FetchPixels.getPixelHeight(52),
          width: FetchPixels.getPixelHeight(52),
          padding: EdgeInsets.all(FetchPixels.getPixelHeight(14)),
          decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE5E8F1), width: 1),
              borderRadius:
                  BorderRadius.circular(FetchPixels.getPixelHeight(50))),
          child: getSvgImage("wallet.svg"),
        ),
        Expanded(
          child: DottedLine(
            dashColor: const Color(0xFFBEC4D3),
            lineThickness: FetchPixels.getPixelHeight(1),
          ),
        ),
        Container(
          height: FetchPixels.getPixelHeight(52),
          width: FetchPixels.getPixelHeight(52),
          padding: EdgeInsets.all(FetchPixels.getPixelHeight(14)),
          decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE5E8F1), width: 1),
              borderRadius:
                  BorderRadius.circular(FetchPixels.getPixelHeight(50))),
          child: getSvgImage("check.svg"),
        ),
      ],
    );
  }
}
