import 'package:baby_book/app/repository/paging_request.dart';
import 'package:baby_book/app/repository/post_repository.dart';
import 'package:get/get.dart';

import '../models/model_post.dart';
import '../view/community/post_type.dart';

class CommunityListController extends GetxController {
  final PostRepository postRepository;

  //map(로컬 캐시용)
  Map<PostType, List<ModelPost>> map = {};

  ///post
  final _postList = <ModelPost>[].obs;

  get postList => _postList.value;

  set postList(value) => _postList.value = value;

  //loading
  final _loading = true.obs;

  get loading => _loading.value;

  set loading(value) => _loading.value = value;

  CommunityListController({required this.postRepository}) {
    assert(postRepository != null);
  }

  @override
  void onInit() {
    super.onInit();
    getAllForInit(PostType.all);
  }

  /// 첫 페이지 로딩 시 사용, 페이지 변경시에도 사용됨
  getAllForInit(PostType postType) async {
    /// 캐시처리, all일경우 제외
    if (map.containsKey(postType) && postType != PostType.all) {
      _postList.clear();
      _postList.addAll(map[postType]!);
      return;
    }

    getAllForPullToRefresh(postType);
  }

  ///pull to refresh 시 사용
  getAllForPullToRefresh(PostType postType) async {
    loading = true;
    List<ModelPost> list = await _request(postType, PagingRequest.createDefault());

    ///리스트 초기화
    _initList(postType, list);

    ///사용자경험 위해 0.2초 딜레이
    Future.delayed(const Duration(milliseconds: 500), () {
      loading = false;
    });
  }

  ///next page 요청 시 사용
  Future<List<ModelPost>> getAllForLoading(PostType postType, PagingRequest pagingRequest) async {
    List<ModelPost> list = await _request(postType, pagingRequest);

    ///데이터 추가
    _addAll(postType, list);
    return list;
  }

  Future<List<ModelPost>> _request(PostType postType, PagingRequest pagingRequest) async {
    /// no cache & 저장만함
    print("_request......${postType.code}........${pagingRequest.pageNumber}");
    return await postRepository.getPostList(postType: postType, pagingRequest: pagingRequest);
  }

  void _initList(PostType postType, List<ModelPost> list) {
    if (postType != PostType.all) {
      if (map.containsKey(postType)) {
        map.remove(postType);
      }
      map[postType] = [];
      map[postType]!.addAll(list);
    }

    _postList.clear();
    _postList.addAll(list);
  }

  void _addAll(PostType postType, List<ModelPost> list) {
    // 이미 map -> list가 맵핑된 상태임으로 list에만 넣어주면 됨
    // 참고로 map에 직접 넣던지 , postList = map[postType]; 이렇게 하면 obx동작 안하는 이슈가 있음
    map[postType]?.addAll(list);
    _postList.addAll(list);

    // _postList.refresh(); 이방법도 존재하나 obx사용을 위해 사용하지 않고 스터디를 위해 해당 코드 남겨둠
  }

  updateLike(PostType postType, String postId, bool liked, int likeCount) {
    ModelPost? targetInMap = findModelPost(map[postType], postId);
    if (targetInMap != null) {
      targetInMap.liked = liked;
      targetInMap.likeCount = likeCount;
    }

    ModelPost? targetInList = findModelPost(_postList, postId);
    if (targetInList != null) {
      targetInList.liked = liked;
      targetInList.likeCount = likeCount;
      _postList.refresh();
    }
  }

  ModelPost? findModelPost(List<ModelPost>? list, String targetPostId) {
    if (list == null) {
      return null;
    }

    for (int i = 0; i < list.length; i++) {
      if (list[i].postId == targetPostId) {
        return list[i];
      }
    }

    return null;
  }
}
