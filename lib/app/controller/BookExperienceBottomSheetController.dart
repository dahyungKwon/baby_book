import 'package:baby_book/app/models/model_my_book.dart';
import 'package:baby_book/app/view/home/book/ReviewType.dart';
import 'package:baby_book/app/view/home/book/review_type_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import '../repository/my_book_repository.dart';
import '../view/home/book/HoldType.dart';
import '../view/home/book/UsedType.dart';
import '../view/home/book/month_bottom_sheet.dart';
import '../view/home/book/used_type_bottom_sheet.dart';

class BookExperienceBottomSheetController extends GetxController {
  MyBookRepository myBookRepository;
  TextEditingController tempReviewTypeTextEditing = TextEditingController();
  TextEditingController reviewTypeTextEditing = TextEditingController();
  TextEditingController usedTypeTextEditing = TextEditingController();
  TextEditingController inMonthTextEditing = TextEditingController();
  TextEditingController outMonthTextEditing = TextEditingController();
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
    _mybook.refresh();
    memoTypeTextEditing.text = (mybook.comment ?? "")!;
    memoTypeTextEditing.moveCursorToEnd();
  }

  @override
  void onInit() async {
    super.onInit();
    init();

    memoTypeTextEditing.addListener(_titleListener);
  }

  void _titleListener() {
    print("text : ${memoTypeTextEditing.text}");
    mybook.comment = memoTypeTextEditing.text;
    _mybook.refresh();
  }

  @override
  void dispose() {
    tempReviewTypeTextEditing.dispose();
    reviewTypeTextEditing.dispose();
    usedTypeTextEditing.dispose();
    inMonthTextEditing.dispose();
    outMonthTextEditing.dispose();
    memoTypeTextEditing.dispose();
    super.dispose();
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

  changeInMonth(int inMonth) {
    mybook.inMonth = inMonth;
    _mybook.refresh();
  }

  changeOutMonth(int outMonth) {
    mybook.outMonth = outMonth;
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

  showInMonthBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => MonthBottomSheet(
              month: mybook.inMonth,
              inMonth: true,
            )).then((selectedInMonth) {
      if (selectedInMonth != null) {
        changeInMonth(selectedInMonth);
      }
    });
  }

  showOutMonthBottomSheet(BuildContext context, int startMonth) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => MonthBottomSheet(
              month: mybook.outMonth,
              startMonth: startMonth,
              inMonth: false,
            )).then((selectedOutMonth) {
      if (selectedOutMonth != null) {
        changeOutMonth(selectedOutMonth);
      }
    });
  }
}
