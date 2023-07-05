import 'package:baby_book/app/view/home/book/category_type.dart';

class ModelBookCategory {
  int bookSetCategoryJoinId;
  int bookSetId;
  CategoryType bookSetCategoryType;

  ModelBookCategory({required this.bookSetCategoryJoinId, required this.bookSetId, required this.bookSetCategoryType});

  // JSON형태에서부터 데이터를 받아온다.
  ModelBookCategory.fromJson(Map<String, dynamic> json)
      : bookSetCategoryJoinId = json['bookSetCategoryJoinId'],
        bookSetId = json['bookSetId'],
        bookSetCategoryType = CategoryType.findByCode(json['bookSetCategoryType']);
}
