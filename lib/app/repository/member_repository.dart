import 'package:dio/dio.dart';

import '../../base/pref_data.dart';
import '../models/model_member.dart';
import '../models/model_refresh_accesstoken.dart';
import '../view/login/gender_type.dart';

class MemberRepository {
  static var dio = Dio(BaseOptions(
    baseUrl: 'http://ec2-15-165-18-218.ap-northeast-2.compute.amazonaws.com:3001/apis',
    connectTimeout: 5000,
    receiveTimeout: 3000,
  ));

  static Future<ModelMember> createMember({
    required String snsLoginType,
    required String snsAccessToken,
  }) async {
    final response =
        await dio.post('/members/join', data: {"snsLoginType": snsLoginType, "snsAccessToken": snsAccessToken});

    return ModelMember.fromJson(response.data['body']);
  }

  static Future<ModelMember> putMember({
    required String memberId,
    required String? nickName,
    required String? email,
    required String? contents,
    required bool? allAgreed,
    required GenderType? gender,
    required String? selectedBabyId,
  }) async {
    final response = await dio.put('/members/$memberId', data: {
      "memberId": memberId,
      "nickName": nickName,
      "email": email,
      "contents": contents,
      "allAgreed": allAgreed,
      "gender": gender?.code,
      "selectedBabyId": selectedBabyId
    });

    return ModelMember.fromJson(response.data['body']);
  }

  static Future<ModelMember> getMember({
    required String memberId,
  }) async {
    var accessToken = await PrefData.getAccessToken();

    final response = await dio.get(
      '/members/$memberId',
      options: Options(
        headers: {"at": accessToken},
      ),
    );

    return ModelMember.fromJson(response.data['body']);
  }

  static Future<ModelRefreshAccessToken> refreshAccessToken() async {
    var memberId = await PrefData.getMemberId();
    var accessToken = await PrefData.getAccessToken();
    var refreshToken = await PrefData.getRefreshToken();

    final response = await dio.post(
      '/members/$memberId/at',
      data: {"accessToken": accessToken, "refreshToken": refreshToken},
      options: Options(
        headers: {"at": accessToken},
      ),
    );

    return ModelRefreshAccessToken.fromJson(response.data['body']);
  }
}
