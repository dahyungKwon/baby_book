import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import '../../base/pref_data.dart';
import '../exception/exception_invalid_member.dart';
import 'package:http_parser/http_parser.dart';

class PostImageRepository {
  var dio = Dio(BaseOptions(
      baseUrl: 'http://ec2-15-165-18-218.ap-northeast-2.compute.amazonaws.com:3001/apis',
      connectTimeout: 5000,
      receiveTimeout: 10000,
      contentType: 'multipart/form-data' //중요
      ));

  Future<bool> addImage({required String postId, required List<XFile> selectedImageList}) async {
    var accessToken = await PrefData.getAccessToken();
    final List<MultipartFile> files = selectedImageList
        .map((img) => MultipartFile.fromFileSync(img.path, contentType: MediaType("image", "jpg")))
        .toList();

    FormData formData = FormData.fromMap({"file": files});
    final response = await dio.post(
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
}
