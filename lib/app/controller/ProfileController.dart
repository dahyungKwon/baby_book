import 'package:baby_book/app/models/model_member.dart';
import 'package:baby_book/app/repository/baby_repository.dart';
import 'package:baby_book/app/repository/member_repository.dart';
import 'package:get/get.dart';
import '../../base/pref_data.dart';
import '../models/model_baby.dart';

class ProfileController extends GetxController {
  final MemberRepository memberRepository;
  final BabyRepository babyRepository;

  String? targetMemberId;
  bool myProfile = false;

  //member
  final _member = ModelMember.createForObsInit().obs;

  get member => _member.value;

  set member(value) => _member.value = value;

  //baby
  final _babyList = <ModelBaby>[].obs;

  get babyList => _babyList.value;

  set babyList(value) => _babyList.value = value;

  //loading
  final _loading = true.obs;

  get loading => _loading.value;

  set loading(value) => _loading.value = value;

  ProfileController({required this.memberRepository, required this.babyRepository, required this.targetMemberId}) {
    assert(memberRepository != null);
    assert(babyRepository != null);
  }

  @override
  void onInit() async {
    super.onInit();
    init();
  }

  init() async {
    loading = true;

    String? myMemberId = await PrefData.getMemberId();
    targetMemberId ??= await PrefData.getMemberId();

    member = await MemberRepository.getMember(memberId: targetMemberId!);
    if (targetMemberId == myMemberId) {
      myProfile = true;
    }

    babyList = await BabyRepository.getBabyList(memberId: targetMemberId!);

    refresh();
    Future.delayed(const Duration(milliseconds: 500), () {
      loading = false;
    });
  }

  getBabyToString() {
    String str = "";
    for (int i = 0; i < babyList.length; i++) {
      str += "#${babyList[i].getBirthdayToString()}  ";
    }
    return str;
  }

  updateProfile(ModelMember updateMember, List<ModelBaby> updateBabyList) {
    member.nickName = updateMember.nickName;
    member.gender = updateMember.gender;
    member.contents = updateMember.contents;
    member.selectedBabyId = updateMember.selectedBabyId;

    babyList = updateBabyList;
    _member.refresh();
    _babyList.refresh();
  }
}
