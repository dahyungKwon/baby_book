import 'package:baby_book/app/models/model_book.dart';
import 'package:baby_book/app/models/model_book_category.dart';
import 'package:baby_book/app/models/model_book_img.dart';
import 'package:baby_book/app/models/model_book_style.dart';
import 'package:baby_book/app/models/model_book_tag.dart';
import 'package:baby_book/app/view/home/book/category_type.dart';

import '../view/home/book/HoldType.dart';
import '../view/home/book/ReviewType.dart';
import '../view/home/book/UsedType.dart';
import 'model_publisher.dart';

class ModelMyBook {
  String myBookId;
  int bookSetId;
  String memberId;
  String babyId;
  HoldType holdType;
  int? inMonth = 0;
  int? outMonth = 0;
  UsedType usedType;
  ReviewType reviewType;
  ReviewType tempReviewType;
  double? reviewRating = 0;
  double? tempReviewRating = 0;
  String? comment;
  DateTime createdAt;
  DateTime? updatedAt;

  ModelMyBook(
      {required this.myBookId,
      required this.bookSetId,
      required this.memberId,
      required this.babyId,
      required this.holdType,
      this.inMonth,
      this.outMonth,
      required this.usedType,
      required this.reviewType,
      required this.tempReviewType,
      this.reviewRating,
      this.tempReviewRating,
      this.comment,
      required this.createdAt,
      this.updatedAt});

  static ModelMyBook createForObsInit() {
    return ModelMyBook(
        myBookId: "",
        bookSetId: 0,
        memberId: "",
        babyId: "",
        holdType: HoldType.none,
        inMonth: 0,
        outMonth: 0,
        usedType: UsedType.none,
        reviewType: ReviewType.none,
        tempReviewType: ReviewType.none,
        reviewRating: 0,
        tempReviewRating: 0,
        comment: "",
        createdAt: DateTime.now(),
        updatedAt: null);
  }

  changedHoldType() {
    if (holdType == HoldType.plan) {
      inMonth = 0;
      outMonth = 0;
      usedType = UsedType.none;
      reviewType = ReviewType.none;
      reviewRating = 0;
    } else if (holdType == HoldType.read) {
      outMonth = 0;
    }
  }

  ModelMyBook.fromJson(Map<String, dynamic> json)
      : myBookId = json['myBookId'],
        bookSetId = json['bookSetId'],
        memberId = json['memberId'],
        babyId = json['babyId'],
        holdType = HoldType.findByCode(json['holdType']),
        inMonth = json['inMonth'],
        outMonth = json['outMonth'],
        usedType = UsedType.findByCode(json['usedType']),
        reviewType = ReviewType.findByCode(json['reviewType']),
        tempReviewType = ReviewType.findByCode(json['tempReviewType']),
        reviewRating = json['reviewRating'],
        tempReviewRating = json['tempReviewRating'],
        comment = json['comment'],
        createdAt = DateTime.parse(json['createdAt']),
        updatedAt = json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null;

  ModelMyBook.copy(ModelMyBook oldBook)
      : myBookId = oldBook.myBookId,
        bookSetId = oldBook.bookSetId,
        memberId = oldBook.memberId,
        babyId = oldBook.babyId,
        holdType = oldBook.holdType,
        inMonth = oldBook.inMonth,
        outMonth = oldBook.outMonth,
        usedType = oldBook.usedType,
        reviewType = oldBook.reviewType,
        tempReviewType = oldBook.tempReviewType,
        reviewRating = oldBook.reviewRating,
        tempReviewRating = oldBook.tempReviewRating,
        comment = oldBook.comment,
        createdAt = oldBook.createdAt,
        updatedAt = oldBook.updatedAt;
}
