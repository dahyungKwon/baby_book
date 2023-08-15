import 'package:baby_book/app/repository/report_new_book_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../base/pref_data.dart';
import '../../base/resizer/fetch_pixels.dart';
import '../exception/exception_invalid_member.dart';
import '../models/model_report_new_book.dart';
import '../routes/app_pages.dart';
import '../view/dialog/error_dialog.dart';

class ReportNewBookAddController extends GetxController {
  final ReportNewBookRepository reportNewBookRepository;

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
  int? modifyReportNewBookId;

  ///modify mode 체크
  final _modifyMode = false.obs;

  get modifyMode => _modifyMode.value;

  set modifyMode(value) => _modifyMode.value = value;

  ReportNewBookAddController({
    required this.reportNewBookRepository,
  }) {
    assert(reportNewBookRepository != null);

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
      Get.dialog(ErrorDialog("책이름을 입력해주세요."));
      return false;
    }

    if (contentsController.text.isEmpty) {
      Get.dialog(ErrorDialog("알고 계시는 책 관련 내용을 입력해주세요."));
      return false;
    }

    bool result = await Get.dialog(
      AlertDialog(
        // title: const Text('dialog title'),
        content: Text(
          modifyMode ? '수정 하시겠습니까?' : '제보 하시겠습니까?',
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
            child: const Text('제보', style: TextStyle(color: Colors.black, fontSize: 14)),
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
        ModelReportNewBook? changedReportNewBook = await ReportNewBookRepository.put(
            id: modifyReportNewBookId!,
            title: titleController.text,
            contents: contentsController.text,
            memberId: memberId!);
        if (changedReportNewBook == null) {
          ///네트워크 에러
          return;
        }
      } else {
        ModelReportNewBook? reportNewBook = await ReportNewBookRepository.add(
            title: titleController.text, contents: contentsController.text, memberId: memberId!);
        if (reportNewBook == null) {
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
  initModifyMode(int reportNewBookId) async {
    loading = true;

    modifyMode = true;
    modifyReportNewBookId = reportNewBookId;

    ModelReportNewBook? reportNewBook = await ReportNewBookRepository.get(id: reportNewBookId);

    ///네트워크에러
    if (reportNewBook == null) {
      loading = false;
      return;
    }
    titleController.text = reportNewBook.title!;
    contentsController.text = reportNewBook.contents!;

    Future.delayed(const Duration(milliseconds: 500), () {
      loading = false;
    });
  }
}
