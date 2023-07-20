import 'package:baby_book/base/color_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../base/skeleton.dart';
import '../../../../base/uuid_util.dart';
import '../../../controller/BookCaseController.dart';
import '../bookcase/book_case_layout.dart';

class TabBookCase extends GetView<BookCaseController> {
  late final String? memberId;
  late final String? uniqueTag;

  TabBookCase({super.key}) {
    memberId = Get.parameters["memberId"];
    uniqueTag = getUuid();

    // Get.delete<BookCaseController>(tag: uniqueTag);
    Get.put(BookCaseController(memberId: null), tag: uniqueTag);
  }

  @override
  String? get tag => uniqueTag;

  @override
  Widget build(BuildContext context) {
    controller.initPageController();

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: backGroundColor,
        body: buildBookCaseLayout(context, controller));
  }
}
