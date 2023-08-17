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
  SplashScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    print("AppSchemeImpl SplashScreen build");

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
    AppSchemeImpl appScheme = AppSchemeImpl.getInstance()!!;
    SchemeEntity? schemeEntity = await appScheme.getInitScheme();
    if (schemeEntity == null) {
      ///멤버 체크
      checkMemberStatus();
      return;
    }

    print("AppSchemeImpl Init  ${schemeEntity.dataString}");

    String? sharedType = schemeEntity.query!["sharedType"];

    print("AppSchemeImpl sharedType : $sharedType");
    if (sharedType == null) {
      ///멤버체크
      checkMemberStatus();
    } else {
      ///앱스킴체크
      checkAppScheme(sharedType, schemeEntity);
    }
  }

  checkAppScheme(String sharedType, SchemeEntity schemeEntity) async {
    Timer(const Duration(seconds: 1), () async {
      switch (sharedType) {
        case "BOOK":
          {
            String? bookSetId = schemeEntity.query!["bookSetId"];
            print("AppSchemeImpl bookSetId : $bookSetId");
            Get.offAllNamed(Routes.bookDetailPath, parameters: {'sharedType': sharedType, 'bookSetId': bookSetId!});
            break;
          }
        case "COMMUNITY":
          {
            String? postId = schemeEntity.query!["postId"];
            Get.offAllNamed(Routes.communityDetailPath,
                parameters: {'sharedType': sharedType, 'postId': postId!, 'tag': 'share'});
            break;
          }
      }
    });
  }

  checkMemberStatus() async {
    Timer(const Duration(seconds: 1), () async {
      print("AppSchemeImpl SplashScreen checkMemberStatus");
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
        print("AppSchemeImpl SplashScreen go home");
        Get.offAllNamed(Routes.homescreenPath);
      }
    });
  }
}
