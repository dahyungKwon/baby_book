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

  late PageController pageController;

  late TabController tabController;
  var position = 0;
  List<String> tabsList = ["전체", "구매예정", "읽는중", "방출"];

  BookCaseController({required this.memberId});

  ///myBookCase
  final _myBookCase = false.obs;

  get myBookCase => _myBookCase.value;

  set myBookCase(value) => _myBookCase.value = value;

  ///loading
  final _loading = false.obs;

  get loading => _loading.value;

  set loading(value) => _loading.value = value;

  @override
  void onInit() async {
    super.onInit();
    loading = true;

    tabController = TabController(length: tabsList.length, vsync: this);
    initPageController();

    String? myId = await PrefData.getMemberId();
    memberId = memberId ?? myId;
    myBookCase = myId == memberId;

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
