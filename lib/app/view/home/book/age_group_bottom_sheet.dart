import 'package:baby_book/app/models/model_age_group.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../base/resizer/fetch_pixels.dart';
import '../../../controller/TabHomeController.dart';

class AgeGroupBottomSheet extends StatefulWidget {
  final ModelAgeGroup selectedAgeGroup;

  const AgeGroupBottomSheet({required this.selectedAgeGroup, Key? key}) : super(key: key);

  @override
  State<AgeGroupBottomSheet> createState() => _AgeGroupBottomSheetState();
}

class _AgeGroupBottomSheetState extends State<AgeGroupBottomSheet> {
  late ModelAgeGroup selectedAgeGroup;

  @override
  void initState() {
    super.initState();
    selectedAgeGroup = widget.selectedAgeGroup;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 30.h,
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
                  "아기 나이를 선택해주세요.",
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
                    _AgeGroupBottomSheetPicker(
                        ageGroupList: ModelAgeGroup.ageGroupList,
                        selectedAgeGroup: selectedAgeGroup!,
                        ageGroupBottomSheetSetter: (ModelAgeGroup ageGroup) {
                          setState(() {
                            selectedAgeGroup = ageGroup;
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

typedef AgeGroupBottomSheetSetter = void Function(ModelAgeGroup ageGroup);

class _AgeGroupBottomSheetPicker extends StatelessWidget {
  final List<ModelAgeGroup> ageGroupList;
  final ModelAgeGroup selectedAgeGroup;
  final AgeGroupBottomSheetSetter ageGroupBottomSheetSetter;

  const _AgeGroupBottomSheetPicker(
      {required this.ageGroupList, required this.selectedAgeGroup, required this.ageGroupBottomSheetSetter, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: ageGroupList.map((e) => render(context, e, selectedAgeGroup == e)).toList(),
    );
  }

  Widget render(BuildContext context, ModelAgeGroup ageGroup, bool isSelected) {
    return RadioListTile<ModelAgeGroup>(
        visualDensity: const VisualDensity(
          horizontal: VisualDensity.minimumDensity,
          vertical: VisualDensity.minimumDensity,
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        contentPadding: EdgeInsets.zero,
        title: Text(ageGroup.title),
        value: ageGroup,
        activeColor: selectedAgeGroup != null ? Colors.black : Colors.black,
        groupValue: selectedAgeGroup,
        onChanged: (ModelAgeGroup? ageGroup) {
          ageGroupBottomSheetSetter(ageGroup!);
          Navigator.pop(context, ageGroup);
        });
  }
}
