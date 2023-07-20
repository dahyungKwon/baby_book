import 'package:baby_book/app/models/model_member.dart';
import 'package:baby_book/app/view/home/bookcase/book_case_list_screen.dart';
import 'package:baby_book/base/pref_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../view/home/book/HoldType.dart';

class BookCaseController extends GetxController with GetSingleTickerProviderStateMixin {
  late String? memberId;
  late ModelMember member;
  bool myBookCase = false;

  late PageController pageController;

  late TabController tabController;
  var position = 0;
  List<String> tabsList = ["전체", "구매예정", "읽는중", "방출"];

  BookCaseController({required this.memberId});

  ///loading
  final _loading = false.obs;

  get loading => _loading.value;

  set loading(value) => _loading.value = value;

  ///북스크린
  final _bookCaseListScreenList = <BookCaseListScreen>[].obs;

  get bookCaseListScreenList => _bookCaseListScreenList.value;

  set bookCaseListScreenList(value) => _bookCaseListScreenList.value = value;

  @override
  void onInit() async {
    super.onInit();
    loading = true;

    tabController = TabController(length: tabsList.length, vsync: this);
    initPageController();

    String? myId = await PrefData.getMemberId();
    memberId = memberId ?? myId;
    myBookCase = myId == memberId;

    bookCaseListScreenList.clear();
    bookCaseListScreenList.addAll([
      BookCaseListScreen(memberId: memberId, holdType: HoldType.all),
      BookCaseListScreen(memberId: memberId, holdType: HoldType.plan),
      BookCaseListScreen(memberId: memberId, holdType: HoldType.read),
      BookCaseListScreen(memberId: memberId, holdType: HoldType.end)
    ]);

    Future.delayed(const Duration(milliseconds: 200), () {
      loading = false;
    });
  }

  void initPageController() {
    pageController = PageController(
      initialPage: position,
    );
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (pageController != null) {
    //     pageController.jumpToPage(position);
    //   }
    // });
  }
}
