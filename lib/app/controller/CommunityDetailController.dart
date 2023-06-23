import 'package:baby_book/app/repository/paging_request.dart';
import 'package:baby_book/app/repository/post_repository.dart';
import 'package:get/get.dart';

import '../exception/exception_invalid_member.dart';
import '../models/model_post.dart';
import '../routes/app_pages.dart';
import '../view/community/post_type.dart';

class CommunityDetailController extends GetxController {
  final PostRepository postRepository;

  String postId;

  //loading
  final _loading = false.obs;

  get loading => _loading.value;

  set loading(value) => _loading.value = value;

  //post
  final _post = ModelPost.createModelPostForObsInit().obs;

  get post => _post.value;

  set post(value) => _post.value = value;

  CommunityDetailController({required this.postRepository, required this.postId}) {
    assert(postRepository != null);
  }

  @override
  void onInit() async {
    super.onInit();
    ModelPost selectedPost = await postRepository.get(postId: postId);
    post.copyWith(selectedPost: selectedPost);
    _post.refresh();
  }
}
