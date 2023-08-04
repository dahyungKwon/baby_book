import 'package:baby_book/app/models/model_my_book.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../../base/resizer/fetch_pixels.dart';
import '../../../controller/BookExperienceBottomSheetController.dart';
import '../../../repository/my_book_repository.dart';

class BookExperienceBottomSheet extends GetView<BookExperienceBottomSheetController> {
  BookExperienceBottomSheet({super.key, required ModelMyBook mybook}) {
    Get.delete<BookExperienceBottomSheetController>();
    Get.put(BookExperienceBottomSheetController(myBookRepository: MyBookRepository(), mybook: mybook));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 40.h,
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.only(left: FetchPixels.getPixelHeight(15), right: FetchPixels.getPixelWidth(15)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                getHorSpace(FetchPixels.getPixelHeight(10)),
                getCustomFont(
                  "생일을 입력해주세요.",
                  18,
                  Colors.black,
                  1,
                  fontWeight: FontWeight.w500,
                )
              ]),
              getVerSpace(FetchPixels.getPixelHeight(10)),
              getSimpleTextButton("확인", 18, Colors.black, Colors.white, FontWeight.w500,
                  FetchPixels.getPixelHeight(double.infinity), FetchPixels.getPixelHeight(50), () {
                // Navigator.pop(context, birth);
              })
            ],
          ),
        ));
  }
}
