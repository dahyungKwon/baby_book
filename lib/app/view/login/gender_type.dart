enum GenderType {
  man("MAN", "남자"),
  woman("WOMAN", "여자"),
  none("NONE", "선택안함");

  final String code;
  final String desc;

  const GenderType(this.code, this.desc);

  static GenderType findByCode(String code) {
    return GenderType.values.firstWhere((value) => value.code == code, orElse: () => GenderType.none);
  }

  static List<String> findDescList() {
    return GenderType.values.map((e) => e.desc).toList();
  }
}
