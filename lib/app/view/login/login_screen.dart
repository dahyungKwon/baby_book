import 'package:baby_book/app/models/model_member.dart';
import 'package:baby_book/app/repository/member_repository.dart';
import 'package:baby_book/app/routes/app_routes.dart';
import 'package:baby_book/base/color_data.dart';
import 'package:baby_book/base/pref_data.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import '../../../base/constant.dart';
import '../../../base/kakao_login_util.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();

    isLogin().then((isLogin) async => {
          if (isLogin) //로그인이 되어있는데 들어온 경우 토큰 업데이트하고 다시 메인으로 보냅니다.
            {
              MemberRepository.refreshAccessToken().then((response) async => {
                    await PrefData.setAccessToken(response.accessToken!),
                    await PrefData.setRefreshToken(response.refreshToken!),
                    Constant.sendToNext(context, Routes.homeScreenRoute)
                  })
            }
        });
  }

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
              if (await isLogin()) {
                print("토큰 존재하고 유효함");
                Constant.sendToNext(context, Routes.homeScreenRoute);
              } else {
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
                  Constant.sendToNext(context, Routes.homeScreenRoute);
                }
              }
            },
            child: getAssetImage("kakao_login_large_wide.png", FetchPixels.getPixelWidth(double.infinity),
                FetchPixels.getPixelHeight(70))),
      ],
    );
  }
}
