import 'package:baby_book/app/controller/TabCommunityController.dart';
import 'package:baby_book/app/models/model_book_response.dart';
import 'package:baby_book/app/models/model_post.dart';
import 'package:baby_book/app/models/model_post_file.dart';
import 'package:baby_book/app/models/model_post_request.dart';
import 'package:baby_book/app/repository/book_repository.dart';
import 'package:baby_book/app/repository/post_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../base/pref_data.dart';
import '../../base/resizer/fetch_pixels.dart';
import '../exception/exception_invalid_member.dart';
import '../repository/post_image_repository.dart';
import '../routes/app_pages.dart';
import '../view/community/post_type.dart';
import '../view/dialog/error_dialog.dart';
import 'CommunityListController.dart';

class CommunityAddController extends GetxController {
  final PostRepository postRepository;
  final PostImageRepository postImageRepository;
  final BookRepository bookRepository;

  //loading
  final _loading = true.obs;

  get loading => _loading.value;

  set loading(value) => _loading.value = value;

  ///right color
  final _canRegister = false.obs;

  get canRegister => _canRegister.value;

  set canRegister(value) => _canRegister.value = value;

  final _postType = PostType.all.obs;

  get postType => _postType.value;

  set postType(value) => _postType.value = value;

  ///선택된 책태그 리스트
  final _selectedBookTagList = <ModelBookResponse>[].obs;

  get selectedBookTagList => _selectedBookTagList.value;

  set selectedBookTagList(value) => _selectedBookTagList.value = value;

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

  ///이미지 - 파일 모델로 변경
  List<ModelPostFile> _modifyPostFileList = [];
  List<XFile> _networkImageList = [];

  /// 수정용 ID
  String? modifyPostId;

  ///modify mode 체크
  final _modifyMode = false.obs;

  get modifyMode => _modifyMode.value;

  set modifyMode(value) => _modifyMode.value = value;

