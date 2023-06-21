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

class CommunityLinkAddController extends GetxController {
  ///선택된 링크 리스트
  final _selectedLinkList = <String>[].obs;

  get selectedLinkList => _selectedLinkList.value;

  set selectedLinkList(value) => _selectedLinkList.value = value;

  // late PostType postType;
  TextEditingController linkController = TextEditingController();

  CommunityLinkAddController() {
    linkController.addListener(() {
      if (linkController.text.contains('\n')) {
        addLink();
      }
    });
  }

  addLink() {
    if (_selectedLinkList.length >= 1) {
      linkController.text = "";
      Get.dialog(ErrorDialog("1개만 등록 가능합니다."));
      return;
    }

    String link = linkController.text.replaceAll("\n", "");
    if (!link.startsWith("http://") && !link.startsWith("https://")) {
      linkController.text = "";
      Get.dialog(ErrorDialog("http 또는 https로 시작해야합니다."));
      return;
    }

    if (_selectedLinkList.contains(link)) {
      linkController.text = "";
      Get.dialog(ErrorDialog("이미 존재하는 링크입니다."));
      return;
    }

    _selectedLinkList.add(link);
    linkController.text = "";
  }

  void removeLink(int index) {
    _selectedLinkList.removeAt(index);
  }

  @override
  void onInit() {
    super.onInit();
  }
}
