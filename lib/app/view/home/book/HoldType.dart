enum HoldType {
  plan("PLAN", "구매예정"),
  read("READ", "읽는중"),
  end("END", "방출"),
  none("NONE", "선택안함");

  final String code;
  final String desc;

  const HoldType(this.code, this.desc);

  static HoldType findByCode(String code) {
    return HoldType.values.firstWhere((value) => value.code == code, orElse: () => HoldType.none);
  }

  static List<String> findDescList() {
    return HoldType.values.map((e) => e.desc).toList();
  }
}
