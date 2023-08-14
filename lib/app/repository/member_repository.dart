import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../base/pref_data.dart';
import '../exception/exception_invalid_member.dart';
import '../models/model_member.dart';
import '../models/model_refresh_accesstoken.dart';
import '../routes/app_pages.dart';
import '../view/dialog/error_dialog.dart';
import '../view/login/gender_type.dart';

class MemberRepository {
  static var dio = Dio(BaseOptions(
    baseUrl: 'http://ec2-52-78-163-194.ap-northeast-2.compute.amazonaws.com:3001/apis',
    connectTimeout: 5000,
    receiveTimeout: 3000,
  ));

  static Future<ModelMember?> createMember({
    required String snsLoginType,
    required String snsAccessToken,
  }) async {
    final response =
        await dio.post('/members/join', data: {"snsLoginType": snsLoginType, "snsAccessToken": snsAccessToken});

    if (response.data['code'] == 'FAIL') {
      if (response.data['body']['errorCode'] == 'INVALID_MEMBER') {
        Get.toNamed(Routes.reAuthPath);
      } else {
        Get.dialog(ErrorDialog("네트워크 오류가 발생하였습니다.\n잠시 후 다시 시도해주세요.\n상세 에러 코드: ${response.data['body']['errorCode']}"));
        return null;
      }
    }

    return ModelMember.fromJson(response.data['body']);
  }

  static Future<ModelMember?> putMember({
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
        Get.toNamed(Routes.reAuthPath);
      } else {
        Get.dialog(ErrorDialog("네트워크 오류가 발생하였습니다.\n잠시 후 다시 시도해주세요.\n상세 에러 코드: ${response.data['body']['errorCode']}"));
        return null;
      }
    }

    return ModelMember.fromJson(response.data['body']);
  }

  static Future<bool> deleteMember({required String memberId}) async {
    var accessToken = await PrefData.getAccessToken();

    final response = await dio.delete(
      '/members/$memberId',
      options: Options(
        headers: {"at": accessToken},
      ),
    );

    if (response.data['code'] == 'FAIL') {
      if (response.data['body']['errorCode'] == 'INVALID_MEMBER') {
        Get.toNamed(Routes.reAuthPath);
      } else {
        Get.dialog(ErrorDialog("네트워크 오류가 발생하였습니다.\n잠시 후 다시 시도해주세요.\n상세 에러 코드: ${response.data['body']['errorCode']}"));
        return false;
      }
    }

    return true;
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
        Get.toNamed(Routes.reAuthPath);
      } else {
        Get.dialog(ErrorDialog("네트워크 오류가 발생하였습니다.\n잠시 후 다시 시도해주세요.\n상세 에러 코드: ${response.data['body']['errorCode']}"));
        return ModelMember.createForObsInit();
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
        await PrefData.setAccessToken(null);
        await PrefData.setRefreshToken(null);
        Get.toNamed(Routes.loginPath);
      } else {
        Get.dialog(ErrorDialog("네트워크 오류가 발생하였습니다.\n잠시 후 다시 시도해주세요.\n상세 에러 코드: ${response.data['body']['errorCode']}"));
        return ModelRefreshAccessToken();
      }
    }

    return ModelRefreshAccessToken.fromJson(response.data['body']);
  }

  static Future<bool?> existNickName({
    required String nickName,
  }) async {
    final response = await dio.get(
      '/members/nicknames/$nickName',
    );

    if (response.data['code'] == 'FAIL') {
      if (response.data['body']['errorCode'] == 'INVALID_MEMBER') {
        Get.toNamed(Routes.reAuthPath);
      } else {
        Get.dialog(ErrorDialog("네트워크 오류가 발생하였습니다.\n잠시 후 다시 시도해주세요.\n상세 에러 코드: ${response.data['body']['errorCode']}"));
        return null;
      }
    }

    //true면 존재, false면 존재하지 않음
    return response.data['body'];
  }
}
