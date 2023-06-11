import 'package:baby_book/app/repository/post_repository.dart';
import 'package:get/get.dart';

import '../models/model_post.dart';
import '../routes/app_pages.dart';
import '../view/community/post_type.dart';

class CommunityListController extends GetxController {
  final PostRepository postRepository;

  /// post
  final _postList = <ModelPost>[].obs;

  get postList => _postList.value;

  set postList(value) => _postList.value = value;

  CommunityListController({required this.postRepository}) {
    assert(postRepository != null);
  }

  getAll(PostType postType) {
    postRepository.getPostList(postTypeRequest: postType.code).then((data) {
      postList = data;
    }, onError: (e) {
      print(e);
    }).catchError((onError) => {print(onError), Get.toNamed(Routes.loginPath)});
  }
}
