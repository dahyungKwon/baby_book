import 'dart:async';

import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../base/kakao_login_util.dart';
import '../routes/app_pages.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  void backClick() {
    // Constant.backToPrev(context);
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 1), () async {
      if (await isLogin()) {
        print("로그인 완료");
        Get.toNamed(Routes.homescreenPath);
      } else {
        Get.toNamed(Routes.loginPath);
      }
    });

    FetchPixels(context);

    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
              child: Center(
                  child: getAssetImage("sp2.png", FetchPixels.getPixelWidth(double.infinity),
                      FetchPixels.getPixelHeight(double.infinity)))),
        ),
        onWillPop: () async {
          backClick();
          return false;
        });
  }
}
