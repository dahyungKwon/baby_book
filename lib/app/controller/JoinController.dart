import 'package:baby_book/app/models/model_book_response.dart';
import 'package:baby_book/app/repository/book_repository.dart';
import 'package:baby_book/app/repository/comment_repository.dart';
import 'package:baby_book/app/repository/member_repository.dart';
import 'package:baby_book/app/repository/my_book_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../base/pref_data.dart';
import '../exception/exception_invalid_member.dart';
import '../models/model_comment_response.dart';
import '../models/model_my_book.dart';
import '../routes/app_pages.dart';
import '../view/dialog/error_dialog.dart';

class JoinController extends GetxController {
  final MemberRepository memberRepository;

  //loading
  final _loading = false.obs;

  get loading => _loading.value;

  set loading(value) => _loading.value = value;

  JoinController({required this.memberRepository}) {
    assert(memberRepository != null);
  }

  @override
  void onInit() async {
    super.onInit();
    init();
  }

  init() async {
    loading = true;

    Future.delayed(const Duration(milliseconds: 200), () {
      loading = false;
    });
  }
}
