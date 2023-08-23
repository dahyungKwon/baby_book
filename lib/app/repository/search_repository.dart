import 'package:baby_book/app/models/model_book_response.dart';
import 'package:baby_book/app/repository/paging_request.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../base/pref_data.dart';
import '../models/model_publisher.dart';
import '../routes/app_pages.dart';
import '../view/dialog/error_dialog.dart';

class SearchRepository {
  var dio = Dio(BaseOptions(
    baseUrl: 'https://babybear-readbook.com/apis',
    connectTimeout: 5000,
    receiveTimeout: 3000,
  ));

  Future<List<ModelBookResponse>> getBookListForBookName(
      {required String keyword, required PagingRequest pagingRequest}) async {
    try {
      var accessToken = await PrefData.getAccessToken();

      final response = await dio.get(
        '/search/books/book-name',
        queryParameters: {
          'pageSize': pagingRequest.pageSize,
          'pageNumber': pagingRequest.pageNumber,
          'keyword': keyword,
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
          .map<ModelBookResponse>(
            (item) => ModelBookResponse.fromJson(item),
          )
          .toList();
    } catch (e) {
      print(e);
      await Get.dialog(ErrorDialog("에러가 발생했습니다. 잠시 후 다시 시도해주세요."));
      return [];
    }
  }

  Future<List<ModelBookResponse>> getBookListForPublisherId(
      {required int publisherId, required PagingRequest pagingRequest}) async {
    try {
      var accessToken = await PrefData.getAccessToken();

      final response = await dio.get(
        '/search/books/publisher-id',
        queryParameters: {
          'pageSize': pagingRequest.pageSize,
          'pageNumber': pagingRequest.pageNumber,
          'publisherId': publisherId,
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
          .map<ModelBookResponse>(
            (item) => ModelBookResponse.fromJson(item),
          )
          .toList();
    } catch (e) {
      print(e);
      await Get.dialog(ErrorDialog("에러가 발생했습니다. 잠시 후 다시 시도해주세요."));
      return [];
    }
  }

  Future<List<ModelPublisher>> getPublisherListForPublisherName(
      {required String keyword, required PagingRequest pagingRequest}) async {
    try {
      var accessToken = await PrefData.getAccessToken();

      final response = await dio.get(
        '/search/publisher/publisher-name',
        queryParameters: {
          'pageSize': pagingRequest.pageSize,
          'pageNumber': pagingRequest.pageNumber,
          'keyword': keyword,
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
          .map<ModelPublisher>(
            (item) => ModelPublisher.fromJson(item),
          )
          .toList();
    } catch (e) {
      print(e);
      await Get.dialog(ErrorDialog("에러가 발생했습니다. 잠시 후 다시 시도해주세요."));
      return [];
    }
  }
}