  CommunityAddController({
    required this.postRepository,
    required this.postImageRepository,
    required this.bookRepository,
  }) {
    assert(postRepository != null);
    assert(postImageRepository != null);
    assert(bookRepository != null);

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
        content: Text(
          modifyMode ? '수정 하시겠습니까?' : '등록 하시겠습니까?',
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
            child: const Text('등록', style: TextStyle(color: Colors.black, fontSize: 14)),
          ),
        ],
      ),
    );

    if (result) {
      if (!modifyMode) {
        await Get.find<CommunityListController>().getAllForPullToRefresh(postType);
        await Get.find<TabCommunityController>().changePosition(postType);
      }
    }

    Get.back(result: result);
  }

  void requestAdd() async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);

    var memberId = await PrefData.getMemberId();
    try {
      ModelPostRequest request = ModelPostRequest(
          postType: postType,
          memberId: memberId!,
          title: titleController.text,
          contents: contentsController.text,
          // postTag1: selectedTagList.length > 0 ? selectedTagList[0] : null,
          // postTag2: selectedTagList.length > 1 ? selectedTagList[1] : null,
          // postTag3: selectedTagList.length > 2 ? selectedTagList[2] : null,
          bookIdTag1: selectedBookTagList.length > 0 ? selectedBookTagList[0].modelBook.id : null,
          bookIdTag2: selectedBookTagList.length > 1 ? selectedBookTagList[1].modelBook.id : null,
          bookIdTag3: selectedBookTagList.length > 2 ? selectedBookTagList[2].modelBook.id : null,
          externalLink: selectedLinkList.length > 0 ? selectedLinkList[0] : null);

      String selectedPostId = "";
      if (modifyMode) {
        bool result = await postRepository.put(postId: modifyPostId!, modelPostRequest: request);
        if (!result) {
          ///네트워크 에러
          EasyLoading.dismiss();
          return;
        }
        selectedPostId = modifyPostId!;
      } else {
        ModelPost? post = await postRepository.add(modelPostRequest: request);
        if (post == null) {
          ///네트워크 에러
          EasyLoading.dismiss();
          return;
        }
        selectedPostId = post.postId;
      }

      List<XFile> finalImageList = [];
      if (modifyMode) {
        List<String> removedFileIdList = findRemovedFileList();
        for (int i = 0; i < removedFileIdList.length; i++) {
          await postImageRepository.removeImage(postId: selectedPostId, fileId: removedFileIdList[i]);
        }

        finalImageList = findFinalImageList();
      } else {
        finalImageList = selectedImageList;
      }

      if (finalImageList != null && finalImageList.isNotEmpty) {
        bool result = await postImageRepository.addImage(postId: selectedPostId, selectedImageList: finalImageList);
        Get.back(result: result);
      } else {
        Get.back(result: true);
      }
      EasyLoading.dismiss();
    } on InvalidMemberException catch (e) {
      print(e);
      EasyLoading.dismiss();
      Get.toNamed(Routes.reAuthPath);
    } catch (e) {
      print(e);
      EasyLoading.dismiss();
      Get.dialog(ErrorDialog("네트워크 오류가 발생하였습니다.\n잠시 후 다시 시도해주세요.\n상세코드: $e"));
    }
  }

  ///[수정모드]에서 이미 존재하는 이미지가 있을경우엔 제외 시키기 위함
  List<XFile> findFinalImageList() {
    List<XFile> finalImageList = [];
    for (int i = 0; i < selectedImageList.length; i++) {
      XFile selectedImage = selectedImageList[i];
      bool isExist = false;

      for (int j = 0; j < _networkImageList.length; j++) {
        XFile networkImage = _networkImageList[j];
        if (selectedImage.name == networkImage.name) {
          isExist = true;
          break;
        }
      }

      if (!isExist) {
        finalImageList.add(selectedImage);
      }
    }

    return finalImageList;
  }

  ///[수정모드]에서 삭제된 이미지를 제거하기 위함
  List<String> findRemovedFileList() {
    List<String> removedImageList = [];
    for (int i = 0; i < _networkImageList.length; i++) {
      XFile networkImage = _networkImageList[i];
      bool isExist = false;

      for (int j = 0; j < selectedImageList.length; j++) {
        XFile selectedImage = selectedImageList[j];
        if (selectedImage.name == networkImage.name) {
          isExist = true;
          break;
        }
      }

      if (!isExist) {
        //제거 해야 할 이미지의 fileId를 저장
        removedImageList.add(_modifyPostFileList[i].postFileId);
      }
    }

    return removedImageList;
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

  refreshSelectedBookTagList() {
    _selectedBookTagList.refresh();
  }

  refreshSelectedLinkList() {
    _selectedLinkList.refresh();
  }

  ///[수정모드]] 진입
  initModifyMode(String postId) async {
    loading = true;

    modifyMode = true;
    modifyPostId = postId;

    ModelPost? post = await postRepository.get(postId: postId);

    ///네트워크에러
    if (post == null) {
      loading = false;
      return;
    }

    postType = post.postType;
    titleController.text = post.title;
    contentsController.text = post.contents;

    if (post.externalLink != null) {
      selectedLinkList.clear();
      selectedLinkList.add(post.externalLink);
    }
    // if (post.postTagList.isNotEmpty) {
    //   selectedTagList.clear();
    //   selectedTagList.addAll(post.postTagList);
    // }

    if (post.bookIdTagList.isNotEmpty) {
      selectedBookTagList.clear();
      for (int i = 0; i < post.bookIdTagList.length; i++) {
        selectedBookTagList.add(await bookRepository.get(bookSetId: post.bookIdTagList[i]));
      }
    }

    if (post.postFileList.isNotEmpty) {
      _modifyPostFileList = post.postFileList;
      selectedImageList.clear();
      _networkImageList.clear();
      for (int i = 0; i < post.postFileList.length; i++) {
        XFile originImage = await getImageXFileByUrl(post.postFileList[i].postFileUrl);
        selectedImageList.add(originImage);
        _networkImageList.add(originImage);
      }
    }

    Future.delayed(const Duration(milliseconds: 500), () {
      loading = false;
    });
  }

  Future<XFile> getImageXFileByUrl(String url) async {
    var file = await DefaultCacheManager().getSingleFile(url);
    XFile result = XFile(file.path);
    return result;
  }

  initBookTagList(List<ModelBookResponse> bookTagList) {
    selectedBookTagList.clear();
    selectedBookTagList.addAll(bookTagList);
    _selectedBookTagList.refresh();
  }
}
