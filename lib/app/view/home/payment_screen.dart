import 'package:dotted_line/dotted_line.dart';

import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../base/color_data.dart';
import '../../../base/constant.dart';
import '../../../base/widget_utils.dart';
import '../../routes/app_pages.dart';
import 'online_card_screen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> with SingleTickerProviderStateMixin {
  final PageController _controller = PageController(
    initialPage: 0,
  );

  late TabController tabController;
  var position = 0;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    setState(() {});
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: backGroundColor,
          bottomNavigationBar: continueButton(context),
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
              child: Column(
                children: [
                  getVerSpace(FetchPixels.getPixelHeight(20)),
                  gettoolbarMenu(context, "back.svg", () {
                    Constant.backToPrev(context);
                  }, title: "Proceed", weight: FontWeight.w900, istext: true, fontsize: 24, textColor: Colors.black),
                  getVerSpace(FetchPixels.getPixelHeight(30)),
                  processTracker(),
                  getVerSpace(FetchPixels.getPixelHeight(30)),
                  const OnlineCardScreen()
                  // tabbar(),
                  // pageviewer()
                ],
              ),
            ),
          ),
        ),
        onWillPop: () async {
          Constant.backToPrev(context);
          return false;
        });
  }

  Container continueButton(BuildContext context) {
    return Container(
      color: backGroundColor,
      padding: EdgeInsets.only(
          left: FetchPixels.getPixelWidth(20),
          right: FetchPixels.getPixelWidth(20),
          bottom: FetchPixels.getPixelHeight(33)),
      child: getButton(context, blueColor, "Continue", Colors.white, () {
        Get.toNamed(Routes.orderDetailPath);
      }, 18,
          weight: FontWeight.w600,
          buttonHeight: FetchPixels.getPixelHeight(60),
          borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(14))),
    );
  }

  // Expanded pageviewer() {
  //   return Expanded(
  //     child: PageView(
  //       physics: BouncingScrollPhysics(),
  //       controller: _controller,
  //       scrollDirection: Axis.horizontal,
  //       children: [Container(), OnlineCardScreen()],
  //       onPageChanged: (value) {
  //         tabController.animateTo(value);
  //       },
  //     ),
  //   );
  // }

  // Stack tabbar() {
  //   return Stack(
  //     alignment: Alignment.bottomCenter,
  //     children: <Widget>[
  //       Container(
  //         decoration: BoxDecoration(
  //           border: Border(
  //             bottom: BorderSide(color: Color(0xFFE5E8F1), width: 2.0),
  //           ),
  //         ),
  //       ),
  //       TabBar(
  //         physics: BouncingScrollPhysics(),
  //         controller: tabController,
  //         indicator: UnderlineTabIndicator(
  //             borderSide: BorderSide(color: blueColor, width: 3)),
  //         onTap: (index) {
  //           _controller.animateToPage(
  //             index,
  //             duration: const Duration(milliseconds: 500),
  //             curve: Curves.easeInOut,
  //           );
  //           position = index;
  //           setState(() {});
  //         },
  //         tabs: [
  //           Tab(
  //             child: Container(
  //               alignment: Alignment.center,
  //               width: FetchPixels.getPixelWidth(187),
  //               child: getCustomFont(
  //                   "Cash", 16, position == 0 ? blueColor : Colors.black, 1,
  //                    fontWeight: FontWeight.w600),
  //             ),
  //           ),
  //           Tab(
  //             child: Container(
  //               alignment: Alignment.center,
  //               width: FetchPixels.getPixelWidth(187),
  //               child: getCustomFont(
  //                   "Online", 16, position == 1 ? blueColor : Colors.black, 1,
  //                    fontWeight: FontWeight.w600),
  //             ),
  //           )
  //         ],
  //       ),
  //     ],
  //   );
  // }

  Row processTracker() {
    return Row(
      children: [
        Container(
          height: FetchPixels.getPixelHeight(52),
          width: FetchPixels.getPixelHeight(52),
          padding: EdgeInsets.all(FetchPixels.getPixelHeight(14)),
          decoration:
              BoxDecoration(color: procced, borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(50))),
          child: getSvgImage("location_select.svg"),
        ),
        Expanded(
          child: DottedLine(
            dashColor: blueColor,
            lineThickness: FetchPixels.getPixelHeight(1),
          ),
        ),
        Container(
          height: FetchPixels.getPixelHeight(52),
          width: FetchPixels.getPixelHeight(52),
          padding: EdgeInsets.all(FetchPixels.getPixelHeight(14)),
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0.0, 4.0)),
              ],
              borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(50))),
          child: getSvgImage("wallet.svg"),
        ),
        Expanded(
          child: DottedLine(
            dashColor: const Color(0xFFBEC4D3),
            lineThickness: FetchPixels.getPixelHeight(1),
          ),
        ),
        Container(
          height: FetchPixels.getPixelHeight(52),
          width: FetchPixels.getPixelHeight(52),
          padding: EdgeInsets.all(FetchPixels.getPixelHeight(14)),
          decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE5E8F1), width: 1),
              borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(50))),
          child: getSvgImage("check.svg"),
        ),
      ],
    );
  }
}
