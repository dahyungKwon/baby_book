import 'dart:ffi';

import 'package:baby_book/app/controller/BookDetailController.dart';
import 'package:baby_book/app/data/data_file.dart';
import 'package:baby_book/app/models/model_book.dart';
import 'package:baby_book/app/repository/member_repository.dart';
import 'package:baby_book/app/repository/my_book_repository.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:intl/intl.dart';
import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../base/color_data.dart';
import '../../../../base/constant.dart';
import '../../../../base/skeleton.dart';
import '../../controller/JoinController.dart';

class JoinScreen extends GetView<JoinController> {
  JoinScreen({super.key}) {
    Get.delete<JoinController>();
    Get.put(JoinController(memberRepository: MemberRepository()));
  }

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    double defHorSpace = FetchPixels.getDefaultHorSpace(context);
    EdgeInsets edgeInsets = EdgeInsets.symmetric(horizontal: defHorSpace);
    return WillPopScope(
        onWillPop: () async {
          Get.back();
          return false;
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: backGroundColor,
            body: Obx(
              () => SafeArea(
                child: controller.loading
                    ? const FullSizeSkeleton()
                    : Column(
                        children: [
                          buildToolbar(context),
                          getVerSpace(FetchPixels.getPixelHeight(10)),
                          buildMainArea(context, edgeInsets, defHorSpace)
                        ],
                      ),
              ),
            )));
  }

  Widget buildToolbar(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(5, 10, 0, 0),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            getSimpleImageButton("back_outline.svg", FetchPixels.getPixelHeight(50), FetchPixels.getPixelHeight(50),
                Colors.white, FetchPixels.getPixelHeight(26), FetchPixels.getPixelHeight(26), () async {
              Get.back();
            }),
            getCustomFont(
              "회원가입",
              22,
              Colors.black,
              1,
              fontWeight: FontWeight.w600,
            ),
          ],
        ));
  }

  Expanded buildMainArea(BuildContext context, EdgeInsets edgeInsets, double defHorSpace) {
    return Expanded(
      flex: 1,
      child: ListView(
        primary: true,
        shrinkWrap: true,
        children: [],
      ),
    );
  }
}
