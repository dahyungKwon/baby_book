import 'package:baby_book/app/models/model_post_tag.dart';
import 'package:baby_book/app/repository/paging_request.dart';
import 'package:baby_book/app/repository/post_repository.dart';
import 'package:get/get.dart';

import '../exception/exception_invalid_member.dart';
import '../models/model_post.dart';
import '../routes/app_pages.dart';

class BookCommunityListController extends GetxController {
  final PostRepository postRepository;
  int bookId;

  ///post
  final _postList = <ModelPost>[].obs;

  get postList => _postList.value;

  set postList(value) => _postList.value = value;

  //loading
  final _loading = false.obs;

  get loading => _loading.value;

  set loading(value) => _loading.value = value;

  BookCommunityListController({required this.postRepository, required this.bookId}) {
    assert(postRepository != null);
  }

  @override
  void onInit() async {
    super.onInit();
    getAllForInit();
  }

  /// 첫 페이지 로딩 시 사용, 페이지 변경시에도 사용됨
  getAllForInit() async {
    getAllForPullToRefresh();
  }

  ///pull to refresh 시 사용
  getAllForPullToRefresh() async {
    loading = true;
    List<ModelPost> list = await _request(PagingRequest.createDefault());

    ///리스트 초기화
    _initList(list);

    ///사용자경험 위해 0.2초 딜레이
    Future.delayed(const Duration(milliseconds: 500), () {
      loading = false;
    });
  }

  ///next page 요청 시 사용
  Future<List<ModelPost>> getAllForLoading(PagingRequest pagingRequest) async {
    List<ModelPost> list = await _request(pagingRequest);

    ///데이터 추가
    _addAll(list);
    return list;
  }

  Future<List<ModelPost>> _request(PagingRequest pagingRequest) async {
    /// no cache & 저장만함
    try {
      ModelPostTag postTag = await postRepository.getPostBookTag(bookId: bookId, pagingRequest: pagingRequest);
      return postTag.postList;
    } on InvalidMemberException catch (e) {
      print(e);
      loading = false;
      Get.toNamed(Routes.loginPath);
    } catch (e) {
      print(e);
      loading = false;
      Get.toNamed(Routes.loginPath);
    }

    return [];
  }

  void _initList(List<ModelPost> list) {
    _postList.clear();
    _postList.addAll(list);
  }

  void _addAll(List<ModelPost> list) {
    _postList.addAll(list);
  }
}
