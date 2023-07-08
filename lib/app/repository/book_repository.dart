import 'package:baby_book/app/models/model_age_group.dart';
import 'package:baby_book/app/models/model_book_response.dart';
import 'package:baby_book/app/repository/paging_request.dart';
import 'package:baby_book/app/view/home/book/category_type.dart';
import 'package:dio/dio.dart';

import '../../base/pref_data.dart';
import '../exception/exception_invalid_member.dart';

class BookRepository {
  var dio = Dio(BaseOptions(
    baseUrl: 'http://ec2-15-165-18-218.ap-northeast-2.compute.amazonaws.com:3001/apis',
    connectTimeout: 5000,
    receiveTimeout: 3000,
  ));

  Future<List<ModelBookResponse>> getBookList(
      {required ModelAgeGroup ageGroup, //일단 1개만 받도록
      required CategoryType categoryType, //일단 1개만 받도록
      required PagingRequest pagingRequest}) async {
    var accessToken = await PrefData.getAccessToken();

    final response = await dio.get(
      '/bookset',
      queryParameters: {
        'pageSize': pagingRequest.pageSize,
        'pageNumber': pagingRequest.pageNumber,
        'categoryList': categoryType.code, //리스트형태인데 예시 ['MATH,LIFE'], 일단 하나만 보내게 해둠
        'startMonth': ageGroup.minAge,
        'endMonth': ageGroup.maxAge,
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
        .map<ModelBookResponse>(
          (item) => ModelBookResponse.fromJson(item),
        )
        .toList();
  }

  Future<ModelBookResponse> get({required int bookSetId}) async {
    var accessToken = await PrefData.getAccessToken();

    final response = await dio.get(
      '/bookset/$bookSetId',
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

    return ModelBookResponse.fromJson(response.data['body']);
  }
}
