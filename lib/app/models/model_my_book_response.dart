import 'model_book_response.dart';
import 'model_my_book.dart';

class ModelMyBookResponse {
  ModelMyBook myBook;
  ModelBookResponse modelBookResponse;

  ModelMyBookResponse({
    required this.myBook,
    required this.modelBookResponse,
  });

  ModelMyBookResponse.fromJson(Map<String, dynamic> json)
      : myBook = ModelMyBook.fromJson(json['myBook']),
        modelBookResponse = ModelBookResponse.fromJson(json['bookSetResponse']);
}
