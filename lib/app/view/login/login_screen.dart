import 'package:baby_book/app/routes/app_routes.dart';
import 'package:baby_book/base/color_data.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import '../../../base/constant.dart';
import '../../../base/pref_data.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  void finishView() {
    Constant.closeApp();
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPass = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: backGroundColor,
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: FetchPixels.getDefaultHorSpace(context)),
              alignment: Alignment.topCenter,
              child: buildWidgetList(context),
            ),
          ),
        ),
        onWillPop: () async {
          finishView();
          return false;
        });
  }

  ListView buildWidgetList(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      primary: true,
      children: [
        getVerSpace(FetchPixels.getPixelHeight(70)),
        getCustomFont(
          "로그인",
          24,
          Colors.black,
          1,
          fontWeight: FontWeight.w900,
        ),
        getVerSpace(FetchPixels.getPixelHeight(10)),
        getVerSpace(FetchPixels.getPixelHeight(50)),
        getDivider(dividerColor, FetchPixels.getPixelHeight(1), 1),
        getVerSpace(FetchPixels.getPixelHeight(200)),
        GestureDetector(
            onTap: () async {
              //토큰 존재 체크 및 유효성 체크
              if (await AuthApi.instance.hasToken() && await validateKakaoToken()) {
                print("토큰 존재하고 유효함");
                Constant.sendToNext(context, Routes.homeScreenRoute);
              } else {
                OAuthToken? token = await login();
                if (token == null) {
                  print("시스템 에러");
                } else {
                  print('카카오톡 최종 로그인 성공 ${token?.accessToken}');
                  Constant.sendToNext(context, Routes.homeScreenRoute);
                }
              }
            },
            child: getAssetImage("kakao_login_large_wide.png", FetchPixels.getPixelWidth(double.infinity),
                FetchPixels.getPixelHeight(70))),
      ],
    );
  }

  Future<bool> validateKakaoToken() async {
    try {
      AccessTokenInfo tokenInfo = await UserApi.instance.accessTokenInfo();
      print('토큰 유효성 체크 성공 ${tokenInfo.id} ${tokenInfo.expiresIn}');
      return true;
    } catch (error) {
      if (error is KakaoException && error.isInvalidTokenError()) {
        print('토큰 만료 $error');
      } else {
        print('토큰 정보 조회 실패 $error');
      }

      return false;
    }
  }

  Future<OAuthToken?> login() async {
    // 카카오톡 실행 가능 여부 확인
    // 카카오톡 실행이 가능하면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
    if (await isKakaoTalkInstalled()) {
      try {
        print('카카오톡 존재');
        OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
        print('카카오톡으로 로그인 성공 ${token.accessToken}');
        return token;
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');

        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
        if (error is PlatformException && error.code == 'CANCELED') {
          return null;
        }
        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        try {
          print('카카오톡에 연결된 계정없음');
          OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
          print('카카오계정으로 로그인 성공 ${token.accessToken}');
          return token;
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
        }
      }
    } else {
      //카카오톡이 없는 케이스
      try {
        print('카카오톡 없음');
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        print('카카오계정으로 로그인 성공 ${token.accessToken}');
        return token;
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
      }
    }

    return null;
  }
}
