import '../view/home/book/ReviewType.dart';
import '../view/home/book/UsedType.dart';
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

  static ModelMyBookResponse createForObsInit() {
    return ModelMyBookResponse(
        myBook: ModelMyBook.createForObsInit(), modelBookResponse: ModelBookResponse.createForObsInit());
  }

  bool needDetailReview() {
    return (myBook.inMonth == 0) &&
        (myBook.reviewType == ReviewType.none) &&
        (myBook.usedType == UsedType.none) &&
        (myBook.usedType == UsedType.none);
  }
}
