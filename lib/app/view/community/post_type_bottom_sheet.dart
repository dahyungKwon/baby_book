import 'package:baby_book/app/view/community/post_type.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PostTypeBottomSheet extends StatefulWidget {
  final PostType postType;

  const PostTypeBottomSheet({required this.postType, Key? key}) : super(key: key);

  @override
  State<PostTypeBottomSheet> createState() => _PostTypeBottomSheetState();
}

class _PostTypeBottomSheetState extends State<PostTypeBottomSheet> {
  PostType? selectedPostType;

  @override
  void initState() {
    super.initState();
    selectedPostType = widget.postType;
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SizedBox(
      height: 100.h / 4 + bottomInset,
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          getCustomFont(
            "글타입",
            18,
            Colors.black,
            1,
            fontWeight: FontWeight.w700,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 7),
            color: Colors.white,
            child: Wrap(
              children: [
                _PostTypeBottomSheetPicker(
                    postTypeList: PostType.findAddViewList(),
                    selectedPostType: selectedPostType!,
                    postTypeBottomSheetSetter: (PostType postType) {
                      setState(() {
                        selectedPostType = postType;
                      });
                    })
              ],
            ),
          ),
        ],
      ),
    );
  }
}

typedef PostTypeBottomSheetSetter = void Function(PostType postType);

class _PostTypeBottomSheetPicker extends StatelessWidget {
  final List<PostType> postTypeList;
  final PostType selectedPostType;
  final PostTypeBottomSheetSetter postTypeBottomSheetSetter;

  const _PostTypeBottomSheetPicker(
      {required this.postTypeList, required this.selectedPostType, required this.postTypeBottomSheetSetter, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 20.0,
      runSpacing: 10.0,
      children: postTypeList
          .map(
            (e) => GestureDetector(
              onTap: () {
                postTypeBottomSheetSetter(e!);
                Navigator.pop(context, e);
              },
              child: renderPostType(e, selectedPostType == e),
            ),
          )
          .toList(),
    );
  }

  Widget renderPostType(PostType postType, bool isSelected) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
          color: Colors.black12,
          border: isSelected ? Border.all(color: Colors.blue, width: 4.0) : null),
      child: Center(child: Text('${postType.desc}')),
      width: 70.0,
      height: 32.0,
    );
  }
}
