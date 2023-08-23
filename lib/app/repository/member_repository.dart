import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../base/pref_data.dart';
import '../models/model_member.dart';
import '../models/model_refresh_accesstoken.dart';
import '../routes/app_pages.dart';
import '../view/dialog/error_dialog.dart';
import '../view/login/gender_type.dart';

class MemberRepository {
  static var dio = Dio(BaseOptions(
    baseUrl: 'https://babybear-readbook.com/apis',
    connectTimeout: 5000,
    receiveTimeout: 3000,
  ));

  static Future<ModelMember?> createMember({
    required String snsLoginType,
    required String snsAccessToken,
  }) async {
    try {
      final response =
          await dio.post('/members/join', data: {"snsLoginType": snsLoginType, "snsAccessToken": snsAccessToken});

      if (response.data['code'] == 'FAIL') {
        if (response.data['body']['errorCode'] == 'INVALID_MEMBER') {
          Get.toNamed(Routes.reAuthPath);
        } else {
          Get.dialog(ErrorDialog("${response.data['body']['errorMessage']}"));
          return null;
        }
      }

      return ModelMember.fromJson(response.data['body']);
    } catch (e) {
      print(e);
      await Get.dialog(ErrorDialog("에러가 발생했습니다. 잠시 후 다시 시도해주세요."));
      return null;
    }
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
    try {
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
          Get.dialog(ErrorDialog("${response.data['body']['errorMessage']}"));
          return null;
        }
      }

      return ModelMember.fromJson(response.data['body']);
    } catch (e) {
      print(e);
      await Get.dialog(ErrorDialog("에러가 발생했습니다. 잠시 후 다시 시도해주세요."));
      return null;
    }
  }

  static Future<bool> deleteMember({required String memberId}) async {
    try {
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
          Get.dialog(ErrorDialog("${response.data['body']['errorMessage']}"));
          return false;
        }
      }

      return true;
    } catch (e) {
      print(e);
      await Get.dialog(ErrorDialog("에러가 발생했습니다. 잠시 후 다시 시도해주세요."));
      return false;
    }
  }

  static Future<ModelMember> getMember({
    required String memberId,
  }) async {
    try {
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
          Get.dialog(ErrorDialog("${response.data['body']['errorMessage']}"));
          return ModelMember.createForObsInit();
        }
      }

      return ModelMember.fromJson(response.data['body']);
    } catch (e) {
      print(e);
      await Get.dialog(ErrorDialog("에러가 발생했습니다. 잠시 후 다시 시도해주세요."));
      return ModelMember.createForObsInit();
    }
  }

  static Future<ModelRefreshAccessToken> refreshAccessToken() async {
    try {
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
          Get.dialog(ErrorDialog("${response.data['body']['errorMessage']}"));
          return ModelRefreshAccessToken();
        }
      }

      return ModelRefreshAccessToken.fromJson(response.data['body']);
    } catch (e) {
      print(e);
      await Get.dialog(ErrorDialog("에러가 발생했습니다. 잠시 후 다시 시도해주세요."));
      return ModelRefreshAccessToken();
    }
  }

  static Future<bool?> existNickName({
    required String nickName,
  }) async {
    try {
      final response = await dio.get(
        '/members/nicknames/$nickName',
      );

      if (response.data['code'] == 'FAIL') {
        if (response.data['body']['errorCode'] == 'INVALID_MEMBER') {
          Get.toNamed(Routes.reAuthPath);
        } else {
          Get.dialog(ErrorDialog("${response.data['body']['errorMessage']}"));
          return null;
        }
      }

      //true면 존재, false면 존재하지 않음
      return response.data['body'];
    } catch (e) {
      print(e);
      await Get.dialog(ErrorDialog("에러가 발생했습니다. 잠시 후 다시 시도해주세요."));
      return null;
    }
  }
}
