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
import 'CommunityListController.dart';

class CommunityAddController extends GetxController {
  final PostRepository postRepository;

  ///right color
  final _canRegister = false.obs;

  get canRegister => _canRegister.value;

  set canRegister(value) => _canRegister.value = value;

  final _postType = PostType.all.obs;

  get postType => _postType.value;

  set postType(value) => _postType.value = value;

  // late PostType postType;
  TextEditingController titleController = TextEditingController();
  TextEditingController contentsController = TextEditingController();
  TextEditingController postTypeController = TextEditingController();

  CommunityAddController({required this.postRepository}) {
    assert(postRepository != null);

    titleController.addListener(_titleListener);
    contentsController.addListener(_contentsListener);
  }

  void _titleListener() {
    if (titleController.text.isNotEmpty && contentsController.text.isNotEmpty) {
      canRegister = true;
    } else {
      canRegister = false;
    }
  }

  void _contentsListener() {
    if (titleController.text.isNotEmpty && contentsController.text.isNotEmpty) {
      canRegister = true;
    } else {
      canRegister = false;
    }
  }

  void add() async {
    if (postType == PostType.none || postType == PostType.all) {
      Get.dialog(ErrorDialog("글 타입을 선택해주세요."));
      return;
    }

    if (titleController.text.isEmpty) {
      Get.dialog(ErrorDialog("제목을 입력해주세요."));
      return;
    }

    if (contentsController.text.isEmpty) {
      Get.dialog(ErrorDialog("내용을 입력해주세요."));
      return;
    }

    bool result = await Get.dialog(
      AlertDialog(
        // title: const Text('dialog title'),
        content: const Text('등록 하시겠습니까?'),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('취소', style: TextStyle(color: Colors.black))),
          TextButton(
            onPressed: requestAdd,
            child: const Text('등록', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );

    if (result) {
      await Get.find<CommunityListController>().getAllForPullToRefresh(postType);
      await Get.find<TabCommunityController>().changePosition(postType);
      Get.back();
      //   Get.snackbar('', '등록 되었습니다.',
      //       colorText: Colors.white,
      //       backgroundColor: Color(0xFF4B4B4B),
      //       snackPosition: SnackPosition.BOTTOM,
      //       margin: EdgeInsets.only(bottom: FetchPixels.getPixelHeight(20)));
    }
  }

  void requestAdd() async {
    var memberId = await PrefData.getMemberId();
    try {
      ModelPost post = await postRepository.add(
          modelPostRequest: ModelPostRequest(
              postType: postType, memberId: memberId!, title: titleController.text, contents: contentsController.text));

      Get.back(result: true);
    } on InvalidMemberException catch (e) {
      print(e);
      Get.toNamed(Routes.loginPath);
    } catch (e) {
      print(e);
      Get.toNamed(Routes.loginPath);
    }
  }

  @override
  void onInit() {
    super.onInit();
  }
}
