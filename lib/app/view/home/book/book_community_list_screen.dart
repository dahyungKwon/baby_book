import 'package:baby_book/app/models/model_post.dart';
import 'package:baby_book/app/repository/paging_request.dart';
import 'package:baby_book/base/skeleton.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../base/uuid_util.dart';
import '../../../controller/BookCommunityListController.dart';
import '../../../repository/post_repository.dart';
import '../../../routes/app_pages.dart';

/// 예상외에 동작을 한다면, TabCommunity#pageViewer쪽을 살펴보기!!
class BookCommunityListScreen extends GetView<BookCommunityListController> {
  late final int? bookId;
  late final String? uniqueTag;

  late RefreshController refreshController;
  int pageNumber = 1;

  BookCommunityListScreen(this.bookId, {super.key}) {
    uniqueTag = getUuid();

    Get.put(BookCommunityListController(postRepository: PostRepository(), bookId: bookId!), tag: uniqueTag);
    refreshController = RefreshController(initialRefresh: false);
  }

  @override
  String? get tag => uniqueTag;

  void initPageNumber() {
    ///캐시된게 있으면 맨 마지막 number를 넣어야함
    // if (controller.map.containsKey(memberPostType)) {
    //   // 1 12345 -1 01234 /5 = 0 +1 => 1
    //   // 2 678910 -1 56789 / 5 = 1 +1 => 2
    //   pageNumber = (controller.map[memberPostType]!.length - 1) ~/ PagingRequest.defaultPageSize + 1;
    // } else {
    //   pageNumber = 1;
    // }

    pageNumber = 1;
  }

  void plusPageNumber() {
    pageNumber++;
  }

  void onRefresh() async {
    await controller.getAllForPullToRefresh();
    initPageNumber(); //순서중요

    await Future.delayed(Duration(milliseconds: 500));

    refreshController.refreshCompleted();
  }

  void onLoading() async {
    List<ModelPost>? list = await controller.getAllForLoading(PagingRequest.create(pageNumber + 1));
    if (list != null && list.isNotEmpty) {
      plusPageNumber();
    }

    await Future.delayed(Duration(milliseconds: 500));
    refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets edgeInsets = EdgeInsets.symmetric(
      horizontal: FetchPixels.getDefaultHorSpace(context),
    );

    return Obx(() => Container(
          color: Color(0xFFF5F6F8),
          child: controller.loading
              ? const ListSkeleton()
              : controller.postList.isEmpty
                  ? getPaddingWidget(edgeInsets, nullListView(context))
                  : draw(),
        ));
  }

  SmartRefresher draw() {
    return SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: const MaterialClassicHeader(
          color: Colors.black,
        ),
        footer: const ClassicFooter(
            loadStyle: LoadStyle.ShowWhenLoading,
            loadingText: "Loading...",
            idleText: "Loading...",
            canLoadingText: "Loading..."),
        controller: refreshController,
        onRefresh: onRefresh,
        onLoading: onLoading,
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: controller.postList.length,
          itemBuilder: (context, index) {
            ModelPost modelPost = controller.postList[index];
            return buildPostListItem(modelPost, context, index, () {
              Get.toNamed("${Routes.communityDetailPath}", parameters: {'postId': modelPost.postId!, 'tag': 'profile'});
            }, () {
              //delete function
            });
          },
        ));
  }

  Column nullListView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // getSvgImage("clipboard.svg", height: FetchPixels.getPixelHeight(124), width: FetchPixels.getPixelHeight(124)),
        // getVerSpace(FetchPixels.getPixelHeight(40)),
        getCustomFont("글이 없습니다.", 20, Colors.black, 1, fontWeight: FontWeight.w600),
        getVerSpace(FetchPixels.getPixelHeight(10)),
        getCustomFont(
          "관련된 커뮤니티 글이 없습니다.",
          16,
          Colors.black45,
          1,
          fontWeight: FontWeight.w400,
        ),
        getVerSpace(FetchPixels.getPixelHeight(30)),
        //   getButton(context, backGroundColor, "글쓰러가기", Colors.black87, () {
        //     Get.toNamed("${Routes.communityAddPath}?postType=${memberPostType.code}");
        //   }, 18,
        //       weight: FontWeight.w600,
        //       buttonHeight: FetchPixels.getPixelHeight(60),
        //       insetsGeometry: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(120)),
        //       borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(14)),
        //       isBorder: true,
        //       borderColor: Colors.grey,
        //       borderWidth: 1.5)
      ],
    );
  }
}
