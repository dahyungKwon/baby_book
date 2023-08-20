import 'dart:async';

import 'package:baby_book/base/pref_data.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../base/kakao_login_util.dart';
import '../routes/app_pages.dart';
import 'package:appscheme/appscheme.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    init();

    FetchPixels(context);
    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
              color: Colors.white,
              child: Center(
                  child: getAssetImage("sp11.png", FetchPixels.getPixelWidth(double.infinity),
                      FetchPixels.getPixelHeight(double.infinity)))),
        ),
        onWillPop: () async {
          Get.back();
          return false;
        });
  }

  init() async {
    Timer(const Duration(seconds: 1), () async {
      if (!await isLogin()) {
        Get.offAllNamed(Routes.loginPath);
        return;
      }
      if (!await isAgreed()) {
        Get.offAllNamed(Routes.joinPath);
        return;
      }
      if (await PrefData.needRefreshAuth()) {
        Get.offAllNamed(Routes.reAuthPath, parameters: {"referrer": Routes.splashPath});
      } else {
        checkAppScheme();
      }
    });
  }

  checkAppScheme() async {
    Timer(const Duration(seconds: 1), () async {
      AppSchemeImpl appScheme = AppSchemeImpl.getInstance()!!;

      SchemeEntity? schemeEntity = await appScheme.getInitScheme();
      if (schemeEntity == null) {
        Get.offAllNamed(Routes.homescreenPath);
        return;
      }

      String? sharedType = schemeEntity.query!["sharedType"];
      if (sharedType == null) {
        Get.offAllNamed(Routes.homescreenPath);
        return;
      }

      switch (sharedType) {
        case "BOOK":
          {
            String? bookSetId = schemeEntity.query!["bookSetId"];
            print("AppSchemeImpl bookSetId : $bookSetId");
            Get.offAllNamed(Routes.homescreenPath, parameters: {'sharedType': sharedType, 'bookSetId': bookSetId!});
            break;
          }
        case "COMMUNITY":
          {
            String? postId = schemeEntity.query!["postId"];
            print("AppSchemeImpl postId : $postId");
            Get.offAllNamed(Routes.homescreenPath, parameters: {'sharedType': sharedType, 'postId': postId!});
            break;
          }
        default:
          {
            Get.offAllNamed(Routes.homescreenPath);
            break;
          }
      }
    });
  }
}
