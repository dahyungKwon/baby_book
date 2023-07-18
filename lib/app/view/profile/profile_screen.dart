import 'package:baby_book/app/view/profile/profile_layout.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../base/color_data.dart';
import '../../controller/ProfileController.dart';
import '../../repository/baby_repository.dart';
import '../../repository/member_repository.dart';

class ProfileScreen extends GetView<ProfileController> {
  late final String? memberId;
  late final String? uniqueTag;

  ProfileScreen({super.key}) {
    memberId = Get.parameters["memberId"];
    uniqueTag = memberId;

    Get.put(
        ProfileController(
            memberRepository: MemberRepository(), babyRepository: BabyRepository(), targetMemberId: memberId),
        tag: uniqueTag);
  }

  @override
  String? get tag => uniqueTag;

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: backGroundColor,
        body: Obx(() => SafeArea(
            child: buildProfileLayout(
                context, controller.loading, controller.member, controller.myProfile, controller.getBabyToString()))));
  }
}
