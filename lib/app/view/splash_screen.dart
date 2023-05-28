import 'dart:async';

import 'package:baby_book/base/color_data.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:flutter/material.dart';

import '../../base/constant.dart';
import '../../base/kakao_login_util.dart';
import '../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () async {
      if (await isLogin()) {
        print("로그인 완료");
        Constant.sendToNext(context, Routes.homeScreenRoute);
      } else {
        Constant.sendToNext(context, Routes.loginRoute);
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
        color: blueColor,
        child: Center(
            child: getSvgImageWithSize(
                context, "splash_logo.svg", FetchPixels.getPixelHeight(180), FetchPixels.getPixelHeight(180))));
  }
}
