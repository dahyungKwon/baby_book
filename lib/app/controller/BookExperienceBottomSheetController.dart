import 'package:baby_book/app/models/model_my_book.dart';
import 'package:baby_book/app/view/home/book/ReviewType.dart';
import 'package:baby_book/app/view/home/book/review_type_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../repository/my_book_repository.dart';
import '../view/home/book/HoldType.dart';
import '../view/home/book/UsedType.dart';
import '../view/home/book/used_type_bottom_sheet.dart';

class BookExperienceBottomSheetController extends GetxController {
  MyBookRepository myBookRepository;
  TextEditingController tempReviewTypeTextEditing = TextEditingController();
  TextEditingController reviewTypeTextEditing = TextEditingController();
  TextEditingController usedTypeTextEditing = TextEditingController();
  TextEditingController memoTypeTextEditing = TextEditingController();

  //mybook
  final _mybook = ModelMyBook.createForObsInit().obs;

  get mybook => _mybook.value;

  set mybook(value) => _mybook.value = value;

  //loading
  final _loading = false.obs;

  get loading => _loading.value;

  set loading(value) => _loading.value = value;

  BookExperienceBottomSheetController({required this.myBookRepository, required ModelMyBook mybook}) {
    assert(myBookRepository != null);
    this.mybook = mybook;
  }

  @override
  void onInit() async {
    super.onInit();
    init();
  }

  init() async {
    loading = true;

    Future.delayed(const Duration(milliseconds: 500), () {
      loading = false;
    });
  }

  changeHoldType(HoldType holdType) {
    mybook.holdType = holdType;
    _mybook.refresh();
  }

  changeTempReviewType(ReviewType reviewType) {
    mybook.tempReviewType = reviewType;
    _mybook.refresh();
  }

  changeReviewType(ReviewType reviewType) {
    mybook.reviewType = reviewType;
    _mybook.refresh();
  }

  changeUsedType(UsedType usedType) {
    mybook.usedType = usedType;
    _mybook.refresh();
  }

  showTempReviewTypeBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => ReviewTypeBottomSheet(
              reviewType: mybook.tempReviewType,
              isTemp: true,
            )).then((selectedTempReviewType) {
      if (selectedTempReviewType != null) {
        changeTempReviewType(selectedTempReviewType);
      }
    });
  }

  showReviewTypeBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => ReviewTypeBottomSheet(
              reviewType: mybook.reviewType,
              isTemp: false,
            )).then((selectedReviewType) {
      if (selectedReviewType != null) {
        changeReviewType(selectedReviewType);
      }
    });
  }

  showUsedTypeBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => UsedTypeBottomSheet(
              usedType: mybook.usedType,
            )).then((selectedUsedType) {
      if (selectedUsedType != null) {
        changeUsedType(selectedUsedType);
      }
    });
  }
}
