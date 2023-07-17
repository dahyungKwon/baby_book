import 'dart:io';

import 'package:baby_book/app/models/model_member.dart';
import 'package:baby_book/app/repository/baby_repository.dart';
import 'package:baby_book/app/repository/member_repository.dart';
import 'package:baby_book/app/view/login/gender_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../base/pref_data.dart';
import '../models/model_baby.dart';
import '../routes/app_pages.dart';
import '../view/dialog/error_dialog.dart';
import '../view/dialog/re_confirm_dialog.dart';
import '../view/login/baby_dialog.dart';
import '../view/login/gender_type_bottom_sheet.dart';

class TabProfileController extends GetxController {
  final MemberRepository memberRepository;
  final BabyRepository babyRepository;

  String? targetMemberId;
  bool myProfile = false;

  //member
  final _member = ModelMember.createForObsInit().obs;

  get member => _member.value;

  set member(value) => _member.value = value;

  //baby
  final _babyList = <ModelBaby>[].obs;

  get babyList => _babyList.value;

  set babyList(value) => _babyList.value = value;

  //loading
  final _loading = false.obs;

  get loading => _loading.value;

  set loading(value) => _loading.value = value;

  TabProfileController({required this.memberRepository, required this.babyRepository, required this.targetMemberId}) {
    assert(memberRepository != null);
    assert(babyRepository != null);
  }

  @override
  void onInit() async {
    super.onInit();
    init();
  }

  init() async {
    loading = true;

    targetMemberId ??= await PrefData.getMemberId();

    member = await MemberRepository.getMember(memberId: targetMemberId!);
    if (targetMemberId! == member.memberId) {
      myProfile = true;
    }

    babyList = await BabyRepository.getBabyList(memberId: targetMemberId!);

    refresh();
    Future.delayed(const Duration(milliseconds: 200), () {
      loading = false;
    });
  }

  getBabyToString() {
    String str = "";
    for (int i = 0; i < babyList.length; i++) {
      str += "#${babyList[i].getBirthdayToString()}  ";
    }
    return str;
  }

  updateProfile(ModelMember updateMember, List<ModelBaby> updateBabyList) {
    member.nickName = updateMember.nickName;
    member.gender = updateMember.gender;
    member.contents = updateMember.contents;
    member.selectedBabyId = updateMember.selectedBabyId;

    babyList = updateBabyList;
    _member.refresh();
    _babyList.refresh();
  }
}
