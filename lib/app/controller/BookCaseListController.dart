import 'package:baby_book/app/models/model_member.dart';
import 'package:baby_book/app/repository/baby_repository.dart';
import 'package:baby_book/app/repository/member_repository.dart';
import 'package:baby_book/base/pref_data.dart';
import 'package:get/get.dart';
import '../models/model_baby.dart';
import '../models/model_my_book_response.dart';
import '../repository/my_book_repository.dart';
import '../repository/paging_request.dart';
import '../view/home/book/HoldType.dart';

class BookCaseListController extends GetxController with GetSingleTickerProviderStateMixin {
  final MyBookRepository myBookRepository;
  final MemberRepository memberRepository;
  final BabyRepository babyRepository;
  late String? memberId;
  late HoldType? holdType;
  late ModelMember member;
  late List<ModelBaby> babyList;
  late ModelBaby selectedBaby; //대표아기

  List<String> tabsList = ["전체", "구매예정", "읽는중", "방출"];

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
  final _loading = false.obs;

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
    memberId = memberId ?? await PrefData.getMemberId();

    member = await MemberRepository.getMember(memberId: memberId!);
    selectedBaby = await BabyRepository.getBaby(babyId: member.selectedBabyId!);
    babyList = await BabyRepository.getBabyList(memberId: memberId!);
    myBookResponseList = await myBookRepository.getMyBookList(
        pagingRequest: PagingRequest.createDefault(), babyId: selectedBaby.babyId!, holdType: holdType);

    for (int i = 0; i < babyList.length; i++) {
      if (babyList[i].babyId == selectedBaby.babyId) {
        selectedBabyIndex = i;
      }
    }

    Future.delayed(const Duration(milliseconds: 200), () {
      loading = false;
    });
  }
}
