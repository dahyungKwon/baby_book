enum BookListSortType {
  hot("HOT", "인기순"),
  like("LIKE", "좋아요순");

  final String code;
  final String desc;

  const BookListSortType(this.code, this.desc);

  static BookListSortType findByCode(String? code) {
    return BookListSortType.values.firstWhere((value) => value.code == code, orElse: () => BookListSortType.hot);
  }

  static List<String> findDescList() {
    return BookListSortType.values.map((e) => e.desc).toList();
  }
}
