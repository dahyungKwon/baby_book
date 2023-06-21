import 'package:baby_book/app/controller/CommunityAddController.dart';
import 'package:baby_book/app/view/community/post_type.dart';
import 'package:baby_book/app/view/community/post_type_bottom_sheet.dart';
import 'package:baby_book/app/view/dialog/confirm_dialog.dart';
import 'package:baby_book/app/view/dialog/error_dialog.dart';
import 'package:baby_book/app/view/dialog/link_dialog.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../base/color_data.dart';
import '../../../base/widget_utils.dart';
import '../../exception/exception_invalid_member.dart';
import '../../exception/exception_invalid_param.dart';
import '../../models/model_post.dart';
import '../../repository/post_repository.dart';
import '../../routes/app_pages.dart';
import '../dialog/tag_dialog.dart';

/// 예상외에 동작을 한다면, TabCommunity#pageViewer쪽을 살펴보기!!
class CommunityAddScreen extends GetView<CommunityAddController> {
  List<String> helpToolList = ["images_outline.svg", "tag_outline.svg", "link_outline.svg"];

  CommunityAddScreen({super.key}) {
    Get.delete<CommunityAddController>();
    Get.put(CommunityAddController(postRepository: PostRepository()));
    PostType postType = PostType.findByCode(Get.parameters['postType'] ?? PostType.none.code);
    if (postType == PostType.all) {
      postType = PostType.none;
    }
    controller.postType = postType;
    controller.titleController.text = "";
    controller.contentsController.text = "";
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
            child: Container(
              color: Colors.white,
              // padding: EdgeInsets.symmetric(horizontal: FetchPixels.getDefaultHorSpace(context)),
              child: Column(
                children: [buildToolbar(context), buildExpand(context)],
              ),
            ),
          ),
        ),
        onWillPop: () async {
          Get.back();
          return false;
        });
  }

  Obx buildExpand(BuildContext context) {
    return Obx(() => Expanded(
        flex: 1,
        child: ListView(physics: const BouncingScrollPhysics(), shrinkWrap: true, primary: true, children: [
          getDefaultTextFiledWithLabel2(
              context,
              controller.postType.desc,
              controller.postType.color,
              controller.postTypeController,
              Colors.black87,
              FetchPixels.getPixelHeight(16),
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
              alignmentGeometry: Alignment.center),
          getVerSpace(FetchPixels.getPixelHeight(0)),
          getDefaultTextFiledWithLabel2(context, "내용을 입력해주세요.", Colors.black45.withOpacity(0.3),
              controller.contentsController, Colors.grey, FetchPixels.getPixelHeight(16), FontWeight.w400,
              function: () {},
              isEnable: false,
              withprefix: false,
              minLines: true,
              height: FetchPixels.getPixelHeight(450),
              alignmentGeometry: Alignment.topLeft),
          getVerSpace(FetchPixels.getPixelHeight(10)),
          selectedLinkList(),
          // getVerSpace(FetchPixels.getPixelHeight(10)),
          selectedTagList()
        ])));
  }

  Widget buildToolbar(BuildContext context) {
    return Obx(() => Container(
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
              rightText: "등록",
              rightTextColor: controller.canRegister ? Colors.redAccent : Colors.grey.shade400,
              rightFunction: () async {
                controller.add();
              }),
          // getVerSpace(FetchPixels.getPixelHeight(10))
        ])));
  }

  GestureDetector selectedTagList() {
    return GestureDetector(
      onTap: () {
        if (controller.selectedTagList.length > 0) {
          Get.dialog(TagDialog(controller.selectedTagList));
        }
      },
      child: SizedBox(
          height: 120,
          child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              // scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              itemCount: controller.selectedTagList.length,
              itemBuilder: (context, index) {
                String tag = controller.selectedTagList[index];
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
                        margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
                        child: Text(
                          "#$tag",
                          style: TextStyle(fontSize: 15),
                        ),
                        // getVerSpace(FetchPixels.getPixelHeight(10)),
                        // getSvgImage("close_outline.svg", width: 15, height: 15),
                      ),
                      getVerSpace(FetchPixels.getPixelHeight(5))
                    ]);
              })),
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
                        child: Expanded(child: Text(link, style: TextStyle(fontSize: 13, color: Colors.blueAccent))),
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
                  print("이미지 업로드");
                } else if (selectedTabIndex == 1) {
                  Get.dialog(TagDialog(controller.selectedTagList));
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
}
