import 'package:baby_book/app/models/model_publisher.dart';
import 'package:baby_book/app/repository/search_repository.dart';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../base/pref_data.dart';
import '../models/model_book_response.dart';
import '../models/model_member.dart';
import '../repository/member_repository.dart';
import '../repository/paging_request.dart';
import '../view/dialog/error_dialog.dart';
import '../view/search/search_type.dart';

class SearchScreenController extends GetxController {
  final SearchRepository searchRepository;
  final SearchType searchType;
  String? keyword;
  TextEditingController searchController = TextEditingController();

  SearchScreenController({required this.searchRepository, required this.searchType, required this.keyword}) {
    assert(searchRepository != null);
    if (searchType == SearchType.community) {
      loading = true;
      if (keyword != null && keyword!.isNotEmpty) {
        searchController.text = keyword!;
        search(keyword!, PagingRequest.createDefault());
      }
    } else {
      loading = false;
    }
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

  @override
  void onInit() async {
    super.onInit();

    String? memberId = await PrefData.getMemberId();
    member = await MemberRepository.getMember(memberId: memberId!);

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
    if (keyword == null || keyword!.isEmpty) {
      /// keyword없으면 호출 안함
      return [];
    }
    return await searchRepository.getBookListForBookName(keyword: keyword!, pagingRequest: pagingRequest);
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

  Future<bool> search(String keyword, PagingRequest pagingRequest) async {
    if (keyword.length > 50) {
      await Get.dialog(ErrorDialog("50자 이하로 검색해주세요."));
      return false;
    }
    if (keyword == null || keyword.isEmpty) {
      await Get.dialog(ErrorDialog("검색어를 입력해주세요."));
      return false;
    }

    loading = true;

    firstSearched = true;

    this.keyword = keyword;

    clearSearchResult();

    bookList = await searchRepository.getBookListForBookName(keyword: keyword, pagingRequest: pagingRequest);
    if (searchType != SearchType.community) {
      publisherList = await searchRepository.getPublisherListForPublisherName(
          keyword: keyword, pagingRequest: PagingRequest.createDefault());

      /// 3개만 노출하기 위함
      if (publisherList.length > 3) {
        publisherList = publisherList.sublist(0, 3);
      }
    }

    ///사용자경험 위해 0.2초 딜레이
    Future.delayed(const Duration(milliseconds: 500), () {
      loading = false;
    });
    return true;
  }

  clearSearchResult() {
    _bookList.clear();
    _publisherList.clear();
  }
}
