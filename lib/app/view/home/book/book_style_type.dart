import 'dart:ui';

import 'package:flutter/material.dart';

enum BookStyleType {
  paper("PAPER", "종이책"),
  operation("OPERATION", "조작북"),
  etc("ETC", "기타");

  final String code;
  final String desc;

  const BookStyleType(this.code, this.desc);

  static BookStyleType findByCode(String code) {
    return BookStyleType.values.firstWhere((value) => value.code == code, orElse: () => BookStyleType.etc);
  }

  static List<String> findDescList() {
    return BookStyleType.values.map((e) => e.desc).toList();
  }
}
