import 'package:baby_book/app/models/model_post.dart';
import 'package:baby_book/app/models/model_post_request.dart';
import 'package:baby_book/app/repository/post_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../base/pref_data.dart';
import '../view/community/post_type.dart';
import '../view/dialog/reset_dialog.dart';

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

  Future<ModelPost> add() async {
    if (titleController.text.isEmpty || contentsController.text.isEmpty) {
      throw Exception("제목을 입력해주세요.");
    }

    if (contentsController.text.isEmpty) {
      throw Exception("내용을 입력해주세요.");
    }

    if (postType == PostType.none || postType == PostType.all) {
      throw Exception("글 타입을 선택해주세요.");
    }

    var memberId = await PrefData.getMemberId();
    ModelPost post = await postRepository.add(
        modelPostRequest: ModelPostRequest(
            postType: postType, memberId: memberId!, title: titleController.text, contents: contentsController.text));
    return post;
  }

  @override
  void onInit() {
    super.onInit();
  }
}
