import 'package:baby_book/base/color_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/BookCaseController.dart';
import '../bookcase/book_case_layout.dart';

class TabBookCase extends GetView<BookCaseController> {
  const TabBookCase({super.key});

  @override
  Widget build(BuildContext context) {
    Get.delete<BookCaseController>();
    Get.put(BookCaseController(memberId: null));

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: backGroundColor,
        body: buildBookCaseLayout(context, controller));
  }
}
