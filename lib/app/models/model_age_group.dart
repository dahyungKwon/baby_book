class ModelAgeGroup {
  int? groupId; //index하고 같음
  int? minAge;
  int? maxAge;
  String title;

  ModelAgeGroup(this.groupId, this.minAge, this.maxAge, this.title);

  static List<ModelAgeGroup> ageGroupList = [
    ModelAgeGroup(0, 0, 18, "0 ~ 18개월"), //겹치는 부분 동시노출
    ModelAgeGroup(1, 18, 3 * 12, "18 ~ 36개월"), //18개월~36개월(3살전) 겹치는 부분은 동시 노출
    ModelAgeGroup(2, 3 * 12, 8 * 12, "유아"), //3살이상 ~ 초1
    ModelAgeGroup(3, 8 * 12, 11 * 12, "초등 저학년"), //초1(8),2(9),3(10),4(11) 4학년 이하
    ModelAgeGroup(4, 11 * 12, 14 * 12, "초등 고학년"), //초 4(11),5(12),6(13),중1(14) 중1 이하
  ];

  static ModelAgeGroup getAgeGroup(int groupId) {
    return ageGroupList[groupId];
  }
}
