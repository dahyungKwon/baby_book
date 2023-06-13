import 'package:baby_book/app/models/model_post.dart';
import 'package:baby_book/app/view/community/post_type.dart';
import 'package:baby_book/base/skeleton.dart';
import 'package:baby_book/base/color_data.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../controller/CommunityListController.dart';
import '../../repository/post_repository.dart';

class CommunityListScreen extends GetView<CommunityListController> {
  CommunityListScreen(PostType postType, {super.key}) {
    Get.put(CommunityListController(postRepository: PostRepository()));
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets edgeInsets = EdgeInsets.symmetric(
      horizontal: FetchPixels.getDefaultHorSpace(context),
    );

    return Obx(() => Container(
          color: backGroundColor,
          child: controller.loading
              ? const ListSkeleton()
              : controller.postList.isEmpty
                  ? getPaddingWidget(edgeInsets, nullListView(context))
                  : drawPostList(),
        ));
  }

  ListView drawPostList() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: controller.postList.length,
      itemBuilder: (context, index) {
        ModelPost modelPost = controller.postList[index];
        return buildPostListItem(modelPost, context, index, () {
          //click function
        }, () {
          //delete function
        });
      },
    );
  }

  Column nullListView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // getSvgImage("clipboard.svg", height: FetchPixels.getPixelHeight(124), width: FetchPixels.getPixelHeight(124)),
        // getVerSpace(FetchPixels.getPixelHeight(40)),
        getCustomFont("첫번째 글을 등록해주세요.", 20, Colors.black, 1, fontWeight: FontWeight.w600),
        getVerSpace(FetchPixels.getPixelHeight(10)),
        getCustomFont(
          "여러분의 소중한 경험을 공유해주세요.",
          16,
          Colors.black,
          1,
          fontWeight: FontWeight.w400,
        ),
        getVerSpace(FetchPixels.getPixelHeight(30)),
        getButton(context, backGroundColor, "글쓰러가기", blueColor, () {}, 18,
            weight: FontWeight.w600,
            buttonHeight: FetchPixels.getPixelHeight(60),
            insetsGeometry: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(120)),
            borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(14)),
            isBorder: true,
            borderColor: blueColor,
            borderWidth: 1.5)
      ],
    );
  }
}
