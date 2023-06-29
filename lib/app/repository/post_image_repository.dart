import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import '../../base/pref_data.dart';
import '../exception/exception_invalid_member.dart';
import 'package:http_parser/http_parser.dart';

class PostImageRepository {
  /// 파일 전송 시 사용됨 [중요!!]
  var fileDio = Dio(BaseOptions(
      baseUrl: 'http://ec2-15-165-18-218.ap-northeast-2.compute.amazonaws.com:3001/apis',
      connectTimeout: 5000,
      receiveTimeout: 10000,
      contentType: 'multipart/form-data'));

  var dio = Dio(BaseOptions(
    baseUrl: 'http://ec2-15-165-18-218.ap-northeast-2.compute.amazonaws.com:3001/apis',
    connectTimeout: 5000,
    receiveTimeout: 10000,
  ));

  Future<bool> addImage({required String postId, required List<XFile> selectedImageList}) async {
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
        throw InvalidMemberException();
      } else {
        throw Exception(response.data['body']['errorCode']);
      }
    }

    return true;
  }

  Future<bool> removeImageAll({required String postId}) async {
    var accessToken = await PrefData.getAccessToken();

    final response = await dio.delete(
      '/posts/$postId/files',
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

  Future<bool> removeImage({required String postId, required String fileId}) async {
    var accessToken = await PrefData.getAccessToken();

    final response = await dio.delete(
      '/posts/$postId/files/$fileId',
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
