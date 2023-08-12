import 'dart:io';

import 'package:baby_book/app/controller/CommunityAddController.dart';
import 'package:baby_book/app/models/model_post.dart';
import 'package:baby_book/app/repository/book_repository.dart';
import 'package:baby_book/app/view/community/post_type.dart';
import 'package:baby_book/app/view/community/post_type_bottom_sheet.dart';
import 'package:baby_book/app/view/dialog/link_dialog.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import '../../../base/color_data.dart';
import '../../../base/skeleton.dart';
import '../../../base/widget_utils.dart';
import '../../models/model_book_response.dart';
import '../../repository/post_image_repository.dart';
import '../../repository/post_repository.dart';
import '../dialog/tag_dialog.dart';

/// 예상외에 동작을 한다면, TabCommunity#pageViewer쪽을 살펴보기!!
class CommunityAddScreen extends GetView<CommunityAddController> {
  List<String> helpToolList = ["images_outline.svg", "tag_outline.svg", "link_outline.svg"];
  FocusNode titleFocusNode = FocusNode();
  FocusNode contentsFocusNode = FocusNode();

  CommunityAddScreen({super.key}) {
    Get.delete<CommunityAddController>();
    Get.put(CommunityAddController(
        postRepository: PostRepository(),
        postImageRepository: PostImageRepository(),
        bookRepository: BookRepository()));
    String? postId = Get.parameters['postId'];
    if (postId != null) {
      controller.initModifyMode(postId!);
    } else {
      PostType postType = PostType.findByCode(Get.parameters['postType'] ?? PostType.none.code);
      if (postType == PostType.all) {
        postType = PostType.none;
      }
      controller.postType = postType;
      controller.titleController.text = "";
      controller.contentsController.text = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets edgeInsets = EdgeInsets.symmetric(
      horizontal: FetchPixels.getDefaultHorSpace(context),
    );

    FetchPixels(context);
    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: backGroundColor,
          bottomNavigationBar: buildBottom(context),
          body: SafeArea(
              child: Obx(
            () => Container(
              color: Colors.white,
              // padding: EdgeInsets.symmetric(horizontal: FetchPixels.getDefaultHorSpace(context)),
              child: controller.loading
                  ? const FullSizeSkeleton()
                  : Column(
                      children: [buildToolbar(context), buildExpand(context)],
                    ),
            ),
          )),
        ),
        onWillPop: () async {
          Get.back();
          return false;
        });
  }

  Expanded buildExpand(BuildContext context) {
    return Expanded(
        flex: 1,
        child: ListView(physics: const BouncingScrollPhysics(), shrinkWrap: true, primary: true, children: [
          getDefaultTextFiledWithLabel2(
              context,
              controller.postType.desc,
              controller.postType.color,
              controller.postTypeController,
              Colors.black87,
              FetchPixels.getPixelHeight(16),
              boxColor: backGroundColor,
              controller.postType == PostType.none ? FontWeight.w400 : FontWeight.w600, function: () {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => PostTypeBottomSheet(postType: controller.postType!)).then((selectedPostType) {
              if (selectedPostType != null) {
                controller.postType = selectedPostType;
              }
            });
          },
              isEnable: false,
              withprefix: false,
              minLines: true,
              height: FetchPixels.getPixelHeight(50),
              withSufix: true,
              suffiximage: "down_arrow.svg",
              enableEditing: false),
          getVerSpace(FetchPixels.getPixelHeight(0)),
          getDefaultTextFiledWithLabel2(context, "제목을 입력해주세요.", Colors.black45.withOpacity(0.3),
              controller.titleController, Colors.grey, FetchPixels.getPixelHeight(22), FontWeight.w500,
              function: () {},
              isEnable: false,
              withprefix: false,
              minLines: true,
              height: FetchPixels.getPixelHeight(50),
              alignmentGeometry: Alignment.center,
              boxColor: backGroundColor,
              myFocusNode: titleFocusNode),
          getVerSpace(FetchPixels.getPixelHeight(0)),
          getDefaultTextFiledWithLabel2(context, "내용을 입력해주세요.", Colors.black45.withOpacity(0.3),
              controller.contentsController, Colors.grey, FetchPixels.getPixelHeight(16), FontWeight.w400,
              function: () {},
              isEnable: false,
              withprefix: false,
              minLines: true,
              height: FetchPixels.getPixelHeight(400),
              alignmentGeometry: Alignment.topLeft,
              boxColor: backGroundColor,
              myFocusNode: contentsFocusNode),
          getVerSpace(FetchPixels.getPixelHeight(20)),
          selectedLinkList(),
          getVerSpace(FetchPixels.getPixelHeight(20)),
          selectedTagList(),
          getVerSpace(FetchPixels.getPixelHeight(20)),
          selectedImageList(),
          // getVerSpace(FetchPixels.getPixelHeight(10)),
        ]));
  }

  Container buildToolbar(BuildContext context) {
    return Container(
        color: backGroundColor,
        child: Column(children: [
          getToolbarMenuWithoutImg(
              context,
              "취소",
              Colors.black54,
              () {
                Get.back();
              },
              istext: false,
              isRight: true,
              weight: FontWeight.w500,
              fontsize: 18,
              rightText: controller.modifyMode ? "수정" : "등록",
              rightTextColor: controller.canRegister ? secondMainColor : Colors.grey.shade400,
              rightFunction: () async {
                controller.add();
              }),
          // getVerSpace(FetchPixels.getPixelHeight(10))
        ]));
  }

  GestureDetector selectedTagList() {
    return GestureDetector(
        onTap: () {
          if (controller.selectedBookTagList.length > 0) {
            openBookTagDialog();
          }
        },
        child: Wrap(
            direction: Axis.horizontal,
            // 정렬 방향
            alignment: WrapAlignment.start,
            // 정렬 방식
            spacing: 1,
            // 상하(좌우) 공간
            runSpacing: 5,
            // 좌우(상하) 공간
            children: controller.selectedBookTagList
                .map<Widget>((e) => Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFF5F6F8),
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
                    child: Text("#${e.modelBook.name}", style: TextStyle(fontSize: 15, color: Colors.blueAccent))))
                .toList()));
  }

  SizedBox selectedImageList() {
    return SizedBox(
      child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          // scrollDirection: Axis.horizontal,
          padding: EdgeInsets.zero,
          itemCount: controller.selectedImageList.length,
          itemBuilder: (context, index) {
            XFile image = controller.selectedImageList[index];
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
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0), child: Image.file(File(image.path), fit: BoxFit.cover)),
              ),
              getVerSpace(FetchPixels.getPixelHeight(5)),
              Positioned(
                  top: 15,
                  right: 15,
                  child: GestureDetector(
                    onTap: () {
                      Get.dialog(AlertDialog(
                        // title: const Text('dialog title'),
                        content: const Text(
                          '이미지를 삭제하시겠습니까?',
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
                            onPressed: () {
                              controller.selectedImageList.removeAt(index);
                              controller.refreshSelectedImageList();
                              Get.back();
                            },
                            child: const Text('삭제', style: TextStyle(color: Colors.black, fontSize: 14)),
                          ),
                        ],
                      ));
                    },
                    child: const Icon(
                      Icons.cancel_rounded,
                      color: Colors.black87,
                    ),
                  )),
            ]);
          }),
    );
  }

  GestureDetector selectedLinkList() {
    return GestureDetector(
      onTap: () {
        if (controller.selectedLinkList.length > 0) {
          Get.dialog(LinkDialog(controller.selectedLinkList));
        }
      },
      child: SizedBox(
          child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              // scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              itemCount: controller.selectedLinkList.length,
              itemBuilder: (context, index) {
                String link = controller.selectedLinkList[index];
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
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
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

  Container buildBottom(BuildContext context) {
    double size = FetchPixels.getPixelHeight(50);
    double iconSize = FetchPixels.getPixelHeight(26);

    return Container(
        height: FetchPixels.getPixelHeight(55),
        // color: Colors.white,
        decoration: const BoxDecoration(
            color: Colors.white, border: Border(top: BorderSide(color: Color(0xffd3d3d3), width: 0.8))),
        child: Row(
            children: List.generate(helpToolList.length, (selectedTabIndex) {
          return Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                if (selectedTabIndex == 0) {
                  controller.pickImage();
                } else if (selectedTabIndex == 1) {
                  openBookTagDialog();
                } else if (selectedTabIndex == 2) {
                  Get.dialog(LinkDialog(controller.selectedLinkList));
                } else {
                  print("정의되지 않은 tab select $selectedTabIndex");
                }
              },
              child: Center(
                child: Container(
                  width: size,
                  height: size,
                  child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          getSvgImage(helpToolList[selectedTabIndex], width: iconSize, height: iconSize),
                          getVerSpace(FetchPixels.getPixelHeight(2)),
                        ]),
                  ),
                ),
              ),
            ),
          );
        })));
  }

  openBookTagDialog() async {
    List<ModelBookResponse> bookTagList = await Get.dialog(TagDialog(controller.selectedBookTagList));
    controller.initBookTagList(bookTagList);
  }
}
