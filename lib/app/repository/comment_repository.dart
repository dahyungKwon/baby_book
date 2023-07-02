import 'package:baby_book/app/models/model_comment_response.dart';
import 'package:dio/dio.dart';

import '../../base/pref_data.dart';
import '../exception/exception_invalid_member.dart';

class CommentRepository {
  var dio = Dio(BaseOptions(
    baseUrl: 'http://ec2-15-165-18-218.ap-northeast-2.compute.amazonaws.com:3001/apis',
    connectTimeout: 5000,
    receiveTimeout: 3000,
  ));

  Future<List<ModelCommentResponse>> get({
    required String commentTargetId,
  }) async {
    var accessToken = await PrefData.getAccessToken();

    final response = await dio.get(
      '/comments',
      queryParameters: {'commentTargetId': commentTargetId},
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
        .map<ModelCommentResponse>(
          (item) => ModelCommentResponse.fromJson(item),
        )
        .toList();
  }

  Future<List<ModelCommentResponse>> getCommentDetail({
    required String commentId,
  }) async {
    var accessToken = await PrefData.getAccessToken();

    final response = await dio.get(
      '/comments/$commentId',
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
        .map<ModelCommentResponse>(
          (item) => ModelCommentResponse.fromJson(item),
        )
        .toList();
  }

  Future<ModelCommentResponse> post({
    String commentType = "COMMUNITY",
    required String commentTargetId,
    required String body,
    String? parentId,
  }) async {
    var accessToken = await PrefData.getAccessToken();

    final response = await dio.post(
      '/comments',
      data: {'commentType': commentType, 'commentTargetId': commentTargetId, 'body': body, 'parentId': parentId},
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

    return ModelCommentResponse.fromJson(response.data['body']);
  }

  Future<bool> modify({
    String commentType = "COMMUNITY",
    required String commentId,
    required String commentTargetId,
    required String body,
    String? parentId,
  }) async {
    var accessToken = await PrefData.getAccessToken();

    final response = await dio.put(
      '/comments/$commentId',
      data: {'commentType': commentType, 'commentTargetId': commentTargetId, 'body': body, 'parentId': parentId},
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

  Future<bool> delete({
    required String commentId,
  }) async {
    var accessToken = await PrefData.getAccessToken();

    final response = await dio.delete(
      '/comments/$commentId',
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
