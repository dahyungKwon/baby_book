import 'package:baby_book/app/routes/app_routes.dart';
import 'package:baby_book/base/color_data.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:flutter/material.dart';

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
              padding:
                  EdgeInsets.symmetric(horizontal: FetchPixels.getDefaultHorSpace(context)),
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
                getCustomFont("Login", 24, Colors.black, 1,
                    fontWeight: FontWeight.w900, ),
                getVerSpace(FetchPixels.getPixelHeight(10)),
                getCustomFont("Glad to meet you again! ", 16, Colors.black, 1,
                    fontWeight: FontWeight.w400, ),
                getVerSpace(FetchPixels.getPixelHeight(30)),
                getDefaultTextFiledWithLabel(
                  context,
                  "Email",
                  emailController,
                  Colors.grey,
                  function: () {},
                  height: FetchPixels.getPixelHeight(60),
                  isEnable: false,
                  withprefix: true,
                  image: "message.svg",
                ),
                getVerSpace(FetchPixels.getPixelHeight(20)),
                getDefaultTextFiledWithLabel(
                    context, "Password", passwordController, Colors.grey,
                    function: () {},
                    height: FetchPixels.getPixelHeight(60),
                    isEnable: false,
                    withprefix: true,
                    image: "lock.svg",
                    isPass: isPass,
                    withSufix: true,
                    suffiximage: "eye.svg", imagefunction: () {
                  setState(() {
                    isPass = !isPass;
                  });
                }),
                getVerSpace(FetchPixels.getPixelHeight(19)),
                Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        Constant.sendToNext(context, Routes.forgotRoute);
                      },
                      child: getCustomFont("Forgot Password?", 16, blueColor, 1,
                          fontWeight: FontWeight.w900, ),
                    )),
                getVerSpace(FetchPixels.getPixelHeight(49)),
                getButton(context, blueColor, "Login", Colors.white, () {
                  PrefData.setLogIn(true);
                  Constant.sendToNext(context, Routes.homeScreenRoute);
                }, 18,
                    weight: FontWeight.w600,
                    buttonHeight: FetchPixels.getPixelHeight(60),
                    borderRadius:
                        BorderRadius.circular(FetchPixels.getPixelHeight(15))),
                getVerSpace(FetchPixels.getPixelHeight(30)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    getCustomFont("Don’t have an account?", 14, Colors.black, 1,
                        fontWeight: FontWeight.w400, ),
                    GestureDetector(
                      onTap: () {
                        Constant.sendToNext(context, Routes.signupRoute);
                      },
                      child: getCustomFont(" Sign Up", 16, blueColor, 1,
                          fontWeight: FontWeight.w900, ),
                    )
                  ],
                ),
                getVerSpace(FetchPixels.getPixelHeight(50)),
                getDivider(dividerColor, FetchPixels.getPixelHeight(1), 1),
                getVerSpace(FetchPixels.getPixelHeight(50)),
                getButton(
                  context,
                  Colors.white,
                  "Login with Google",
                  Colors.black,
                  () {},
                  18,
                  weight: FontWeight.w600,
                  isIcon: true,
                  image: "google.svg",
                  buttonHeight: FetchPixels.getPixelHeight(60),
                  borderRadius:
                      BorderRadius.circular(FetchPixels.getPixelHeight(15)),
                  boxShadow: [
                    const BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0.0, 4.0)),
                  ],
                ),
                getVerSpace(FetchPixels.getPixelHeight(20)),
                getButton(context, Colors.white, "Login with Facebook",
                    Colors.black, () {}, 18,
                    weight: FontWeight.w600,
                    isIcon: true,
                    image: "facebook.svg",
                    buttonHeight: FetchPixels.getPixelHeight(60),
                    borderRadius:
                        BorderRadius.circular(FetchPixels.getPixelHeight(15)),
                    boxShadow: [
                      const BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0.0, 4.0)),
                    ]),
              ],
            );
  }
}
