import 'dart:async';

import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../base/constant.dart';
import '../../base/kakao_login_util.dart';
import '../routes/app_pages.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () async {
      if (await isLogin()) {
        print("로그인 완료");
        Get.toNamed(Routes.homescreenPath);
      } else {
        Get.toNamed(Routes.loginPath);
      }
    });
  }

  void backClick() {
    Constant.backToPrev(context);
  }

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);

    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: buildLogo(),
        ),
        onWillPop: () async {
          backClick();
          return false;
        });
  }

  Container buildLogo() {
    return Container(
        child: Center(
            child: getAssetImage("splash3.png", FetchPixels.getPixelWidth(double.infinity),
                FetchPixels.getPixelHeight(double.infinity))));
  }
}
