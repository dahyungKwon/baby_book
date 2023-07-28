import 'package:baby_book/app/view/login/gender_type.dart';

class ModelMyBookMemberBody {
  String memberId;
  String nickName;
  GenderType gender;
  DateTime? babyBirth;

  ModelMyBookMemberBody({
    required this.memberId,
    required this.nickName,
    required this.gender,
    this.babyBirth,
  });

  ModelMyBookMemberBody.fromJson(Map<String, dynamic> json)
      : memberId = json['memberId'],
        nickName = json['nickName'],
        gender = GenderType.findByCode(json['gender']),
        babyBirth = json['babyBirth'] != null ? DateTime.tryParse(json['babyBirth']) : null;

  static ModelMyBookMemberBody createForObsInit() {
    return ModelMyBookMemberBody(memberId: "", nickName: "", gender: GenderType.none);
  }

  getBirthdayToString() {
    if (babyBirth == null) {
      return "생일 선택안함";
    }

    return "${babyBirth!.year}년 ${babyBirth!.month}월생";
  }
}
