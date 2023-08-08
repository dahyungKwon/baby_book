import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../base/pref_data.dart';
import '../exception/exception_invalid_member.dart';
import '../routes/app_pages.dart';
import '../view/dialog/error_dialog.dart';

class PostFeedbackRepository {
  var dio = Dio(BaseOptions(
    baseUrl: 'http://ec2-52-78-163-194.ap-northeast-2.compute.amazonaws.com:3001/apis',
    connectTimeout: 5000,
    receiveTimeout: 3000,
  ));

  Future<bool> like({required String postId}) async {
    var accessToken = await PrefData.getAccessToken();

    final response = await dio.post(
      '/posts/$postId/feedback/like',
      options: Options(
        headers: {"at": accessToken},
      ),
    );

    if (response.data['code'] == 'FAIL') {
      if (response.data['body']['errorCode'] == 'INVALID_MEMBER') {
        Get.toNamed(Routes.reAuthPath);
      } else {
        Get.dialog(ErrorDialog("네트워크 오류가 발생하였습니다.\n잠시 후 다시 시도해주세요.\n상세코드: ${response.data['body']['errorCode']}"));
        return false;
      }
    }
    return true;
  }

  Future<bool> cancelLike({required String postId}) async {
    var accessToken = await PrefData.getAccessToken();

    final response = await dio.delete(
      '/posts/$postId/feedback/like',
      options: Options(
        headers: {"at": accessToken},
      ),
    );

    if (response.data['code'] == 'FAIL') {
      if (response.data['body']['errorCode'] == 'INVALID_MEMBER') {
        Get.toNamed(Routes.reAuthPath);
      } else {
        Get.dialog(ErrorDialog("네트워크 오류가 발생하였습니다.\n잠시 후 다시 시도해주세요.\n상세코드: ${response.data['body']['errorCode']}"));
        return false;
      }
    }

    return true;
  }

  Future<bool> bookmark({required String postId}) async {
    var accessToken = await PrefData.getAccessToken();

    final response = await dio.post(
      '/posts/$postId/feedback/bookmark',
      options: Options(
        headers: {"at": accessToken},
      ),
    );

    if (response.data['code'] == 'FAIL') {
      if (response.data['body']['errorCode'] == 'INVALID_MEMBER') {
        Get.toNamed(Routes.reAuthPath);
      } else {
        Get.dialog(ErrorDialog("네트워크 오류가 발생하였습니다.\n잠시 후 다시 시도해주세요.\n상세코드: ${response.data['body']['errorCode']}"));
        return false;
      }
    }

    return true;
  }

  Future<bool> cancelBookmark({required String postId}) async {
    var accessToken = await PrefData.getAccessToken();

    final response = await dio.delete(
      '/posts/$postId/feedback/bookmark',
      options: Options(
        headers: {"at": accessToken},
      ),
    );

    if (response.data['code'] == 'FAIL') {
      if (response.data['body']['errorCode'] == 'INVALID_MEMBER') {
        Get.toNamed(Routes.reAuthPath);
      } else {
        Get.dialog(ErrorDialog("네트워크 오류가 발생하였습니다.\n잠시 후 다시 시도해주세요.\n상세코드: ${response.data['body']['errorCode']}"));
        return false;
      }
    }

    return true;
  }
}
