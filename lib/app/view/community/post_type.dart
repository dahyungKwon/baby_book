import 'package:flutter/material.dart';

/// TabCommunityController를 통해 PostType에 지정한 desc가 tab list로 노출되니 주의하세요!
enum PostType {
  all("ALL", "전체", Colors.black),
  // culture("CULTURE", "책육아문화", Color(0xFFEC6E5D)),
  review("REVIEW", "책 후기", Color(0xFFEC6E5D)),
  question("QUESTION", "책 질문", Color(0xFF1E90FF)),
  english("ENGLISH", "영어", Color(0xFFCCAF12)),
  free("FREE", "자유이야기", Color(0xFF78C759)),
  none("NONE", "글 타입을 선택해주세요.", Colors.black45);

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

  ///탭 리스트에 노출용 ("전체" 노출)
  static List<PostType> findListViewList() {
    return PostType.values.where((element) => element != PostType.none).toList();
  }

  ///글쓰기에 노출용
  static List<PostType> findAddViewList() {
    return PostType.values.where((element) => element != PostType.all && element != PostType.none).toList();
  }
}
