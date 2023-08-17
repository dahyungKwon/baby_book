import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../../base/pref_data.dart';
import '../exception/exception_invalid_member.dart';
import '../models/model_baby.dart';
import '../routes/app_pages.dart';
import '../view/dialog/error_dialog.dart';
import '../view/login/gender_type.dart';

class BabyRepository {
  static var dio = Dio(BaseOptions(
    baseUrl: 'http://ec2-52-78-163-194.ap-northeast-2.compute.amazonaws.com:3001/apis',
    connectTimeout: 5000,
    receiveTimeout: 3000,
  ));

  static Future<ModelBaby?> createBaby({
    required String memberId,
    required String name,
    required GenderType gender,
    required DateTime birth,
  }) async {
    var accessToken = await PrefData.getAccessToken();

    final response = await dio.post('/babys',
        data: {
          "memberId": memberId,
          "name": name,
          "gender": gender.code,
          "birth": DateFormat('yyyy-MM-dd').format(birth)
        },
        options: Options(
          headers: {"at": accessToken},
        ));

    if (response.data['code'] == 'FAIL') {
      if (response.data['body']['errorCode'] == 'INVALID_MEMBER') {
        Get.toNamed(Routes.reAuthPath);
      } else {
        Get.dialog(ErrorDialog("${response.data['body']['errorMessage']}"));
        return null;
      }
    }

    return ModelBaby.fromJson(response.data['body']);
  }

  static Future<ModelBaby?> putBaby({
    required String babyId,
    String? name,
    GenderType? gender,
    DateTime? birth,
  }) async {
    var accessToken = await PrefData.getAccessToken();

    final response = await dio.put(
      '/babys/$babyId',
      data: {
        "babyId": babyId,
        "name": name,
        "gender": gender!.code,
        "birth": birth != null ? DateFormat('yyyy-MM-dd').format(birth) : null,
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

    return ModelBaby.fromJson(response.data['body']);
  }

  static Future<ModelBaby> getBaby({
    required String babyId,
  }) async {
    var accessToken = await PrefData.getAccessToken();

    final response = await dio.get(
      '/babys/$babyId',
      options: Options(
        headers: {"at": accessToken},
      ),
    );

    if (response.data['code'] == 'FAIL') {
      if (response.data['body']['errorCode'] == 'INVALID_MEMBER') {
        Get.toNamed(Routes.reAuthPath);
      } else {
        Get.dialog(ErrorDialog("${response.data['body']['errorMessage']}"));
        return ModelBaby();
      }
    }

    return ModelBaby.fromJson(response.data['body']);
  }

  static Future<List<ModelBaby>> getBabyList({required String memberId}) async {
    var accessToken = await PrefData.getAccessToken();

    final response = await dio.get(
      '/babys',
      queryParameters: {"memberId": memberId},
      options: Options(
        headers: {"at": accessToken},
      ),
    );

    if (response.data['code'] == 'FAIL') {
      if (response.data['body']['errorCode'] == 'INVALID_MEMBER') {
        Get.toNamed(Routes.reAuthPath);
      } else {
        Get.dialog(ErrorDialog("${response.data['body']['errorMessage']}"));
        return [];
      }
    }

    return response.data['body']
        .map<ModelBaby>(
          (item) => ModelBaby.fromJson(item),
        )
        .toList();
  }

  static Future<bool> deleteBaby({
    required String babyId,
  }) async {
    var accessToken = await PrefData.getAccessToken();

    final response = await dio.delete(
      '/babys/$babyId',
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
  }

  static Future<bool> deleteAllBaby() async {
    var accessToken = await PrefData.getAccessToken();

    final response = await dio.delete(
      '/babys',
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
  }
}
