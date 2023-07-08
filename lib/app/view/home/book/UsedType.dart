enum UsedType {
  newBook("NEW_BOOK", "새책"),
  usedBook("USED_BOOK", "읽는중"),
  none("NONE", "선택안함");

  final String code;
  final String desc;

  const UsedType(this.code, this.desc);

  static UsedType findByCode(String code) {
    return UsedType.values.firstWhere((value) => value.code == code, orElse: () => UsedType.none);
  }

  static List<String> findDescList() {
    return UsedType.values.map((e) => e.desc).toList();
  }
}
