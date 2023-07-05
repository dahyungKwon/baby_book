import 'package:baby_book/app/models/model_book.dart';
import 'package:baby_book/app/models/model_book_category.dart';
import 'package:baby_book/app/models/model_book_img.dart';
import 'package:baby_book/app/models/model_book_style.dart';
import 'package:baby_book/app/models/model_book_tag.dart';
import 'package:baby_book/app/view/home/book/category_type.dart';

import 'model_publisher.dart';

class ModelBookResponse {
  ModelBook modelBook;
  List<ModelBookCategory> categoryList;
  List<ModelBookStyle>? styleList;
  List<ModelBookTag>? tagList;
  List<ModelBookImg>? imgUrlList;
  ModelPublisher modelPublisher;

  ModelBookResponse(
      {required this.modelBook,
      required this.categoryList,
      this.styleList,
      this.tagList,
      this.imgUrlList,
      required this.modelPublisher});

  // response.data['body']
  //     .map<ModelBookResponse>(
  // (item) => ModelBookResponse.fromJson(item),
  // )
  //     .toList();
  // List<ModelPostFile>.from(json['postFileList'].map((item) => ModelPostFile.fromJson(item))).toList();
  // JSON형태에서부터 데이터를 받아온다.
  ModelBookResponse.fromJson(Map<String, dynamic> json)
      : modelBook = ModelBook.fromJson(json),
        categoryList =
            List<ModelBookCategory>.from(json['categoryList'].map((item) => ModelBookCategory.fromJson(item))).toList(),
        styleList = List<ModelBookStyle>.from(json['styleList'].map((item) => ModelBookStyle.fromJson(item))).toList(),
        tagList = List<ModelBookTag>.from(json['tagList'].map((item) => ModelBookTag.fromJson(item))).toList(),
        imgUrlList = List<ModelBookImg>.from(json['imgList'].map((item) => ModelBookImg.fromJson(item))).toList(),
        modelPublisher = ModelPublisher.fromJson(json['publisher']);

  CategoryType getCategoryType() {
    return categoryList.isNotEmpty ? categoryList[0].bookSetCategoryType : CategoryType.none;
  }
}
