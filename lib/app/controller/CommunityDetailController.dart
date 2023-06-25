import 'package:baby_book/app/repository/comment_repository.dart';
import 'package:baby_book/app/repository/paging_request.dart';
import 'package:baby_book/app/repository/post_repository.dart';
import 'package:get/get.dart';

import '../exception/exception_invalid_member.dart';
import '../models/model_comment_response.dart';
import '../models/model_post.dart';
import '../routes/app_pages.dart';
import '../view/community/post_type.dart';

class CommunityDetailController extends GetxController {
  final PostRepository postRepository;
  final CommentRepository commentRepository;

  String postId;

  //loading
  final _loading = false.obs;

  get loading => _loading.value;

  set loading(value) => _loading.value = value;

  //post
  final _post = ModelPost.createModelPostForObsInit().obs;

  get post => _post.value;

  set post(value) => _post.value = value;

  //comment
  final _commentList = <ModelCommentResponse>[].obs;

  get commentList => _commentList.value;

  set commentList(value) => _commentList.value = value;

  CommunityDetailController({required this.postRepository, required this.commentRepository, required this.postId}) {
    assert(postRepository != null);
    assert(commentRepository != null);
  }

  @override
  void onInit() async {
    super.onInit();
    loading = true;

    ModelPost selectedPost = await postRepository.get(postId: postId);
    post.copyWith(selectedPost: selectedPost);
    _post.refresh();

    commentList.clear();
    List<ModelCommentResponse> commentResponseList = await commentRepository.get(commentTargetId: postId);
    commentList.addAll(commentResponseList);
    _commentList.refresh();

    loading = false;
  }
}
