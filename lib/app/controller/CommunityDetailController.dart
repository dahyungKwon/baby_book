import 'package:baby_book/app/repository/comment_repository.dart';
import 'package:baby_book/app/repository/post_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../base/pref_data.dart';
import '../exception/exception_invalid_member.dart';
import '../models/model_comment_response.dart';
import '../models/model_post.dart';
import '../repository/post_feedback_repository.dart';
import '../routes/app_pages.dart';
import '../view/dialog/error_dialog.dart';

class CommunityDetailController extends GetxController {
  final PostRepository postRepository;
  final CommentRepository commentRepository;
  final PostFeedbackRepository postFeedbackRepository;

  TextEditingController commentController = TextEditingController();

  ScrollController scrollController = ScrollController();

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

  //comment 등록 버튼 색깔
  final _canRegisterComment = false.obs;

  get canRegisterComment => _canRegisterComment.value;

  set canRegisterComment(value) => _canRegisterComment.value = value;

  //comment 수정 활성화
  final _modifyCommentMode = false.obs;

  get modifyCommentMode => _modifyCommentMode.value;

  set modifyCommentMode(value) => _modifyCommentMode.value = value;

  //bookmark
  final _bookmark = false.obs;

  get bookmark => _bookmark.value;

  set bookmark(value) => _bookmark.value = value;

  //liked
  final _liked = false.obs;

  get liked => _liked.value;

  set liked(value) => _liked.value = value;

  ModelCommentResponse? selectedComment;

  CommunityDetailController(
      {required this.postRepository,
      required this.commentRepository,
      required this.postFeedbackRepository,
      required this.postId}) {
    assert(postRepository != null);
    assert(commentRepository != null);
    assert(postFeedbackRepository != null);

    commentController.addListener(_titleListener);
    init();
  }

  @override
  void onInit() async {
    super.onInit();
    // init();
  }

  void _titleListener() {
    if (commentController.text.isNotEmpty) {
      canRegisterComment = true;
    } else {
      canRegisterComment = false;
    }
  }

  rebuild(String postIdParam) {
    postId = postIdParam;
    init();
  }

  init() async {
    loading = true;
    commentController.text = "";

    await getPost();

    await getComment();

    var memberId = await PrefData.getMemberId();
    if (memberId == post.memberId) {
      myPost = true;
    }

    Future.delayed(const Duration(milliseconds: 500), () {
      loading = false;
    });
  }

  clickBookmark() async {
    if (bookmark) {
      bool result = await postFeedbackRepository.cancelBookmark(postId: postId);
      if (result) {
        bookmark = false;
        post.bookmark = false;
        post.bookmarkCount = post.bookmarkCount - 1;
      }
    } else {
      bool result = await postFeedbackRepository.bookmark(postId: postId);
      if (result) {
        bookmark = true;
        post.bookmark = true;
        post.bookmarkCount = post.bookmarkCount + 1;
      }
    }
  }

  clickLiked() async {
    if (liked) {
      bool result = await postFeedbackRepository.cancelLike(postId: postId);
      if (result) {
        liked = false;
        post.liked = false;
        post.likeCount = post.likeCount - 1;
      }
    } else {
      bool result = await postFeedbackRepository.like(postId: postId);
      if (result) {
        liked = true;
        post.liked = true;
        post.likeCount = post.likeCount + 1;
      }
    }
  }

  Future<bool> getPost() async {
    ModelPost? selectedPost = await postRepository.get(postId: postId);
    if (selectedPost == null) {
      return false;
    }

    post.copyWith(selectedPost: selectedPost);
    bookmark = post.bookmark; //북마크 별도 관리
    liked = post.liked; //좋아요 별도 관리
    _post.refresh();

    return true;
  }

  Future<bool> removePost() async {
    return await postRepository.delete(postId: postId);
  }

  Future<bool> getComment() async {
    commentList.clear();
    List<ModelCommentResponse> commentResponseList = await commentRepository.get(commentTargetId: postId);
    commentList.addAll(commentResponseList);
    _commentList.refresh();

    return true;
  }

  Future<bool> addComment() async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);

    ModelCommentResponse? response =
        await commentRepository.post(commentTargetId: postId, body: commentController.text);

    if (response != null) {
      commentList.add(response);
      _commentList.refresh();
      commentController.text = "";
      EasyLoading.dismiss();
      Future.delayed(const Duration(milliseconds: 500), () {
        scrollController.animateTo(scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 700), curve: Curves.ease);
      });

      return true;
    } else {
      EasyLoading.dismiss();
      return false;
    }
  }

  Future<bool> modifyComment() async {
    if (selectedComment == null) {
      Get.dialog(ErrorDialog("선택된 댓글이 없습니다."));
      return false;
    }

    EasyLoading.show(maskType: EasyLoadingMaskType.black);

    bool result = await commentRepository.modify(
        commentId: selectedComment!.comment.commentId,
        commentTargetId: selectedComment!.comment.commentTargetId,
        body: commentController.text,
        parentId: selectedComment!.comment.commentParentId);

    if (result) {
      selectedComment!.comment.body = commentController.text;
      selectedComment!.comment.updatedAt = DateTime.now();
      selectedComment!.timeDiffForUi = "방금 전";
      // getComment();
      exitModifyCommentMode();

      EasyLoading.dismiss();
      return true;
    } else {
      EasyLoading.dismiss();
      return false;
    }
  }

  Future<bool> removeComment(String commentId) async {
    return await commentRepository.delete(commentId: commentId);
  }

  Future<bool> executeModifyCommentMode(ModelCommentResponse comment) async {
    commentController.text = comment.comment.body;
    modifyCommentMode = true;
    selectedComment = comment;
    return true;
  }

  Future<bool> exitModifyCommentMode() async {
    commentController.text = "";
    modifyCommentMode = false;
    selectedComment = null;
    return true;
  }
}
