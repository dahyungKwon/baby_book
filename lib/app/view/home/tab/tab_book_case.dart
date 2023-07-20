import 'package:baby_book/app/repository/baby_repository.dart';
import 'package:baby_book/app/repository/member_repository.dart';
import 'package:baby_book/app/repository/my_book_repository.dart';
import 'package:baby_book/base/color_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../../../base/uuid_util.dart';
import '../../../controller/BookCaseController.dart';
import '../bookcase/book_case_layout.dart';

class TabBookCase extends GetView<BookCaseController> {
  late final String? memberId;
  late final String? uniqueTag;

  TabBookCase({super.key}) {
    memberId = Get.parameters["memberId"];
    uniqueTag = getUuid();

    Get.put(BookCaseController(memberId: null), tag: uniqueTag);
  }

  @override
  String? get tag => uniqueTag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backGroundColor,
      body: Obx(
        () => buildBookCaseLayout(context, controller),
      ),
    );
  }
}
