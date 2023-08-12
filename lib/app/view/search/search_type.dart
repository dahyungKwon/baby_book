enum SearchType {
  community("COMMUNITY", "커뮤니티 책검색"),
  none("NONE", "없음");

  final String code;
  final String desc;

  const SearchType(this.code, this.desc);

  static SearchType findByCode(String? code) {
    return SearchType.values.firstWhere((value) => value.code == code, orElse: () => SearchType.none);
  }

  static List<String> findDescList() {
    return SearchType.values.map((e) => e.desc).toList();
  }
}
