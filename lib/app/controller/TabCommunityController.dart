import 'package:baby_book/app/view/community/post_type.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabCommunityController extends GetxController with GetSingleTickerProviderStateMixin {
  final PageController pageController = PageController(
    initialPage: 0,
  );
  List<PostType> postTypeList = PostType.values;
  List<String> tabsList = PostType.findDescList();
  late TabController tabController;

  ///position
  final _position = 0.obs;

  get position => _position.value;

  set position(value) => _position.value = value;

  TabCommunityController() {
    print("TabCommunityController constructor");
  }

  @override
  void onInit() {
    tabController = TabController(vsync: this, initialIndex: 0, length: tabsList.length);
    super.onInit();
  }

  @override
  onClose() {
    tabController.dispose();
    super.onClose();
  }
}
