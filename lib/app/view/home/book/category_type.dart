import 'dart:ui';

import 'package:flutter/material.dart';

enum CategoryType {
  all("ALL", "전체", Colors.black),
  multiple("MULTIPLE", "다중지능", Color(0xFF202FDA)),
  creative("CREATIVE", "창작", Color(0xFFDAA520)),
  nature("NATURE", "자연관찰", Color(0xFF20B2AA)),
  math("MATH", "수학/과학", Color(0xFF778899)),
  know("KNOW", "백과/탐구/지식", Color(0xFFD2691E)),
  fairy("FAIRY", "전래/명작", Color(0xFF2E8B57)),
  greateman("GREATEMAN", "위인", Color(0xFF1E90FF)),
  social("SOCIAL", "사회/경제/문화", Color(0xFF081A2C)),
  history("HISTORY", "역사/신화", Color(0xFF1662AF)),
  classic("CLASSIC", "고전/문학", Color(0xFF880033)),
  english("ENGLISH", "영어", Color(0xFFFA8072)),
  art("ART", "예술", Color(0xFFC53D65)),
  etc("ETC", "기타", Colors.black),
  none("NONE", "글 타입을 선택해주세요.", Colors.black45);

  final String code;
  final String desc;
  final Color color;

  const CategoryType(this.code, this.desc, this.color);

  static CategoryType findByCode(String code) {
    return CategoryType.values.firstWhere((value) => value.code == code, orElse: () => CategoryType.etc);
  }

  static List<String> findDescList() {
    return CategoryType.values.map((e) => e.desc).toList();
  }

  ///탭 리스트에 노출용 ("전체" 노출)
  static List<CategoryType> findListViewList() {
    return CategoryType.values.where((element) => element != CategoryType.none).toList();
  }

  ///글쓰기에 노출용
  static List<CategoryType> findAddViewList() {
    return CategoryType.values.where((element) => element != CategoryType.all && element != CategoryType.none).toList();
  }
}
