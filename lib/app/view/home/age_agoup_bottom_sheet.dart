import 'package:baby_book/app/data/data_file.dart';
import 'package:baby_book/app/models/model_age_group.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:flutter/material.dart';

class AgeGroupBottomSheet extends StatefulWidget {
  final int ageGroupId;

  const AgeGroupBottomSheet({required this.ageGroupId, Key? key}) : super(key: key);

  @override
  State<AgeGroupBottomSheet> createState() => _AgeGroupBottomSheetState();
}

class _AgeGroupBottomSheetState extends State<AgeGroupBottomSheet> {
  int? selectedAgeGroupId;

  @override
  void initState() {
    super.initState();
    selectedAgeGroupId = widget.ageGroupId;
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SizedBox(
      height: MediaQuery.of(context).size.height / 4 + bottomInset,
      child: Column(
        children: [
          SizedBox(height: 10,),
          getCustomFont(
            "개월수",
            18,
            Colors.black,
            1,
            fontWeight: FontWeight.w700,
          ),
          Container(
            padding: EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 7),
            color: Colors.white,
            child: Wrap(
              children: [
                _AgeGroupPicker(ageGroups: DataFile.ageGroupList, selectedAgeGroupId: selectedAgeGroupId!, ageGroupSetter: (int id) {
                  setState(() {
                    selectedAgeGroupId = id;
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

typedef AgeGroupSetter = void Function(int id);

class _AgeGroupPicker extends StatelessWidget {
  final List<ModelAgeGroup> ageGroups;
  final int selectedAgeGroupId;
  final AgeGroupSetter ageGroupSetter;

  const _AgeGroupPicker({required this.ageGroups, required this.selectedAgeGroupId, required this.ageGroupSetter, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 20.0,
      runSpacing: 10.0,
      children: ageGroups
          .map(
            (e) => GestureDetector(
          onTap: () {
            ageGroupSetter(e.groupId!);
            Navigator.pop(context, e.groupId);
          },
          child: renderAge(e, selectedAgeGroupId == e.groupId),
        ),
      )
          .toList(),
    );
  }

  Widget renderAge(ModelAgeGroup ageGroup, bool isSelected) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
          color: Colors.black12,
          border: isSelected ? Border.all(color: Colors.blue, width: 4.0) : null
          ),
      child: Center(child: Text('${ageGroup.minAge} ~ ${ageGroup.maxAge}')),
      width: 70.0,
      height: 32.0,
    );
  }
}

