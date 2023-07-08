import 'package:baby_book/app/models/model_age_group.dart';
import 'package:baby_book/app/models/model_book_response.dart';
import 'package:baby_book/app/models/model_my_book.dart';
import 'package:baby_book/app/repository/paging_request.dart';
import 'package:baby_book/app/view/home/book/category_type.dart';
import 'package:dio/dio.dart';

import '../../base/pref_data.dart';
import '../exception/exception_invalid_member.dart';
import '../models/model_my_book_request.dart';

class MyBookRepository {
  var dio = Dio(BaseOptions(
    baseUrl: 'http://ec2-15-165-18-218.ap-northeast-2.compute.amazonaws.com:3001/apis',
    connectTimeout: 5000,
    receiveTimeout: 3000,
  ));

  Future<List<ModelMyBook>> getMyBookList() async {
    var accessToken = await PrefData.getAccessToken();

    final response = await dio.get(
      '/mybooks',
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
        .map<ModelMyBook>(
          (item) => ModelMyBook.fromJson(item),
        )
        .toList();
  }

  Future<ModelMyBook?> get({required int bookSetId}) async {
    var accessToken = await PrefData.getAccessToken();

    final response = await dio.get(
      '/mybooks/books/$bookSetId',
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
      return ModelMyBook.fromJson(response.data['body']);
    } else {
      return ModelMyBook.createForObsInit();
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
}
