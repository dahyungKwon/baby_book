import 'package:baby_book/app/view/community/post_type.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../base/resizer/fetch_pixels.dart';
import 'package:flutter/foundation.dart' as foundation;

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
    return SizedBox(
        height: 30.h,
        child: Container(
          color: Colors.white,
          margin: EdgeInsets.only(
              bottom:
              FetchPixels.getPixelHeight(foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS ? 20 : 0)),
          padding: EdgeInsets.only(left: FetchPixels.getPixelHeight(15), right: FetchPixels.getPixelWidth(15)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getVerSpace(FetchPixels.getPixelHeight(20)),
              Row(children: [
                getHorSpace(FetchPixels.getPixelHeight(10)),
                getCustomFont(
                  "글 타입을 선택해주세요.",
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
        ));
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
    return Column(
      children: postTypeList.map((e) => renderPostType(context, e, selectedPostType == e)).toList(),
    );
  }

  Widget renderPostType(BuildContext context, PostType postType, bool isSelected) {
    return RadioListTile<PostType>(
        visualDensity: const VisualDensity(
          horizontal: VisualDensity.minimumDensity,
          vertical: VisualDensity.minimumDensity,
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        contentPadding: EdgeInsets.zero,
        title: Text(postType.desc),
        value: postType,
        activeColor: selectedPostType != null ? selectedPostType.color : Colors.black,
        groupValue: selectedPostType,
        onChanged: (PostType? postType) {
          postTypeBottomSheetSetter(postType!);
          Navigator.pop(context, postType);
        });
  }
}
