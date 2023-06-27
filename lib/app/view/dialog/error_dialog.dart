import 'package:baby_book/app/view/home/home_screen.dart';
import 'package:baby_book/base/constant.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../base/color_data.dart';

class ErrorDialog extends StatefulWidget {
  String? errorMessage;

  ErrorDialog(this.errorMessage, {Key? key}) : super(key: key);

  @override
  State<ErrorDialog> createState() => _ErrorDialogState(errorMessage);
}

class _ErrorDialogState extends State<ErrorDialog> {
  String? errorMessage;

  _ErrorDialogState(this.errorMessage);

  Future<bool> _onWillPop() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(20))),
        backgroundColor: backGroundColor,
        content: Builder(
          builder: (context) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                getVerSpace(FetchPixels.getPixelHeight(10)),
                getMultilineCustomFont(errorMessage ?? "잠시 후 다시 시도해주세요.", 16, Colors.black,
                    fontWeight: FontWeight.w400, txtHeight: 1.3, textAlign: TextAlign.center),
                getVerSpace(FetchPixels.getPixelHeight(30)),
                TextButton(
                    style: TextButton.styleFrom(splashFactory: NoSplash.splashFactory),
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text("확인", style: TextStyle(color: Colors.black, fontSize: 14))),
              ],
            );
          },
        ),
      ),
    );
  }
}
