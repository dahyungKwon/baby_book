import 'package:baby_book/app/view/home/book/UsedType.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../base/resizer/fetch_pixels.dart';

class MonthBottomSheet extends StatefulWidget {
  int month;
  bool inMonth;

  MonthBottomSheet({required this.month, required this.inMonth, Key? key}) : super(key: key);

  @override
  State<MonthBottomSheet> createState() => _MonthBottomSheet();
}

class _MonthBottomSheet extends State<MonthBottomSheet> {
  late int selectedMonth;
  late bool selectedInMonth;

  @override
  void initState() {
    super.initState();
    selectedMonth = widget.month;
    selectedInMonth = widget.inMonth;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 35.h,
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.only(left: FetchPixels.getPixelHeight(15), right: FetchPixels.getPixelWidth(15)),
          child: Column(
            children: [
              getVerSpace(FetchPixels.getPixelHeight(20)),
              Row(children: [
                getHorSpace(FetchPixels.getPixelHeight(10)),
                getCustomFont(
                  selectedInMonth ? "시작 개월수를 선택해주세요." : "종료 개월수를 선택해주세요.",
                  18,
                  Colors.black,
                  1,
                  fontWeight: FontWeight.w500,
                )
              ]),
              getVerSpace(FetchPixels.getPixelHeight(10)),
              Container(
                color: Colors.white,
                child: Wrap(
                  children: [
                    _MonthBottomSheetPicker(
                        selectedMonth: selectedMonth!,
                        monthBottomSheetSetter: (int month) {
                          setState(() {
                            selectedMonth = month;
                          });
                        })
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

typedef MonthBottomSheetSetter = void Function(int month);

class _MonthBottomSheetPicker extends StatelessWidget {
  late int selectedMonth;
  final MonthBottomSheetSetter monthBottomSheetSetter;
  late FixedExtentScrollController monthPickerScrollController;

  _MonthBottomSheetPicker({required this.selectedMonth, required this.monthBottomSheetSetter, Key? key}) {
    ///해당 책이나 선택된 베이비 기준으로할 수 있다.
    ///현재는 12개월로 디폴트 잡아둠
    if (selectedMonth == null || selectedMonth == 0) {
      selectedMonth = 12;
    }

    monthPickerScrollController = FixedExtentScrollController(initialItem: selectedMonth);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Padding(
        //   padding: const EdgeInsets.symmetric(vertical: 15),
        //   child: Text(
        //     selectedMonth == 0 ? "" : "$selectedMonth개월",
        //     // style: theme.textTheme.bodyText1!
        //     //     .copyWith(color: Colors.teal, fontSize: 32),
        //   ),
        // ),
        Container(
          width: FetchPixels.getPixelHeight(200),
          height: FetchPixels.getPixelHeight(200),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
          child: CupertinoPicker.builder(
              itemExtent: 50,
              childCount: 14 * 12 + 1,
              scrollController: monthPickerScrollController,
              onSelectedItemChanged: (i) {
                monthBottomSheetSetter(i);
                // Navigator.pop(context, i);
              },
              itemBuilder: (context, index) {
                return Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "$index 개월",
                    ),
                    Text(
                      " 만${calAge(index)}세",
                      style: TextStyle(color: Colors.black45, fontSize: 13),
                    )
                  ],
                )
                    // style: theme.textTheme.bodyText1!
                    //     .copyWith(color: Colors.white, fontSize: 25),
                    );
              }),
        ),
        getSimpleTextButton("확인", 18, Colors.black, Colors.white, FontWeight.w500,
            FetchPixels.getPixelHeight(double.infinity), FetchPixels.getPixelHeight(50), () {
          Navigator.pop(context, selectedMonth);
        })
      ],
    );
  }

  int calAge(int month) {
    ///0~11 => 만 0세 month / 12
    ///12~23 => 만 1세
    ///24~36 => 만 2세
    return month ~/ 12;
  }

// Widget render(BuildContext context, UsedType usedType, bool isSelected) {
//   return RadioListTile<UsedType>(
//       visualDensity: const VisualDensity(
//         horizontal: VisualDensity.minimumDensity,
//         vertical: VisualDensity.minimumDensity,
//       ),
//       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//       contentPadding: EdgeInsets.zero,
//       title: Text(usedType.desc),
//       value: usedType,
//       activeColor: Colors.black,
//       groupValue: selectedUsedType,
//       onChanged: (UsedType? usedType) {
//         usedTypeBottomSheetSetter(usedType!);
//         Navigator.pop(context, usedType);
//       });
// }
}
