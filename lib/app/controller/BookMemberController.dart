import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../view/home/book/book_member_list_screen.dart';

class BookMemberController extends GetxController with GetSingleTickerProviderStateMixin {
  int bookId;
  String bookName;

  ///controller
  late PageController pageController = PageController(
    initialPage: position,
  );
  late TabController tabController;

  BookMemberController({required this.bookId, required this.bookName});

  //loading
  final _loading = false.obs;

  get loading => _loading.value;

  set loading(value) => _loading.value = value;

  ///data
  late List<String> tabsList;
  late List<BookMemberListScreen> widgetList;

  ///position
  final _position = 0.obs;

  get position => _position.value;

  set position(value) => _position.value = value;

  @override
  void onInit() async {
    super.onInit();
    loading = true;

    tabsList = [bookName];
    widgetList = [BookMemberListScreen(bookId)];

    tabController = TabController(vsync: this, length: tabsList.length);
    widgetList[0].controller.getAllForInit();

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
}
