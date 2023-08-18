import 'package:baby_book/app/repository/paging_request.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../base/pref_data.dart';
import '../models/model_baby.dart';
import '../models/model_report_new_book.dart';
import '../routes/app_pages.dart';
import '../view/dialog/error_dialog.dart';

class ReportNewBookRepository {
  static var dio = Dio(BaseOptions(
    baseUrl: 'http://ec2-52-78-163-194.ap-northeast-2.compute.amazonaws.com:3001/apis',
    connectTimeout: 5000,
    receiveTimeout: 3000,
  ));

  static Future<ModelReportNewBook?> add({
    required String title,
    required String contents,
    required String memberId,
  }) async {
    try {
      var accessToken = await PrefData.getAccessToken();

      final response = await dio.post('/report-new-books',
          data: {"title": title, "contents": contents, "memberId": memberId},
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

      return ModelReportNewBook.fromJson(response.data['body']);
    } catch (e) {
      print(e);
      await Get.dialog(ErrorDialog("에러가 발생했습니다. 잠시 후 다시 시도해주세요."));
      return null;
    }
  }

  static Future<ModelReportNewBook?> put({
    required int id,
    String? title,
    String? contents,
    required String memberId,
  }) async {
    try {
      var accessToken = await PrefData.getAccessToken();

      final response = await dio.put(
        '/report-new-books/$id',
        data: {
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

      return ModelReportNewBook.fromJson(response.data['body']);
    } catch (e) {
      print(e);
      await Get.dialog(ErrorDialog("에러가 발생했습니다. 잠시 후 다시 시도해주세요."));
      return null;
    }
  }

  static Future<ModelReportNewBook> get({
    required int id,
  }) async {
    try {
      var accessToken = await PrefData.getAccessToken();

      final response = await dio.get(
        '/report-new-books/$id',
        options: Options(
          headers: {"at": accessToken},
        ),
      );

      if (response.data['code'] == 'FAIL') {
        if (response.data['body']['errorCode'] == 'INVALID_MEMBER') {
          Get.toNamed(Routes.reAuthPath);
        } else {
          Get.dialog(ErrorDialog("${response.data['body']['errorMessage']}"));
          return ModelReportNewBook();
        }
      }

      return ModelReportNewBook.fromJson(response.data['body']);
    } catch (e) {
      print(e);
      await Get.dialog(ErrorDialog("에러가 발생했습니다. 잠시 후 다시 시도해주세요."));
      return ModelReportNewBook();
    }
  }

  static Future<List<ModelReportNewBook>> getList(
      {required String memberId, required PagingRequest pagingRequest}) async {
    try {
      var accessToken = await PrefData.getAccessToken();

      final response = await dio.get(
        '/report-new-books',
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
            (item) => ModelReportNewBook.fromJson(item),
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
        '/report-new-books/$id',
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
