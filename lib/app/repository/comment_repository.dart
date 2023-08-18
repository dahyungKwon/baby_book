import 'package:baby_book/app/models/model_comment_response.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../base/pref_data.dart';
import '../routes/app_pages.dart';
import '../view/dialog/error_dialog.dart';

class CommentRepository {
  var dio = Dio(BaseOptions(
    baseUrl: 'http://ec2-52-78-163-194.ap-northeast-2.compute.amazonaws.com:3001/apis',
    connectTimeout: 5000,
    receiveTimeout: 3000,
  ));

  Future<List<ModelCommentResponse>> get({
    required String commentTargetId,
  }) async {
    try {
      var accessToken = await PrefData.getAccessToken();

      final response = await dio.get(
        '/comments',
        queryParameters: {'commentTargetId': commentTargetId},
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
          .map<ModelCommentResponse>(
            (item) => ModelCommentResponse.fromJson(item),
          )
          .toList();
    } catch (e) {
      print(e);
      await Get.dialog(ErrorDialog("에러가 발생했습니다. 잠시 후 다시 시도해주세요."));
      return [];
    }
  }

  Future<List<ModelCommentResponse>> getCommentDetail({
    required String commentId,
  }) async {
    try {
      var accessToken = await PrefData.getAccessToken();

      final response = await dio.get(
        '/comments/$commentId',
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
          .map<ModelCommentResponse>(
            (item) => ModelCommentResponse.fromJson(item),
          )
          .toList();
    } catch (e) {
      print(e);
      await Get.dialog(ErrorDialog("에러가 발생했습니다. 잠시 후 다시 시도해주세요."));
      return [];
    }
  }

  Future<ModelCommentResponse?> post({
    String commentType = "COMMUNITY",
    required String commentTargetId,
    required String body,
    String? parentId,
  }) async {
    try {
      var accessToken = await PrefData.getAccessToken();

      final response = await dio.post(
        '/comments',
        data: {'commentType': commentType, 'commentTargetId': commentTargetId, 'body': body, 'parentId': parentId},
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

      return ModelCommentResponse.fromJson(response.data['body']);
    } catch (e) {
      print(e);
      await Get.dialog(ErrorDialog("에러가 발생했습니다. 잠시 후 다시 시도해주세요."));
      return null;
    }
  }

  Future<bool> modify({
    String commentType = "COMMUNITY",
    required String commentId,
    required String commentTargetId,
    required String body,
    String? parentId,
  }) async {
    try {
      var accessToken = await PrefData.getAccessToken();

      final response = await dio.put(
        '/comments/$commentId',
        data: {'commentType': commentType, 'commentTargetId': commentTargetId, 'body': body, 'parentId': parentId},
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

  Future<bool> delete({
    required String commentId,
  }) async {
    try {
      var accessToken = await PrefData.getAccessToken();

      final response = await dio.delete(
        '/comments/$commentId',
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
}
