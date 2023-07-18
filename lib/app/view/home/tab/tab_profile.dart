import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../base/color_data.dart';
import '../../../controller/ProfileController.dart';
import '../../../repository/baby_repository.dart';
import '../../../repository/member_repository.dart';
import '../../profile/profile_layout.dart';

class TabProfile extends GetView<ProfileController> {
  const TabProfile({super.key});

  @override
  Widget build(BuildContext context) {
    Get.delete<ProfileController>();
    Get.put(ProfileController(
        memberRepository: MemberRepository(), babyRepository: BabyRepository(), targetMemberId: null));

    FetchPixels(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: backGroundColor,
        body: Obx(() => SafeArea(
            child: buildProfileLayout(
                context, controller.loading, controller.member, controller.myProfile, controller.getBabyToString()))));
  }
}
