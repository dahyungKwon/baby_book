import 'package:baby_book/app/controller/BookMemberListController.dart';
import 'package:baby_book/app/repository/my_book_repository.dart';
import 'package:baby_book/app/repository/paging_request.dart';
import 'package:baby_book/base/skeleton.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../base/uuid_util.dart';
import '../../../models/model_my_book_member_body.dart';
import '../../../routes/app_pages.dart';
import '../../login/gender_type.dart';

class BookMemberListScreen extends GetView<BookMemberListController> {
  late final int? bookId;
  late final String? uniqueTag;

  late RefreshController refreshController;
  int pageNumber = 1;

  BookMemberListScreen(this.bookId, {super.key}) {
    uniqueTag = getUuid();

    Get.put(BookMemberListController(myBookRepository: MyBookRepository(), bookId: bookId!), tag: uniqueTag);
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
    List<ModelMyBookMemberBody>? list = await controller.getAllForLoading(PagingRequest.create(pageNumber + 1));
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
              : controller.memberList.isEmpty
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
          itemCount: controller.memberList.length,
          itemBuilder: (context, index) {
            ModelMyBookMemberBody member = controller.memberList[index];
            return buildMemberItem(member, context, index, () {
              Get.toNamed(Routes.profilePath, parameters: {'memberId': member.memberId});
            });
          },
        ));
  }

  GestureDetector buildMemberItem(
    ModelMyBookMemberBody member,
    BuildContext context,
    int index,
    Function clickFunction,
  ) {
    return GestureDetector(
      onTap: () {
        clickFunction();
      },
      child: Container(
        height: FetchPixels.getPixelHeight(80),
        margin: EdgeInsets.only(bottom: FetchPixels.getPixelHeight(1)),
        padding:
            EdgeInsets.symmetric(vertical: FetchPixels.getPixelHeight(12), horizontal: FetchPixels.getPixelWidth(15)),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Color(0xFFEDEBE8), blurRadius: 3, offset: Offset(0.0, 1.0)),
            ],
            borderRadius: BorderRadius.zero),
        child: Column(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Row(children: [
                    getHorSpace(FetchPixels.getPixelWidth(10)),
                    getAssetImage(member.gender == GenderType.man ? "man_bear3.png" : "woman_bear3.png",
                        FetchPixels.getPixelWidth(50), FetchPixels.getPixelWidth(50)),
                    getHorSpace(FetchPixels.getPixelWidth(15)),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: getHorSpace(0),
                          ),
                          Row(children: [
                            Expanded(
                                child: getCustomFont(member.nickName ?? "", 16, Colors.black, 1,
                                    fontWeight: FontWeight.w500)),
                            Expanded(
                              flex: 1,
                              child: getHorSpace(0),
                            ),
                          ]),
                          getVerSpace(FetchPixels.getPixelHeight(5)),
                          getCustomFont(
                            member.getBirthdayToString(),
                            13,
                            Colors.black38,
                            1,
                            fontWeight: FontWeight.w400,
                          ),
                          getVerSpace(FetchPixels.getPixelHeight(5)),
                          // getCustomFont(
                          //   modelBaby.getBirthdayToString(),
                          //   12,
                          //   Colors.black38,
                          //   1,
                          //   fontWeight: FontWeight.w400,
                          // ),
                          Expanded(
                            flex: 1,
                            child: getHorSpace(0),
                          ),
                        ],
                      ),
                    ),
                  ])),
                  getSvgImage("arrow_right.svg",
                      width: FetchPixels.getPixelHeight(20), height: FetchPixels.getPixelHeight(20))
                  // getSimpleTextButton(
                  //     "수정",
                  //     14,
                  //     Colors.black54,
                  //     modelBaby.babyId == representBabyId ? Colors.grey.shade100 : Colors.white,
                  //     FontWeight.w400,
                  //     FetchPixels.getPixelWidth(50),
                  //     FetchPixels.getPixelHeight(30), () {
                  //   openModifyBabyDialogFunction(index);
                  // }),
                  // getSimpleTextButton(
                  //     "삭제",
                  //     14,
                  //     Colors.black54,
                  //     modelBaby.babyId == representBabyId ? Colors.grey.shade100 : Colors.white,
                  //     FontWeight.w400,
                  //     FetchPixels.getPixelWidth(50),
                  //     FetchPixels.getPixelHeight(30), () {
                  //   deleteFunction(index);
                  // }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column nullListView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // getSvgImage("clipboard.svg", height: FetchPixels.getPixelHeight(124), width: FetchPixels.getPixelHeight(124)),
        // getVerSpace(FetchPixels.getPixelHeight(40)),
        getCustomFont("읽고 있는 사람이 없습니다.", 20, Colors.black, 1, fontWeight: FontWeight.w600),
        getVerSpace(FetchPixels.getPixelHeight(10)),
        getCustomFont(
          "책을 읽고 있으면 책장에 담아주세요.",
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
