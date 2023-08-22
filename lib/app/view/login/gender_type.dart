///아이폰 이슈로 "선택안함"도 선택 할 수 있게 해야함, 즉 nullType이라고 만들어서 한 depth 더 둠
///null로 두려고 했는데, Obx이슈가 존재
///https://github.com/team-wooho/baby-book-flutter/issues/148
enum GenderType {
  man("MAN", "남자", "아빠곰", "아들"),
  woman("WOMAN", "여자", "엄마곰", "딸"),
  none("NONE", "선택안함", "선택안함", "선택안함"),
  nullType("NULL", "NULL", "NULL", "NULL");

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

  ///가입시 노출 - none도 받아야함 / 아이폰 이슈 (https://github.com/team-wooho/baby-book-flutter/issues/148)
  static List<GenderType> findJoinViewList() {
    return GenderType.values.where((element) => element != GenderType.nullType).toList();
  }
}
