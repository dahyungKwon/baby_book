import 'dart:ui';

import 'package:flutter/material.dart';

/// 주의! 지정된 dcsc, color가 화면에 노출됩니다.
enum MemberPostType {
  writer_post("WRITER_POST", "작성글", Colors.black),
  writer_comment("WRITER_COMMENT", "작성댓글", Colors.black),
  bookmark("BOOKMARK", "북마크", Colors.black),
  etc("ETC", "기타", Colors.black),
  ;

  final String code;
  final String desc;
  final Color color;

  const MemberPostType(this.code, this.desc, this.color);

  static MemberPostType findByCode(String code) {
    return MemberPostType.values.firstWhere((value) => value.code == code, orElse: () => MemberPostType.etc);
  }

  static List<String> findDescList() {
    return MemberPostType.values.map((e) => e.desc).toList();
  }

  static List<MemberPostType> findMyProfile() {
    return MemberPostType.values.where((element) => element != MemberPostType.etc).toList();
  }

  static List<MemberPostType> findAnotherPeopleProfile() {
    return MemberPostType.values
        .where((element) => element != MemberPostType.bookmark && element != MemberPostType.etc)
        .toList();
  }
}
