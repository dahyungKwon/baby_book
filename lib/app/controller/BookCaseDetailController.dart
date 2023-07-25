import 'package:baby_book/app/models/model_book_response.dart';
import 'package:baby_book/app/repository/book_repository.dart';
import 'package:baby_book/app/repository/my_book_repository.dart';
import 'package:get/get.dart';
import '../models/model_my_book_response.dart';
import '../view/home/book/HoldType.dart';

class BookCaseDetailController extends GetxController {
  final BookRepository bookRepository;
  final MyBookRepository myBookRepository;
  final int bookSetId;
  final String? babyId;

  //book
  final _book = ModelBookResponse.createForObsInit().obs;

  get book => _book.value;

  set book(value) => _book.value = value;

  //mybook
  final _myBookResponse = ModelMyBookResponse.createForObsInit().obs;

  get myBookResponse => _myBookResponse.value;

  set myBookResponse(value) => _myBookResponse.value = value;

  //loading
  final _loading = false.obs;

  get loading => _loading.value;

  set loading(value) => _loading.value = value;

  //mybook
  final _myBook = false.obs;

  get myBook => _myBook.value;

  set myBook(value) => _myBook.value = value;

  BookCaseDetailController(
      {required this.bookRepository, required this.myBookRepository, required this.bookSetId, this.babyId}) {
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
    myBookResponse = await myBookRepository.get(bookSetId: bookSetId, babyId: babyId);
    _book.refresh();
    _myBookResponse.refresh();
    myBook = myBookResponse.myBook.myBookId != null && myBookResponse.myBook.myBookId != "";

    Future.delayed(const Duration(milliseconds: 200), () {
      loading = false;
    });
  }

  Future<bool> removeBook() async {
    return await myBookRepository.delete(myBookId: myBookResponse.myBook.myBookId);
  }
}
