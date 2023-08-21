import 'package:baby_book/app/controller/CommunityDetailController.dart';
import 'package:baby_book/app/repository/comment_repository.dart';
import 'package:baby_book/app/view/community/community_detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../base/pref_data.dart';
import '../exception/exception_invalid_member.dart';
import '../models/model_comment_response.dart';
import '../routes/app_pages.dart';
import '../view/dialog/error_dialog.dart';

class CommentDetailController extends GetxController {
  final CommentRepository commentRepository;

  TextEditingController commentController = TextEditingController();

  ScrollController scrollController = ScrollController();

  String postId;
  String commentId;
  String title;

  //loading
  final _loading = true.obs;

  get loading => _loading.value;

  set loading(value) => _loading.value = value;

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

  ModelCommentResponse? selectedComment;

  bool changed = false;

  CommentDetailController(
      {required this.commentRepository, required this.postId, required this.commentId, required this.title}) {
    assert(commentRepository != null);

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

    await getComment();

    Future.delayed(const Duration(milliseconds: 500), () {
      loading = false;
    });
  }

  Future<bool> getComment() async {
    commentList.clear();
    List<ModelCommentResponse> commentResponseList = await commentRepository.getCommentDetail(commentId: commentId);
    commentList.addAll(commentResponseList);
    _commentList.refresh();

    return true;
  }

  Future<bool> addComment() async {
    if (commentController.text == null || commentController.text.isEmpty) {
      await Get.dialog(ErrorDialog("댓글을 입력해주세요."));
      return false;
    }
    if (commentController.text.length > 500) {
      await Get.dialog(ErrorDialog("500자 이하로 입력해주세요."));
      return false;
    }

    EasyLoading.show(maskType: EasyLoadingMaskType.black);

    ModelCommentResponse? response =
        await commentRepository.post(commentTargetId: postId, body: commentController.text, parentId: commentId);

    if (response != null) {
      ///답글쓰는 상황
      commentList[0].childComments.add(response);
      _commentList.refresh();
      commentController.text = "";
      EasyLoading.dismiss();
      Future.delayed(const Duration(milliseconds: 500), () {
        scrollController.animateTo(scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 700), curve: Curves.ease);
      });

      changed = true;
      Get.find<CommunityDetailController>(tag: postId).getComment();

      return true;
    } else {
      EasyLoading.dismiss();
      return false;
    }
  }

  Future<bool> modifyComment() async {
    if (selectedComment == null) {
      await Get.dialog(ErrorDialog("선택된 댓글이 없습니다."));
      return false;
    }
    if (commentController.text == null || commentController.text.isEmpty) {
      await Get.dialog(ErrorDialog("댓글을 입력해주세요."));
      return false;
    }
    if (commentController.text.length > 500) {
      await Get.dialog(ErrorDialog("500자 이하로 입력해주세요."));
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

      changed = true;
      Get.find<CommunityDetailController>(tag: postId).getComment();

      EasyLoading.dismiss();
      return true;
    } else {
      EasyLoading.dismiss();
    }

    return false;
  }

  Future<bool> removeComment(String commentId) async {
    bool result = await commentRepository.delete(commentId: commentId);
    if (result) {
      changed = true;
      Get.find<CommunityDetailController>(tag: postId).getComment();
    }

    return result;
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
