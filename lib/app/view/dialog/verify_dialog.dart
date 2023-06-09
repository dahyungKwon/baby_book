import 'package:baby_book/base/constant.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../base/color_data.dart';
import '../../../base/widget_utils.dart';
import '../../routes/app_pages.dart';

class VerifyDialog extends StatefulWidget {
  const VerifyDialog({Key? key}) : super(key: key);

  @override
  State<VerifyDialog> createState() => _VerifyDialogState();
}

class _VerifyDialogState extends State<VerifyDialog> {
  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(20))),
      backgroundColor: backGroundColor,
      content: Builder(
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              getVerSpace(FetchPixels.getPixelHeight(20)),
              getSvgImage("group.svg"),
              getVerSpace(FetchPixels.getPixelHeight(30)),
              getCustomFont("Account Created", 22, Colors.black, 1, fontWeight: FontWeight.w900),
              getVerSpace(FetchPixels.getPixelHeight(10)),
              getMultilineCustomFont("Your account has been successfully created!", 16, Colors.black,
                  fontWeight: FontWeight.w400, textAlign: TextAlign.center, txtHeight: 1.3),
              getVerSpace(FetchPixels.getPixelHeight(30)),
              getButton(context, blueColor, "Ok", Colors.white, () {
                Get.toNamed(Routes.loginPath);
              }, 18,
                  weight: FontWeight.w600,
                  buttonHeight: FetchPixels.getPixelHeight(60),
                  borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(15))),
              getVerSpace(FetchPixels.getPixelHeight(20)),
            ],
          );
        },
      ),
    );
  }
}
