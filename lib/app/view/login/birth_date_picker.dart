import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class BirthDatePicker extends StatelessWidget {
  final void Function(DateTime) onDateTimeChanged;
  final String initDateStr;

  const BirthDatePicker({
    super.key,
    required this.onDateTimeChanged,
    required this.initDateStr,
  });

  @override
  Widget build(BuildContext context) {
    final initDate = DateFormat('yyyy-MM-dd').parse(initDateStr);
    return SizedBox(
      height: 180,
      child: CupertinoDatePicker(
        minimumYear: 1900,
        maximumYear: 9999,
        initialDateTime: initDate,
        maximumDate: DateTime.now().add(const Duration(days: 100000)),
        onDateTimeChanged: onDateTimeChanged,
        mode: CupertinoDatePickerMode.date,
      ),
    );
  }
}
