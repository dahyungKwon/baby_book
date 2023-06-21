import 'package:baby_book/app/controller/TabCommunityController.dart';
import 'package:baby_book/app/exception/exception_invalid_param.dart';
import 'package:baby_book/app/models/model_post.dart';
import 'package:baby_book/app/models/model_post_request.dart';
import 'package:baby_book/app/repository/post_repository.dart';
import 'package:baby_book/app/view/dialog/re_confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../base/pref_data.dart';
import '../../base/resizer/fetch_pixels.dart';
import '../exception/exception_invalid_member.dart';
import '../repository/post_image_repository.dart';
import '../routes/app_pages.dart';
import '../view/community/post_type.dart';
import '../view/dialog/error_dialog.dart';
import '../view/dialog/reset_dialog.dart';
import 'CommunityListController.dart';

class CommunityAddController extends GetxController {
  final PostRepository postRepository;
  final PostImageRepository postImageRepository;

  ///right color
  final _canRegister = false.obs;

  get canRegister => _canRegister.value;

  set canRegister(value) => _canRegister.value = value;

  final _postType = PostType.all.obs;

  get postType => _postType.value;

  set postType(value) => _postType.value = value;

  ///선택된 태그 리스트
  final _selectedTagList = <String>[].obs;

  get selectedTagList => _selectedTagList.value;

  set selectedTagList(value) => _selectedTagList.value = value;

  ///선택된 링크 리스트
  final _selectedLinkList = <String>[].obs;

  get selectedLinkList => _selectedLinkList.value;

  set selectedLinkList(value) => _selectedLinkList.value = value;

  // late PostType postType;
  TextEditingController titleController = TextEditingController();
  TextEditingController contentsController = TextEditingController();
  TextEditingController postTypeController = TextEditingController();

  /// 선택된 이미지 리스트
  final ImagePicker _picker = ImagePicker();
  final _selectedImageList = <XFile>[].obs;

  get selectedImageList => _selectedImageList.value;

  set selectedImageList(value) => _selectedImageList.value = value;

  CommunityAddController({required this.postRepository, required this.postImageRepository}) {
    assert(postRepository != null);

    titleController.addListener(_titleListener);
    contentsController.addListener(_contentsListener);
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

  void add() async {
    if (postType == PostType.none || postType == PostType.all) {
      Get.dialog(ErrorDialog("글 타입을 선택해주세요."));
      return;
    }

    if (titleController.text.isEmpty) {
      Get.dialog(ErrorDialog("제목을 입력해주세요."));
      return;
    }

    if (contentsController.text.isEmpty) {
      Get.dialog(ErrorDialog("내용을 입력해주세요."));
      return;
    }

    bool result = await Get.dialog(
      AlertDialog(
        // title: const Text('dialog title'),
        content: const Text(
          '등록 하시겠습니까?',
          style: TextStyle(fontSize: 15),
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
            child: const Text('등록', style: TextStyle(color: Colors.black, fontSize: 14)),
          ),
        ],
      ),
    );

    if (result) {
      await Get.find<CommunityListController>().getAllForPullToRefresh(postType);
      await Get.find<TabCommunityController>().changePosition(postType);
      Get.back();
      //   Get.snackbar('', '등록 되었습니다.',
      //       colorText: Colors.white,
      //       backgroundColor: Color(0xFF4B4B4B),
      //       snackPosition: SnackPosition.BOTTOM,
      //       margin: EdgeInsets.only(bottom: FetchPixels.getPixelHeight(20)));
    }
  }

  void requestAdd() async {
    var memberId = await PrefData.getMemberId();
    try {
      ModelPost post = await postRepository.add(
          modelPostRequest: ModelPostRequest(
              postType: postType,
              memberId: memberId!,
              title: titleController.text,
              contents: contentsController.text,
              postTag1: selectedTagList.length > 0 ? selectedTagList[0] : null,
              postTag2: selectedTagList.length > 1 ? selectedTagList[1] : null,
              postTag3: selectedTagList.length > 2 ? selectedTagList[2] : null,
              externalLink: selectedLinkList.length > 0 ? selectedLinkList[0] : null));

      bool result = await postImageRepository.addImage(postId: post.postId, selectedImageList: selectedImageList);

      Get.back(result: result);
    } on InvalidMemberException catch (e) {
      print(e);
      Get.toNamed(Routes.loginPath);
    } catch (e) {
      print(e);
      Get.toNamed(Routes.loginPath);
    }
  }

  Future<void> pickImage() async {
    List<XFile> imageList = await _picker.pickMultiImage(maxWidth: 720, maxHeight: 1440, imageQuality: 100);
    if (imageList != null && imageList.isNotEmpty) {
      selectedImageList.addAll(imageList);

      if (selectedImageList.length > 3) {
        Get.dialog(ErrorDialog("이미지는 최대 3장까지 등록 가능합니다."));
        selectedImageList = selectedImageList.sublist(0, 3);
      }

      refreshSelectedImageList();
    }
  }

  refreshSelectedImageList() {
    _selectedImageList.refresh();
  }

  refreshSelectedTagList() {
    _selectedTagList.refresh();
  }

  refreshSelectedLinkList() {
    _selectedLinkList.refresh();
  }

  @override
  void onInit() {
    super.onInit();
  }
}
