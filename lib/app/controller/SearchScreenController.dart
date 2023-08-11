import 'package:baby_book/app/models/model_publisher.dart';
import 'package:baby_book/app/repository/search_repository.dart';
import 'package:baby_book/app/view/home/book/category_type.dart';
import 'package:get/get.dart';

import '../../base/pref_data.dart';
import '../models/model_book_response.dart';
import '../models/model_member.dart';
import '../repository/member_repository.dart';
import '../repository/paging_request.dart';

class SearchScreenController extends GetxController {
  final SearchRepository searchRepository;

  SearchScreenController({required this.searchRepository}) {
    assert(searchRepository != null);
  }

  ///publisher 3개만 노출될 예정
  final _publisherList = <ModelPublisher>[].obs;

  get publisherList => _publisherList.value;

  set publisherList(value) => _publisherList.value = value;

  ///book
  final _bookList = <ModelBookResponse>[].obs;

  get bookList => _bookList.value;

  set bookList(value) => _bookList.value = value;

  ///loading
  final _loading = true.obs;

  get loading => _loading.value;

  set loading(value) => _loading.value = value;

  ///첫번째 검색을 시작하였는지 여부, 검색창 하단에 문구 노출 용도
  final _firstSearched = false.obs;

  get firstSearched => _firstSearched.value;

  set firstSearched(value) => _firstSearched.value = value;

  late ModelMember member;

  String keyword = "";

  @override
  void onInit() async {
    super.onInit();

    String? memberId = await PrefData.getMemberId();
    member = await MemberRepository.getMember(memberId: memberId!);

    loading = false;
    // getAllForInit(CategoryType.all);
  }

  /// 첫 페이지 로딩 시 사용, 페이지 변경시에도 사용됨
  getAllForInit() async {
    getAllForPullToRefresh();
  }

  ///pull to refresh 시 사용
  getAllForPullToRefresh() async {
    loading = true;
    List<ModelBookResponse> list = await _request(PagingRequest.createDefault());

    ///리스트 초기화
    _initList(list);

    ///사용자경험 위해 0.2초 딜레이
    Future.delayed(const Duration(milliseconds: 500), () {
      loading = false;
    });
  }

  ///next page 요청 시 사용
  Future<List<ModelBookResponse>> getAllForLoading(PagingRequest pagingRequest) async {
    List<ModelBookResponse> list = await _request(pagingRequest);

    ///데이터 추가
    _addAll(list);
    return list;
  }

  Future<List<ModelBookResponse>> _request(PagingRequest pagingRequest) async {
    if (keyword == null || keyword.isEmpty) {
      /// keyword없으면 호출 안함
      return [];
    }
    return await searchRepository.getBookListForBookName(keyword: keyword, pagingRequest: pagingRequest);
  }

  void initCache() {
    _bookList.clear();
  }

  void _initList(List<ModelBookResponse> list) {
    _bookList.clear();
    _bookList.addAll(list);
  }

  void _addAll(List<ModelBookResponse> list) {
    _bookList.addAll(list);
  }

  search(String keyword, PagingRequest pagingRequest) async {
    loading = true;

    firstSearched = true;

    this.keyword = keyword;

    clearSearchResult();

    if (keyword == null || keyword.isEmpty) {
      return;
    }

    bookList = await searchRepository.getBookListForBookName(keyword: keyword, pagingRequest: pagingRequest);
    publisherList = await searchRepository.getPublisherListForPublisherName(
        keyword: keyword, pagingRequest: PagingRequest.createDefault());

    /// 3개만 노출하기 위함
    if (publisherList.length > 3) {
      publisherList = publisherList.sublist(0, 3);
    }

    ///사용자경험 위해 0.2초 딜레이
    Future.delayed(const Duration(milliseconds: 500), () {
      loading = false;
    });
  }

  clearSearchResult() {
    _bookList.clear();
    _publisherList.clear();
  }
}
