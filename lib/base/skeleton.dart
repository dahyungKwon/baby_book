import 'package:flutter/material.dart';

import 'resizer/fetch_pixels.dart';

class Skeleton extends StatelessWidget {
  const Skeleton({Key? key, this.height, this.width}) : super(key: key);

  final double? height, width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(7),
      margin: const EdgeInsets.fromLTRB(10, 12, 10, 0),
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.04), borderRadius: const BorderRadius.all(Radius.circular(20))),
    );
  }
}

class ListSkeleton extends StatelessWidget {
  const ListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: Column(children: [row(), row(), row(), row()]));
  }

  Widget row() {
    return Container(
        height: FetchPixels.getPixelHeight(180),
        margin: EdgeInsets.only(bottom: FetchPixels.getPixelHeight(1)),
        padding:
            EdgeInsets.symmetric(vertical: FetchPixels.getPixelHeight(12), horizontal: FetchPixels.getPixelWidth(20)),
        decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Color(0xFFEDEBE8), blurRadius: 3, offset: Offset(0.0, 1.0)),
            ],
            borderRadius: BorderRadius.zero),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Skeleton(width: 150),
            SizedBox(height: 8),
            Skeleton(),
            SizedBox(height: 8),
            Skeleton(),
            SizedBox(height: 8),
            Skeleton(),
            SizedBox(height: 8),
          ],
        ));
  }
}

class PostDetailSkeleton extends StatelessWidget {
  const PostDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: Column(children: [row(), row()]));
  }

  Widget row() {
    return Container(
        margin: EdgeInsets.only(bottom: FetchPixels.getPixelHeight(1)),
        padding:
            EdgeInsets.symmetric(vertical: FetchPixels.getPixelHeight(12), horizontal: FetchPixels.getPixelWidth(20)),
        decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Color(0xFFEDEBE8), blurRadius: 3, offset: Offset(0.0, 1.0)),
            ],
            borderRadius: BorderRadius.zero),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Skeleton(),
            SizedBox(height: 8),
            Skeleton(),
            SizedBox(height: 8),
            Skeleton(),
            SizedBox(height: 8),
            Skeleton(),
            SizedBox(height: 8),
            Skeleton(),
            SizedBox(height: 8),
            Skeleton(),
            SizedBox(height: 8),
            Skeleton(),
            SizedBox(height: 8),
            Skeleton(),
            SizedBox(height: 8),
            Skeleton(),
            SizedBox(height: 8),
            Skeleton(),
            SizedBox(height: 8),
            Skeleton(),
            SizedBox(height: 8),
            Skeleton(),
            SizedBox(height: 8),
            Skeleton(),
            SizedBox(height: 8),
            Skeleton(),
            SizedBox(height: 8),
            Skeleton(),
            SizedBox(height: 8),
            Skeleton(),
            SizedBox(height: 8),
            Skeleton(),
            SizedBox(height: 8),
            Skeleton(),
            SizedBox(height: 8),
            Skeleton(),
            SizedBox(height: 8),
            Skeleton(),
            SizedBox(height: 8),
            Skeleton(),
            SizedBox(height: 8),
            Skeleton(),
            SizedBox(height: 8),
          ],
        ));
  }
}

class CircleSkeleton extends StatelessWidget {
  const CircleSkeleton({Key? key, this.size = 24}) : super(key: key);

  final double? size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.04),
        shape: BoxShape.circle,
      ),
    );
  }
}
