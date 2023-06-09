import 'dart:convert';
import 'package:baby_book/app/data/data_file.dart';
import 'package:baby_book/app/models/model_booking.dart';
import 'package:baby_book/base/color_data.dart';
import 'package:baby_book/base/pref_data.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_pages.dart';

class AllBookingScreen extends StatefulWidget {
  const AllBookingScreen({Key? key}) : super(key: key);

  @override
  State<AllBookingScreen> createState() => _AllBookingScreenState();
}

class _AllBookingScreenState extends State<AllBookingScreen> {
  List<ModelBooking> bookingLists = DataFile.bookingList;

  @override
  Widget build(BuildContext context) {
    EdgeInsets edgeInsets = EdgeInsets.symmetric(
      horizontal: FetchPixels.getDefaultHorSpace(context),
    );
    return Container(
      color: backGroundColor,
      child: bookingLists.isEmpty
          ? getPaddingWidget(edgeInsets, nullListView(context))
          : allBookingList(),
    );
  }


  @override
  void initState() {
    super.initState();

  }

  ListView allBookingList() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: bookingLists.length,
      itemBuilder: (context, index) {
        ModelBooking modelBooking = bookingLists[index];
        return buildBookingListItem(modelBooking, context, index, () {
          ModelBooking booking = ModelBooking(
              modelBooking.image ?? "",
              modelBooking.name ?? "",
              modelBooking.date ?? "",
              modelBooking.rating ?? "",
              modelBooking.price ?? 0.0,
              modelBooking.owner ?? "",
              modelBooking.tag,
              0,
              null);
          PrefData.setBookingModel(jsonEncode(booking));
          Get.toNamed(Routes.bookingPath);
        }, () {
          setState(() {
            bookingLists.removeAt(index);
          });
        });
      },
    );
  }

  Column nullListView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        getSvgImage("clipboard.svg",
            height: FetchPixels.getPixelHeight(124),
            width: FetchPixels.getPixelHeight(124)),
        getVerSpace(FetchPixels.getPixelHeight(40)),
        getCustomFont("No Bookings Yet!", 20, Colors.black, 1,
            fontWeight: FontWeight.w900),
        getVerSpace(FetchPixels.getPixelHeight(10)),
        getCustomFont(
          "Go to services and book the best services. ",
          16,
          Colors.black,
          1,
          fontWeight: FontWeight.w400,
        ),
        getVerSpace(FetchPixels.getPixelHeight(30)),
        getButton(
            context, backGroundColor, "Go to Service", blueColor, () {}, 18,
            weight: FontWeight.w600,
            buttonHeight: FetchPixels.getPixelHeight(60),
            insetsGeometry: EdgeInsets.symmetric(
                horizontal: FetchPixels.getPixelWidth(106)),
            borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(14)),
            isBorder: true,
            borderColor: blueColor,
            borderWidth: 1.5)
      ],
    );
  }
}
