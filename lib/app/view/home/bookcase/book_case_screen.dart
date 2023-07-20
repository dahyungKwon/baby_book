import 'package:baby_book/base/color_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../base/skeleton.dart';
import '../../../../base/uuid_util.dart';
import '../../../controller/BookCaseController.dart';
import '../bookcase/book_case_layout.dart';

class BookCaseScreen extends GetView<BookCaseController> {
  late final String? memberId;
  late final String? uniqueTag;

  BookCaseScreen({super.key}) {
    memberId = Get.parameters["memberId"];
    uniqueTag = getUuid();
    // Get.delete<BookCaseController>(tag: uniqueTag);
    Get.put(BookCaseController(memberId: memberId), tag: uniqueTag);
  }

  @override
  String? get tag => uniqueTag;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Get.back();
          return false;
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: backGroundColor,
            body: SafeArea(child: buildBookCaseLayout(context, controller))));
  }
}
