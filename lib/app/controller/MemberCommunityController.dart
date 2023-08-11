import 'package:baby_book/app/view/community/post_type.dart';
import 'package:baby_book/app/view/profile/member_post_type.dart';
import 'package:baby_book/base/pref_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../repository/post_repository.dart';
import '../view/community/community_list_screen.dart';
import '../view/profile/member_community_list_screen.dart';

class MemberCommunityController extends GetxController with GetSingleTickerProviderStateMixin {
  final PostRepository postRepository;
  String memberId;

  ///나의 프로필인지 여부
  final _myProfile = false.obs;

  get myProfile => _myProfile.value;

  set myProfile(value) => _myProfile.value = value;

  ///controller
  late PageController pageController = PageController(
    initialPage: position,
  );
  late TabController tabController;

  MemberCommunityController({required this.postRepository, required this.memberId}) {
    assert(postRepository != null);
  }

  //loading
  final _loading = true.obs;

  get loading => _loading.value;

  set loading(value) => _loading.value = value;

  ///data
  late List<MemberPostType> memberPostTypeList;
  late List<String> tabsList;
  late List<MemberCommunityListScreen> widgetList;

  ///position
  final _position = 0.obs;

  get position => _position.value;

  set position(value) => _position.value = value;

  @override
  void onInit() async {
    super.onInit();
    loading = true;

    String? myMemberId = await PrefData.getMemberId();
    if (myMemberId == memberId) {
      myProfile = true;
      memberPostTypeList = MemberPostType.findMyProfile();
    } else {
      memberPostTypeList = MemberPostType.findAnotherPeopleProfile();
    }

    tabsList = memberPostTypeList.map((e) => e.desc).toList();
    widgetList = memberPostTypeList.map((e) => MemberCommunityListScreen(memberId, e)).toList();

    tabController = TabController(vsync: this, length: tabsList.length);
    widgetList[0].controller.getAllForInit(memberPostTypeList[0]);

    ///사용자경험 위해 0.2초 딜레이
    Future.delayed(const Duration(milliseconds: 500), () {
      loading = false;
    });
  }

  @override
  onClose() {
    pageController.dispose();
    tabController.dispose();
    super.onClose();
  }

  MemberPostType selectedMemberPostType() {
    return memberPostTypeList[position];
  }

  changePosition(MemberPostType meberPostType) async {
    int position = memberPostTypeList.indexOf(meberPostType);
    this.position = position;
    widgetList[position].initPageNumber();
    tabController.index = position;
    pageController.jumpToPage(position);
  }
}
