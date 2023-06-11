import 'package:dio/dio.dart';

import '../../base/pref_data.dart';
import '../exception/exception_invalid_member.dart';
import '../models/model_post.dart';

class PostRepository {
  var dio = Dio(BaseOptions(
    baseUrl: 'http://ec2-52-79-255-107.ap-northeast-2.compute.amazonaws.com:3001/apis',
    connectTimeout: 5000,
    receiveTimeout: 3000,
  ));

  Future<List<ModelPost>> getPostList({
    required String? postTypeRequest,
  }) async {
    var accessToken = await PrefData.getAccessToken();

    final response = await dio.get(
      '/posts',
      queryParameters: {
        'pageSize': 15,
        'pageNumber': '1',
        'postTypeRequest': postTypeRequest ?? "ALL",
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

    return response.data['body']['postPagingList']
        .map<ModelPost>(
          (item) => ModelPost.fromJson(item),
        )
        .toList();
  }
}
