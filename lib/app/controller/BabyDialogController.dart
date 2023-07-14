import 'package:baby_book/app/models/model_baby.dart';
import 'package:baby_book/app/view/login/gender_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../repository/baby_repository.dart';
import '../view/dialog/error_dialog.dart';
import 'JoinController.dart';

class BabyDialogController extends GetxController {
  final BabyRepository babyRepository;
  TextEditingController nameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController birthController = TextEditingController();

  ModelBaby? selectedModelBaby;

  //선택된 시간
  final _selectedBirthday = Rxn<DateTime>();

  get selectedBirthday => _selectedBirthday.value;

  set selectedBirthday(value) => _selectedBirthday.value = value;

  //loading
  final _loading = false.obs;

  get loading => _loading.value;

  set loading(value) => _loading.value = value;

  ///성별
  final _gender = GenderType.none.obs;

  get gender => _gender.value;

  set gender(value) => _gender.value = value;

  ///추가 가능
  final _canAdd = false.obs;

  get canAdd => _canAdd.value;

  set canAdd(value) => _canAdd.value = value;

  BabyDialogController({required this.babyRepository}) {
    assert(babyRepository != null);
  }

  @override
  void onInit() async {
    super.onInit();
    init();
  }

  init() async {
    loading = true;

    checkAdd();

    Future.delayed(const Duration(milliseconds: 200), () {
      loading = false;
    });
  }

  changeGender(GenderType changedGender) {
    gender = changedGender;
    checkAdd();
  }

  checkAdd() {
    if (nameController.text.isNotEmpty && gender != null && gender != GenderType.none) {
      canAdd = true;
    } else {
      canAdd = false;
    }
  }

  getSelectedBaby() {
    return ModelBaby(name: nameController.text, gender: gender, birth: selectedBirthday);
  }

  confirm(int? modifyIndex, bool modifyMode) {
    if (nameController.text == null || nameController.text.isEmpty) {
      Get.dialog(ErrorDialog("아기곰 이름을 입력해주세요."));
      return;
    }

    if (gender == null || gender == GenderType.none) {
      Get.dialog(ErrorDialog("아기곰 성별을 선택해주세요."));
      return;
    }

    if (selectedBirthday == null) {
      Get.dialog(ErrorDialog("아기곰 생일을 선택해주세요."));
      return;
    }
    if (modifyMode) {
      Get.find<JoinController>().modifyBaby(modifyIndex!, getSelectedBaby());
    } else {
      Get.find<JoinController>().addBaby(getSelectedBaby());
    }
    Get.back();
  }
}
