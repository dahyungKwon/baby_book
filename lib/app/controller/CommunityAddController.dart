import 'package:baby_book/app/repository/post_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../view/community/post_type.dart';

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
    postTypeController.addListener(_postTypeListener);
  }

  void _titleListener() {
    if (titleController.text.isNotEmpty && contentsController.text.isNotEmpty) {
      canRegister = true;
    } else {
      canRegister = false;
    }
    // print("Second text field: ${myController.text}");
  }

  void _contentsListener() {
    if (titleController.text.isNotEmpty && contentsController.text.isNotEmpty) {
      canRegister = true;
    } else {
      canRegister = false;
    }
    // print("Second text field: ${myController.text}");
  }

  void _postTypeListener() {
    // print("Second text field: ${myController.text}");
  }

  @override
  void onInit() {
    super.onInit();
  }
}
