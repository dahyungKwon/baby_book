import 'package:baby_book/app/exception/exception_invalid_member.dart';
import 'package:baby_book/app/models/model_book.dart';
import 'package:baby_book/app/routes/app_pages.dart';
import 'package:get/get.dart';

import '../repository/book_list_repository.dart';

class TabHomeController extends GetxController {
  final BookListRepository bookListRepository;

  TabHomeController(int initAgeGroupId, {required this.bookListRepository}) {
    assert(bookListRepository != null);
    ageGroupId = initAgeGroupId;
  }

  final _bookLists = <ModelBook>[].obs;

  get bookList => _bookLists.value;

  set bookList(value) => _bookLists.value = value;

  final _ageGroupId = 0.obs;

  get ageGroupId => _ageGroupId.value;

  set ageGroupId(value) => _ageGroupId.value = value;

  getAll() {
    bookListRepository.getBookList(categoryList: 'LIFE').then((data) {
      bookList = data;
    }, onError: (e) => e is InvalidMemberException ? Get.toNamed(Routes.loginPath) : e).catchError(
        (onError) => {print(onError + "error"), Get.toNamed(Routes.loginPath)});
  }
}
