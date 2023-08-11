import 'package:baby_book/app/repository/search_repository.dart';
import 'package:baby_book/app/view/home/book/category_type.dart';
import 'package:get/get.dart';

import '../../base/pref_data.dart';
import '../models/model_book_response.dart';
import '../models/model_member.dart';
import '../repository/member_repository.dart';
import '../repository/paging_request.dart';

class PublisherController extends GetxController {
  final SearchRepository searchRepository;
  final int publisherId;
  final String publisherName;

  PublisherController({required this.searchRepository, required this.publisherId, required this.publisherName}) {
    assert(searchRepository != null);
  }

  ///book
  final _bookList = <ModelBookResponse>[].obs;

  get bookList => _bookList.value;

  set bookList(value) => _bookList.value = value;

  ///loading
  final _loading = true.obs;

  get loading => _loading.value;

  set loading(value) => _loading.value = value;

  late ModelMember member;

  @override
  void onInit() async {
    super.onInit();

    String? memberId = await PrefData.getMemberId();
    member = await MemberRepository.getMember(memberId: memberId!);

    getAllForInit(CategoryType.all);
  }

  /// 첫 페이지 로딩 시 사용, 페이지 변경시에도 사용됨
  getAllForInit(CategoryType categoryType) async {
    getAllForPullToRefresh();
  }

  ///pull to refresh 시 사용
  getAllForPullToRefresh() async {
    loading = true;
    print("testbook-로딩 시작");
    List<ModelBookResponse> list = await _request(PagingRequest.createDefault());
    print("testbook-list 조회 끝");

    ///리스트 초기화
    _initList(list);
    print("testbook-initList 끝");

    ///사용자경험 위해 0.2초 딜레이
    Future.delayed(const Duration(milliseconds: 500), () {
      print("testbook-로딩 끝");
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
    /// no cache & 저장만함
    return await searchRepository.getBookListForPublisherId(publisherId: publisherId, pagingRequest: pagingRequest);
  }

  void initCache() {
    bookList.clear();
  }

  void _initList(List<ModelBookResponse> list) {
    bookList.clear();
    bookList.addAll(list);
  }

  void _addAll(List<ModelBookResponse> list) {
    bookList.addAll(list);
  }
}
