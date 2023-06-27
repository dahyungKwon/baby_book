import 'package:baby_book/app/repository/paging_request.dart';
import 'package:dio/dio.dart';

import '../../base/pref_data.dart';
import '../exception/exception_invalid_member.dart';
import '../models/model_post.dart';
import '../models/model_post_request.dart';
import '../view/community/post_type.dart';

class PostRepository {
  var dio = Dio(BaseOptions(
    baseUrl: 'http://ec2-15-165-18-218.ap-northeast-2.compute.amazonaws.com:3001/apis',
    connectTimeout: 5000,
    receiveTimeout: 3000,
  ));

  Future<List<ModelPost>> getPostList({required PostType? postType, required PagingRequest pagingRequest}) async {
    var accessToken = await PrefData.getAccessToken();

    final response = await dio.get(
      '/posts',
      queryParameters: {
        'pageSize': pagingRequest.pageSize,
        'pageNumber': pagingRequest.pageNumber,
        'postTypeRequest': postType?.code ?? "ALL",
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

  Future<ModelPost> get({required String postId}) async {
    var accessToken = await PrefData.getAccessToken();

    final response = await dio.get(
      '/posts/$postId',
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

    return ModelPost.fromJson(response.data['body']);
  }

  Future<ModelPost> add({required ModelPostRequest modelPostRequest}) async {
    var accessToken = await PrefData.getAccessToken();

    final response = await dio.post(
      '/posts',
      data: modelPostRequest.toJson(),
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

    return ModelPost.fromJson(response.data['body']);
  }

  put({required String postId, required ModelPostRequest modelPostRequest}) async {
    var accessToken = await PrefData.getAccessToken();

    final response = await dio.put(
      '/posts/$postId',
      data: modelPostRequest.toJson(),
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
  }

  delete({required String postId}) async {
    var accessToken = await PrefData.getAccessToken();

    final response = await dio.delete(
      '/posts/$postId',
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
  }
}
