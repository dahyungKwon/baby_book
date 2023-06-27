import 'package:baby_book/app/repository/comment_repository.dart';
import 'package:baby_book/app/repository/post_repository.dart';
import 'package:get/get.dart';

import '../../base/pref_data.dart';
import '../models/model_comment_response.dart';
import '../models/model_post.dart';
import '../repository/post_feedback_repository.dart';

class CommunityDetailController extends GetxController {
  final PostRepository postRepository;
  final CommentRepository commentRepository;
  final PostFeedbackRepository postFeedbackRepository;

  String postId;
  bool myPost = false;

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

  //bookmark
  final _bookmark = false.obs;

  get bookmark => _bookmark.value;

  set bookmark(value) => _bookmark.value = value;

  //liked
  final _liked = false.obs;

  get liked => _liked.value;

  set liked(value) => _liked.value = value;

  CommunityDetailController(
      {required this.postRepository,
      required this.commentRepository,
      required this.postFeedbackRepository,
      required this.postId}) {
    assert(postRepository != null);
    assert(commentRepository != null);
    assert(postFeedbackRepository != null);
  }

  @override
  void onInit() async {
    super.onInit();
    init();
  }

  init() async {
    loading = true;

    ModelPost selectedPost = await postRepository.get(postId: postId);
    post.copyWith(selectedPost: selectedPost);
    bookmark = post.bookmark; //북마크 별도 관리
    liked = post.liked; //좋아요 별도 관리
    _post.refresh();

    commentList.clear();
    List<ModelCommentResponse> commentResponseList = await commentRepository.get(commentTargetId: postId);
    commentList.addAll(commentResponseList);
    _commentList.refresh();

    var memberId = await PrefData.getMemberId();
    if (memberId == post.memberId) {
      myPost = true;
    }

    loading = false;
  }

  clickBookmark() {
    if (bookmark) {
      postFeedbackRepository.cancelBookmark(postId: postId);
      bookmark = false;
      post.bookmark = false;
      post.bookmarkCount = post.bookmarkCount - 1;
    } else {
      postFeedbackRepository.bookmark(postId: postId);
      bookmark = true;
      post.bookmark = true;
      post.bookmarkCount = post.bookmarkCount + 1;
    }
  }

  clickLiked() {
    if (liked) {
      postFeedbackRepository.cancelLike(postId: postId);
      liked = false;
      post.liked = false;
      post.likeCount = post.likeCount - 1;
    } else {
      postFeedbackRepository.like(postId: postId);
      liked = true;
      post.liked = true;
      post.likeCount = post.likeCount + 1;
    }
  }
}
