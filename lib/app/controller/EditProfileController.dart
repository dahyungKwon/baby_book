import 'dart:io';

import 'package:baby_book/app/controller/BabyDialogController.dart';
import 'package:baby_book/app/models/model_member.dart';
import 'package:baby_book/app/repository/baby_repository.dart';
import 'package:baby_book/app/repository/member_repository.dart';
import 'package:baby_book/app/view/login/gender_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../base/pref_data.dart';
import '../models/model_baby.dart';
import '../routes/app_pages.dart';
import '../view/dialog/error_dialog.dart';
import '../view/dialog/re_confirm_dialog.dart';
import '../view/login/baby_dialog.dart';
import '../view/login/gender_type_bottom_sheet.dart';
import 'ProfileController.dart';

class EditProfileController extends GetxController {
  final MemberRepository memberRepository;
  final BabyRepository babyRepository;
  TextEditingController nickNameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController contentsController = TextEditingController();

  String checkedNickName = "";

  String? targetMemberId;
  late ModelMember member;
  bool myProfile = false;
  bool isModifyBaby = false; //아기가 변경된걸 확인하고, 변경되었으면 전체 삭제하고 추가함

  List<ModelBaby> deletedBabyList = [];

  ///대표 아기 아이디
  final _representBabyId = "".obs;

  get representBabyId => _representBabyId.value;

  set representBabyId(value) => _representBabyId.value = value;

  ///선택된 아기 리스트
  final _selectedBabyList = <ModelBaby>[].obs;

  get selectedBabyList => _selectedBabyList.value;

  set selectedBabyList(value) => _selectedBabyList.value = value;

  //loading
  final _loading = true.obs;

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

  int randomKey = 0;

  EditProfileController({required this.memberRepository, required this.babyRepository}) {
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

    targetMemberId ??= await PrefData.getMemberId();

    member = await MemberRepository.getMember(memberId: targetMemberId!);
    if (targetMemberId! == member.memberId) {
      myProfile = true;
    }

    nickNameController.text = member.nickName!;
    gender = member.gender;
    selectedBabyList = await BabyRepository.getBabyList(memberId: targetMemberId!);

    contentsController.text = member.contents ?? "";
    canCheckNickName = true;
    validNickName = true;
    checkedNickName = member.nickName!;

    representBabyId = member.selectedBabyId;

    Future.delayed(const Duration(milliseconds: 500), () {
      loading = false;
    });
  }

  confirmNickName() async {
    String? nickName = nickNameController.text;
    if (nickName == null || nickName.isBlank!) {
      Get.dialog(ErrorDialog("닉네임을 입력해주세요."));
      return;
    }

    bool? existNickName = await MemberRepository.existNickName(nickName: nickName);
    if (existNickName == null) {
      ///네트웍에러
      return;
    }

    if (existNickName) {
      Get.dialog(ErrorDialog("이미 존재하는 닉네임입니다."));
      return;
    } else {
      validNickName = true;
      checkedNickName = nickName;
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

    if (representBabyId == null || representBabyId == "") {
      Get.dialog(ErrorDialog("대표 아기곰을 선택해주세요."));
      return;
    }

    var memberId = await PrefData.getMemberId();

    //tempid가 아닌, 실제로 서버에서 받은 id를 선정해야합니다.
    String? createdRepresentBabyId;
    List<ModelBaby> registeredBabyList = [];
    for (ModelBaby baby in selectedBabyList) {
      if (baby.babyId!.startsWith("temp")) {
        ModelBaby? createdBaby = await BabyRepository.createBaby(
            memberId: memberId!, name: baby.name!, gender: baby.gender!, birth: baby.birth!);
        if (createdBaby == null) {
          ///네트웍오류
          return;
        }

        registeredBabyList.add(createdBaby);

        if (baby.babyId == representBabyId) {
          createdRepresentBabyId = createdBaby.babyId!;
        }
      } else {
        ModelBaby? changedBaby = await BabyRepository.putBaby(
            babyId: baby.babyId!, name: baby.name!, gender: baby.gender!, birth: baby.birth!);
        if (changedBaby == null) {
          ///네트웍에러
          return;
        }

        registeredBabyList.add(changedBaby);
      }
    }

    for (ModelBaby deletedBaby in deletedBabyList) {
      if (deletedBaby.babyId != null) {
        bool result = await BabyRepository.deleteBaby(babyId: deletedBaby.babyId!);
        if (!result) {
          ///네트웍에러
          return;
        }
      }
    }

    ModelMember? member = await MemberRepository.putMember(
        memberId: memberId!,
        nickName: checkedNickName,
        allAgreed: true,
        gender: gender,
        selectedBabyId: createdRepresentBabyId ?? representBabyId,
        contents: contentsController.text);
    if (member == null) {
      ///네트웍에러
      return;
    }

    await PrefData.setAgreed(true);

    Get.find<ProfileController>().updateProfile(member, selectedBabyList);

    Get.offNamed(Routes.homescreenPath);
  }

  openModifyBabyDialog(int index) {
    Get.dialog(BabyDialog(index, selectedBabyList[index], BabyDialogController.callerEditProfile));
  }

  /// babyId가 최초엔 없음, 서버갔다와야하는데, 그때까지 구분용
  createTempBabyId() {
    randomKey++;
    return "temp${randomKey.toString()}";
  }

  addBaby(ModelBaby baby) {
    baby.babyId = createTempBabyId();

    ///최초아기는 대표아기로 선정
    if (selectedBabyList.isEmpty) {
      changeRepresentBaby(baby.babyId!);
    }

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

  deleteBaby(int index) async {
    await Get.dialog(ReConfirmDialog("삭제 하시겠습니까?", "네", "아니오", () async {
      ModelBaby baby = selectedBabyList[index];

      deletedBabyList.add(baby);
      selectedBabyList.removeAt(index);
      selectedBabyList.sort((ModelBaby a, ModelBaby b) => a.birth!.compareTo(b.birth!));

      ///삭제된 아기가 대표였으면 0번으로 변경
      if (baby.babyId == representBabyId) {
        if (selectedBabyList.isNotEmpty) {
          changeRepresentBaby(selectedBabyList[0].babyId);
        }
      }

      _selectedBabyList.refresh();

      Get.back();
    }));
  }

  changeRepresentBaby(String babyId) {
    representBabyId = babyId;
    _selectedBabyList.refresh();
  }
}
