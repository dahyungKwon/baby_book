import 'package:baby_book/app/models/model_book.dart';
import 'package:dio/dio.dart';

import '../../base/pref_data.dart';
import '../exception/exception_invalid_member.dart';

class CommentRepository {
  var dio = Dio(BaseOptions(
    baseUrl: 'http://ec2-15-165-18-218.ap-northeast-2.compute.amazonaws.com:3001/apis',
    connectTimeout: 5000,
    receiveTimeout: 3000,
  ));

  Future<List<ModelBook>> getBookList({
    required String categoryList,
  }) async {
    var accessToken = await PrefData.getAccessToken();

    final response = await dio.get(
      '/bookset',
      queryParameters: {
        'pageSize': 15,
        'pageNumber': '1',
        'categoryList': categoryList, //'MATH,LIFE'
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
        .map<ModelBook>(
          (item) => ModelBook.fromJson(item),
        )
        .toList();
  }
}
