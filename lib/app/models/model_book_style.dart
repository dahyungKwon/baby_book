import '../view/home/book/book_style_detail_type.dart';
import '../view/home/book/book_style_type.dart';

class ModelBookStyle {
  BookStyleType? bookStyleType;
  BookStyleDetailType? bookStyleDetailType;

  ModelBookStyle({this.bookStyleType, this.bookStyleDetailType});

  // JSON형태에서부터 데이터를 받아온다.
  ModelBookStyle.fromJson(Map<dynamic, dynamic> json)
      : bookStyleType = json['styleList']['bookStyleType'],
        bookStyleDetailType = json['styleList']['bookStyleDetailType'];
}
