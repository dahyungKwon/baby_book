import 'package:baby_book/app/models/model_book_response.dart';
import 'package:baby_book/app/models/model_my_book.dart';
import 'package:baby_book/app/models/model_my_book_member_response.dart';
import 'package:baby_book/app/repository/paging_request.dart';
import 'package:baby_book/app/view/home/book/HoldType.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../base/pref_data.dart';
import '../exception/exception_invalid_member.dart';
import '../models/model_my_book_request.dart';
import '../models/model_my_book_response.dart';
import '../routes/app_pages.dart';
import '../view/dialog/error_dialog.dart';

class MyBookRepository {
  var dio = Dio(BaseOptions(
    baseUrl: 'http://ec2-52-78-163-194.ap-northeast-2.compute.amazonaws.com:3001/apis',
    connectTimeout: 5000,
    receiveTimeout: 3000,
  ));

  Future<List<ModelMyBookResponse>> getMyBookList(
      {required PagingRequest pagingRequest,
      required String memberId,
      required String babyId,
      required HoldType holdType}) async {
    try {
      var accessToken = await PrefData.getAccessToken();

      final response = await dio.get(
        '/mybooks',
        queryParameters: {
          "pageSize": pagingRequest.pageSize,
          "pageNumber": pagingRequest.pageNumber,
          "memberId": memberId,
          "babyId": babyId,
          "holdType": holdType.code
        },
        options: Options(
          headers: {"at": accessToken},
        ),
      );

      if (response.data['code'] == 'FAIL') {
        if (response.data['body']['errorCode'] == 'INVALID_MEMBER') {
          Get.toNamed(Routes.reAuthPath);
        } else {
          Get.dialog(
              ErrorDialog("네트워크 오류가 발생하였습니다.\n잠시 후 다시 시도해주세요.\n상세 에러 코드: ${response.data['body']['errorCode']}"));
          return [];
        }
      }

      return response.data['body']
          .map<ModelMyBookResponse>(
            (item) => ModelMyBookResponse.fromJson(item),
          )
          .toList();
    } catch (e) {
      print(e);
      await Get.dialog(ErrorDialog("에러가 발생했습니다. 잠시 후 다시 시도해주세요."));
      return [];
    }
  }

  Future<ModelMyBookResponse> get({required int bookSetId, String? babyId}) async {
    try {
      var accessToken = await PrefData.getAccessToken();

      final response = await dio.get(
        '/mybooks/books/$bookSetId',
        queryParameters: {"babyId": babyId},
        options: Options(
          headers: {"at": accessToken},
        ),
      );

      if (response.data['code'] == 'FAIL') {
        if (response.data['body']['errorCode'] == 'INVALID_MEMBER') {
          Get.toNamed(Routes.reAuthPath);
        } else {
          Get.dialog(
              ErrorDialog("네트워크 오류가 발생하였습니다.\n잠시 후 다시 시도해주세요.\n상세 에러 코드: ${response.data['body']['errorCode']}"));
          return ModelMyBookResponse(
              myBook: ModelMyBook.createForObsInit(), modelBookResponse: ModelBookResponse.createForObsInit());
        }
      }

      if (response.data['body'] != null) {
        return ModelMyBookResponse.fromJson(response.data['body']);
      } else {
        return ModelMyBookResponse(
            myBook: ModelMyBook.createForObsInit(), modelBookResponse: ModelBookResponse.createForObsInit());
      }
    } catch (e) {
      print(e);
      await Get.dialog(ErrorDialog("에러가 발생했습니다. 잠시 후 다시 시도해주세요."));
      return ModelMyBookResponse(
          myBook: ModelMyBook.createForObsInit(), modelBookResponse: ModelBookResponse.createForObsInit());
    }
  }

  Future<ModelMyBook?> post({
    required ModelMyBookRequest request,
  }) async {
    var accessToken = await PrefData.getAccessToken();

    final response = await dio.post(
      '/mybooks',
      data: request.toJson(),
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

    return ModelMyBook.fromJson(response.data['body']);
  }

  Future<ModelMyBook?> modify({
    required String myBookId,
    required ModelMyBookRequest request,
  }) async {
    var accessToken = await PrefData.getAccessToken();

    final response = await dio.put(
      '/mybooks/$myBookId',
      data: request.toJson(),
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

    return ModelMyBook.fromJson(response.data['body']);
  }

  Future<bool> delete({
    required String myBookId,
  }) async {
    var accessToken = await PrefData.getAccessToken();

    final response = await dio.delete(
      '/mybooks/$myBookId',
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

  ///해당 책을 몇명이 보고 있는지와 멤버리스트
  Future<ModelMyBookMemberResponse?> getListByBook({required int bookId, required PagingRequest pagingRequest}) async {
    var accessToken = await PrefData.getAccessToken();

    final response = await dio.get(
      '/mybooks/books/$bookId/members',
      queryParameters: {"pageSize": pagingRequest.pageSize, "pageNumber": pagingRequest.pageNumber},
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

    return ModelMyBookMemberResponse.fromJson(response.data['body']);
  }
}
