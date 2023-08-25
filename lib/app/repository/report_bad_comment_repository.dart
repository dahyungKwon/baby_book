import 'package:baby_book/app/repository/paging_request.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../base/pref_data.dart';
import '../models/model_baby.dart';
import '../models/model_report_bad_comment.dart';
import '../routes/app_pages.dart';
import '../view/dialog/error_dialog.dart';

class ReportBadCommentRepository {
  static var dio = Dio(BaseOptions(
    baseUrl: 'https://babybear-readbook.com/apis',
    connectTimeout: 5000,
    receiveTimeout: 3000,
  ));

  static Future<ModelReportBadComment?> add({
    required String commentId,
    required String title,
    required String contents,
    required String memberId,
  }) async {
    try {
      var accessToken = await PrefData.getAccessToken();

      final response = await dio.post('/report/bad-comments',
          data: {"commentId": commentId, "title": title, "contents": contents, "memberId": memberId},
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

      return ModelReportBadComment.fromJson(response.data['body']);
    } catch (e) {
      print(e);
      await Get.dialog(ErrorDialog("에러가 발생했습니다. 잠시 후 다시 시도해주세요."));
      return null;
    }
  }

  static Future<ModelReportBadComment?> put({
    required int id,
    String? commentId,
    String? title,
    String? contents,
    required String memberId,
  }) async {
    try {
      var accessToken = await PrefData.getAccessToken();

      final response = await dio.put(
        '/report/bad-comments/$id',
        data: {
          "commentId": commentId,
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

      return ModelReportBadComment.fromJson(response.data['body']);
    } catch (e) {
      print(e);
      await Get.dialog(ErrorDialog("에러가 발생했습니다. 잠시 후 다시 시도해주세요."));
      return null;
    }
  }

  static Future<ModelReportBadComment> get({
    required int id,
  }) async {
    try {
      var accessToken = await PrefData.getAccessToken();

      final response = await dio.get(
        '/report/bad-comments/$id',
        options: Options(
          headers: {"at": accessToken},
        ),
      );

      if (response.data['code'] == 'FAIL') {
        if (response.data['body']['errorCode'] == 'INVALID_MEMBER') {
          Get.toNamed(Routes.reAuthPath);
        } else {
          Get.dialog(ErrorDialog("${response.data['body']['errorMessage']}"));
          return ModelReportBadComment();
        }
      }

      return ModelReportBadComment.fromJson(response.data['body']);
    } catch (e) {
      print(e);
      await Get.dialog(ErrorDialog("에러가 발생했습니다. 잠시 후 다시 시도해주세요."));
      return ModelReportBadComment();
    }
  }

  static Future<List<ModelReportBadComment>> getList(
      {required String memberId, required PagingRequest pagingRequest}) async {
    try {
      var accessToken = await PrefData.getAccessToken();

      final response = await dio.get(
        '/report/bad-comments',
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
            (item) => ModelReportBadComment.fromJson(item),
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
        '/report/bad-comments/$id',
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
