import 'package:baby_book/app/repository/member_repository.dart';
import 'package:baby_book/app/view/login/gender_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../view/dialog/error_dialog.dart';

class JoinController extends GetxController {
  final MemberRepository memberRepository;
  TextEditingController nickNameController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  String checkedNickName = "";

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

  JoinController({required this.memberRepository}) {
    assert(memberRepository != null);
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

    if (nickNameController.text.isNotEmpty && nickNameController.text.isNotEmpty) {
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
}
