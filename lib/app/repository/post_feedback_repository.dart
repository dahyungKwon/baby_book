import 'package:dio/dio.dart';

import '../../base/pref_data.dart';
import '../exception/exception_invalid_member.dart';

class PostFeedbackRepository {
  var dio = Dio(BaseOptions(
    baseUrl: 'http://ec2-15-165-18-218.ap-northeast-2.compute.amazonaws.com:3001/apis',
    connectTimeout: 5000,
    receiveTimeout: 3000,
  ));

  like({required String postId}) async {
    var accessToken = await PrefData.getAccessToken();

    final response = await dio.post(
      '/posts/$postId/feedback/like',
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

  cancelLike({required String postId}) async {
    var accessToken = await PrefData.getAccessToken();

    final response = await dio.delete(
      '/posts/$postId/feedback/like',
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

  bookmark({required String postId}) async {
    var accessToken = await PrefData.getAccessToken();

    final response = await dio.post(
      '/posts/$postId/feedback/bookmark',
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

  cancelBookmark({required String postId}) async {
    var accessToken = await PrefData.getAccessToken();

    final response = await dio.delete(
      '/posts/$postId/feedback/bookmark',
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
