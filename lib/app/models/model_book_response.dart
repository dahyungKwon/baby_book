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
  bool liked = false;

  ModelBookResponse(
      {required this.modelBook,
      required this.categoryList,
      this.styleList,
      this.tagList,
      this.imgUrlList,
      required this.modelPublisher,
      required this.liked});

  static ModelBookResponse createForObsInit() {
    return ModelBookResponse(
        modelBook: ModelBook(),
        categoryList: [],
        styleList: [],
        tagList: [],
        imgUrlList: [],
        modelPublisher: ModelPublisher(publisherId: 0, publisherLogoUrl: "", publisherName: "", publisherWebUrl: ""),
        liked: false);
  }

  // JSON형태에서부터 데이터를 받아온다.
  ModelBookResponse.fromJson(Map<String, dynamic> json)
      : modelBook = ModelBook.fromJson(json),
        categoryList =
            List<ModelBookCategory>.from(json['categoryList'].map((item) => ModelBookCategory.fromJson(item))).toList(),
        styleList = List<ModelBookStyle>.from(json['styleList'].map((item) => ModelBookStyle.fromJson(item))).toList(),
        tagList = List<ModelBookTag>.from(json['tagList'].map((item) => ModelBookTag.fromJson(item))).toList(),
        imgUrlList = List<ModelBookImg>.from(json['imgList'].map((item) => ModelBookImg.fromJson(item))).toList(),
        modelPublisher = ModelPublisher.fromJson(json['publisher']),
        liked = json['liked'] != null ? json['liked'] : false;

  CategoryType getCategoryType() {
    return categoryList.isNotEmpty ? categoryList[0].bookSetCategoryType : CategoryType.none;
  }

  bool existFirstImg() {
    return modelBook.id != null;
  }

  String getFirstImg() {
    return "https://babybook-file-bucket.s3.ap-northeast-2.amazonaws.com/img_book_${modelBook.id}.png";
  }

  String getPlaceHolderImg() {
    return "assets/images/book_placeholder.png";
  }

  /// webUrl을 기본적으로 리턴 , 없으면 출판사 주소 전달
  String? getWebUrl() {
    if (modelBook.introduceWebUrl == null || modelBook.introduceWebUrl!.isEmpty) {
      return modelPublisher.publisherWebUrl;
    } else {
      return modelBook.introduceWebUrl;
    }
  }
}
