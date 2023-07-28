import 'package:baby_book/app/models/model_book_response.dart';
import 'package:baby_book/app/models/model_my_book.dart';
import 'package:baby_book/app/models/model_my_book_member_response.dart';
import 'package:baby_book/app/repository/paging_request.dart';
import 'package:baby_book/app/view/home/book/HoldType.dart';
import 'package:dio/dio.dart';

import '../../base/pref_data.dart';
import '../exception/exception_invalid_member.dart';
import '../models/model_my_book_request.dart';
import '../models/model_my_book_response.dart';

class MyBookRepository {
  var dio = Dio(BaseOptions(
    baseUrl: 'http://ec2-15-165-18-218.ap-northeast-2.compute.amazonaws.com:3001/apis',
    connectTimeout: 5000,
    receiveTimeout: 3000,
  ));

  Future<List<ModelMyBookResponse>> getMyBookList(
      {required PagingRequest pagingRequest,
      required String memberId,
      required String babyId,
      required HoldType holdType}) async {
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
        throw InvalidMemberException();
      } else {
        throw Exception(response.data['body']['errorCode']);
      }
    }

    return response.data['body']
        .map<ModelMyBookResponse>(
          (item) => ModelMyBookResponse.fromJson(item),
        )
        .toList();
  }

  Future<ModelMyBookResponse?> get({required int bookSetId, String? babyId}) async {
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
        throw InvalidMemberException();
      } else {
        throw Exception(response.data['body']['errorCode']);
      }
    }

    if (response.data['body'] != null) {
      return ModelMyBookResponse.fromJson(response.data['body']);
    } else {
      return ModelMyBookResponse(
          myBook: ModelMyBook.createForObsInit(), modelBookResponse: ModelBookResponse.createForObsInit());
    }
  }

  Future<ModelMyBook> post({
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
        throw InvalidMemberException();
      } else {
        throw Exception(response.data['body']['errorCode']);
      }
    }

    return ModelMyBook.fromJson(response.data['body']);
  }

  Future<ModelMyBook> modify({
    required String myBookId,
    required ModelMyBookRequest request,
  }) async {
    var accessToken = await PrefData.getAccessToken();

    final response = await dio.post(
      '/mybooks/$myBookId',
      data: request.toJson(),
      options: Options(
        headers: {"at": accessToken},
      ),
    );

    if (response.data['code'] == 'FAIL') {
      if (response.data['body']['errorCode'] == 'INVALID_MEMBER') {
        throw InvalidMemberException();
      } else {
        throw Exception(response.data['body']['errorCode']);
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
        throw InvalidMemberException();
      } else {
        throw Exception(response.data['body']['errorCode']);
      }
    }

    return true;
  }

  ///해당 책을 몇명이 보고 있는지와 멤버리스트
  Future<ModelMyBookMemberResponse> getListByBook({required int bookId, required PagingRequest pagingRequest}) async {
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
        throw InvalidMemberException();
      } else {
        throw Exception(response.data['body']['errorCode']);
      }
    }

    return ModelMyBookMemberResponse.fromJson(response.data['body']);
  }
}
