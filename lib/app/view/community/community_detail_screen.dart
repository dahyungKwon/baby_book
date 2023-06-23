import 'package:baby_book/base/skeleton.dart';
import 'package:baby_book/base/color_data.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/CommunityDetailController.dart';
import '../../repository/post_repository.dart';

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

    return Obx(() => Container(color: backGroundColor, child: controller.loading ? const ListSkeleton() : draw()));
  }

  Widget draw() {
    return Text(controller.post.title ?? "test");
  }
}
