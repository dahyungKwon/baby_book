import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../base/resizer/fetch_pixels.dart';

class BookDetailBottomSheet extends StatefulWidget {
  bool myBook;

  BookDetailBottomSheet({required this.myBook, Key? key}) : super(key: key);

  @override
  State<BookDetailBottomSheet> createState() => _BookDetailBottomSheetState(myBook);
}

class _BookDetailBottomSheetState extends State<BookDetailBottomSheet> {
  late List<String> menuList;
  bool myBook;

  _BookDetailBottomSheetState(this.myBook) {
    if (myBook) {
      menuList = ["책 공유하기", "경험 수정하기", "책장에서 삭제하기"];
    } else {
      menuList = ["책 공유하기"];
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.all(FetchPixels.getPixelHeight(5)),
        child: Wrap(
            children: menuList
                .map((e) => GestureDetector(
                    onTap: () {
                      Navigator.pop(context, e);
                    },
                    child: Container(
                        width: 100.w,
                        height: FetchPixels.getPixelHeight(50),
                        color: Colors.white,
                        padding: const EdgeInsets.only(left: 15),
                        margin: const EdgeInsets.only(bottom: 5),
                        // decoration: const BoxDecoration(
                        //     color: Colors.white, border: Border(bottom: BorderSide(color: Color(0xfff1f1f1), width: 0.8))),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(e,
                                style:
                                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black))))))
                .toList()));
  }
}
