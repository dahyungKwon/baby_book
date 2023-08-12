import 'package:baby_book/app/models/model_member.dart';
import 'package:baby_book/app/repository/baby_repository.dart';
import 'package:baby_book/app/repository/member_repository.dart';
import 'package:baby_book/base/pref_data.dart';
import 'package:get/get.dart';
import '../exception/exception_invalid_member.dart';
import '../models/model_baby.dart';
import '../models/model_my_book_response.dart';
import '../repository/my_book_repository.dart';
import '../repository/paging_request.dart';
import '../routes/app_pages.dart';
import '../view/home/book/HoldType.dart';

class BookCaseListController extends GetxController with GetSingleTickerProviderStateMixin {
  final MyBookRepository myBookRepository;
  final MemberRepository memberRepository;
  final BabyRepository babyRepository;
  late String? memberId;
  late HoldType? holdType;

  // late HoldType holdType;
  late ModelMember member;
  late List<ModelBaby> babyList;
  bool myBookCase = false;
  ModelBaby? selectedBaby; //대표아기

  ///map(로컬 캐시용)
  Map<HoldType, List<ModelMyBookResponse>> map = {};

  List<HoldType> tabsList = HoldType.findListForTab();

  BookCaseListController(
      {required this.myBookRepository,
      required this.memberRepository,
      required this.babyRepository,
      required this.memberId,
      required this.holdType}) {
    assert(myBookRepository != null);
    assert(memberRepository != null);
    assert(babyRepository != null);
  }

  ///loading
  final _loading = true.obs;

  get loading => _loading.value;

  set loading(value) => _loading.value = value;

  ///선택된 아기 index
  final _selectedBabyIndex = 0.obs;

  get selectedBabyIndex => _selectedBabyIndex.value;

  set selectedBabyIndex(value) => _selectedBabyIndex.value = value;

  ///나의 책리스트
  final _myBookResponseList = <ModelMyBookResponse>[].obs;

  get myBookResponseList => _myBookResponseList.value;

  set myBookResponseList(value) => _myBookResponseList.value = value;

  @override
  void onInit() async {
    super.onInit();
    loading = true;
    String? myId = await PrefData.getMemberId();
    memberId = memberId ?? myId;
    myBookCase = myId == memberId;

    member = await MemberRepository.getMember(memberId: memberId!);

    ///null을 허용할지 추후 고민
    if (member.selectedBabyId != null) {
      selectedBaby = await BabyRepository.getBaby(babyId: member.selectedBabyId!);
    }

    babyList = await BabyRepository.getBabyList(memberId: memberId!);
    for (int i = 0; i < babyList.length; i++) {
      if (babyList[i].babyId == selectedBaby?.babyId) {
        selectedBabyIndex = i;
      }
    }

    if (holdType == HoldType.all) {
      await getAllForInit(HoldType.all);
    }

    ///사용자경험 위해 0.2초 딜레이
    Future.delayed(const Duration(milliseconds: 500), () {
      loading = false;
    });
  }

  /// 첫 페이지 로딩 시 사용, 페이지 변경시에도 사용됨
  getAllForInit(HoldType holdType) async {
    /// 캐시처리, all도 캐시 처리
    if (map.containsKey(holdType)) {
      _myBookResponseList.clear();
      _myBookResponseList.addAll(map[holdType]!);
      return;
    }

    getAllForPullToRefresh(holdType);
  }

  ///pull to refresh 시 사용
  getAllForPullToRefresh(HoldType holdType) async {
    loading = true;
    List<ModelMyBookResponse> list = await _request(holdType, PagingRequest.createDefault());

    ///최초기에 paging은 0

    ///리스트 초기화
    _initList(holdType, list);

    ///사용자경험 위해 0.2초 딜레이
    Future.delayed(const Duration(milliseconds: 500), () {
      loading = false;
    });
  }

  ///next page 요청 시 사용
  Future<List<ModelMyBookResponse>> getAllForLoading(HoldType holdType, PagingRequest pagingRequest) async {
    List<ModelMyBookResponse> list = await _request(holdType, pagingRequest);

    ///데이터 추가
    _addAll(holdType, list);
    return list;
  }

  Future<List<ModelMyBookResponse>> _request(HoldType holdType, PagingRequest pagingRequest) async {
    /// no cache & 저장만함
    if (selectedBaby == null) {
      print("_request......selected baby is null, so don't connect server");
      return Future(() => []);
    }

    print("_request......${holdType.code}........${pagingRequest.pageNumber}");
    return await myBookRepository.getMyBookList(
        pagingRequest: pagingRequest, memberId: memberId!, babyId: selectedBaby!.babyId!, holdType: holdType);
  }

  void _initList(HoldType holdType, List<ModelMyBookResponse> list) {
    // if (holdType != HoldType.all) {
    if (map.containsKey(holdType)) {
      map.remove(holdType);
    }
    map[holdType] = [];
    map[holdType]!.addAll(list);
    // }

    _myBookResponseList.clear();
    _myBookResponseList.addAll(list);
  }

  void _addAll(HoldType holdType, List<ModelMyBookResponse> list) {
    map[holdType]?.addAll(list);
    _myBookResponseList.addAll(list);
  }

  Future<bool> removeBook(HoldType holdType, ModelMyBookResponse book) async {
    return await myBookRepository.delete(myBookId: book.myBook.myBookId);
  }

  updateMyBook(int index, ModelMyBookResponse book) {
    _myBookResponseList[index].myBook = book.myBook;
    _myBookResponseList.refresh();
  }
}
