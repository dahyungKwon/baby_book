import 'package:baby_book/app/view/home/home_screen.dart';
import 'package:baby_book/base/constant.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:flutter/material.dart';

import '../../../base/color_data.dart';

class ReConfirmDialog extends StatefulWidget {
  String confirmMessage;

  ReConfirmDialog(this.confirmMessage, {Key? key}) : super(key: key);

  @override
  State<ReConfirmDialog> createState() => _ReConfirmDialogState(confirmMessage);
}

class _ReConfirmDialogState extends State<ReConfirmDialog> {
  String confirmMessage;

  _ReConfirmDialogState(this.confirmMessage);

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
                getMultilineCustomFont(confirmMessage, 16, Colors.black,
                    fontWeight: FontWeight.w400, txtHeight: 1.3, textAlign: TextAlign.center),
                getVerSpace(FetchPixels.getPixelHeight(30)),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  getButton(context, const Color(0xffd2d2d2), "취소", Colors.black, () {
                    Constant.backToPrev(context);
                  }, 15,
                      weight: FontWeight.w400,
                      buttonHeight: FetchPixels.getPixelHeight(40),
                      borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(8))),
                  getButton(context, const Color(0xffd2d2d2), "확인", Colors.black, () {
                    Constant.backToPrev(context);
                  }, 15,
                      weight: FontWeight.w400,
                      buttonHeight: FetchPixels.getPixelHeight(40),
                      borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(8))),
                ])
              ],
            );
          },
        ),
      ),
    );
  }
}
