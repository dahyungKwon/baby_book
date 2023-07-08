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

class ModelMyBookRequest {
  int bookSetId;
  String memberId;
  HoldType holdType;
  int? inMonth = 0;
  int? outMonth = 0;
  UsedType usedType;
  ReviewType reviewType;
  String? comment;

  ModelMyBookRequest(
      {required this.bookSetId,
      required this.memberId,
      required this.holdType,
      this.inMonth,
      this.outMonth,
      required this.usedType,
      required this.reviewType,
      this.comment});

  Map<String, dynamic> toJson() => {
        'bookSetId': bookSetId,
        'memberId': memberId,
        'holdType': holdType.code,
        'inMonth': inMonth,
        'outMonth': outMonth,
        'usedType': usedType.code,
        'reviewType': reviewType.code,
        'comment': comment
      };
}
