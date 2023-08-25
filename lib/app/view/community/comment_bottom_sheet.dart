import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../base/resizer/fetch_pixels.dart';
import 'package:flutter/foundation.dart' as foundation;

class CommentBottomSheet extends StatefulWidget {
  late bool myComment;

  CommentBottomSheet({Key? key, required this.myComment}) : super(key: key);

  @override
  State<CommentBottomSheet> createState() => _CommentBottomSheetState(myComment);
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  late bool myComment;
  List<String> selectedMenuList = [];
  List<String> noMyCommentList = ["신고하기"];
  List<String> myMenuList = ["수정하기", "삭제하기"];

  _CommentBottomSheetState(this.myComment);

  @override
  void initState() {
    super.initState();

    if (myComment) {
      selectedMenuList.addAll(myMenuList);
    } else {
      selectedMenuList.addAll(noMyCommentList);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        margin: EdgeInsets.only(
            bottom:
            FetchPixels.getPixelHeight(foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS ? 20 : 5)),
        padding: EdgeInsets.all(FetchPixels.getPixelHeight(5)),
        child: Wrap(
            children: selectedMenuList
                .map((e) => GestureDetector(
                    onTap: () {
                      Navigator.pop(context, e);
                    },
                    child: Container(
                        width: 100.w,
                        height: FetchPixels.getPixelHeight(50),
                        color: Colors.white,
                        padding: const EdgeInsets.only(left: 15),
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
