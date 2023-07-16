import '../view/login/gender_type.dart';

class ModelBaby {
  String? babyId;
  String? memberId;
  String? name;
  GenderType? gender;
  DateTime? birth;
  DateTime? createdAt;
  DateTime? updatedAt;

  ModelBaby({
    this.babyId,
    this.memberId,
    this.name,
    this.gender,
    this.birth,
    this.createdAt,
    this.updatedAt,
  });

  // JSON형태에서부터 데이터를 받아온다.
  ModelBaby.fromJson(Map<String, dynamic> json)
      : babyId = json['babyId'],
        memberId = json['memberId'],
        name = json['name'],
        gender = json['gender'] != null ? GenderType.findByCode(json['gender']) : GenderType.none,
        birth = DateTime.tryParse(json['birth']),
        createdAt = DateTime.tryParse(json['createdAt']),
        updatedAt = json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null;

  getBirthdayToString() {
    if (birth == null) {
      return "생일 선택안함";
    }

    return "${birth!.year}년 ${birth!.month}월생";
  }

  getBabyMonth() {
    //올해 나온아기 2023 7 - 2023 5 2개월
    //작년에 나온아기 2023 7 - 2022 6
    //작년에 나온아기 2023 7 - 2022 8
    DateTime now = DateTime.now();
    int gapYear = now.year - birth!.year;
    int gapMonth = now.month - birth!.year;
  }

  getBabyAge() {}
}
