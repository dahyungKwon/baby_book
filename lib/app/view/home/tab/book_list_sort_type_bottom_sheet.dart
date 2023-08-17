import 'package:baby_book/app/view/home/tab/book_list_sort_type.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sizer/sizer.dart';

import '../../../../base/resizer/fetch_pixels.dart';
import '../../dialog/error_dialog.dart';

class BookListSortTypeBottomSheet extends StatefulWidget {
  final BookListSortType bookListSortType;

  const BookListSortTypeBottomSheet({required this.bookListSortType, Key? key}) : super(key: key);

  @override
  State<BookListSortTypeBottomSheet> createState() => _BookListSortTypeBottomSheetState();
}

class _BookListSortTypeBottomSheetState extends State<BookListSortTypeBottomSheet> {
  BookListSortType? selectedBookListSortType;

  @override
  void initState() {
    super.initState();
    selectedBookListSortType = widget.bookListSortType;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 14.h,
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.only(left: FetchPixels.getPixelHeight(15), right: FetchPixels.getPixelWidth(15)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getVerSpace(FetchPixels.getPixelHeight(10)),
              Container(
                color: Colors.white,
                child: Wrap(
                  children: [
                    _BookListSortTypeBottomSheetPicker(
                        bookListSortTypeList: BookListSortType.values,
                        selectedBookListSortType: selectedBookListSortType!,
                        bookListSortTypeBottomSheetSetter: (BookListSortType bookListSortType) {
                          setState(() {
                            selectedBookListSortType = bookListSortType;
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

typedef BookListSortTypeBottomSheetSetter = void Function(BookListSortType bookListSortType);

class _BookListSortTypeBottomSheetPicker extends StatelessWidget {
  final List<BookListSortType> bookListSortTypeList;
  final BookListSortType selectedBookListSortType;
  final BookListSortTypeBottomSheetSetter bookListSortTypeBottomSheetSetter;

  const _BookListSortTypeBottomSheetPicker(
      {required this.bookListSortTypeList,
      required this.selectedBookListSortType,
      required this.bookListSortTypeBottomSheetSetter,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: bookListSortTypeList.map((e) => render(context, e, selectedBookListSortType == e)).toList(),
    );
  }

  Widget render(BuildContext context, BookListSortType bookListSortType, bool isSelected) {
    return Row(children: [
      Expanded(
          child: RadioListTile<BookListSortType>(
              visualDensity: const VisualDensity(
                horizontal: VisualDensity.minimumDensity,
                vertical: VisualDensity.minimumDensity,
              ),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              contentPadding: EdgeInsets.zero,
              title: Row(children: [
                Text(bookListSortType.desc),
                if (bookListSortType == BookListSortType.hot) ...[
                  getHorSpace(FetchPixels.getPixelWidth(6)),
                  GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: FetchPixels.getPixelHeight(30),
                        height: FetchPixels.getPixelHeight(50),
                        // color: Colors.blueAccent,
                        child: getSimpleImageButton(
                            "alert_noti.svg",
                            FetchPixels.getPixelHeight(50),
                            FetchPixels.getPixelHeight(50),
                            Colors.white,
                            FetchPixels.getPixelHeight(23),
                            FetchPixels.getPixelHeight(23), () async {
                          Get.dialog(ErrorDialog("인기도의 경우는 대형 포탈사의 검색량, 리뷰데이터 등을 기준으로 평가하여 산정됩니다."));
                        }),
                      ))
                ]
              ]),
              value: bookListSortType,
              activeColor: Colors.black,
              groupValue: selectedBookListSortType,
              onChanged: (BookListSortType? bookListSortType) {
                bookListSortTypeBottomSheetSetter(bookListSortType!);
                Navigator.pop(context, bookListSortType);
              })),
    ]);
  }
}
