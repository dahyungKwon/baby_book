import 'package:baby_book/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../base/resizer/fetch_pixels.dart';
import 'birth_date_picker.dart';

class BirthBottomSheet extends StatefulWidget {
  DateTime? birth;

  BirthBottomSheet({this.birth, Key? key}) : super(key: key);

  @override
  State<BirthBottomSheet> createState() => _BirthBottomSheetState();
}

class _BirthBottomSheetState extends State<BirthBottomSheet> {
  late DateTime birth;

  @override
  void initState() {
    super.initState();
    birth = widget.birth ?? DateTime(2022, 01, 01);
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
              getVerSpace(FetchPixels.getPixelHeight(20)),
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
              getVerSpace(FetchPixels.getPixelHeight(30)),
              Container(
                color: Colors.white,
                child: Wrap(
                  children: [
                    BirthDatePicker(
                      onDateTimeChanged: (dateTime) {
                        birth = dateTime;
                      },
                      initDateStr: DateFormat('yyyy-MM-dd').format(birth),
                    )
                  ],
                ),
              ),
              getVerSpace(FetchPixels.getPixelHeight(10)),
              getSimpleTextButton("확인", 18, Colors.black, Colors.white, FontWeight.w500,
                  FetchPixels.getPixelHeight(double.infinity), FetchPixels.getPixelHeight(50), () {
                Navigator.pop(context, birth);
              })
            ],
          ),
        ));
  }
}
