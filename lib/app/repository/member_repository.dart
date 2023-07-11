import 'package:dio/dio.dart';

import '../../base/pref_data.dart';
import '../exception/exception_invalid_member.dart';
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
    String? email,
    String? contents,
    required bool? allAgreed,
    required GenderType? gender,
    String? selectedBabyId,
  }) async {
    var accessToken = await PrefData.getAccessToken();

    final response = await dio.put(
      '/members/$memberId',
      data: {
        "memberId": memberId,
        "nickName": nickName,
        "email": email,
        "contents": contents,
        "allAgreed": allAgreed,
        "gender": gender?.code,
        "selectedBabyId": selectedBabyId
      },
      options: Options(
        headers: {"at": accessToken},
      ),
    );

    if (response.data['code'] == 'FAIL') {
      if (response.data['body']['errorCode'] == 'INVALID_MEMBER') {
        throw InvalidMemberException();
      } else {
        throw Exception(response.data['body']['errorCode']);
      }
    }

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

    if (response.data['code'] == 'FAIL') {
      if (response.data['body']['errorCode'] == 'INVALID_MEMBER') {
        throw InvalidMemberException();
      } else {
        throw Exception(response.data['body']['errorCode']);
      }
    }

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

    if (response.data['code'] == 'FAIL') {
      if (response.data['body']['errorCode'] == 'INVALID_MEMBER') {
        throw InvalidMemberException();
      } else {
        throw Exception(response.data['body']['errorCode']);
      }
    }

    return ModelRefreshAccessToken.fromJson(response.data['body']);
  }

  static Future<bool> existNickName({
    required String nickName,
  }) async {
    final response = await dio.get(
      '/members/nicknames/$nickName',
    );

    if (response.data['code'] == 'FAIL') {
      if (response.data['body']['errorCode'] == 'INVALID_MEMBER') {
        throw InvalidMemberException();
      } else {
        throw Exception(response.data['body']['errorCode']);
      }
    }

    //true면 존재, false면 존재하지 않음
    return response.data['body'];
  }
}
