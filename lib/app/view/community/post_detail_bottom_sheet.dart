import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../base/resizer/fetch_pixels.dart';
import '../../models/model_post.dart';

class PostDetailBottomSheet extends StatefulWidget {
  late ModelPost post;
  late bool myPost;

  PostDetailBottomSheet(this.post, this.myPost, {Key? key}) : super(key: key);

  @override
  State<PostDetailBottomSheet> createState() => _PostDetailBottomSheetState(post, myPost);
}

class _PostDetailBottomSheetState extends State<PostDetailBottomSheet> {
  late ModelPost post;
  bool myPost = false;
  List<String> selectedMenuList = [];
  List<String> commonMenuList = ["공유하기"];
  List<String> myMenuList = ["수정하기", "삭제하기"];

  _PostDetailBottomSheetState(this.post, this.myPost);

  @override
  void initState() {
    super.initState();
    selectedMenuList.addAll(commonMenuList);

    if (myPost) {
      selectedMenuList.addAll(myMenuList);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
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
