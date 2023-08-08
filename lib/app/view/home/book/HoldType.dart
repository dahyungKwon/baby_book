import 'package:baby_book/base/color_data.dart';
import 'package:flutter/material.dart';

enum HoldType {
  all("ALL", "전체", Colors.black, "add_bookcase.svg"),
  plan("PLAN", "구매예정", Color(0xFFEC6E5D), "book_plan2.svg"),
  read("READ", "읽는중", Color(0xFF5D8DE7), "book_read.svg"),
  end("END", "방출", Color(0xFF6B6A6A), "book_end.svg"),
  none("NONE", "선택안함", Color(0xFF464343), "add_bookcase.svg");

  final String code;
  final String desc;
  final Color color;
  final String image;

  const HoldType(this.code, this.desc, this.color, this.image);

  static HoldType findByCode(String code) {
    return HoldType.values.firstWhere((value) => value.code == code, orElse: () => HoldType.none);
  }

  static List<String> findDescList() {
    return HoldType.values.map((e) => e.desc).toList();
  }

  ///탭 리스트에 노출용 ("전체" 노출)
  static List<HoldType> findListForTab() {
    return HoldType.values.where((element) => element != HoldType.none).toList();
  }
}
