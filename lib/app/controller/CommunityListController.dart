import 'package:baby_book/app/repository/post_repository.dart';
import 'package:get/get.dart';

import '../exception/exception_invalid_member.dart';
import '../models/model_post.dart';
import '../routes/app_pages.dart';
import '../view/community/post_type.dart';

class CommunityListController extends GetxController {
  final PostRepository postRepository;

  Map<PostType, List<ModelPost>> map = Map();

  /// post
  final _postList = <ModelPost>[].obs;

  get postList => _postList.value;

  set postList(value) => _postList.value = value;

  //loading
  final _loading = false.obs;

  get loading => _loading.value;

  set loading(value) => _loading.value = value;

  CommunityListController({required this.postRepository}) {
    assert(postRepository != null);
  }

  @override
  void onInit() {
    super.onInit();
    getAll(PostType.all);
  }

  getAll(PostType postType) async {
    /// 캐시처리, all일경우 제외
    if (map.containsKey(postType) && postType != PostType.all) {
      postList = map[postType];
      return;
    }

    getAllForPullToRefresh(postType);
  }

  getAllForPullToRefresh(PostType postType) async {
    /// no cache & 저장만함
    loading = true;
    await postRepository.getPostList(postTypeRequest: postType.code).then((data) {
      map[postType] = data;
      postList = data;

      ///사용자경험 위해 0.2초 딜레이
      Future.delayed(const Duration(milliseconds: 200), () {
        loading = false;
      });
    },
        onError: (e) => {
              e is InvalidMemberException ? {loading = false, Get.toNamed(Routes.loginPath)} : e
            }).catchError((onError) => {print(onError + "error"), loading = false, Get.toNamed(Routes.loginPath)});
  }
}
