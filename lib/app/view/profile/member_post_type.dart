import 'dart:ui';

import 'package:flutter/material.dart';

/// TabCommunityController를 통해 PostType에 지정한 desc가 tab list로 노출되니 주의하세요!
enum MemberPostType {
  writer_post("WRITER_POST", "작성글", Color(0xFFDAA520)),
  writer_comment("WRITER_COMMENT", "작성댓글", Color(0xFF20B2AA)),
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
