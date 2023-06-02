import 'package:dio/dio.dart';

import '../models/model_member.dart';

class MemberRepository {
  static Future<ModelMember> findMember({
    required String memberId,
  }) async {
    final response =
        await Dio().get('http://ec2-43-201-150-252.ap-northeast-2.compute.amazonaws.com:3001/apis/members/$memberId');

    return ModelMember.fromJson(response.data['body']);
  }

  static Future<ModelMember> createMember({
    required String snsLoginType,
    required String snsAccessToken,
  }) async {
    final response = await Dio().post(
        'http://ec2-43-201-150-252.ap-northeast-2.compute.amazonaws.com:3001/apis/members/join',
        data: {"snsLoginType": snsLoginType, "snsAccessToken": snsAccessToken});

    return ModelMember.fromJson(response.data['body']);
  }
}
