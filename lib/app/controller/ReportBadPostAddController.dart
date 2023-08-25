import 'package:baby_book/app/models/model_report_bad_post.dart';
import 'package:baby_book/app/repository/report_bad_post_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../base/pref_data.dart';
import '../../base/resizer/fetch_pixels.dart';
import '../exception/exception_invalid_member.dart';
import '../routes/app_pages.dart';
import '../view/dialog/error_dialog.dart';

class ReportBadPostAddController extends GetxController {
  final ReportBadPostRepository reportBadPostRepository;
  final String postId;
  final String postTitle; //당장 노출 안하는중
  final String writerName; //당장 노출 안하는중

  //loading
  final _loading = true.obs;

  get loading => _loading.value;

  set loading(value) => _loading.value = value;

  ///right color
  final _canRegister = false.obs;

  get canRegister => _canRegister.value;

  set canRegister(value) => _canRegister.value = value;

  TextEditingController titleController = TextEditingController();
  TextEditingController contentsController = TextEditingController();

  /// 수정용 ID
  int? modifyReportId;

  ///modify mode 체크
  final _modifyMode = false.obs;

  get modifyMode => _modifyMode.value;

  set modifyMode(value) => _modifyMode.value = value;

  ReportBadPostAddController(
      {required this.reportBadPostRepository,
      required this.postId,
      required this.postTitle,
      required this.writerName}) {
    assert(reportBadPostRepository != null);

    titleController.addListener(_titleListener);
    contentsController.addListener(_contentsListener);
  }

  @override
  void onInit() {
    super.onInit();
    loading = false;

    ///로딩은 수정시에만 필요
  }

  void _titleListener() {
    if (titleController.text.isNotEmpty && contentsController.text.isNotEmpty) {
      canRegister = true;
    } else {
      canRegister = false;
    }
  }

  void _contentsListener() {
    if (titleController.text.isNotEmpty && contentsController.text.isNotEmpty) {
      canRegister = true;
    } else {
      canRegister = false;
    }
  }

  Future<bool> add() async {
    if (titleController.text.isEmpty) {
      await Get.dialog(ErrorDialog("신고 제목을 입력해주세요."));
      return false;
    }
    if (titleController.text.length > 100) {
      await Get.dialog(ErrorDialog("신고 제목은 100자 이하로 입력해주세요."));
      return false;
    }

    if (contentsController.text.isEmpty) {
      await Get.dialog(ErrorDialog("신고 상세 내용을 입력해주세요."));
      return false;
    }
    if (contentsController.text.length > 3000) {
      await Get.dialog(ErrorDialog("신고 상세 내용은 3000자 이하로 입력 해주세요."));
      return false;
    }

    bool result = await Get.dialog(
      AlertDialog(
        // title: const Text('dialog title'),
        content: Text(
          modifyMode ? '수정 하시겠습니까?' : '신고 하시겠습니까?',
          style: const TextStyle(fontSize: 15),
        ),
        contentPadding: EdgeInsets.only(
            top: FetchPixels.getPixelHeight(20),
            left: FetchPixels.getPixelHeight(20),
            bottom: FetchPixels.getPixelHeight(10)),
        actions: [
          TextButton(
              style: TextButton.styleFrom(splashFactory: NoSplash.splashFactory),
              onPressed: Get.back,
              child: const Text('취소', style: TextStyle(color: Colors.black, fontSize: 14))),
          TextButton(
            style: TextButton.styleFrom(splashFactory: NoSplash.splashFactory),
            onPressed: requestAdd,
            child: const Text('신고', style: TextStyle(color: Colors.black, fontSize: 14)),
          ),
        ],
      ),
    );

    return result;
  }

  void requestAdd() async {
    var memberId = await PrefData.getMemberId();
    try {
      if (modifyMode) {
        ModelReportBadPost? changed = await ReportBadPostRepository.put(
            id: modifyReportId!,
            postId: postId,
            title: titleController.text,
            contents: contentsController.text,
            memberId: memberId!);
        if (changed == null) {
          ///네트워크 에러
          return;
        }
      } else {
        ModelReportBadPost? newReport = await ReportBadPostRepository.add(
            postId: postId, title: titleController.text, contents: contentsController.text, memberId: memberId!);
        if (newReport == null) {
          ///네트워크 에러
          return;
        }
      }
      Get.back(result: true);
    } on InvalidMemberException catch (e) {
      print(e);
      Get.toNamed(Routes.reAuthPath);
    } catch (e) {
      print(e);
      Get.dialog(ErrorDialog("네트워크 오류가 발생하였습니다.\n잠시 후 다시 시도해주세요.\n상세코드: $e"));
    }
  }

  ///[수정모드]] 진입
  initModifyMode(int reportId) async {
    loading = true;

    modifyMode = true;
    modifyReportId = reportId;

    ModelReportBadPost? old = await ReportBadPostRepository.get(id: reportId);

    ///네트워크에러
    if (old == null) {
      loading = false;
      return;
    }
    titleController.text = old.title!;
    contentsController.text = old.contents!;

    Future.delayed(const Duration(milliseconds: 500), () {
      loading = false;
    });
  }
}
