enum GenderType {
  man("MAN", "아빠곰"),
  woman("WOMAN", "엄마곰"),
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

  ///가입시 노출
  static List<GenderType> findJoinViewList() {
    return GenderType.values.where((element) => element != GenderType.none).toList();
  }
}
