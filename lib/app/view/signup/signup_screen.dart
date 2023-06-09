
import 'package:baby_book/base/pref_data.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../base/color_data.dart';
import '../../../base/constant.dart';
import '../../../base/widget_utils.dart';
import '../../routes/app_pages.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  void finishView() {
    Constant.backToPrev(context);
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  bool agree = false;

  TextEditingController passwordController = TextEditingController();
  bool isPass = true;
  String defCode = "";
  String defCountry = PrefData.defCountryName;

  getPrefVal() async {
    defCode = await PrefData.getDefCode();
    defCountry = await PrefData.getDefCountry();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getPrefVal();
  }

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: backGroundColor,
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: FetchPixels.getPixelWidth(20)),
              child: buildSignUpWidget(context),
            ),
          ),
        ),
        onWillPop: () async {
          finishView();
          return false;
        });
  }

  ListView buildSignUpWidget(BuildContext context) {
    return ListView(
      primary: true,
      shrinkWrap: true,
      children: [
        getVerSpace(FetchPixels.getPixelHeight(26)),
        gettoolbarMenu(
          context,
          "back.svg",
          () {
            finishView();
          },
        ),
        getVerSpace(FetchPixels.getPixelHeight(22)),
        getCustomFont(
          "Sign Up",
          24,
          Colors.black,
          1,
          fontWeight: FontWeight.w900,
        ),
        getVerSpace(FetchPixels.getPixelHeight(10)),
        getCustomFont("Enter your detail for sign up!", 16, Colors.black, 1,
            fontWeight: FontWeight.w400),
        getVerSpace(FetchPixels.getPixelHeight(30)),
        getDefaultTextFiledWithLabel(
          context,
          "Name",
          nameController,
          Colors.grey,
          function: () {},
          height: FetchPixels.getPixelHeight(60),
          isEnable: false,
          withprefix: true,
          image: "user.svg",
        ),
        getVerSpace(FetchPixels.getPixelHeight(20)),
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
        GestureDetector(
            onTap: () {
              Constant.sendToNextWithRes(context, Routes.selectCountryPath,
                  fun: () {
                getPrefVal();
              });
            },
            child: getCountryTextField(context, "Phone Number",
                phoneNumberController, textColor, defCode,
                function: () {},
                height: FetchPixels.getPixelHeight(60),
                isEnable: false,
                minLines: true,
                image: defCountry)),
        getVerSpace(FetchPixels.getPixelHeight(20)),
        getDefaultTextFiledWithLabel(
            context, "Password", passwordController, Colors.grey,
            function: () {},
            height: FetchPixels.getPixelHeight(60),
            isEnable: false,
            withprefix: true,
            image: "lock.svg",
            isPass: isPass,
            imageWidth: FetchPixels.getPixelWidth(19),
            imageHeight: FetchPixels.getPixelHeight(17.66),
            withSufix: true,
            suffiximage: "eye.svg", imagefunction: () {
          setState(() {
            isPass = !isPass;
          });
        }),
        getVerSpace(FetchPixels.getPixelHeight(30)),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  agree = !agree;
                });
              },
              child: Container(
                height: FetchPixels.getPixelHeight(24),
                width: FetchPixels.getPixelHeight(24),
                decoration: BoxDecoration(
                    color: (agree) ? blueColor : backGroundColor,
                    border: (agree)
                        ? null
                        : Border.all(color: Colors.grey, width: 2),
                    borderRadius:
                        BorderRadius.circular(FetchPixels.getPixelHeight(6))),
                padding: EdgeInsets.symmetric(
                    vertical: FetchPixels.getPixelHeight(6),
                    horizontal: FetchPixels.getPixelWidth(4)),
                child: (agree) ? getSvgImage("done.svg") : null,
              ),
            ),
            getHorSpace(FetchPixels.getPixelWidth(10)),
            getCustomFont("I agree with Terms & Privacy", 16, Colors.black, 1,
                fontWeight: FontWeight.w400)
          ],
        ),
        getVerSpace(FetchPixels.getPixelHeight(50)),
        getButton(context, blueColor, "Sign Up", Colors.white, () {
          Get.toNamed(Routes.verifyPath);
        }, 18,
            weight: FontWeight.w600,
            buttonHeight: FetchPixels.getPixelHeight(60),
            borderRadius:
                BorderRadius.circular(FetchPixels.getPixelHeight(15))),
        getVerSpace(FetchPixels.getPixelHeight(30)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            getCustomFont(
              "Already have an account?",
              14,
              Colors.black,
              1,
              fontWeight: FontWeight.w400,
            ),
            GestureDetector(
              onTap: () {
                finishView();
              },
              child: getCustomFont(" Login", 16, blueColor, 1,
                  fontWeight: FontWeight.w900),
            )
          ],
        )
      ],
    );
  }
}
