import 'package:baby_book/app/view/home/book/book_community_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../repository/book_repository.dart';
import '../repository/post_repository.dart';

class BookCommunityController extends GetxController with GetSingleTickerProviderStateMixin {
  final PostRepository postRepository;
  final BookRepository bookRepository;
  int bookId;
  String bookName;

  ///controller
  late PageController pageController = PageController(
    initialPage: position,
  );
  late TabController tabController;

  BookCommunityController(
      {required this.postRepository, required this.bookRepository, required this.bookId, required this.bookName}) {
    assert(postRepository != null);
    assert(bookRepository != null);
  }

  //loading
  final _loading = true.obs;

  get loading => _loading.value;

  set loading(value) => _loading.value = value;

  ///data
  late List<String> tabsList;
  late List<BookCommunityListScreen> widgetList;

  ///position
  final _position = 0.obs;

  get position => _position.value;

  set position(value) => _position.value = value;

  @override
  void onInit() async {
    super.onInit();
    loading = true;

    tabsList = [bookName];
    widgetList = [BookCommunityListScreen(bookId)];

    tabController = TabController(vsync: this, length: tabsList.length);
    // widgetList[0].controller.getAllForInit();

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
