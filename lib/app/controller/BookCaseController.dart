import 'package:baby_book/app/exception/exception_invalid_member.dart';
import 'package:baby_book/app/models/model_book.dart';
import 'package:baby_book/app/models/model_member.dart';
import 'package:baby_book/app/repository/baby_repository.dart';
import 'package:baby_book/app/repository/member_repository.dart';
import 'package:baby_book/app/routes/app_pages.dart';
import 'package:baby_book/app/view/home/book/category_type.dart';
import 'package:baby_book/base/pref_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../models/model_age_group.dart';
import '../models/model_baby.dart';
import '../models/model_book_response.dart';
import '../models/model_my_book.dart';
import '../repository/book_repository.dart';
import '../repository/my_book_repository.dart';
import '../repository/paging_request.dart';

class BookCaseController extends GetxController with GetSingleTickerProviderStateMixin {
  late String? memberId;
  late ModelMember member;

  final PageController pageController = PageController(
    initialPage: 0,
  );

  late TabController tabController;
  var position = 0;
  List<String> tabsList = ["전체", "구매예정", "읽는중", "방출"];

  BookCaseController({required this.memberId});

  ///loading
  final _loading = false.obs;

  get loading => _loading.value;

  set loading(value) => _loading.value = value;

  @override
  void onInit() async {
    super.onInit();
    tabController = TabController(length: tabsList.length, vsync: this);
    memberId = memberId ?? await PrefData.getMemberId();
  }
}
