import 'dart:ui';

import 'package:flutter/material.dart';

/// TabCommunityController를 통해 PostType에 지정한 desc가 tab list로 노출되니 주의하세요!
enum PostType {
  all("ALL", "전체", Colors.black),
  review("REVIEW", "전집후기", Color(0xFFDAA520)),
  bookcase("BOOKCASE", "책장소개", Color(0xFF20B2AA)),
  english("ENGLISH", "엄마표영어", Color(0xFFFA8072)),
  question("QUESTION", "육아고민", Color(0xFF1E90FF)),
  grow("GROW", "성장일기", Color(0xFF2E8B57)),
  recommend("RECOMMEND", "강추", Color(0xFFD2691E)),
  free("FREE", "자유이야기", Color(0xFF778899));
  // etc("ETC", "기타", Colors.black);

  final String code;
  final String desc;
  final Color color;

  const PostType(this.code, this.desc, this.color);

  static PostType findByCode(String code) {
    return PostType.values.firstWhere((value) => value.code == code, orElse: () => PostType.free);
  }

  static List<String> findDescList() {
    return PostType.values.map((e) => e.desc).toList();
  }
}
