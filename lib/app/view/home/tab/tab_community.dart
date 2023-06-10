import 'package:baby_book/app/view/bookings/active_booking_screen.dart';
import 'package:baby_book/app/view/bookings/all_booking_screen.dart';
import 'package:baby_book/app/view/bookings/cancel_booking_screen.dart';
import 'package:baby_book/app/view/bookings/complete_booking_screen.dart';
import 'package:baby_book/base/color_data.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:flutter/material.dart';

class TabCommunity extends StatefulWidget {
  const TabCommunity({Key? key}) : super(key: key);

  @override
  State<TabCommunity> createState() => _TabCommunityState();
}

class _TabCommunityState extends State<TabCommunity> with SingleTickerProviderStateMixin {
  final PageController _controller = PageController(
    initialPage: 0,
  );

  late TabController tabController;
  var position = 0;
  List<String> tabsList = ["전체", "전집후기", "책장공유", "영어", "육아고민", "성장공유", "자유이야기"];

  @override
  void initState() {
    tabController = TabController(length: tabsList.length, vsync: this);
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backGroundColor,
      body: Column(
        children: [tabBar(), getVerSpace(FetchPixels.getPixelHeight(25)), pageViewer()],
      ),
    );
  }

  Expanded pageViewer() {
    return Expanded(
      child: PageView(
        physics: const BouncingScrollPhysics(),
        controller: _controller,
        scrollDirection: Axis.horizontal,
        children: const [
          AllBookingScreen(),
          ActiveBookingScreen(),
          CompleteBookingScreen(),
          CancelBookingScreen(),
          CancelBookingScreen(),
          CancelBookingScreen(),
          CancelBookingScreen(),
        ],
        onPageChanged: (value) {
          tabController.animateTo(value);
          position = value;
          setState(() {});
        },
      ),
    );
  }

  Widget tabBar() {
    return getPaddingWidget(
      EdgeInsets.symmetric(horizontal: FetchPixels.getDefaultHorSpace(context)),
      TabBar(
        overlayColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            return Colors.transparent;
          },
        ),
        isScrollable: true,
        indicatorColor: Colors.transparent,
        physics: const BouncingScrollPhysics(),
        controller: tabController,
        labelPadding: EdgeInsets.fromLTRB(10, 25, 10, 0),
        // labelStyle: TextStyle(fontSize: 5),
        onTap: (index) {
          _controller.jumpToPage(index);
          position = index;
          setState(() {});
        },
        labelColor: Colors.black,
        unselectedLabelColor: Colors.black.withOpacity(0.3),
        labelStyle:
            TextStyle(fontSize: 16, fontWeight: FontWeight.w600, overflow: TextOverflow.visible), //For Selected tab
        tabs: List.generate(tabsList.length, (index) {
          return Tab(
            height: 16.0,
            child: Container(
                alignment: Alignment.center,
                child: Column(
                  children: [Text(tabsList[index])],
                )),
          );
        }),
      ),
    );
  }
}
