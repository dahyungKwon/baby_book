import 'dart:io';

import 'package:baby_book/app/models/model_member.dart';
import 'package:baby_book/app/repository/baby_repository.dart';
import 'package:baby_book/app/repository/member_repository.dart';
import 'package:baby_book/app/view/login/gender_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../base/pref_data.dart';
import '../models/model_baby.dart';
import '../routes/app_pages.dart';
import '../view/dialog/error_dialog.dart';
import '../view/dialog/re_confirm_dialog.dart';
import '../view/login/baby_dialog.dart';
import '../view/login/gender_type_bottom_sheet.dart';
import 'BabyDialogController.dart';

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

  ///전체동의
  final _allAgreed = false.obs;

  get allAgreed => _allAgreed.value;

  set allAgreed(value) => _allAgreed.value = value;

  ///서비스이용약관
  final _serviceAgreed = false.obs;

  get serviceAgreed => _serviceAgreed.value;

  set serviceAgreed(value) => _serviceAgreed.value = value;

  ///개인정보
  final _privacyAgreed = false.obs;

  get privacyAgreed => _privacyAgreed.value;

  set privacyAgreed(value) => _privacyAgreed.value = value;

  ///첫번째스탭 준비완료
  final _readyFirstStep = false.obs;

  get readyFirstStep => _readyFirstStep.value;

  set readyFirstStep(value) => _readyFirstStep.value = value;

  ///두번째스탭 준비완료
  final _readySecondStep = false.obs;

  get readySecondStep => _readySecondStep.value;

  set readySecondStep(value) => _readySecondStep.value = value;

  ///세번째스탭 준비완료
  final _readyThirdStep = false.obs;

  get readyThirdStep => _readyThirdStep.value;

  set readyThirdStep(value) => _readyThirdStep.value = value;

  ///네번째스탭 준비완료
  final _readyFourthStep = false.obs;

  get readyFourthStep => _readyFourthStep.value;

  set readyFourthStep(value) => _readyFourthStep.value = value;

  ///첫번째스탭 완료
  final _finishFirstStep = false.obs;

  get finishFirstStep => _finishFirstStep.value;

  set finishFirstStep(value) => _finishFirstStep.value = value;

  ///두번째스탭 완료
  final _finishSecondStep = false.obs;

  get finishSecondStep => _finishSecondStep.value;

  set finishSecondStep(value) => _finishSecondStep.value = value;

  ///세번째스탭 완료
  final _finishThirdStep = false.obs;

  get finishThirdStep => _finishThirdStep.value;

  set finishThirdStep(value) => _finishThirdStep.value = value;

  ///네번째스탭 완료
  final _finishFourthStep = false.obs;

  get finishFourthStep => _finishFourthStep.value;

  set finishFourthStep(value) => _finishFourthStep.value = value;

  ///현재 스텝 번호
  final _currentStep = 1.obs;

  get currentStep => _currentStep.value;

  set currentStep(value) => _currentStep.value = value;

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
    print("text listener : ${nickNameController.text}");

    if (nickNameController.text.isEmpty) {
      canCheckNickName = false;
      return;
    }

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

    Future.delayed(const Duration(milliseconds: 200), () {
      loading = false;
    });
  }

  ///첫번째스탭 - 닉네임 중복확인 된 이후
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
      readyFirstStep = true;

      ///자동으로 넘어 가게 하기 위함
      // confirmStep();
    }
  }

  showGenderBottomSheet(BuildContext context) {
    showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) =>
                GenderTypeBottomSheet(genderType: gender!, genderPresentationType: GenderTypeBottomSheet.genderAdult))
        .then((selectedGender) {
      if (selectedGender != null) {
        changeGender(selectedGender);
      }
    });
  }

  ///두번째스텝 - 성별선정
  changeGender(GenderType changedGender) {
    gender = changedGender;
    readySecondStep = true;

    ///자동으로 넘어 가게 하기 위함
    // confirmStep();
  }

  clickAllAgreed() {
    if (allAgreed) {
      allAgreed = false;
      serviceAgreed = false;
      privacyAgreed = false;
      readyFourthStep = false;
    } else {
      allAgreed = true;
      serviceAgreed = true;
      privacyAgreed = true;
      readyFourthStep = true;
    }
  }

  ///네번째스텝 - 서비스이용약관동의
  clickServiceAgreed() {
    if (serviceAgreed) {
      serviceAgreed = false;
    } else {
      serviceAgreed = true;
    }

    if (privacyAgreed && serviceAgreed) {
      allAgreed = true;
      readyFourthStep = true;
    } else {
      allAgreed = false;
      readyFourthStep = false;
    }
  }

  ///네번째스텝 - 개인정보동의
  clickPrivacyAgreed() {
    if (privacyAgreed) {
      privacyAgreed = false;
    } else {
      privacyAgreed = true;
    }

    if (privacyAgreed && serviceAgreed) {
      allAgreed = true;
      readyFourthStep = true;
    } else {
      allAgreed = false;
      readyFourthStep = false;
    }
  }

  confirmStep(BuildContext context) {
    if (!finishFirstStep) {
      if (nickNameController.text == null || nickNameController.text.isEmpty) {
        Get.dialog(ErrorDialog("닉네임을 입력해주세요."));
        return;
      }

      if (checkedNickName == null || checkedNickName.isEmpty) {
        Get.dialog(ErrorDialog("닉네임 중복체크를 해주세요."));
        return;
      }

      finishFirstStep = true;
      currentStep = 2; //2스텝으로 이동
      showGenderBottomSheet(context);
      return;
    }

    if (!finishSecondStep) {
      if (gender == null || gender == GenderType.none) {
        Get.dialog(ErrorDialog("성별을 선택해주세요."));
        return;
      }

      finishSecondStep = true;
      currentStep = 3; //3스텝으로 이동
      return;
    }

    if (!finishThirdStep) {
      if (selectedBabyList == null || selectedBabyList.isEmpty) {
        Get.dialog(ErrorDialog("아기곰을 추가해주세요."));
        return;
      }

      finishThirdStep = true;
      currentStep = 4; //4스텝으로 이동
      return;
    }

    if (!finishFourthStep) {
      if (!serviceAgreed) {
        Get.dialog(ErrorDialog("서비스 이용약관을 동의 해주세요."));
        return;
      }

      if (!privacyAgreed) {
        Get.dialog(ErrorDialog("개인정보 취급방침을 동의 해주세요."));
        return;
      }

      finishFourthStep = true;

      ///동의하고 나서는 서버 통신하면 될뜻
      _confirm();
      return;
    }
  }

  backStep() {
    /// 4스텝에서는 이미 서버통신이 이뤄진 상태라 뒤로 안감
    // if (finishFourthStep) {
    //   finishFourthStep = false;
    //   currentStep = 3;
    //   return;
    // }

    if (finishThirdStep) {
      finishThirdStep = false;
      currentStep = 3;
      return;
    }

    if (finishSecondStep) {
      finishSecondStep = false;
      currentStep = 2;
      return;
    }

    if (finishFirstStep) {
      finishFirstStep = false;
      currentStep = 1;
      return;
    }

    if (!finishFirstStep) {
      ///종료하시겠습니까?
      if (Platform.isAndroid) {
        SystemNavigator.pop();
      } else if (Platform.isIOS) {
        exit(0);
      }
    }
  }

  _confirm() async {
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
    Get.dialog(BabyDialog(index, selectedBabyList[index], BabyDialogController.callerJoin));
  }

  addBaby(ModelBaby baby) {
    selectedBabyList.add(baby);
    selectedBabyList.sort((ModelBaby a, ModelBaby b) => a.birth!.compareTo(b.birth!));
    _selectedBabyList.refresh();

    if (selectedBabyList.isNotEmpty) {
      readyThirdStep = true;
    } else {
      readyThirdStep = false;
    }
  }

  modifyBaby(int index, ModelBaby baby) {
    selectedBabyList[index].name = baby.name;
    selectedBabyList[index].gender = baby.gender;
    selectedBabyList[index].birth = baby.birth;
    selectedBabyList.sort((ModelBaby a, ModelBaby b) => a.birth!.compareTo(b.birth!));
    _selectedBabyList.refresh();
  }

  deleteBaby(int index) async {
    await Get.dialog(ReConfirmDialog("삭제 하시겠습니까?", "네", "아니오", () async {
      selectedBabyList.removeAt(index);
      selectedBabyList.sort((ModelBaby a, ModelBaby b) => a.birth!.compareTo(b.birth!));
      _selectedBabyList.refresh();

      if (selectedBabyList.isNotEmpty) {
        readyThirdStep = true;
      } else {
        readyThirdStep = false;
      }

      Get.back();
    }));
  }

  changeRepresentBabyIndex(int index) {
    representBabyIndex = index;
    _selectedBabyList.refresh();
  }
}
