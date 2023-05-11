import 'package:baby_book/app/data/data_file.dart';
import 'package:baby_book/app/routes/app_routes.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../base/color_data.dart';
import '../../../base/constant.dart';
import '../../../base/widget_utils.dart';

class DateTimeScreen extends StatefulWidget {
  const DateTimeScreen({Key? key}) : super(key: key);

  @override
  State<DateTimeScreen> createState() => _DateTimeScreenState();
}

class _DateTimeScreenState extends State<DateTimeScreen> {
  List<String> timeLists = DataFile.timeList;
  var select = 0;

  SharedPreferences? selection;

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((SharedPreferences sp) {
      selection = sp;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: backGroundColor,
          bottomNavigationBar: doneButton(context),
          body: SafeArea(
            child: Container(
              padding:
                  EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getVerSpace(FetchPixels.getPixelHeight(20)),
                  gettoolbarMenu(context, "back.svg", () {
                    Constant.backToPrev(context);
                  },
                      title: "Date & Time",
                      
                      weight: FontWeight.w900,
                      istext: true,
                      fontsize: 24,
                      textColor: Colors.black),
                  getVerSpace(FetchPixels.getPixelHeight(30)),
                  calendarContainer(),
                  getVerSpace(FetchPixels.getPixelHeight(30)),
                  getCustomFont("Select Time", 16, Colors.black, 1,
                       fontWeight: FontWeight.w900),
                  getVerSpace(FetchPixels.getPixelHeight(10)),
                  timeList()
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

  Container doneButton(BuildContext context) {
    return Container(
          color: backGroundColor,
          padding: EdgeInsets.only(
              left: FetchPixels.getPixelWidth(20),
              right: FetchPixels.getPixelWidth(20),
              bottom: FetchPixels.getPixelHeight(33)),
          child: getButton(context, blueColor, "Done", Colors.white, () {
            Constant.sendToNext(context, Routes.paymentRoute);
          }, 18,
              weight: FontWeight.w600,
              buttonHeight: FetchPixels.getPixelHeight(60),
              borderRadius:
                  BorderRadius.circular(FetchPixels.getPixelHeight(14))),
        );
  }

  Expanded timeList() {
    return Expanded(
      child: GridView.builder(
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        itemCount: timeLists.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                select = index;
                selection!.setString("time", timeLists[index]);
              });
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0.0, 4.0)),
                  ],
                  border: select == index
                      ? Border.all(color: blueColor, width: 2)
                      : null,
                  borderRadius:
                      BorderRadius.circular(FetchPixels.getPixelHeight(12))),
              child: getCustomFont(timeLists[index], 16,
                  select == index ? blueColor : Colors.black, 1,
                  fontWeight: FontWeight.w600, ),
            ),
          );
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisExtent: FetchPixels.getPixelHeight(56),
            crossAxisSpacing: FetchPixels.getPixelWidth(19),
            mainAxisSpacing: FetchPixels.getPixelHeight(16)),
      ),
    );
  }

  Container calendarContainer() {
    return Container(
      height: FetchPixels.getPixelHeight(363),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0.0, 4.0)),
          ],
          borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(20))),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(20)),
        child: SfDateRangePicker(
          monthViewSettings: const DateRangePickerMonthViewSettings(
            dayFormat: "EEE",
          ),
          onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
            selection!.setString("date", DateFormat.d().format(args.value));
            selection!.setString("month", DateFormat.MMMM().format(args.value));
            selection!.setString("year", DateFormat.y().format(args.value));
          },
          selectionShape: DateRangePickerSelectionShape.circle,
          showNavigationArrow: true,
          backgroundColor: Colors.white,
          selectionColor: blueColor,
          monthCellStyle: DateRangePickerMonthCellStyle(
              todayCellDecoration: BoxDecoration(
                  border: Border.all(color: blueColor), shape: BoxShape.circle),
              textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: FetchPixels.getPixelHeight(14),
                  fontWeight: FontWeight.w400,
                  ),
              todayTextStyle: TextStyle(
                  color: blueColor,
                  fontSize: FetchPixels.getPixelHeight(14),
                  fontWeight: FontWeight.w400,
                  )),
          selectionTextStyle: TextStyle(
              color: Colors.white,
              fontSize: FetchPixels.getPixelHeight(14),
              fontWeight: FontWeight.w400,
              ),
          selectionMode: DateRangePickerSelectionMode.single,
          headerStyle: DateRangePickerHeaderStyle(
              textAlign: TextAlign.start,
              textStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  
                  fontSize: FetchPixels.getPixelHeight(16))),
        ),
      ),
    );
  }
}
