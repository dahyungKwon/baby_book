import 'package:baby_book/app/repository/member_repository.dart';
import 'package:baby_book/base/pref_data.dart';
import 'package:get/get.dart';

import '../routes/app_pages.dart';
import '../view/dialog/re_confirm_dialog.dart';

class SettingController extends GetxController with GetSingleTickerProviderStateMixin {
  final MemberRepository memberRepository;
  late String memberId;

  SettingController({required this.memberRepository}) {
    assert(memberRepository != null);
  }

  //loading
  final _loading = false.obs;

  get loading => _loading.value;

  set loading(value) => _loading.value = value;

  @override
  void onInit() async {
    super.onInit();
    loading = true;

    memberId = (await PrefData.getMemberId())!;

    ///사용자경험 위해 0.2초 딜레이
    Future.delayed(const Duration(milliseconds: 500), () {
      loading = false;
    });
  }

  deleteMember() async {
    await Get.dialog(ReConfirmDialog("아기곰책육아 회원 탈퇴 하시겠습니까?", "네", "아니오", () async {
      await MemberRepository.deleteMember(memberId: memberId);
      await PrefData.setAgreed(false);
      await PrefData.setLogIn(false);
      await PrefData.setMemberId(null);
      await PrefData.setAccessToken(null);
      await PrefData.setRefreshToken(null);

      Get.toNamed(Routes.loginPath);
    }));
  }

  @override
  onClose() {
    super.onClose();
  }
}
