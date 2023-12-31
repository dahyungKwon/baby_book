import 'package:baby_book/app/controller/BookCaseController.dart';
import 'package:baby_book/app/models/model_book_response.dart';
import 'package:baby_book/app/models/model_member.dart';
import 'package:baby_book/app/models/model_my_book.dart';
import 'package:baby_book/app/models/model_my_book_member_response.dart';
import 'package:baby_book/app/repository/book_repository.dart';
import 'package:baby_book/app/repository/comment_repository.dart';
import 'package:baby_book/app/repository/member_repository.dart';
import 'package:baby_book/app/repository/my_book_repository.dart';
import 'package:baby_book/app/repository/post_repository.dart';
import 'package:baby_book/base/pref_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../models/model_comment_response.dart';
import '../models/model_my_book_request.dart';
import '../models/model_my_book_response.dart';
import '../models/model_post_tag.dart';
import '../repository/paging_request.dart';
import '../view/home/book/HoldType.dart';
import 'BookCaseListController.dart';

class BookDetailController extends GetxController {
  final BookRepository bookRepository;
  final MyBookRepository myBookRepository;
  final CommentRepository commentRepository;
  final PostRepository postRepository;
  final int bookSetId;
  late String? babyId;
  ScrollController scrollController = ScrollController();
  late String? bookSetCommentId;
  late ModelMyBookMemberResponse bookMember;
  late HoldType lastHoldType;

  ///변경 후 취소시 다시 원복하기 위한 용도

  //book
  final _book = ModelBookResponse.createForObsInit().obs;

  get book => _book.value;

  set book(value) => _book.value = value;

  //mybook
  final _myBookResponse = ModelMyBookResponse.createForObsInit().obs;

  get myBookResponse => _myBookResponse.value;

  set myBookResponse(value) => _myBookResponse.value = value;

  //loading
  final _loading = true.obs;

  get loading => _loading.value;

  set loading(value) => _loading.value = value;

  //내책에 포함된건지 여부
  final _isMyBook = false.obs;

  get isMyBook => _isMyBook.value;

  set isMyBook(value) => _isMyBook.value = value;

  //좋아요여부
  final _like = false.obs;

  get like => _like.value;

  set like(value) => _like.value = value;

  //좋아요카운트
  final _likeCount = 0.obs;

  get likeCount => _likeCount.value;

  set likeCount(value) => _likeCount.value = value;

  //책경험컨테이너 폴딩여부 디폴트 열림
  final _myBookContainerSwitch = true.obs;

  get myBookContainerSwitch => _myBookContainerSwitch.value;

  set myBookContainerSwitch(value) => _myBookContainerSwitch.value = value;

  //해당 책이 상이 있는지
  final _hasAward = false.obs;

  get hasAward => _hasAward.value;

  set hasAward(value) => _hasAward.value = value;

  //책소개 컨테이너
  final _bookInfoContainer = true.obs;

  get bookInfoContainer => _bookInfoContainer.value;

  set bookInfoContainer(value) => _bookInfoContainer.value = value;

  //한줄코멘트
  final _commentList = <ModelCommentResponse>[].obs;

  get commentList => _commentList.value;

  set commentList(value) => _commentList.value = value;

  //커뮤니티태그
  final _postTag = ModelPostTag.createForObsInit().obs;

  get postTag => _postTag.value;

  set postTag(value) => _postTag.value = value;

  BookDetailController(
      {required this.bookRepository,
      required this.myBookRepository,
      required this.commentRepository,
      required this.postRepository,
      required this.bookSetId,
      this.babyId}) {
    assert(bookRepository != null);
    assert(myBookRepository != null);
    assert(commentRepository != null);
    assert(postRepository != null);
    bookSetCommentId = "book-$bookSetId";
  }

  @override
  void onInit() async {
    super.onInit();
    init();
  }

