import 'package:baby_book/app/view/profile/member_post_type.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../repository/post_repository.dart';
import '../view/profile/member_community_list_screen.dart';

class MemberCommunityController extends GetxController with GetSingleTickerProviderStateMixin {
  final PostRepository postRepository;
  String memberId;
  bool myProfile;

  ///controller
  late PageController pageController = PageController(
    initialPage: position,
  );
  late TabController tabController = TabController(length: 0, vsync: this);

  //loading
  final _loading = true.obs;

  get loading => _loading.value;

  set loading(value) => _loading.value = value;

  ///data
  late List<MemberPostType> memberPostTypeList;
  late List<String> tabsList;
  late List<MemberCommunityListScreen> widgetList = [];

  ///position
  final _position = 0.obs;

  get position => _position.value;

  set position(value) => _position.value = value;

  MemberCommunityController({required this.postRepository, required this.memberId, required this.myProfile}) {
    assert(postRepository != null);
    if (myProfile) {
      memberPostTypeList = MemberPostType.findMyProfile();
    } else {
      memberPostTypeList = MemberPostType.findAnotherPeopleProfile();
    }

    tabsList = memberPostTypeList.map((e) => e.desc).toList();
    tabController = TabController(vsync: this, length: tabsList.length);
    widgetList = memberPostTypeList.map((e) => MemberCommunityListScreen(memberId, e)).toList();
  }

  @override
  void onInit() async {
    super.onInit();
    loading = true;

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
