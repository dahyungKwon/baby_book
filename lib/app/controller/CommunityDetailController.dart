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
  }

  @override
  void onInit() async {
    super.onInit();
    init();
  }

  void _titleListener() {
    if (commentController.text.isNotEmpty) {
      canRegisterComment = true;
    } else {
      canRegisterComment = false;
    }
  }

  init() async {
    loading = true;
    commentController.text = "";

    getPost();

    getComment();

    var memberId = await PrefData.getMemberId();
    if (memberId == post.memberId) {
      myPost = true;
    }

    Future.delayed(const Duration(milliseconds: 200), () {
      loading = false;
    });
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

  Future<bool> getPost() async {
    ModelPost selectedPost = await postRepository.get(postId: postId);
    post.copyWith(selectedPost: selectedPost);
    bookmark = post.bookmark; //북마크 별도 관리
    liked = post.liked; //좋아요 별도 관리
    _post.refresh();

    return true;
  }

  Future<bool> removePost() async {
    try {
      await postRepository.delete(postId: postId);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> getComment() async {
    commentList.clear();
    List<ModelCommentResponse> commentResponseList = await commentRepository.get(commentTargetId: postId);
    commentList.addAll(commentResponseList);
    _commentList.refresh();

    return true;
  }

  Future<bool> addComment() async {
    try {
      EasyLoading.show(maskType: EasyLoadingMaskType.black);
      ModelCommentResponse response =
          await commentRepository.post(commentTargetId: postId, body: commentController.text);
      if (response != null) {
        commentList.add(response);
        _commentList.refresh();
        commentController.text = "";
        EasyLoading.dismiss();
        Future.delayed(const Duration(milliseconds: 200), () {
          scrollController.animateTo(scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 700), curve: Curves.ease);
        });

        return true;
      } else {
        EasyLoading.dismiss();
        Get.dialog(ErrorDialog("네트워크 오류가 발생했습니다. 다시 시도해주세요."));
      }
    } on InvalidMemberException catch (e) {
      print(e);
      EasyLoading.dismiss();
      Get.toNamed(Routes.loginPath);
    } catch (e) {
      print(e);
      EasyLoading.dismiss();
      Get.toNamed(Routes.loginPath);
    }

    return false;
  }

  Future<bool> modifyComment() async {
    try {
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
        Get.dialog(ErrorDialog("네트워크 오류가 발생했습니다. 다시 시도해주세요."));
      }
    } on InvalidMemberException catch (e) {
      print(e);
      EasyLoading.dismiss();
      Get.toNamed(Routes.loginPath);
    } catch (e) {
      print(e);
      EasyLoading.dismiss();
      Get.toNamed(Routes.loginPath);
    }

    return false;
  }

  Future<bool> removeComment(String commentId) async {
    try {
      await commentRepository.delete(commentId: commentId);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
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
