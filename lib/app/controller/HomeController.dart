import 'package:baby_book/app/models/model_book.dart';
import 'package:baby_book/app/routes/app_pages.dart';
import 'package:get/get.dart';

import '../repository/book_list_repository.dart';
import 'IsLoadingController.dart';

class HomeController extends GetxController {
  final BookListRepository bookListRepository;

  HomeController({required this.bookListRepository}) : assert(bookListRepository != null);

  final _bookLists = <ModelBook>[].obs;

  get bookList => _bookLists.value;

  set bookList(value) => _bookLists.value = value;

  final _ageGroupId = 2.obs;

  get ageGroupId => _ageGroupId.value;

  set ageGroupId(value) => _ageGroupId.value = value;

  // final _isLoading = false.obs;
  // bool get isLoading => _isLoading.value;
  // set isLoading(bool value) => _isLoading.value = value;

  getAll() {
    bookListRepository.getBookList(categoryList: 'MATH,LIFE').then((data) {
      bookList = data;
    }).catchError((onError) => {Get.toNamed(Routes.loginPath)});
  }
}
