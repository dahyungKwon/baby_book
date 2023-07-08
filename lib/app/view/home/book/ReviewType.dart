enum ReviewType {
  nice("NICE", "초대박"),
  good("GOOD", "대박"),
  SOSO("SOSO", "중박"),
  bad("BAD", "쪽박"),
  none("NONE", "선택안함");

  final String code;
  final String desc;

  const ReviewType(this.code, this.desc);

  static ReviewType findByCode(String code) {
    return ReviewType.values.firstWhere((value) => value.code == code, orElse: () => ReviewType.none);
  }

  static List<String> findDescList() {
    return ReviewType.values.map((e) => e.desc).toList();
  }
}
