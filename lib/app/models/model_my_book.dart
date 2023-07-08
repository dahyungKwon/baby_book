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
  HoldType holdType;
  int? inMonth = 0;
  int? outMonth = 0;
  UsedType usedType;
  ReviewType reviewType;
  String? comment;
  DateTime createdAt;
  DateTime? updatedAt;

  ModelMyBook(
      {required this.myBookId,
      required this.bookSetId,
      required this.memberId,
      required this.holdType,
      this.inMonth,
      this.outMonth,
      required this.usedType,
      required this.reviewType,
      this.comment,
      required this.createdAt,
      this.updatedAt});

  static ModelMyBook createForObsInit() {
    return ModelMyBook(
        myBookId: "",
        bookSetId: 0,
        memberId: "",
        holdType: HoldType.none,
        inMonth: 0,
        outMonth: 0,
        usedType: UsedType.none,
        reviewType: ReviewType.none,
        comment: "",
        createdAt: DateTime.now(),
        updatedAt: null);
  }

  ModelMyBook.fromJson(Map<String, dynamic> json)
      : myBookId = json['myBookId'],
        bookSetId = json['bookSetId'],
        memberId = json['memberId'],
        holdType = HoldType.findByCode(json['holdType']),
        inMonth = json['inMonth'],
        outMonth = json['outMonth'],
        usedType = UsedType.findByCode(json['usedType']),
        reviewType = ReviewType.findByCode(json['reviewType']),
        comment = json['comment'],
        createdAt = DateTime.parse(json['createdAt']),
        updatedAt = json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null;
}
