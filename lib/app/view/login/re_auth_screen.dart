import 'dart:async';

import 'package:baby_book/app/repository/member_repository.dart';

import 'package:baby_book/base/color_data.dart';
import 'package:baby_book/base/pref_data.dart';
import 'package:baby_book/base/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../base/kakao_login_util.dart';
import '../../routes/app_pages.dart';
import '../dialog/error_dialog.dart';

class ReAuthScreen extends StatelessWidget {
  const ReAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print("ReAuthScreen in");
    String? referrer = Get.parameters["referrer"];
    Timer(const Duration(seconds: 1), () async {
      if (!await isLogin()) {
        Get.offAllNamed(Routes.loginPath);
      }
      if (!await isAgreed()) {
        Get.offAllNamed(Routes.joinPath);
      }
      if (await PrefData.needRefreshAuth()) {
        reAuth();
      }

      if (referrer != null && referrer == Routes.splashPath) {
        Get.offAllNamed(Routes.homescreenPath);
      } else {
        reAuth();
      }
    });

    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: backGroundColor,
          body: const SafeArea(
            child: Column(children: [Expanded(child: FullSizeSkeleton())]),
          ),
        ),
        onWillPop: () async {
          Get.offAllNamed(Routes.loginPath);

          return false;
        });
  }

  reAuth() {
    MemberRepository.refreshAccessToken()
        .then((response) => {
              if (response.accessToken != null && response.refreshToken != null)
                {
                  PrefData.setLastLoginDate(DateTime.now()),
                  PrefData.setAccessToken(response.accessToken!),
                  PrefData.setRefreshToken(response.refreshToken!),
                  Get.toNamed(Routes.homescreenPath)
                }
            })
        .catchError((e) {
      Get.dialog(ErrorDialog("토큰 갱신에 실패하였습니다. 재로그인 해주세요."));
      Get.offAllNamed(Routes.loginPath);
    });
  }
}
