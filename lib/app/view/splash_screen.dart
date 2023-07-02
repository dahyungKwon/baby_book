import 'dart:async';

import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../base/kakao_login_util.dart';
import '../routes/app_pages.dart';
import 'package:appscheme/appscheme.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //app scheme
    AppSchemeImpl appScheme = AppSchemeImpl.getInstance()!!;
    appScheme.getInitScheme().then((value) {
      if (value != null) {
        print("AppSchemeImpl Init  ${value.dataString}");
        String? sharedType = value.query!["sharedType"];
        String? postId = value.query!["postId"];
        print("AppSchemeImpl sharedType : $sharedType");
        print("AppSchemeImpl postId : $postId");
        if (sharedType != null) {
          switch (sharedType) {
            case "BOOK":
              {
                /// 책공유 시 활용
                break;
              }
            case "COMMUNITY":
              {
                Get.toNamed(Routes.communityDetailPath, parameters: {'sharedType': sharedType, 'postId': postId!});
                break;
              }
          }

          return;
        }
      }

      Timer(const Duration(seconds: 1), () async {
        if (await isLogin()) {
          print("로그인 완료");
          Get.toNamed(Routes.homescreenPath);
        } else {
          Get.toNamed(Routes.loginPath);
        }
      });
    });

    FetchPixels(context);

    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
              color: Colors.white,
              child: Center(
                  child: getAssetImage("sp2.png", FetchPixels.getPixelWidth(double.infinity),
                      FetchPixels.getPixelHeight(double.infinity)))),
        ),
        onWillPop: () async {
          Get.back();
          return false;
        });
  }
}
