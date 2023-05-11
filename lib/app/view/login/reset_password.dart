import 'package:baby_book/app/view/dialog/reset_dialog.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:flutter/material.dart';

import '../../../base/color_data.dart';
import '../../../base/constant.dart';
import '../../../base/widget_utils.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  void finish() {
    Constant.backToPrev(context);
  }

  TextEditingController oldController = TextEditingController();
  TextEditingController newController = TextEditingController();
  TextEditingController confirmController = TextEditingController();

  ValueNotifier confirmPass=ValueNotifier(true);
  ValueNotifier newPass=ValueNotifier(true);
  ValueNotifier oldPass=ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: backGroundColor,
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
              child: buildListWidget(context),
            ),
          ),
        ),
        onWillPop: () async {
          finish();
          return false;
        });
  }

  ListView buildListWidget(BuildContext context) {
    return ListView(
              primary: true,
              shrinkWrap: true,
              children: [
                getVerSpace(FetchPixels.getPixelHeight(26)),
                gettoolbarMenu(
                  context,
                  "back.svg",
                  () {
                    finish();
                  },
                ),
                getVerSpace(FetchPixels.getPixelHeight(20)),
                getCustomFont("Reset Password", 24, Colors.black, 1,
                     fontWeight: FontWeight.w900,textAlign: TextAlign.center),
                getVerSpace(FetchPixels.getPixelHeight(10)),
                buildDetailView(),
                getVerSpace(FetchPixels.getPixelHeight(36)),
                buildPassField(),
                getVerSpace(FetchPixels.getPixelHeight(14)),
                buildNewPassField(),
                getVerSpace(FetchPixels.getPixelHeight(14)),
                buildConfirmPassField(),
                getVerSpace(FetchPixels.getPixelHeight(50)),
                getButton(context, blueColor, "Submit", Colors.white, () {
                  showDialog(
                      barrierDismissible: false,
                      builder: (context) {
                        return const ResetDialog();
                      },
                      context: context);
                }, 18,
                    weight: FontWeight.w600,
                    buttonHeight: FetchPixels.getPixelHeight(60),
                    borderRadius:
                        BorderRadius.circular(FetchPixels.getPixelHeight(15))),
              ],
            );
  }

  ValueListenableBuilder<dynamic> buildPassField() {
    return ValueListenableBuilder(
                  builder: (context, value, child) {
                    return getDefaultTextFiledWithLabel(
                        context, "Old Password", oldController, textColor,
                        function: () {},
                        height: FetchPixels.getPixelHeight(60),
                        isEnable: false,
                        withprefix: true,
                        image: "lock.svg",
                        withSufix: true,
                        isPass: oldPass.value,
                        suffiximage: "eye.svg", imagefunction: () {
                      setState(() {
                        oldPass.value = !oldPass.value;
                      });
                    });
                  },
                  valueListenable:oldPass ,);
  }

  ValueListenableBuilder<dynamic> buildNewPassField() {
    return ValueListenableBuilder(
                    builder: (context, value, child) {
                      return getDefaultTextFiledWithLabel(
                          context, "New Password", newController, textColor,
                          function: () {},
                          height: FetchPixels.getPixelHeight(60),
                          isEnable: false,
                          withprefix: true,
                          image: "lock.svg",
                          withSufix: true,
                          isPass: newPass.value,
                          suffiximage: "eye.svg", imagefunction: () {
                        setState(() {
                          newPass.value = !newPass.value;
                        });
                      });
                    },
                    valueListenable:newPass );
  }

  ValueListenableBuilder<dynamic> buildConfirmPassField() {
    return ValueListenableBuilder(
                  builder: (context, value, child) {
                    return getDefaultTextFiledWithLabel(
                        context, "Confirm Password", confirmController, textColor,
                        function: () {},
                        height: FetchPixels.getPixelHeight(60),
                        isEnable: false,
                        withprefix: true,
                        image: "lock.svg",
                        withSufix: true,
                        isPass: confirmPass.value,
                        suffiximage: "eye.svg", imagefunction: () {
                      setState(() {
                        confirmPass.value = !confirmPass.value;
                      });
                    });
                  },
                  valueListenable: confirmPass, );
  }

  Widget buildDetailView() {
    return getPaddingWidget(
                    EdgeInsets.symmetric(
                        horizontal: FetchPixels.getPixelWidth(60)),
                    getMultilineCustomFont(
                        "We need your registration email for reset password!",
                        16,
                        Colors.black,
                        fontWeight: FontWeight.w400,

                        textAlign: TextAlign.center,
                        txtHeight: 1.3));
  }
}
