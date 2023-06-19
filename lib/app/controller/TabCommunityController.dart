import 'package:baby_book/app/view/community/post_type.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../view/community/community_list_screen.dart';

class TabCommunityController extends GetxController with GetSingleTickerProviderStateMixin {
  ///controller
  late PageController pageController = PageController(
    initialPage: position,
  );
  late TabController tabController;

  ///data
  List<PostType> postTypeList = PostType.findListViewList();
  late List<String> tabsList = postTypeList.map((e) => e.desc).toList();
  late List<CommunityListScreen> widgetList = postTypeList.map((e) => CommunityListScreen(e)).toList();

  ///position
  final _position = 0.obs;

  get position => _position.value;

  set position(value) => _position.value = value;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(vsync: this, length: tabsList.length);
    widgetList[0].controller.getAllForInit(postTypeList[0]);
  }

  @override
  onClose() {
    pageController.dispose();
    tabController.dispose();
    super.onClose();
  }

  PostType selectedPostType() {
    return postTypeList[position];
  }

  changePosition(PostType postType) async {
    int position = postTypeList.indexOf(postType);
    this.position = position;
    widgetList[position].initPageNumber();
    tabController.index = position;
    pageController.jumpToPage(position);
  }
}
