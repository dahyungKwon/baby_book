enum GenderType {
  man("MAN", "남자", "아빠곰", "아들"),
  woman("WOMAN", "여자", "엄마곰", "딸"),
  none("NONE", "선택안함", "선택안함", "선택안함");

  final String code;
  final String desc;
  final String adult;
  final String baby;

  const GenderType(this.code, this.desc, this.adult, this.baby);

  static GenderType findByCode(String code) {
    return GenderType.values.firstWhere((value) => value.code == code, orElse: () => GenderType.none);
  }

  static List<String> findDescList() {
    return GenderType.values.map((e) => e.desc).toList();
  }

  static List<String> findAdultList() {
    return GenderType.values.map((e) => e.adult).toList();
  }

  static List<String> findBabyList() {
    return GenderType.values.map((e) => e.baby).toList();
  }

  ///가입시 노출
  static List<GenderType> findJoinViewList() {
    return GenderType.values.where((element) => element != GenderType.none).toList();
  }
}
