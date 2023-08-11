import 'package:baby_book/app/repository/search_repository.dart';
import 'package:baby_book/app/view/home/book/category_type.dart';
import 'package:get/get.dart';

import '../../base/pref_data.dart';
import '../models/model_member.dart';
import '../models/model_publisher.dart';
import '../repository/member_repository.dart';
import '../repository/paging_request.dart';

class PublisherListController extends GetxController {
  final SearchRepository searchRepository;
  final String keyword;

  PublisherListController({required this.searchRepository, required this.keyword}) {
    assert(searchRepository != null);
  }

  ///publisher
  final _publisherList = <ModelPublisher>[].obs;

  get publisherList => _publisherList.value;

  set publisherList(value) => _publisherList.value = value;

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
    List<ModelPublisher> list = await _request(PagingRequest.createDefault());

    ///리스트 초기화
    _initList(list);

    ///사용자경험 위해 0.2초 딜레이
    Future.delayed(const Duration(milliseconds: 500), () {
      loading = false;
    });
  }

  ///next page 요청 시 사용
  Future<List<ModelPublisher>> getAllForLoading(PagingRequest pagingRequest) async {
    List<ModelPublisher> list = await _request(pagingRequest);

    ///데이터 추가
    _addAll(list);
    return list;
  }

  Future<List<ModelPublisher>> _request(PagingRequest pagingRequest) async {
    /// no cache & 저장만함
    return await searchRepository.getPublisherListForPublisherName(keyword: keyword, pagingRequest: pagingRequest);
  }

  void initCache() {
    _publisherList.clear();
  }

  void _initList(List<ModelPublisher> list) {
    _publisherList.clear();
    _publisherList.addAll(list);
  }

  void _addAll(List<ModelPublisher> list) {
    _publisherList.addAll(list);
  }
}
