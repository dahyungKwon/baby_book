import 'package:baby_book/app/repository/paging_request.dart';
import 'package:baby_book/app/repository/post_repository.dart';
import 'package:get/get.dart';

import '../../base/pref_data.dart';
import '../exception/exception_invalid_member.dart';
import '../models/model_post.dart';
import '../routes/app_pages.dart';
import '../view/community/post_type.dart';
import '../view/profile/member_post_type.dart';

class MemberCommunityListController extends GetxController {
  final PostRepository postRepository;
  String memberId;

  //map(로컬 캐시용)
  // Map<MemberPostType, List<ModelPost>> map = {};

  ///post
  final _postList = <ModelPost>[].obs;

  get postList => _postList.value;

  set postList(value) => _postList.value = value;

  //loading
  final _loading = false.obs;

  get loading => _loading.value;

  set loading(value) => _loading.value = value;

  MemberCommunityListController({required this.postRepository, required this.memberId}) {
    assert(postRepository != null);
  }

  @override
  void onInit() async {
    super.onInit();
    String? myMemberId = await PrefData.getMemberId();
    if (myMemberId == memberId) {
      getAllForInit(MemberPostType.bookmark);
    } else {
      getAllForInit(MemberPostType.writer_post);
    }
  }

  /// 첫 페이지 로딩 시 사용, 페이지 변경시에도 사용됨
  getAllForInit(MemberPostType memberPostType) async {
    /// 캐시처리, all일경우 제외
    // if (map.containsKey(memberPostType)) {
    //   _postList.clear();
    //   _postList.addAll(map[memberPostType]!);
    //   return;
    // }

    getAllForPullToRefresh(memberPostType);
  }

  ///pull to refresh 시 사용
  getAllForPullToRefresh(MemberPostType memberPostType) async {
    loading = true;
    List<ModelPost> list = await _request(memberPostType, PagingRequest.createDefault());

    ///리스트 초기화
    _initList(memberPostType, list);

    ///사용자경험 위해 0.2초 딜레이
    Future.delayed(const Duration(milliseconds: 200), () {
      loading = false;
    });
  }

  ///next page 요청 시 사용
  Future<List<ModelPost>> getAllForLoading(MemberPostType memberPostType, PagingRequest pagingRequest) async {
    List<ModelPost> list = await _request(memberPostType, pagingRequest);

    ///데이터 추가
    _addAll(memberPostType, list);
    return list;
  }

  Future<List<ModelPost>> _request(MemberPostType memberPostType, PagingRequest pagingRequest) async {
    /// no cache & 저장만함
    try {
      print("_request......${memberPostType.code}........${pagingRequest.pageNumber}");
      return await postRepository.getPostListByMemberPostType(
          memberId: memberId, memberPostType: memberPostType, pagingRequest: pagingRequest);
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

  void _initList(MemberPostType memberPostType, List<ModelPost> list) {
    // if (map.containsKey(memberPostType)) {
    //   map.remove(memberPostType);
    // }
    // map[memberPostType] = [];
    // map[memberPostType]!.addAll(list);

    _postList.clear();
    _postList.addAll(list);
  }

  void _addAll(MemberPostType memberPostType, List<ModelPost> list) {
    // 이미 map -> list가 맵핑된 상태임으로 list에만 넣어주면 됨
    // 참고로 map에 직접 넣던지 , postList = map[postType]; 이렇게 하면 obx동작 안하는 이슈가 있음
    // map[memberPostType]?.addAll(list);
    _postList.addAll(list);

    // _postList.refresh(); 이방법도 존재하나 obx사용을 위해 사용하지 않고 스터디를 위해 해당 코드 남겨둠
  }
}
