import 'package:baby_book/app/models/model_member.dart';
import 'package:baby_book/app/repository/member_repository.dart';

import 'package:baby_book/base/color_data.dart';
import 'package:baby_book/base/pref_data.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import '../../../base/constant.dart';
import '../../../base/kakao_login_util.dart';
import '../../routes/app_pages.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  void finishView() {
    Constant.closeApp();
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPass = true;

  @override
  Widget build(BuildContext context) {
    isLogin().then((isLogin) async => {
          if (isLogin) //로그인이 되어있는데 들어온 경우 토큰 업데이트하고 다시 메인으로 보냅니다.
            {
              MemberRepository.refreshAccessToken()
                  .then((response) => {
                        if (response.accessToken != null && response.refreshToken != null)
                          {
                            PrefData.setAccessToken(response.accessToken!),
                            PrefData.setRefreshToken(response.refreshToken!),
                            Get.toNamed(Routes.homescreenPath)
                          }
                      })
                  .catchError((e) {
                print("error :$e");
              })
            }
        });

    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: backGroundColor,
          body: SafeArea(
            child: Column(children: [buildTop(context), buildWidgetList(context)]),
          ),
        ),
        onWillPop: () async {
          finishView();
          return false;
        });
  }

  Widget buildTop(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(5, 10, 0, 0),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            getSimpleImageButton("back_outline.svg", FetchPixels.getPixelHeight(50), FetchPixels.getPixelHeight(50),
                Colors.white, FetchPixels.getPixelHeight(26), FetchPixels.getPixelHeight(26), () async {
              finishView();
            }),
            getCustomFont(
              "로그인",
              22,
              Colors.black,
              1,
              fontWeight: FontWeight.w600,
            ),
          ],
        ));
  }

  Expanded buildWidgetList(BuildContext context) {
    return Expanded(
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(25)),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                  color: Colors.white,
                  child: Center(
                      child: getAssetImage("app_icon6.jpeg", FetchPixels.getPixelWidth(double.infinity),
                          FetchPixels.getPixelHeight(200)))),
              getVerSpace(FetchPixels.getPixelHeight(100)),
              GestureDetector(
                  onTap: () async {
                    //어떤 상황에서든 로그인버튼 누르면 인증초기화 진행
                    OAuthToken? token = await kakaoLogin();
                    if (token == null) {
                      print("시스템 에러");
                    } else {
                      print('카카오톡 최종 로그인 성공 ${token?.accessToken}');
                      ModelMember member =
                          await MemberRepository.createMember(snsLoginType: "KAKAO", snsAccessToken: token.accessToken);
                      await PrefData.setAccessToken(member.accessToken!);
                      await PrefData.setRefreshToken(member.refreshToken!);
                      await PrefData.setMemberId(member.memberId!);

                      if (member.allAgreed == null || member.allAgreed == false) {
                        Get.toNamed(Routes.joinPath);
                      } else {
                        await PrefData.setAgreed(true); //로그아웃하고 새로 들어왔을경우
                        Get.toNamed(Routes.homescreenPath);
                      }
                    }
                  },
                  child: getAssetImage("kakao_login_large_wide.png", FetchPixels.getPixelWidth(double.infinity),
                      FetchPixels.getPixelHeight(70))),
              getVerSpace(FetchPixels.getPixelHeight(15)),
              Row(
                children: [
                  getSvgImage("alert_circle_outline.svg",
                      width: FetchPixels.getPixelHeight(15), height: FetchPixels.getPixelHeight(15)),
                  getHorSpace(FetchPixels.getPixelHeight(5)),
                  getCustomFont("회원가입은 카카오 인증을 통해 진행됩니다.", 14, Colors.black, 1, fontWeight: FontWeight.w400)
                ],
              ),
              getVerSpace(FetchPixels.getPixelHeight(10)),
              Row(
                children: [
                  getSvgImage("alert_circle_outline.svg",
                      width: FetchPixels.getPixelHeight(15), height: FetchPixels.getPixelHeight(15)),
                  getHorSpace(FetchPixels.getPixelHeight(5)),
                  GestureDetector(
                    onTap: () async {
                      Get.toNamed(Routes.privacyPolicyPath);
                    },
                    child: getCustomFont(
                      "개인정보 취급방침 보기",
                      14,
                      Colors.blueAccent,
                      1,
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.underline,
                    ),
                  )
                ],
              )
            ])));
  }
}
