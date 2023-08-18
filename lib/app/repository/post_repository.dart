import 'package:baby_book/app/models/model_post_tag.dart';
import 'package:baby_book/app/repository/paging_request.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../base/pref_data.dart';
import '../models/model_post.dart';
import '../models/model_post_request.dart';
import '../routes/app_pages.dart';
import '../view/community/post_type.dart';
import '../view/dialog/error_dialog.dart';
import '../view/profile/member_post_type.dart';

class PostRepository {
  var dio = Dio(BaseOptions(
    baseUrl: 'http://ec2-52-78-163-194.ap-northeast-2.compute.amazonaws.com:3001/apis',
    connectTimeout: 5000,
    receiveTimeout: 3000,
  ));

  Future<List<ModelPost>> getPostList({required PostType? postType, required PagingRequest pagingRequest}) async {
    try {
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
          Get.toNamed(Routes.reAuthPath);
        } else {
          Get.dialog(ErrorDialog("${response.data['body']['errorMessage']}"));
          return [];
        }
      }

      return response.data['body']['postPagingList']
          .map<ModelPost>(
            (item) => ModelPost.fromJson(item),
          )
          .toList();
    } catch (e) {
      print(e);
      await Get.dialog(ErrorDialog("에러가 발생했습니다. 잠시 후 다시 시도해주세요."));
      return [];
    }
  }

  Future<ModelPost?> get({required String postId}) async {
    try {
      var accessToken = await PrefData.getAccessToken();

      final response = await dio.get(
        '/posts/$postId',
        options: Options(
          headers: {"at": accessToken},
        ),
      );

      if (response.data['code'] == 'FAIL') {
        if (response.data['body']['errorCode'] == 'INVALID_MEMBER') {
          Get.toNamed(Routes.reAuthPath);
        } else {
          Get.dialog(ErrorDialog("${response.data['body']['errorMessage']}"));
          return null;
        }
      }

      return ModelPost.fromJson(response.data['body']);
    } catch (e) {
      print(e);
      await Get.dialog(ErrorDialog("에러가 발생했습니다. 잠시 후 다시 시도해주세요."));
      return null;
    }
  }

  Future<ModelPost?> add({required ModelPostRequest modelPostRequest}) async {
    try {
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
          Get.toNamed(Routes.reAuthPath);
        } else {
          Get.dialog(ErrorDialog("${response.data['body']['errorMessage']}"));
          return null;
        }
      }

      return ModelPost.fromJson(response.data['body']);
    } catch (e) {
      print(e);
      await Get.dialog(ErrorDialog("에러가 발생했습니다. 잠시 후 다시 시도해주세요."));
      return null;
    }
  }

  Future<bool> put({required String postId, required ModelPostRequest modelPostRequest}) async {
    try {
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
          Get.toNamed(Routes.reAuthPath);
        } else {
          Get.dialog(ErrorDialog("${response.data['body']['errorMessage']}"));
          return false;
        }
      }
      return true;
    } catch (e) {
      print(e);
      await Get.dialog(ErrorDialog("에러가 발생했습니다. 잠시 후 다시 시도해주세요."));
      return false;
    }
  }

  Future<bool> delete({required String postId}) async {
    try {
      var accessToken = await PrefData.getAccessToken();

      final response = await dio.delete(
        '/posts/$postId',
        options: Options(
          headers: {"at": accessToken},
        ),
      );

      if (response.data['code'] == 'FAIL') {
        if (response.data['body']['errorCode'] == 'INVALID_MEMBER') {
          Get.toNamed(Routes.reAuthPath);
        } else {
          Get.dialog(ErrorDialog("${response.data['body']['errorMessage']}"));
          return false;
        }
      }

      return true;
    } catch (e) {
      print(e);
      await Get.dialog(ErrorDialog("에러가 발생했습니다. 잠시 후 다시 시도해주세요."));
      return false;
    }
  }

  Future<List<ModelPost>> getPostListByMemberPostType(
      {required String memberId, required MemberPostType memberPostType, required PagingRequest pagingRequest}) async {
    try {
      var accessToken = await PrefData.getAccessToken();

      final response = await dio.get(
        '/members/$memberId/posts',
        queryParameters: {
          'pageSize': pagingRequest.pageSize,
          'pageNumber': pagingRequest.pageNumber,
          'memberPostTypeRequest': memberPostType.code,
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

      return response.data['body']['postPagingList']
          .map<ModelPost>(
            (item) => ModelPost.fromJson(item),
          )
          .toList();
    } catch (e) {
      print(e);
      await Get.dialog(ErrorDialog("에러가 발생했습니다. 잠시 후 다시 시도해주세요."));
      return [];
    }
  }

  ///태그조회
  ///현재 안씀
  Future<ModelPostTag?> getPostTag({required String tag, required PagingRequest pagingRequest}) async {
    try {
      var accessToken = await PrefData.getAccessToken();

      final response = await dio.get(
        '/posts/tags/$tag',
        queryParameters: {
          'pageSize': pagingRequest.pageSize,
          'pageNumber': pagingRequest.pageNumber,
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
          return null;
        }
      }

      return ModelPostTag.fromJson(response.data['body']);
    } catch (e) {
      print(e);
      await Get.dialog(ErrorDialog("에러가 발생했습니다. 잠시 후 다시 시도해주세요."));
      return null;
    }
  }

  ///북태그조회
  Future<ModelPostTag?> getPostBookTag({required int bookId, required PagingRequest pagingRequest}) async {
    try {
      var accessToken = await PrefData.getAccessToken();

      final response = await dio.get(
        '/posts/book-tags/$bookId',
        queryParameters: {
          'pageSize': pagingRequest.pageSize,
          'pageNumber': pagingRequest.pageNumber,
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
          return null;
        }
      }

      return ModelPostTag.fromJson(response.data['body']);
    } catch (e) {
      print(e);
      await Get.dialog(ErrorDialog("에러가 발생했습니다. 잠시 후 다시 시도해주세요."));
      return null;
    }
  }
}
