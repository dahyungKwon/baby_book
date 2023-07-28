import 'package:baby_book/app/view/login/gender_type.dart';

class ModelMyBookMemberBody {
  String memberId;
  String nickName;
  GenderType gender;

  ModelMyBookMemberBody({
    required this.memberId,
    required this.nickName,
    required this.gender,
  });

  ModelMyBookMemberBody.fromJson(Map<String, dynamic> json)
      : memberId = json['memberId'],
        nickName = json['nickName'],
        gender = GenderType.findByCode(json['gender']);

  static ModelMyBookMemberBody createForObsInit() {
    return ModelMyBookMemberBody(memberId: "", nickName: "", gender: GenderType.none);
  }
}
