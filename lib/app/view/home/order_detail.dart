import 'package:dotted_line/dotted_line.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../base/color_data.dart';
import '../../../base/constant.dart';
import '../../../base/widget_utils.dart';
import '../../data/data_file.dart';
import '../../models/model_cart.dart';
import '../dialog/confirm_dialog.dart';

class OrderDetail extends StatefulWidget {
  const OrderDetail({Key? key}) : super(key: key);

  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  static Map<String, ModelCart> cartLists = DataFile.cartList;
  List<ModelCart> list = [];
  double total = 0;
  double discount = 4.80;

  Future<List<ModelCart>> getList() async {
    list = [];
    cartLists.forEach((key, value) {
      list.add(value);
    });

    return list;
  }

  double cartTotalPrice() {
    cartLists.forEach((key, value) {
      total += value.totalPrice();
    });
    return total;
  }

  SharedPreferences? selection;

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((SharedPreferences sp) {
      selection = sp;
      setState(() {});
    });
    cartTotalPrice();
  }

  String? date;
  String? month;
  String? year;
  String? time;
  String? image;
  String? cardname;
  String? cardnumber;

  bool confirm = false;

  @override
  Widget build(BuildContext context) {
    date = selection!.getString("date") ?? "";
    month = selection!.getString("month") ?? "";
    year = selection!.getString("year") ?? "";
    time = selection!.getString("time") ?? "";
    image = selection!.getString("image") ?? '';
    cardname = selection!.getString("cardname") ?? "";
    cardnumber = selection!.getString("cardnumber") ?? "";
    FetchPixels(context);
    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: backGroundColor,
          bottomNavigationBar: confirmButton(context),
          body: SafeArea(
            child: Container(
              padding:
                  EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
              child: Column(
                children: [
                  getVerSpace(FetchPixels.getPixelHeight(20)),
                  gettoolbarMenu(context, "back.svg", () {
                    Constant.backToPrev(context);
                  },
                      title: "Proceed",
                      
                      weight: FontWeight.w900,
                      istext: true,
                      fontsize: 24,
                      textColor: Colors.black),
                  getVerSpace(FetchPixels.getPixelHeight(30)),
                  processTracker(),
                  getVerSpace(FetchPixels.getPixelHeight(30)),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            dateTimeContainer(),
                            getVerSpace(FetchPixels.getPixelHeight(20)),
                            addressContainer(),
                            getVerSpace(FetchPixels.getPixelHeight(20)),
                            paymentContainer(),
                            getVerSpace(FetchPixels.getPixelHeight(20)),
                            cartList(),
                            getVerSpace(FetchPixels.getPixelHeight(30)),
                            paymentDetail(),
                            getVerSpace(FetchPixels.getPixelHeight(30)),
                          ],
                        ),
                      ),
                    ),
                  )
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

  Container confirmButton(BuildContext context) {
    return Container(
      color: backGroundColor,
      padding: EdgeInsets.only(
          left: FetchPixels.getPixelWidth(20),
          right: FetchPixels.getPixelWidth(20),
          bottom: FetchPixels.getPixelHeight(33)),
      child: getButton(context, blueColor, "Confirm", Colors.white, () {
        setState(() {
          confirm = true;
        });
        showDialog(
            barrierDismissible: false,
            builder: (context) {
              return const ConfirmDialog();
            },
            context: context);
      }, 18,
          weight: FontWeight.w600,
          buttonHeight: FetchPixels.getPixelHeight(60),
          borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(14))),
    );
  }

  Column paymentDetail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getCustomFont("Payment Detail", 20, Colors.black, 1,
            fontWeight: FontWeight.w900, ),
        getVerSpace(FetchPixels.getPixelHeight(16)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            getCustomFont("Service Charge Total", 16, Colors.black, 1,
                fontWeight: FontWeight.w400, ),
            getCustomFont("\$$total", 16, Colors.black, 1,
                fontWeight: FontWeight.w600, )
          ],
        ),
        getVerSpace(FetchPixels.getPixelHeight(16)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            getCustomFont("Discount (20%)", 16, Colors.black, 1,
                fontWeight: FontWeight.w400, ),
            getCustomFont("-\$$discount", 16, Colors.black, 1,
                fontWeight: FontWeight.w600, )
          ],
        ),
        getVerSpace(FetchPixels.getPixelHeight(20)),
        getDivider(dividerColor, FetchPixels.getPixelHeight(1), 1),
        getVerSpace(FetchPixels.getPixelHeight(16)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            getCustomFont("Total", 24, Colors.black, 1,
                 fontWeight: FontWeight.w900),
            getCustomFont("\$${total - discount}", 24, Colors.black, 1,
                fontWeight: FontWeight.w900, )
          ],
        ),
      ],
    );
  }

  Container cartList() {
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.only(
          left: FetchPixels.getPixelWidth(16),
          right: FetchPixels.getPixelWidth(16),
          top: FetchPixels.getPixelHeight(16)),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0.0, 4.0)),
          ],
          borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(12))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getCustomFont("Cart Detail", 16, Colors.black, 1,
              fontWeight: FontWeight.w900, ),
          getVerSpace(FetchPixels.getPixelHeight(13)),
          FutureBuilder<List<ModelCart>>(
              future: getList(),
              builder: (context, snapshot) {
                if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                  list = snapshot.data!;
                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    primary: true,
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      ModelCart? modelCart = list[index];
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: FetchPixels.getPixelHeight(84),
                                    width: FetchPixels.getPixelHeight(84),
                                    decoration: BoxDecoration(
                                      image: getDecorationAssetImage(
                                          context, modelCart.image ?? ""),
                                    ),
                                  ),
                                  getHorSpace(FetchPixels.getPixelWidth(16)),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      getCustomFont(modelCart.name ?? "", 16,
                                          Colors.black, 1,
                                          
                                          fontWeight: FontWeight.w900),
                                      getVerSpace(
                                          FetchPixels.getPixelHeight(4)),
                                      getCustomFont(
                                          modelCart.productName ?? "",
                                          14,
                                          textColor,
                                          1,
                                          fontWeight: FontWeight.w400,
                                          ),
                                      getVerSpace(
                                          FetchPixels.getPixelHeight(9)),
                                      getCustomFont("\$${modelCart.price}",
                                          16, blueColor, 1,
                                          
                                          fontWeight: FontWeight.w900)
                                    ],
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    child: getSvgImage("add1.svg",
                                        width: FetchPixels.getPixelHeight(30),
                                        height:
                                            FetchPixels.getPixelHeight(30)),
                                    onTap: () {
                                      modelCart.quantity =
                                          (modelCart.quantity! + 1);
                                      total = total + (modelCart.price! * 1);
                                      setState(() {});
                                    },
                                  ),
                                  getHorSpace(FetchPixels.getPixelWidth(10)),
                                  getCustomFont(modelCart.quantity.toString(),
                                      14, Colors.black, 1,
                                      fontWeight: FontWeight.w400,
                                      ),
                                  getHorSpace(FetchPixels.getPixelWidth(10)),
                                  GestureDetector(
                                    child: getSvgImage("minus.svg",
                                        width: FetchPixels.getPixelHeight(30),
                                        height:
                                            FetchPixels.getPixelHeight(30)),
                                    onTap: () {
                                      if (modelCart.quantity! <= 1) {
                                        setState(() {
                                          cartLists.remove(index.toString());
                                        });
                                      } else {
                                        modelCart.quantity =
                                            (modelCart.quantity! - 1);
                                      }
                                      // print(modelSalon.quantity);
                                      total = total - (modelCart.price! * 1);

                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          getVerSpace(FetchPixels.getPixelHeight(20)),
                          index == 2
                              ? Container()
                              : getDivider(dividerColor,
                                  FetchPixels.getPixelHeight(1), 1),
                          index == 2
                              ? Container()
                              : getVerSpace(FetchPixels.getPixelHeight(20)),
                        ],
                      );
                    },
                  );
                } else {
                  return Container();
                }
              })
        ],
      ),
    );
  }

  Container paymentContainer() {
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.symmetric(
          vertical: FetchPixels.getPixelHeight(16),
          horizontal: FetchPixels.getPixelWidth(16)),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0.0, 4.0)),
          ],
          borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(12))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getCustomFont("Payment Method", 16, Colors.black, 1,
              fontWeight: FontWeight.w900, ),
          getVerSpace(FetchPixels.getPixelHeight(14)),
          Row(
            children: [
              getSvgImage(image ?? "",
                  height: FetchPixels.getPixelHeight(46),
                  width: FetchPixels.getPixelHeight(46)),
              getHorSpace(FetchPixels.getPixelWidth(12)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getCustomFont(cardname ?? "", 16, Colors.black, 1,
                      fontWeight: FontWeight.w600, ),
                  getVerSpace(FetchPixels.getPixelHeight(3)),
                  getCustomFont(cardnumber ?? '', 16, Colors.black, 1,
                       fontWeight: FontWeight.w400)
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Container addressContainer() {
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.symmetric(
          vertical: FetchPixels.getPixelHeight(16),
          horizontal: FetchPixels.getPixelWidth(16)),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0.0, 4.0)),
          ],
          borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(12))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getCustomFont("Address", 16, Colors.black, 1,
              fontWeight: FontWeight.w900, ),
          getVerSpace(FetchPixels.getPixelHeight(8)),
          getMultilineCustomFont(
              "3891 Ranchview Dr. Richardson, California 62639",
              16,
              Colors.black,
              
              fontWeight: FontWeight.w400,
              txtHeight: 1.3)
        ],
      ),
    );
  }

  Container dateTimeContainer() {
    return Container(
      width: FetchPixels.getPixelWidth(374),
      padding: EdgeInsets.only(
          left: FetchPixels.getPixelWidth(18),
          right: FetchPixels.getPixelWidth(20),
          top: FetchPixels.getPixelHeight(18),
          bottom: FetchPixels.getPixelHeight(18)),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0.0, 4.0)),
          ],
          borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(12))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              getSvgImage("calender.svg",
                  width: FetchPixels.getPixelHeight(24),
                  height: FetchPixels.getPixelHeight(24)),
              getHorSpace(FetchPixels.getPixelWidth(12)),
              getCustomFont(
                  "$date $month, $year, $time", 16, Colors.black, 1,
                   fontWeight: FontWeight.w400)
            ],
          ),
          getSvgImage("arrow_right.svg",
              width: FetchPixels.getPixelHeight(20),
              height: FetchPixels.getPixelHeight(20))
        ],
      ),
    );
  }

  Row processTracker() {
    return Row(
      children: [
        Container(
          height: FetchPixels.getPixelHeight(52),
          width: FetchPixels.getPixelHeight(52),
          padding: EdgeInsets.all(FetchPixels.getPixelHeight(14)),
          decoration: BoxDecoration(
              color: procced,
              borderRadius:
                  BorderRadius.circular(FetchPixels.getPixelHeight(50))),
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
              color: procced,
              borderRadius:
                  BorderRadius.circular(FetchPixels.getPixelHeight(50))),
          child: getSvgImage("wallet_select.svg"),
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
          decoration: confirm == true
              ? BoxDecoration(
                  color: procced,
                  borderRadius:
                      BorderRadius.circular(FetchPixels.getPixelHeight(50)))
              : BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0.0, 4.0)),
                  ],
                  borderRadius:
                      BorderRadius.circular(FetchPixels.getPixelHeight(50))),
          child: getSvgImage(confirm == true ? "check_select.svg" : "check.svg",
              height: FetchPixels.getPixelHeight(24),
              width: FetchPixels.getPixelHeight(24)),
        ),
      ],
    );
  }
}
