import 'package:baby_book/app/models/model_age_group.dart';
import 'package:baby_book/app/models/model_book_response.dart';
import 'package:baby_book/app/repository/paging_request.dart';
import 'package:baby_book/app/view/home/book/category_type.dart';
import 'package:baby_book/app/view/home/tab/book_list_sort_type.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../base/pref_data.dart';
import '../exception/exception_invalid_member.dart';
import '../routes/app_pages.dart';
import '../view/dialog/error_dialog.dart';

class BookRepository {
  var dio = Dio(BaseOptions(
    baseUrl: 'http://ec2-52-78-163-194.ap-northeast-2.compute.amazonaws.com:3001/apis',
    connectTimeout: 5000,
    receiveTimeout: 3000,
  ));

  Future<List<ModelBookResponse>> getBookList(
      {required ModelAgeGroup ageGroup, //일단 1개만 받도록
      required CategoryType categoryType, //일단 1개만 받도록
      required PagingRequest pagingRequest,
      required BookListSortType bookListSortType}) async {
    try {
      var accessToken = await PrefData.getAccessToken();
      // pageSize=15&pageNumber=1&categoryList=ALL&startMonth=0&endMonth=17&sortType=LIKE
      final response = await dio.get(
        '/bookset/guest',
        queryParameters: {
          'pageSize': pagingRequest.pageSize,
          'pageNumber': pagingRequest.pageNumber,
          'categoryList': categoryType.code, //리스트형태인데 예시 ['MATH,LIFE'], 일단 하나만 보내게 해둠
          'startMonth': ageGroup.minAge,
          'endMonth': ageGroup.maxAge,
          'sortType': bookListSortType?.code ?? BookListSortType.hot
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

      return response.data['body']
          .map<ModelBookResponse>(
            (item) => ModelBookResponse.fromJson(item),
          )
          .toList();
    } catch (e) {
      print(e);
      await Get.dialog(ErrorDialog("에러가 발생했습니다. 잠시 후 다시 시도해주세요."));
      return [];
    }
  }

  Future<ModelBookResponse> get({required int bookSetId}) async {
    var accessToken = await PrefData.getAccessToken();

    try {
      final response = await dio.get(
        '/bookset/$bookSetId',
        options: Options(
          headers: {"at": accessToken},
        ),
      );
      if (response.data['code'] == 'FAIL') {
        if (response.data['body']['errorCode'] == 'INVALID_MEMBER') {
          Get.toNamed(Routes.reAuthPath);
        } else {
          Get.dialog(ErrorDialog("${response.data['body']['errorMessage']}"));
          return ModelBookResponse.createForObsInit();
        }
      }

      return ModelBookResponse.fromJson(response.data['body']);
    } catch (e) {
      print(e);
      await Get.dialog(ErrorDialog("에러가 발생했습니다. 잠시 후 다시 시도해주세요."));
      return ModelBookResponse.createForObsInit();
    }
  }

  Future<bool> like({required int bookSetId}) async {
    try {
      var accessToken = await PrefData.getAccessToken();

      final response = await dio.post(
        '/bookset/$bookSetId/like',
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

  Future<bool> cancelLike({required int bookSetId}) async {
    try {
      var accessToken = await PrefData.getAccessToken();

      final response = await dio.post(
        '/bookset/$bookSetId/cancel-like',
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
}
