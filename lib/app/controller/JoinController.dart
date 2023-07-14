import 'package:baby_book/app/models/model_member.dart';
import 'package:baby_book/app/repository/baby_repository.dart';
import 'package:baby_book/app/repository/member_repository.dart';
import 'package:baby_book/app/view/login/gender_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../base/pref_data.dart';
import '../models/model_baby.dart';
import '../routes/app_pages.dart';
import '../view/dialog/error_dialog.dart';
import '../view/login/baby_dialog.dart';

class JoinController extends GetxController {
  final MemberRepository memberRepository;
  final BabyRepository babyRepository;
  TextEditingController nickNameController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  String checkedNickName = "";

  ///대표 아기 인덱스
  final _representBabyIndex = 0.obs;

  get representBabyIndex => _representBabyIndex.value;

  set representBabyIndex(value) => _representBabyIndex.value = value;

  ///선택된 아기 리스트
  final _selectedBabyList = <ModelBaby>[].obs;

  get selectedBabyList => _selectedBabyList.value;

  set selectedBabyList(value) => _selectedBabyList.value = value;

  //loading
  final _loading = false.obs;

  get loading => _loading.value;

  set loading(value) => _loading.value = value;

  ///가입 가능여부
  final _canJoin = false.obs;

  get canJoin => _canJoin.value;

  set canJoin(value) => _canJoin.value = value;

  ///닉네임 체크가 가능한지 여부
  final _canCheckNickName = false.obs;

  get canCheckNickName => _canCheckNickName.value;

  set canCheckNickName(value) => _canCheckNickName.value = value;

  ///닉네임이 유효한지 여부
  final _validNickName = false.obs;

  get validNickName => _validNickName.value;

  set validNickName(value) => _validNickName.value = value;

  ///성별
  final _gender = GenderType.none.obs;

  get gender => _gender.value;

  set gender(value) => _gender.value = value;

  ///서비스이용약관 가입 가능여부
  final _serviceAgreed = false.obs;

  get serviceAgreed => _serviceAgreed.value;

  set serviceAgreed(value) => _serviceAgreed.value = value;

  ///개인정보 가입 가능여부
  final _privacyAgreed = false.obs;

  get privacyAgreed => _privacyAgreed.value;

  set privacyAgreed(value) => _privacyAgreed.value = value;

  JoinController({required this.memberRepository, required this.babyRepository}) {
    assert(memberRepository != null);
    assert(babyRepository != null);
  }

  @override
  void onInit() async {
    super.onInit();
    init();
    nickNameController.addListener(_nickNameListener);
  }

  void _nickNameListener() {
    if (nickNameController.text == checkedNickName) {
      print("중복체크이후 닉네임 변경 진입");
      return;
    }

    if (validNickName) {
      validNickName = false;
      canCheckNickName = true;
      return;
    }

    if (nickNameController.text.isNotEmpty) {
      canCheckNickName = true;
    } else {
      canCheckNickName = false;
    }
  }

  init() async {
    loading = true;

    checkJoin();

    Future.delayed(const Duration(milliseconds: 200), () {
      loading = false;
    });
  }

  confirmNickName() async {
    String? nickName = nickNameController.text;
    if (nickName == null || nickName.isBlank!) {
      Get.dialog(ErrorDialog("닉네임을 입력해주세요."));
      return;
    }

    bool existNickName = await MemberRepository.existNickName(nickName: nickName);
    if (existNickName) {
      Get.dialog(ErrorDialog("이미 존재하는 닉네임입니다."));
      return;
    } else {
      validNickName = true;
      checkedNickName = nickName;
    }

    checkJoin();
  }

  changeGender(GenderType changedGender) {
    gender = changedGender;
    checkJoin();
  }

  clickServiceAgreed() {
    if (serviceAgreed) {
      serviceAgreed = false;
    } else {
      serviceAgreed = true;
    }

    checkJoin();
  }

  clickPrivacyAgreed() {
    if (privacyAgreed) {
      privacyAgreed = false;
    } else {
      privacyAgreed = true;
    }

    checkJoin();
  }

  checkJoin() {
    if (validNickName && gender != GenderType.none && privacyAgreed && serviceAgreed) {
      canJoin = true;
    } else {
      canJoin = false;
    }
  }

  confirm() async {
    if (nickNameController.text == null || nickNameController.text.isEmpty) {
      Get.dialog(ErrorDialog("닉네임을 입력해주세요."));
      return;
    }

    if (checkedNickName == null || checkedNickName.isEmpty) {
      Get.dialog(ErrorDialog("닉네임 중복체크를 해주세요."));
      return;
    }

    if (gender == null || gender == GenderType.none) {
      Get.dialog(ErrorDialog("성별을 선택해주세요."));
      return;
    }

    if (selectedBabyList == null || selectedBabyList.isEmpty) {
      Get.dialog(ErrorDialog("아기곰을 추가해주세요."));
      return;
    }

    if (!serviceAgreed) {
      Get.dialog(ErrorDialog("서비스 이용약관을 자세히 읽고 동의 해주세요."));
      return;
    }

    if (!privacyAgreed) {
      Get.dialog(ErrorDialog("개인정보 취급방침을 자세히 읽고 동의 해주세요."));
      return;
    }

    var memberId = await PrefData.getMemberId();

    List<ModelBaby> registeredBabyList = [];
    for (ModelBaby baby in selectedBabyList) {
      registeredBabyList.add(await BabyRepository.createBaby(
          memberId: memberId!, name: baby.name!, gender: baby.gender!, birth: baby.birth!));
    }

    ModelMember member = await MemberRepository.putMember(
        memberId: memberId!,
        nickName: checkedNickName,
        allAgreed: true,
        gender: gender,
        selectedBabyId: registeredBabyList[representBabyIndex].babyId!);

    await PrefData.setAgreed(true);

    Get.toNamed(Routes.homescreenPath);
  }

  openModifyBabyDialog(int index) {
    Get.dialog(BabyDialog(index, selectedBabyList[index]));
  }

  addBaby(ModelBaby baby) {
    selectedBabyList.add(baby);
    selectedBabyList.sort((ModelBaby a, ModelBaby b) => a.birth!.compareTo(b.birth!));
    _selectedBabyList.refresh();
  }

  modifyBaby(int index, ModelBaby baby) {
    selectedBabyList[index].name = baby.name;
    selectedBabyList[index].gender = baby.gender;
    selectedBabyList[index].birth = baby.birth;
    selectedBabyList.sort((ModelBaby a, ModelBaby b) => a.birth!.compareTo(b.birth!));
    _selectedBabyList.refresh();
  }

  deleteBaby(int index) {
    selectedBabyList.removeAt(index);
    selectedBabyList.sort((ModelBaby a, ModelBaby b) => a.birth!.compareTo(b.birth!));
    _selectedBabyList.refresh();
  }

  changeRepresentBabyIndex(int index) {
    representBabyIndex = index;
    _selectedBabyList.refresh();
  }
}
