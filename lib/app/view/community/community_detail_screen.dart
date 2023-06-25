import 'package:baby_book/app/models/model_post.dart';
import 'package:baby_book/app/models/model_post_file.dart';
import 'package:baby_book/base/skeleton.dart';
import 'package:baby_book/base/color_data.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../controller/CommunityDetailController.dart';
import '../../repository/post_repository.dart';
import '../../routes/app_pages.dart';

class CommunityDetailScreen extends GetView<CommunityDetailController> {
  CommunityDetailScreen({super.key}) {
    Get.delete<CommunityDetailController>();
    Get.put(CommunityDetailController(postRepository: PostRepository(), postId: Get.parameters['postId']!));
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets edgeInsets = EdgeInsets.symmetric(
      horizontal: FetchPixels.getDefaultHorSpace(context),
    );
    FetchPixels(context);
    return WillPopScope(
        onWillPop: () async {
          Get.back();
          return false;
        },
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.white,
            body: SafeArea(
                child: Obx(() => Container(
                    child: controller.loading
                        ? const ListSkeleton()
                        : Column(children: [top(context), body(context, controller.post)]))))));
  }

  Widget top(BuildContext context) {
    return Container(
        margin: const EdgeInsets.fromLTRB(5, 10, 5, 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            getSimpleButton("back_outline.svg", () {
              Get.back();
            }),
            Row(children: [
              getSimpleButton("notification.svg", () {
                Get.toNamed(Routes.notificationPath);
              }),
              getHorSpace(FetchPixels.getPixelHeight(5)),
              getSimpleButton("bookmark_unchecked.svg", () {}),
              getHorSpace(FetchPixels.getPixelHeight(5)),
              getSimpleButton("ellipsis_horizontal_outline.svg", () {}),
              getHorSpace(FetchPixels.getPixelHeight(5)),
            ])
          ],
        ));
  }

  Widget body(BuildContext context, ModelPost modelPost) {
    return Expanded(
      flex: 1,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        primary: true,
        children: [
          post(context, modelPost),
          Container(height: FetchPixels.getPixelHeight(25), color: backGroundColor),
          comment(context),
        ],
      ),
    );
  }

  Widget post(BuildContext context, ModelPost modelPost) {
    return Container(
        // height: 50.h,
        // margin: EdgeInsets.only(bottom: FetchPixels.getPixelHeight(15)),
        padding:
            EdgeInsets.symmetric(vertical: FetchPixels.getPixelHeight(0), horizontal: FetchPixels.getPixelWidth(20)),
        decoration: const BoxDecoration(
            color: Colors.white, border: Border(bottom: BorderSide(color: Color(0xfff1f1f1), width: 0.8))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(children: [
              getCustomFont(modelPost.postType.desc ?? "", 14, modelPost.postType.color, 1,
                  fontWeight: FontWeight.w500),
              // getVerSpace(FetchPixels.getPixelHeight(6)),
              getCustomFont(" · ${modelPost.nickName} · ${modelPost.timeDiffForUi}" ?? "", 13, Colors.black45, 1,
                  fontWeight: FontWeight.w500)
            ]),
            getVerSpace(FetchPixels.getPixelHeight(20)),
            getCustomFont(modelPost.title ?? "", 24, Colors.black, 3, fontWeight: FontWeight.w600),
            getVerSpace(FetchPixels.getPixelHeight(8)),
            getCustomFont(modelPost.contents ?? "", 17, Colors.black87, 10000,
                fontWeight: FontWeight.w400, txtHeight: 1.5),
            getVerSpace(FetchPixels.getPixelHeight(20)),
            selectedLinkList(modelPost),
            getVerSpace(FetchPixels.getPixelHeight(20)),
            selectedTagList(modelPost),
            getVerSpace(FetchPixels.getPixelHeight(20)),
            selectedImageList(modelPost),
            getVerSpace(FetchPixels.getPixelHeight(30)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, //Center Row contents horizontally,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    getSvgImage("heart.svg",
                        height: FetchPixels.getPixelHeight(25), width: FetchPixels.getPixelHeight(25)),
                    getHorSpace(FetchPixels.getPixelWidth(6)),
                    getCustomFont(numberFormat.format(modelPost.likeCount), 16, Colors.black87, 1,
                        fontWeight: FontWeight.w400),
                    getHorSpace(FetchPixels.getPixelHeight(30))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    getSvgImage("chatbox_ellipses_outline.svg",
                        height: FetchPixels.getPixelHeight(25), width: FetchPixels.getPixelHeight(25)),
                    getHorSpace(FetchPixels.getPixelWidth(6)),
                    getCustomFont(numberFormat.format(modelPost.commentCount), 16, Colors.black87, 1,
                        fontWeight: FontWeight.w400),
                    getHorSpace(FetchPixels.getPixelHeight(30))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    getSvgImage("eye_outline.svg",
                        height: FetchPixels.getPixelHeight(25), width: FetchPixels.getPixelHeight(25)),
                    getHorSpace(FetchPixels.getPixelWidth(6)),
                    getCustomFont(numberFormat.format(modelPost.viewCount), 16, Colors.black87, 1,
                        fontWeight: FontWeight.w400),
                    getHorSpace(FetchPixels.getPixelHeight(30))
                  ],
                ),
              ],
            ),
            getVerSpace(FetchPixels.getPixelHeight(30)),
          ],
        ));
  }

  GestureDetector selectedLinkList(ModelPost post) {
    return GestureDetector(
      onTap: () {
        if (post.existExternalLink()) {
          print("post externalLink:${post.externalLink}");
        }
      },
      child: SizedBox(
          child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              // scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              itemCount: post.existExternalLink() ? 1 : 0,
              itemBuilder: (context, index) {
                String link = post.externalLink!;
                return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // getVerSpace(FetchPixels.getPixelHeight(10)),
                      Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFFF5F6F8),
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                        ),
                        // margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
                        child: Text(link, style: TextStyle(fontSize: 13, color: Colors.blueAccent)),
                        // getVerSpace(FetchPixels.getPixelHeight(10)),
                        // getSvgImage("close_outline.svg", width: 15, height: 15),
                      ),
                      getVerSpace(FetchPixels.getPixelHeight(5))
                    ]);
              })),
    );
  }

  Wrap selectedTagList(ModelPost modelPost) {
    return Wrap(
        direction: Axis.horizontal,
        // 정렬 방향
        alignment: WrapAlignment.start,
        // 정렬 방식
        spacing: 1,
        // 상하(좌우) 공간
        runSpacing: 5,
        // 좌우(상하) 공간
        children: modelPost.postTagList
            .map<Widget>((e) => GestureDetector(
                onTap: () {
                  print("click tag $e");
                },
                child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFF5F6F8),
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
                    child: Text("#$e", style: TextStyle(fontSize: 15, color: Colors.blueAccent)))))
            .toList());
  }

  SizedBox selectedImageList(ModelPost post) {
    return SizedBox(
      child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          // scrollDirection: Axis.horizontal,
          padding: EdgeInsets.zero,
          itemCount: post.postFileList?.length,
          itemBuilder: (context, index) {
            ModelPostFile image = post.postFileList[index];
            return Stack(children: [
              // getVerSpace(FetchPixels.getPixelHeight(10)),
              Container(
                constraints: BoxConstraints(
                  minHeight: 100, //minimum height
                  minWidth: 100.w, // minimum width

                  maxHeight: 800,
                  //maximum height set to 100% of vertical height

                  maxWidth: 100.w,
                  //maximum width set to 100% of width
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F6F8),
                  borderRadius: BorderRadius.all(
                    Radius.circular(15.0),
                  ),
                ),
                // margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(image.postFileUrl, fit: BoxFit.cover)),
              ),
              getVerSpace(FetchPixels.getPixelHeight(5)),
            ]);
          }),
    );
  }

  Widget comment(BuildContext context) {
    return Text("코멘트");
  }
}