  init() async {
    loading = true;

    String? memberId = await PrefData.getMemberId();
    ModelMember member = await MemberRepository.getMember(memberId: memberId!);
    if (babyId == null) {
      print("AppSchemeImpl babyId init");
      babyId = member.selectedBabyId;
    }

    book = await bookRepository.get(bookSetId: bookSetId);
    if (book.modelBook.id == null) {
      ///에러 발생, 페이지 오픈 안됨
      Get.back();
      return;
    }
    myBookResponse = await myBookRepository.get(bookSetId: bookSetId, babyId: babyId);
    // _book.refresh();
    // _myBookResponse.refresh();
    isMyBook = myBookResponse.myBook.myBookId != null && myBookResponse.myBook.myBookId != "";
    like = book.liked;
    likeCount = book.modelBook.likeCount ?? 0;

    requestComment();

    postTag =
        await postRepository.getPostBookTag(bookId: book.modelBook.id, pagingRequest: PagingRequest.createDefault());

    bookMember =
        await myBookRepository.getListByBook(bookId: bookSetId, pagingRequest: PagingRequest.createDefault()) ??
            ModelMyBookMemberResponse.createForObsInit();

    Future.delayed(const Duration(milliseconds: 500), () {
      loading = false;
    });
  }

  String getLikeCount() {
    return likeCount >= 10000 ? "9999+" : likeCount.toString();
  }

  Future<bool> clickLike() async {
    return await bookRepository.like(bookSetId: bookSetId);
  }

  Future<bool> clickCancelLike() async {
    return await bookRepository.cancelLike(bookSetId: bookSetId);
  }

  Future<bool> removeMyBook() async {
    bool result = await myBookRepository.delete(myBookId: myBookResponse.myBook.myBookId);
    if (result) {
      reloadMyBook("remove", myBookResponse.myBook.myBookId, myBookResponse.myBook.memberId);
    }

    return result;
  }

  Future<bool> addMyBook(ModelMyBook myBook) async {
    String? memberId = await PrefData.getMemberId();
    ModelMyBook? result = await myBookRepository.post(
        request: ModelMyBookRequest(
      bookSetId: bookSetId,
      memberId: memberId!,
      babyId: babyId!,
      holdType: myBook.holdType,
      inMonth: myBook.inMonth,
      outMonth: myBook.outMonth,
      tempInMonth: myBook.tempInMonth,
      tempOutMonth: myBook.tempOutMonth,
      usedType: myBook.usedType,
      reviewType: myBook.reviewType,
      reviewRating: myBook.reviewRating,
      tempReviewRating: myBook.tempReviewRating,
      comment: myBook.comment,
    ));

    if (result != null) {
      reloadMyBook("add", myBookResponse.myBook.myBookId, myBookResponse.myBook.memberId);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> modifyMyBook(ModelMyBook myBook) async {
    ModelMyBook? result = await myBookRepository.modify(
        myBookId: myBook.myBookId,
        request: ModelMyBookRequest(
          bookSetId: myBook.bookSetId,
          memberId: myBook.memberId,
          babyId: myBook.babyId,
          holdType: myBook.holdType,
          inMonth: myBook.inMonth,
          outMonth: myBook.outMonth,
          tempInMonth: myBook.tempInMonth,
          tempOutMonth: myBook.tempOutMonth,
          usedType: myBook.usedType,
          reviewType: myBook.reviewType,
          reviewRating: myBook.reviewRating,
          tempReviewRating: myBook.tempReviewRating,
          comment: myBook.comment,
        ));

    if (result != null) {
      reloadMyBook("modify", myBookResponse.myBook.myBookId, myBookResponse.myBook.memberId);
      return true;
    } else {
      return false;
    }
  }

  reloadMyBook(String type, String oldMyBookId, String oldMemberId) async {
    myBookResponse = await myBookRepository.get(bookSetId: bookSetId, babyId: babyId);
    isMyBook = myBookResponse.myBook.myBookId != null && myBookResponse.myBook.myBookId != "";
    _myBookResponse.refresh();
    _isMyBook.refresh();

    switch (type) {
      case "add":
        {
          Get.find<BookCaseListController>(tag: myBookResponse.myBook.memberId).addMyBook(myBookResponse);
          break;
        }
      case "modify":
        {
          Get.find<BookCaseListController>(tag: myBookResponse.myBook.memberId).updateMyBook(myBookResponse);
          break;
        }
      case "remove":
        {
          Get.find<BookCaseListController>(tag: oldMemberId).removeMyBook(oldMyBookId);
          break;
        }
    }
  }

  requestComment() async {
    commentList = await commentRepository.get(commentTargetId: "book-$bookSetId");
  }
}
