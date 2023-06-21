import 'package:baby_book/app/controller/TabCommunityController.dart';
import 'package:baby_book/app/exception/exception_invalid_param.dart';
import 'package:baby_book/app/models/model_post.dart';
import 'package:baby_book/app/models/model_post_request.dart';
import 'package:baby_book/app/repository/post_repository.dart';
import 'package:baby_book/app/view/dialog/re_confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../base/pref_data.dart';
import '../../base/resizer/fetch_pixels.dart';
import '../exception/exception_invalid_member.dart';
import '../routes/app_pages.dart';
import '../view/community/post_type.dart';
import '../view/dialog/error_dialog.dart';
import '../view/dialog/reset_dialog.dart';
import 'CommunityAddController.dart';
import 'CommunityListController.dart';

class CommunityTagAddController extends GetxController {
  ///선택된 태그 리스트
  final _selectedTagList = <String>[].obs;

  get selectedTagList => _selectedTagList.value;

  set selectedTagList(value) => _selectedTagList.value = value;

  // late PostType postType;
  TextEditingController tagController = TextEditingController();

  CommunityTagAddController() {
    tagController.addListener(() {
      if (tagController.text.contains('\n')) {
        addTag();
      }
    });
  }

  addTag() {
    if (_selectedTagList.length >= 3) {
      tagController.text = "";
      Get.dialog(ErrorDialog("최대 3개까지 등록이 가능합니다."));
      return;
    }

    String tag = tagController.text.replaceAll("\n", "");
    if (tag.length > 10) {
      tagController.text = "";
      Get.dialog(ErrorDialog("10자 이하만 가능합니다."));
      return;
    }

    if (_selectedTagList.contains(tag)) {
      tagController.text = "";
      Get.dialog(ErrorDialog("이미 존재하는 태그입니다."));
      return;
    }

    _selectedTagList.add(tag);
    tagController.text = "";
  }

  void removeTag(int index) {
    _selectedTagList.removeAt(index);
  }

  @override
  void onInit() {
    super.onInit();
  }
}
