class ModelRefreshAccessToken {
  String? serviceType;
  String? accessToken;
  String? refreshToken;

  ModelRefreshAccessToken({this.serviceType, this.accessToken, this.refreshToken});

  // JSON형태에서부터 데이터를 받아온다.
  ModelRefreshAccessToken.fromJson(Map<String, dynamic> json)
      : serviceType = json['serviceType'],
        accessToken = json['accessToken'],
        refreshToken = json['refreshToken'];
}
