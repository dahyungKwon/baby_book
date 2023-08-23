import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' hide MultipartFile, MediaType, FormData;

///dio랑 겹쳐서 빼버림
import 'package:image_picker/image_picker.dart';

import '../../base/pref_data.dart';
import 'package:http_parser/http_parser.dart';

import '../routes/app_pages.dart';
import '../view/dialog/error_dialog.dart';

class PostImageRepository {
  /// 파일 전송 시 사용됨 [중요!!]
  var fileDio = Dio(BaseOptions(
      baseUrl: 'https://babybear-readbook.com/apis',
      connectTimeout: 5000,
      receiveTimeout: 10000,
      contentType: 'multipart/form-data'));

  var dio = Dio(BaseOptions(
    baseUrl: 'https://babybear-readbook.com/apis',
    connectTimeout: 5000,
    receiveTimeout: 10000,
  ));

  Future<bool> addImage({required String postId, required List<XFile> selectedImageList}) async {
    try {
      var accessToken = await PrefData.getAccessToken();
      final List<MultipartFile> files = selectedImageList
          .map((img) => MultipartFile.fromFileSync(img.path, contentType: MediaType("image", "jpg")))
          .toList();

      FormData formData = FormData.fromMap({"file": files});
      final response = await fileDio.post(
        '/posts/$postId/files',
        data: formData,
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
      EasyLoading.dismiss();
      await Get.dialog(ErrorDialog("에러가 발생했습니다. 잠시 후 다시 시도해주세요."));
      return false;
    }
  }

  Future<bool> removeImageAll({required String postId}) async {
    try {
      var accessToken = await PrefData.getAccessToken();

      final response = await dio.delete(
        '/posts/$postId/files',
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

  Future<bool> removeImage({required String postId, required String fileId}) async {
    try {
      var accessToken = await PrefData.getAccessToken();

      final response = await dio.delete(
        '/posts/$postId/files/$fileId',
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
