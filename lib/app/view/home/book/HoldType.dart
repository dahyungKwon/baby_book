import 'package:flutter/material.dart';

enum HoldType {
  all("ALL", "전체", Colors.black),
  plan("PLAN", "구매예정", Color(0xFFDAA520)),
  read("READ", "읽는중", Color(0xFF1E90FF)),
  end("END", "방출", Color(0xFF778899)),
  none("NONE", "선택안함", Colors.black);

  final String code;
  final String desc;
  final Color color;

  const HoldType(this.code, this.desc, this.color);

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
