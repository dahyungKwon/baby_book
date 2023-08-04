import 'package:baby_book/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../base/resizer/fetch_pixels.dart';
import 'ReviewType.dart';

class ReviewTypeBottomSheet extends StatefulWidget {
  ReviewType reviewType;
  bool isTemp = false;

  ReviewTypeBottomSheet({required this.reviewType, required this.isTemp, Key? key}) : super(key: key);

  @override
  State<ReviewTypeBottomSheet> createState() => _ReviewTypeBottomSheetState();
}

class _ReviewTypeBottomSheetState extends State<ReviewTypeBottomSheet> {
  late ReviewType selectedReviewType;
  bool isTemp = false;

  @override
  void initState() {
    super.initState();
    selectedReviewType = widget.reviewType;
    isTemp = widget.isTemp;
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
                  isTemp ? "책에 대한 기대감을 선택해주세요." : "책 평점을 선택 해주세요.",
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
                    _ReviewTypeBottomSheetPicker(
                        selectedReviewType: selectedReviewType!,
                        reviewTypeBottomSheetSetter: (ReviewType reviewType) {
                          setState(() {
                            selectedReviewType = reviewType;
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

typedef ReviewTypeBottomSheetSetter = void Function(ReviewType reviewType);

class _ReviewTypeBottomSheetPicker extends StatelessWidget {
  final ReviewType selectedReviewType;
  final ReviewTypeBottomSheetSetter reviewTypeBottomSheetSetter;

  const _ReviewTypeBottomSheetPicker(
      {required this.selectedReviewType, required this.reviewTypeBottomSheetSetter, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: ReviewType.values.map((e) => render(context, e, selectedReviewType == e)).toList(),
    );
  }

  Widget render(BuildContext context, ReviewType reviewType, bool isSelected) {
    return RadioListTile<ReviewType>(
        visualDensity: const VisualDensity(
          horizontal: VisualDensity.minimumDensity,
          vertical: VisualDensity.minimumDensity,
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        contentPadding: EdgeInsets.zero,
        title: Text(reviewType.desc),
        value: reviewType,
        activeColor: Colors.black,
        groupValue: selectedReviewType,
        onChanged: (ReviewType? reviewType) {
          reviewTypeBottomSheetSetter(reviewType!);
          Navigator.pop(context, reviewType);
        });
  }
}
