import '../view/home/book/HoldType.dart';
import '../view/home/book/ReviewType.dart';
import '../view/home/book/UsedType.dart';

class ModelMyBookRequest {
  int bookSetId;
  String memberId;
  String babyId;
  HoldType holdType;
  int? inMonth = 0;
  int? outMonth = 0;
  UsedType usedType;
  ReviewType reviewType;
  double? reviewRating;
  double? tempReviewRating;
  String? comment;

  ModelMyBookRequest(
      {required this.bookSetId,
      required this.memberId,
      required this.babyId,
      required this.holdType,
      this.inMonth,
      this.outMonth,
      required this.usedType,
      required this.reviewType,
      this.reviewRating,
      this.tempReviewRating,
      this.comment});

  Map<String, dynamic> toJson() => {
        'bookSetId': bookSetId,
        'memberId': memberId,
        'babyId': babyId,
        'holdType': holdType.code,
        'inMonth': inMonth,
        'outMonth': outMonth,
        'usedType': usedType.code,
        'reviewType': reviewType.code,
        'reviewRating': reviewRating,
        'tempReviewRating': tempReviewRating,
        'comment': comment
      };
}
