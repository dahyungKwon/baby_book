import '../view/login/gender_type.dart';

class ModelMember {
  String? memberId;
  String? nickName;
  String? email;
  String? contents;
  String? snsLoginType;
  String? snsLoginId;
  String? accessToken;
  String? refreshToken;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? allAgreed;
  GenderType? gender;
  String? selectedBabyId;

  ModelMember(
      {this.memberId,
      this.nickName,
      this.email,
      this.contents,
      this.snsLoginType,
      this.snsLoginId,
      this.accessToken,
      this.refreshToken,
      this.createdAt,
      this.updatedAt,
      this.allAgreed,
      this.gender,
      this.selectedBabyId});

  static ModelMember createForObsInit() {
    return ModelMember();
  }

  // JSON형태에서부터 데이터를 받아온다.
  ModelMember.fromJson(Map<String, dynamic> json)
      : memberId = json['memberId'],
        nickName = json['nickName'],
        email = json['email'],
        contents = json['contents'],
        snsLoginType = json['snsLoginType'],
        snsLoginId = json['snsLoginId'],
        accessToken = json['accessToken'],
        refreshToken = json['refreshToken'],
        createdAt = json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
        updatedAt = json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
        allAgreed = json['allAgreed'] ?? false,
        gender = json['gender'] != null ? GenderType.findByCode(json['gender']) : GenderType.none,
        selectedBabyId = json['selectedBabyId'];
}
