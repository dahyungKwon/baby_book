import 'package:baby_book/app/models/model_member.dart';
import 'package:baby_book/app/view/home/bookcase/book_case_list_screen.dart';
import 'package:baby_book/base/pref_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../view/home/book/HoldType.dart';
import 'BookCaseListController.dart';

class BookCaseController extends GetxController with GetSingleTickerProviderStateMixin {
  late String? memberId;
  late ModelMember member;

  late PageController pageController = PageController(
    initialPage: 0,
  );

  late TabController tabController;
  List<HoldType> tabsList = HoldType.findListForTab();
  late List<BookCaseListScreen> widgetList = [];

  BookCaseController({required this.memberId});

  ///myBookCase
  final _myBookCase = true.obs; //깜빡거려서 true를 디폴트로함

  get myBookCase => _myBookCase.value;

  set myBookCase(value) => _myBookCase.value = value;

  ///loading
  final _loading = true.obs;

  get loading => _loading.value;

  set loading(value) => _loading.value = value;

  ///position
  final _position = 0.obs;

  get position => _position.value;

  set position(value) => _position.value = value;

  @override
  void onInit() async {
    super.onInit();
    loading = true;

    tabController = TabController(length: tabsList.length, vsync: this);
    String? myId = await PrefData.getMemberId();
    memberId = memberId ?? myId;
    myBookCase = myId == memberId;

    ///이 방법 말고는 없는가..?
    Get.delete<BookCaseListController>(tag: memberId);
    widgetList = tabsList.map((e) => BookCaseListScreen(memberId: memberId, holdType: e)).toList();

    Future.delayed(const Duration(milliseconds: 500), () {
      loading = false;
    });
  }
}
