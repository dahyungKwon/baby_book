import 'package:baby_book/app/models/model_report_bad_post.dart';
import 'package:baby_book/app/repository/paging_request.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../base/pref_data.dart';
import '../models/model_baby.dart';
import '../routes/app_pages.dart';
import '../view/dialog/error_dialog.dart';

class ReportBadPostRepository {
  static var dio = Dio(BaseOptions(
    baseUrl: 'https://babybear-readbook.com/apis',
    connectTimeout: 5000,
    receiveTimeout: 3000,
  ));

  static Future<ModelReportBadPost?> add({
    required String postId,
    required String title,
    required String contents,
    required String memberId,
  }) async {
    try {
      var accessToken = await PrefData.getAccessToken();

      final response = await dio.post('/report/bad-posts',
          data: {"postId": postId, "title": title, "contents": contents, "memberId": memberId},
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

      return ModelReportBadPost.fromJson(response.data['body']);
    } catch (e) {
      print(e);
      await Get.dialog(ErrorDialog("에러가 발생했습니다. 잠시 후 다시 시도해주세요."));
      return null;
    }
  }

  static Future<ModelReportBadPost?> put({
    required int id,
    String? postId,
    String? title,
    String? contents,
    required String memberId,
  }) async {
    try {
      var accessToken = await PrefData.getAccessToken();

      final response = await dio.put(
        '/report/bad-posts/$id',
        data: {
          "postId": postId,
          "title": title,
          "contents": contents,
          "memberId": memberId,
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

      return ModelReportBadPost.fromJson(response.data['body']);
    } catch (e) {
      print(e);
      await Get.dialog(ErrorDialog("에러가 발생했습니다. 잠시 후 다시 시도해주세요."));
      return null;
    }
  }

  static Future<ModelReportBadPost> get({
    required int id,
  }) async {
    try {
      var accessToken = await PrefData.getAccessToken();

      final response = await dio.get(
        '/report/bad-posts/$id',
        options: Options(
          headers: {"at": accessToken},
        ),
      );

      if (response.data['code'] == 'FAIL') {
        if (response.data['body']['errorCode'] == 'INVALID_MEMBER') {
          Get.toNamed(Routes.reAuthPath);
        } else {
          Get.dialog(ErrorDialog("${response.data['body']['errorMessage']}"));
          return ModelReportBadPost();
        }
      }

      return ModelReportBadPost.fromJson(response.data['body']);
    } catch (e) {
      print(e);
      await Get.dialog(ErrorDialog("에러가 발생했습니다. 잠시 후 다시 시도해주세요."));
      return ModelReportBadPost();
    }
  }

  static Future<List<ModelReportBadPost>> getList(
      {required String memberId, required PagingRequest pagingRequest}) async {
    try {
      var accessToken = await PrefData.getAccessToken();

      final response = await dio.get(
        '/report/bad-posts',
        queryParameters: {
          "pageSize": pagingRequest.pageSize,
          "pageNumber": pagingRequest.pageNumber,
          "memberId": memberId
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
          return [];
        }
      }

      return response.data['body']
          .map<ModelBaby>(
            (item) => ModelReportBadPost.fromJson(item),
          )
          .toList();
    } catch (e) {
      print(e);
      await Get.dialog(ErrorDialog("에러가 발생했습니다. 잠시 후 다시 시도해주세요."));
      return [];
    }
  }

  static Future<bool> delete({
    required String id,
  }) async {
    try {
      var accessToken = await PrefData.getAccessToken();

      final response = await dio.delete(
        '/report/bad-posts/$id',
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
