import 'package:baby_book/app/view/home/book/UsedType.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../base/resizer/fetch_pixels.dart';

class UsedTypeBottomSheet extends StatefulWidget {
  UsedType usedType;

  UsedTypeBottomSheet({required this.usedType, Key? key}) : super(key: key);

  @override
  State<UsedTypeBottomSheet> createState() => _UsedTypeBottomSheetState();
}

class _UsedTypeBottomSheetState extends State<UsedTypeBottomSheet> {
  late UsedType selectedUsedType;

  @override
  void initState() {
    super.initState();
    selectedUsedType = widget.usedType;
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
                  "새책여부를 선택해주세요.",
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
                    _UsedTypeBottomSheetPicker(
                        selectedUsedType: selectedUsedType!,
                        usedTypeBottomSheetSetter: (UsedType usedType) {
                          setState(() {
                            selectedUsedType = usedType;
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

typedef UsedTypeBottomSheetSetter = void Function(UsedType usedType);

class _UsedTypeBottomSheetPicker extends StatelessWidget {
  final UsedType selectedUsedType;
  final UsedTypeBottomSheetSetter usedTypeBottomSheetSetter;

  const _UsedTypeBottomSheetPicker({required this.selectedUsedType, required this.usedTypeBottomSheetSetter, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: UsedType.values.map((e) => render(context, e, selectedUsedType == e)).toList(),
    );
  }

  Widget render(BuildContext context, UsedType usedType, bool isSelected) {
    return RadioListTile<UsedType>(
        visualDensity: const VisualDensity(
          horizontal: VisualDensity.minimumDensity,
          vertical: VisualDensity.minimumDensity,
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        contentPadding: EdgeInsets.zero,
        title: Text(usedType.desc),
        value: usedType,
        activeColor: Colors.black,
        groupValue: selectedUsedType,
        onChanged: (UsedType? usedType) {
          usedTypeBottomSheetSetter(usedType!);
          Navigator.pop(context, usedType);
        });
  }
}
