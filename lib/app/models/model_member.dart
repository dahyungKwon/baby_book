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
      this.updatedAt});

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
        createdAt = DateTime.tryParse(json['createdAt']),
        updatedAt = DateTime.tryParse(json['updatedAt']);
}
