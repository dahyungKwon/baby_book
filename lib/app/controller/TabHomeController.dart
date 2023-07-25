import 'package:baby_book/app/exception/exception_invalid_member.dart';
import 'package:baby_book/app/models/model_member.dart';
import 'package:baby_book/app/repository/member_repository.dart';
import 'package:baby_book/app/routes/app_pages.dart';
import 'package:baby_book/app/view/home/book/category_type.dart';
import 'package:baby_book/base/pref_data.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../models/model_age_group.dart';
import '../models/model_book_response.dart';
import '../repository/book_repository.dart';
import '../repository/paging_request.dart';

class TabHomeController extends GetxController {
  final BookRepository bookListRepository;

  TabHomeController(int initAgeGroupId, {required this.bookListRepository}) {
    assert(bookListRepository != null);
    selectedAgeGroupId = initAgeGroupId;
  }

  ///map(로컬 캐시용)
  Map<CategoryType, List<ModelBookResponse>> map = {};

  ///book
  final _bookList = <ModelBookResponse>[].obs;

  get bookList => _bookList.value;

  set bookList(value) => _bookList.value = value;

  ///loading
  final _loading = false.obs;

  get loading => _loading.value;

  set loading(value) => _loading.value = value;

  ///선택된 ageGroup
  final _selectedAgeGroupId = 0.obs;

  get selectedAgeGroupId => _selectedAgeGroupId.value;

  set selectedAgeGroupId(value) => _selectedAgeGroupId.value = value;

  ///선택된 category
  final _selectedCategoryIdx = 0.obs;

  get selectedCategoryIdx => _selectedCategoryIdx.value;

  set selectedCategoryIdx(value) => _selectedCategoryIdx.value = value;

  CategoryType selectedCategoryType = CategoryType.all;

  TextEditingController ageGroupTextEditingController = TextEditingController();

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
    selectedCategoryType = categoryType;

    /// 캐시처리, all일경우 제외
    if (map.containsKey(categoryType) && categoryType != CategoryType.all) {
      _bookList.clear();
      _bookList.addAll(map[categoryType]!);
      return;
    }

    getAllForPullToRefresh();
  }

  ///pull to refresh 시 사용
  getAllForPullToRefresh() async {
    loading = true;
    List<ModelBookResponse> list = await _request(selectedCategoryType, PagingRequest.createDefault());

    ///리스트 초기화
    _initList(selectedCategoryType, list);

    ///사용자경험 위해 0.2초 딜레이
    Future.delayed(const Duration(milliseconds: 500), () {
      loading = false;
    });
  }

  ///next page 요청 시 사용
  Future<List<ModelBookResponse>> getAllForLoading(PagingRequest pagingRequest) async {
    List<ModelBookResponse> list = await _request(selectedCategoryType, pagingRequest);

    ///데이터 추가
    _addAll(selectedCategoryType, list);
    return list;
  }

  Future<List<ModelBookResponse>> _request(CategoryType categoryType, PagingRequest pagingRequest) async {
    /// no cache & 저장만함
    try {
      print("_request......${categoryType.code}........${pagingRequest.pageNumber}");
      return await bookListRepository.getBookList(
          ageGroup: ModelAgeGroup.getAgeGroup(selectedAgeGroupId),
          categoryType: selectedCategoryType,
          pagingRequest: pagingRequest);
    } on InvalidMemberException catch (e) {
      print(e);
      loading = false;
      Get.toNamed(Routes.loginPath);
    } catch (e) {
      print(e);
      loading = false;
      Get.toNamed(Routes.loginPath);
    }

    return [];
  }

  void initCache() {
    map.clear();
    _bookList.clear();
  }

  void _initList(CategoryType categoryType, List<ModelBookResponse> list) {
    if (categoryType != CategoryType.all) {
      if (map.containsKey(categoryType)) {
        map.remove(categoryType);
      }
      map[categoryType] = [];
      map[categoryType]!.addAll(list);
    }

    _bookList.clear();
    _bookList.addAll(list);
  }

  void _addAll(CategoryType categoryType, List<ModelBookResponse> list) {
    // 이미 map -> list가 맵핑된 상태임으로 list에만 넣어주면 됨
    // 참고로 map에 직접 넣던지 , postList = map[postType]; 이렇게 하면 obx동작 안하는 이슈가 있음
    map[categoryType]?.addAll(list);
    _bookList.addAll(list);

    // _postList.refresh(); 이방법도 존재하나 obx사용을 위해 사용하지 않고 스터디를 위해 해당 코드 남겨둠
  }
}
