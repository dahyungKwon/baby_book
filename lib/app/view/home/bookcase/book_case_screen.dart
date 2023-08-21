import 'package:baby_book/base/color_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../base/uuid_util.dart';
import '../../../controller/BookCaseController.dart';
import '../bookcase/book_case_layout.dart';

class BookCaseScreen extends GetView<BookCaseController> {
  late final String? memberId;
  late final String? uniqueTag;

  BookCaseScreen({super.key}) {
    memberId = Get.parameters["memberId"];
    uniqueTag = getUuid();
  }

  @override
  String? get tag => uniqueTag;

  @override
  Widget build(BuildContext context) {
    Get.delete<BookCaseController>(tag: uniqueTag);
    Get.put(BookCaseController(memberId: memberId), tag: uniqueTag);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: backGroundColor,
        body: SafeArea(child: buildBookCaseLayout(context, controller)));
  }
}
