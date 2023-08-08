import 'package:baby_book/app/repository/my_book_repository.dart';
import 'package:baby_book/app/repository/paging_request.dart';
import 'package:get/get.dart';

import '../exception/exception_invalid_member.dart';
import '../models/model_my_book_member_body.dart';
import '../models/model_my_book_member_response.dart';
import '../routes/app_pages.dart';

class BookMemberListController extends GetxController {
  final MyBookRepository myBookRepository;
  int bookId;

  ///memberList
  final _memberList = <ModelMyBookMemberBody>[].obs;

  get memberList => _memberList.value;

  set memberList(value) => _memberList.value = value;

  //loading
  final _loading = false.obs;

  get loading => _loading.value;

  set loading(value) => _loading.value = value;

  BookMemberListController({required this.myBookRepository, required this.bookId}) {
    assert(myBookRepository != null);
  }

  @override
  void onInit() async {
    super.onInit();
    getAllForInit();
  }

  /// 첫 페이지 로딩 시 사용, 페이지 변경시에도 사용됨
  getAllForInit() async {
    getAllForPullToRefresh();
  }

  ///pull to refresh 시 사용
  getAllForPullToRefresh() async {
    loading = true;
    List<ModelMyBookMemberBody> list = await _request(PagingRequest.createDefault());

    ///리스트 초기화
    _initList(list);

    ///사용자경험 위해 0.2초 딜레이
    Future.delayed(const Duration(milliseconds: 500), () {
      loading = false;
    });
  }

  ///next page 요청 시 사용
  Future<List<ModelMyBookMemberBody>> getAllForLoading(PagingRequest pagingRequest) async {
    List<ModelMyBookMemberBody> list = await _request(pagingRequest);

    ///데이터 추가
    _addAll(list);
    return list;
  }

  Future<List<ModelMyBookMemberBody>> _request(PagingRequest pagingRequest) async {
    /// no cache & 저장만함
    ModelMyBookMemberResponse? bookMemberResponse =
        await myBookRepository.getListByBook(bookId: bookId, pagingRequest: pagingRequest);
    if (bookMemberResponse == null) {
      return [];
    } else {
      return bookMemberResponse.memberList;
    }
  }

  void _initList(List<ModelMyBookMemberBody> list) {
    _memberList.clear();
    _memberList.addAll(list);
  }

  void _addAll(List<ModelMyBookMemberBody> list) {
    _memberList.addAll(list);
  }
}
