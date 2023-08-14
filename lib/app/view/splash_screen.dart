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
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //app scheme
    checkAppScheme();

    //멤버 상태 체크
    checkMemberStatus();

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

  checkAppScheme() {
    AppSchemeImpl appScheme = AppSchemeImpl.getInstance()!!;
    appScheme.getInitScheme().then((value) {
      if (value != null) {
        print("AppSchemeImpl Init  ${value.dataString}");
        String? sharedType = value.query!["sharedType"];

        print("AppSchemeImpl sharedType : $sharedType");
        if (sharedType != null) {
          switch (sharedType) {
            case "BOOK":
              {
                String? bookSetId = value.query!["bookSetId"];
                print("AppSchemeImpl bookSetId : $bookSetId");
                Get.offAllNamed(Routes.bookDetailPath, parameters: {'sharedType': sharedType, 'bookSetId': bookSetId!});
                break;
              }
            case "COMMUNITY":
              {
                String? postId = value.query!["postId"];
                Get.offAllNamed(Routes.communityDetailPath,
                    parameters: {'sharedType': sharedType, 'postId': postId!, 'tag': 'share'});
                break;
              }
          }

          return;
        }
      }
    });
  }

  checkMemberStatus() {
    Timer(const Duration(seconds: 1), () async {
      if (!await isLogin()) {
        Get.offAllNamed(Routes.loginPath);
      }
      if (!await isAgreed()) {
        Get.offAllNamed(Routes.joinPath);
      }
      if (await PrefData.needRefreshAuth()) {
        Get.offAllNamed(Routes.reAuthPath, parameters: {"referrer": Routes.splashPath});
      } else {
        Get.offAllNamed(Routes.homescreenPath);
      }
    });
  }
}
