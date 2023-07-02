import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ReConfirmDialog extends StatefulWidget {
  String confirmMessage;
  String confirmBtnTitle;
  String cancelBtnTitle;
  Function callBack;

  ReConfirmDialog(this.confirmMessage, this.confirmBtnTitle, this.cancelBtnTitle, this.callBack, {Key? key})
      : super(key: key);

  @override
  State<ReConfirmDialog> createState() =>
      _ReConfirmDialogState(confirmMessage, confirmBtnTitle, cancelBtnTitle, callBack);
}

class _ReConfirmDialogState extends State<ReConfirmDialog> {
  String confirmMessage;
  String confirmBtnTitle;
  String cancelBtnTitle;
  Function callBack;

  _ReConfirmDialogState(this.confirmMessage, this.confirmBtnTitle, this.cancelBtnTitle, this.callBack);

  Future<bool> _onWillPop() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: AlertDialog(
        // title: const Text('dialog title'),
        content: Text(
          confirmMessage,
          style: const TextStyle(fontSize: 15),
        ),
        contentPadding: EdgeInsets.only(
            top: FetchPixels.getPixelHeight(20),
            left: FetchPixels.getPixelHeight(20),
            bottom: FetchPixels.getPixelHeight(10)),
        actions: [
          TextButton(
              style: TextButton.styleFrom(splashFactory: NoSplash.splashFactory),
              onPressed: Get.back,
              child: Text(cancelBtnTitle, style: const TextStyle(color: Colors.black, fontSize: 14))),
          TextButton(
            style: TextButton.styleFrom(splashFactory: NoSplash.splashFactory),
            onPressed: () {
              callBack();
            },
            child: Text(confirmBtnTitle, style: const TextStyle(color: Colors.black, fontSize: 14)),
          ),
        ],
      ),
    );
  }
}
