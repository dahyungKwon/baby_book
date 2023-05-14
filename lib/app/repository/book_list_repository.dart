import 'package:baby_book/app/models/model_book.dart';
import 'package:dio/dio.dart';

class BookListRepository {
  static Future<List<ModelBook>> fetchData({
    required String categoryList,
  }) async {
    final response = await Dio().get(
      'http://ec2-43-201-150-252.ap-northeast-2.compute.amazonaws.com:3001/booki/bookset',
      queryParameters: {
        'pageSize': 15,
        'pageNumber': '1',
        'categoryList': categoryList, //'MATH,LIFE'
      },
    );

    return response.data['body']
        .map<ModelBook>(
          (item) => ModelBook.fromJson(item),
        ).toList();
  }
}
