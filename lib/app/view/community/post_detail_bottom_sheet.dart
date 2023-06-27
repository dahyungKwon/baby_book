import 'package:baby_book/app/view/community/post_type.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../base/pref_data.dart';
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
        padding: EdgeInsets.all(FetchPixels.getPixelHeight(10)),
        child: Wrap(
            children: selectedMenuList
                .map((e) => GestureDetector(
                    onTap: () {
                      Navigator.pop(context, e);
                    },
                    child: Container(
                        height: FetchPixels.getPixelHeight(40),
                        // color: Colors.green,
                        padding: const EdgeInsets.only(left: 15),
                        margin: EdgeInsets.only(bottom: 10),
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

typedef PostDetailBottomSheetSetter = void Function(String menu);

class _PostDetailBottomSheetPicker extends StatelessWidget {
  final List<String> postDetailMenuList = ["공유하기, " "수정하기", "제거하기"];
  final PostDetailBottomSheetSetter postDetailBottomSheetSetter;

  _PostDetailBottomSheetPicker({required this.postDetailBottomSheetSetter, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: postDetailMenuList.map((e) => renderMenu(context, e)).toList(),
    );
  }

  Widget renderMenu(BuildContext context, String menu) {
    return RadioListTile<String>(
        visualDensity: const VisualDensity(
          horizontal: VisualDensity.minimumDensity,
          vertical: VisualDensity.minimumDensity,
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        contentPadding: EdgeInsets.zero,
        title: Text(menu),
        value: menu,
        activeColor: Colors.black,
        groupValue: menu,
        onChanged: (String? menu) {
          postDetailBottomSheetSetter(menu!);
          Navigator.pop(context, menu);
        });
  }
}
