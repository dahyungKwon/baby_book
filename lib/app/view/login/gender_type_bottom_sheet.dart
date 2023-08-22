import 'package:baby_book/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../base/resizer/fetch_pixels.dart';
import 'gender_type.dart';

class GenderTypeBottomSheet extends StatefulWidget {
  final GenderType genderType;
  static const String genderBaby = "BABY";
  static const String genderAdult = "ADULT";
  final String genderPresentationType;

  const GenderTypeBottomSheet({required this.genderType, required this.genderPresentationType, Key? key})
      : super(key: key);

  @override
  State<GenderTypeBottomSheet> createState() => _GenderTypeBottomSheetState();
}

class _GenderTypeBottomSheetState extends State<GenderTypeBottomSheet> {
  GenderType? selectedGenderType;
  String? genderPresentationType;

  @override
  void initState() {
    super.initState();
    selectedGenderType = widget.genderType;
    genderPresentationType = widget.genderPresentationType;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 22.h,
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
                  "성별을 선택해주세요.",
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
                    _GenderTypeBottomSheetPicker(
                        genderTypeList: GenderType.findJoinViewList(),
                        selectedGenderType: selectedGenderType!,
                        genderTypeBottomSheetSetter: (GenderType genderType) {
                          setState(() {
                            selectedGenderType = genderType;
                          });
                        },
                        genderPresentationType: genderPresentationType!)
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

typedef GenderTypeBottomSheetSetter = void Function(GenderType genderType);

class _GenderTypeBottomSheetPicker extends StatelessWidget {
  final List<GenderType> genderTypeList;
  final GenderType selectedGenderType;
  final GenderTypeBottomSheetSetter genderTypeBottomSheetSetter;
  final String genderPresentationType;

  const _GenderTypeBottomSheetPicker(
      {required this.genderTypeList,
      required this.selectedGenderType,
      required this.genderTypeBottomSheetSetter,
      required this.genderPresentationType,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: genderTypeList.map((e) => render(context, e, selectedGenderType == e)).toList(),
    );
  }

  Widget render(BuildContext context, GenderType genderType, bool isSelected) {
    return RadioListTile<GenderType>(
        visualDensity: const VisualDensity(
          horizontal: VisualDensity.minimumDensity,
          vertical: VisualDensity.minimumDensity,
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        contentPadding: EdgeInsets.zero,
        title: Text(genderPresentationType == GenderTypeBottomSheet.genderAdult ? genderType.adult : genderType.baby),
        value: genderType,
        activeColor: Colors.black,
        groupValue: selectedGenderType,
        onChanged: (GenderType? genderType) {
          genderTypeBottomSheetSetter(genderType!);
          Navigator.pop(context, genderType);
        });
  }
}
