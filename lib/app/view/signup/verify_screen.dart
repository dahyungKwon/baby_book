import 'package:baby_book/app/view/dialog/verify_dialog.dart';
import 'package:baby_book/base/color_data.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import '../../../base/constant.dart';
import '../../../base/widget_utils.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({Key? key}) : super(key: key);

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  void finishView() {
    Constant.backToPrev(context);
  }


  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: FetchPixels.getPixelWidth(79),
      height: FetchPixels.getPixelHeight(68),
      textStyle: TextStyle(
          fontSize: FetchPixels.getPixelHeight(24),
          color: blueColor,
          fontWeight: FontWeight.w900,
          ),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0.0, 4.0)),
          ],
          borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(15))),
    );

    FetchPixels(context);
    return WillPopScope(
        child: Scaffold(
          body: SafeArea(
            child: Container(
              padding:
              EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
              child: Column(
                children: [
                  getVerSpace(FetchPixels.getPixelHeight(26)),
                  gettoolbarMenu(
                    context,
                    "back.svg",
                        () {
                      finishView();
                    },
                  ),
                  getVerSpace(FetchPixels.getPixelHeight(22)),
                  getCustomFont("Verify", 24, Colors.black, 1,
                      fontWeight: FontWeight.w900, ),
                  getVerSpace(FetchPixels.getPixelHeight(10)),
                  getCustomFont("Enter code sent to your phone number!", 16,
                      Colors.black, 1,
                       fontWeight: FontWeight.w400),
                  getVerSpace(FetchPixels.getPixelHeight(42)),
                  Pinput(
                    defaultPinTheme: defaultPinTheme,
                    pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                    showCursor: true,
                    onCompleted: (pin){},
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                  getVerSpace(FetchPixels.getPixelHeight(50)),
                  getButton(context, blueColor, "Verify", Colors.white, () {
                    showDialog(
                        barrierDismissible: false,
                        builder: (context) {
                          return const VerifyDialog();
                        },
                        context: context);
                  }, 18,
                      weight: FontWeight.w600,
                      buttonHeight: FetchPixels.getPixelHeight(60),
                      borderRadius:
                      BorderRadius.circular(FetchPixels.getPixelHeight(15))),
                  getVerSpace(FetchPixels.getPixelHeight(30)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      getCustomFont("Didn’t recieve code?", 14, Colors.black, 1,
                           fontWeight: FontWeight.w400),
                      getCustomFont(" Resend", 16, blueColor, 1,
                          fontWeight: FontWeight.w900, )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        onWillPop: () async {
          finishView();
          return false;
        });
  }
}
