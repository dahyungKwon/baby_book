import 'package:baby_book/app/models/model_book_response.dart';
import 'package:baby_book/app/repository/book_repository.dart';
import 'package:baby_book/app/repository/comment_repository.dart';
import 'package:baby_book/app/repository/my_book_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../base/pref_data.dart';
import '../exception/exception_invalid_member.dart';
import '../models/model_comment_response.dart';
import '../models/model_my_book.dart';
import '../routes/app_pages.dart';
import '../view/dialog/error_dialog.dart';

class BookDetailController extends GetxController {
  final BookRepository bookRepository;
  final MyBookRepository myBookRepository;
  final int bookSetId;

  //book
  final _book = ModelBookResponse.createForObsInit().obs;

  get book => _book.value;

  set book(value) => _book.value = value;

  //mybook
  final _mybook = ModelMyBook.createForObsInit().obs;

  get mybook => _mybook.value;

  set mybook(value) => _mybook.value = value;

  //loading
  final _loading = false.obs;

  get loading => _loading.value;

  set loading(value) => _loading.value = value;

  BookDetailController({required this.bookRepository, required this.myBookRepository, required this.bookSetId}) {
    assert(bookRepository != null);
    assert(myBookRepository != null);
  }

  @override
  void onInit() async {
    super.onInit();
    init();
  }

  init() async {
    loading = true;

    book = await bookRepository.get(bookSetId: bookSetId);
    mybook = await myBookRepository.get(bookSetId: bookSetId);
    _book.refresh();
    _mybook.refresh();

    Future.delayed(const Duration(milliseconds: 200), () {
      loading = false;
    });
  }
}
