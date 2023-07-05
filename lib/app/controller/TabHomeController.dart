import 'package:baby_book/app/exception/exception_invalid_member.dart';
import 'package:baby_book/app/models/model_book.dart';
import 'package:baby_book/app/routes/app_pages.dart';
import 'package:baby_book/app/view/home/book/category_type.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../models/model_age_group.dart';
import '../models/model_book_response.dart';
import '../repository/book_list_repository.dart';

class TabHomeController extends GetxController {
  final BookListRepository bookListRepository;

  TabHomeController(int initAgeGroupId, {required this.bookListRepository}) {
    assert(bookListRepository != null);
    selectedAgeGroupId = initAgeGroupId;
  }

  //loading
  final _loading = false.obs;

  get loading => _loading.value;

  set loading(value) => _loading.value = value;

  final _bookLists = <ModelBookResponse>[].obs;

  get bookList => _bookLists.value;

  set bookList(value) => _bookLists.value = value;

  final _selectedAgeGroupId = 0.obs;

  get selectedAgeGroupId => _selectedAgeGroupId.value;

  set selectedAgeGroupId(value) => _selectedAgeGroupId.value = value;

  final _selectedCategoryIdx = 0.obs;

  get selectedCategoryIdx => _selectedCategoryIdx.value;

  set selectedCategoryIdx(value) => _selectedCategoryIdx.value = value;

  CategoryType selectedCategoryType = CategoryType.all;

  TextEditingController ageGroupTextEditingController = TextEditingController();

  getBookList() async {
    loading = true;
    bookList.clear();
    try {
      bookList.addAll(await bookListRepository.getBookList(
          ageGroup: ModelAgeGroup.getAgeGroup(selectedAgeGroupId), categoryType: selectedCategoryType));

      ///사용자경험 위해 0.2초 딜레이
      Future.delayed(const Duration(milliseconds: 200), () {
        loading = false;
      });
    } on InvalidMemberException catch (e) {
      print(e);
      loading = false;
      Get.toNamed(Routes.loginPath);
    } catch (e) {
      print(e);
      loading = false;
      Get.toNamed(Routes.loginPath);
    }
  }
}
