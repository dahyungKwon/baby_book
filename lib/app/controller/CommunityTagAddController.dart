import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../models/model_book_response.dart';
import '../routes/app_pages.dart';
import '../view/dialog/error_dialog.dart';
import '../view/search/search_type.dart';

class CommunityTagAddController extends GetxController {
  ///선택된 책 태그 리스트
  final _selectedBookTagList = <ModelBookResponse>[].obs;

  get selectedBookTagList => _selectedBookTagList.value;

  set selectedBookTagList(value) => _selectedBookTagList.value = value;

  // ///선택된 태그 리스트
  // final _selectedTagList = <String>[].obs;
  //
  // get selectedTagList => _selectedTagList.value;
  //
  // set selectedTagList(value) => _selectedTagList.value = value;

  // late PostType postType;
  TextEditingController tagController = TextEditingController();

  CommunityTagAddController() {
    tagController.addListener(() {
      if (tagController.text.contains('\n')) {
        tagController.text = tagController.text.substring(0, tagController.text.length - 1);
        searchBook();
      }
    });
  }

  searchBook() async {
    ModelBookResponse selectedNewBook = await Get.toNamed(Routes.searchPath,
        parameters: {"keyword": tagController.text, "searchType": SearchType.community.code});
    addBookTag(selectedNewBook);
  }

  addBookTag(ModelBookResponse newBook) {
    if (_selectedBookTagList.length >= 3) {
      tagController.text = "";
      Get.dialog(ErrorDialog("최대 3개까지 등록이 가능합니다."));
      return;
    }

    // String tag = tagController.text.replaceAll("\n", "");
    // if (tag.length > 10) {
    //   tagController.text = "";
    //   Get.dialog(ErrorDialog("10자 이하만 가능합니다."));
    //   return;
    // }

    for (int i = 0; i < _selectedBookTagList.length; i++) {
      if (_selectedBookTagList[i].modelBook.id == newBook.modelBook.id) {
        tagController.text = "";
        Get.dialog(ErrorDialog("이미 존재하는 책 태그입니다."));
        return;
      }
    }

    _selectedBookTagList.add(newBook);
    tagController.text = "";
  }

  void removeBookTag(int index) {
    _selectedBookTagList.removeAt(index);
  }

  @override
  void onInit() {
    super.onInit();
  }
}
