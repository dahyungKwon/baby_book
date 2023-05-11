import 'package:baby_book/app/data/data_file.dart';
import 'package:baby_book/app/models/model_cart.dart';
import 'package:baby_book/app/models/model_other.dart';
import 'package:baby_book/app/routes/app_routes.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:flutter/material.dart';

import '../../../base/color_data.dart';
import '../../../base/constant.dart';
import '../../../base/widget_utils.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  static Map<String, ModelCart> cartLists = DataFile.cartList;
  List<ModelCart> list = [];
  List<ModelOther> otherProductLists = DataFile.otherProductList;
  double total = 0;
  double discount = 4.80;

  Future<List<ModelCart>> getList() async {
    list = [];
    cartLists.forEach((key, value) {
      list.add(value);
    });

    return list;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cartTotalPrice();
  }

  double cartTotalPrice() {
    cartLists.forEach((key, value) {
      total += value.totalPrice();
    });
    return total;
  }

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: backGroundColor,
          body: SafeArea(
            child: Column(
              children: [
                getVerSpace(FetchPixels.getPixelHeight(20)),
                getPaddingWidget(
                  EdgeInsets.symmetric(
                      horizontal: FetchPixels.getPixelWidth(20)),
                  gettoolbarMenu(
                    context,
                    "back.svg",
                    () {
                      Constant.backToPrev(context);
                    },
                    title: "Cart",
                    weight: FontWeight.w900,
                    textColor: Colors.black,
                    fontsize: 24,
                    istext: true,
                  ),
                ),
                getVerSpace(FetchPixels.getPixelHeight(30)),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          cartList(),
                          frequentlyAddedList(),
                          paymentDetail(),
                          getVerSpace(FetchPixels.getPixelHeight(30)),
                          proceedButton(context),
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
        onWillPop: () async {
          Constant.backToPrev(context);
          return false;
        });
  }

  Widget proceedButton(BuildContext context) {
    return getPaddingWidget(
      EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
      getButton(context, blueColor, "Proceed", Colors.white, () {
        Constant.sendToNext(context, Routes.addressRoute);
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
        getPaddingWidget(
            EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
            getCustomFont(
              "Payment Detail",
              20,
              Colors.black,
              1,
              fontWeight: FontWeight.w900,
            )),
        getVerSpace(FetchPixels.getPixelHeight(16)),
        getPaddingWidget(
          EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              getCustomFont(
                "Service Charge Total",
                16,
                Colors.black,
                1,
                fontWeight: FontWeight.w400,
              ),
              getCustomFont(
                "\$$total",
                16,
                Colors.black,
                1,
                fontWeight: FontWeight.w600,
              )
            ],
          ),
        ),
        getVerSpace(FetchPixels.getPixelHeight(16)),
        getPaddingWidget(
          EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              getCustomFont(
                "Discount (20%)",
                16,
                Colors.black,
                1,
                fontWeight: FontWeight.w400,
              ),
              getCustomFont(
                "-\$$discount",
                16,
                Colors.black,
                1,
                fontWeight: FontWeight.w600,
              )
            ],
          ),
        ),
        getVerSpace(FetchPixels.getPixelHeight(20)),
        getDivider(dividerColor, FetchPixels.getPixelHeight(1), 1),
        getVerSpace(FetchPixels.getPixelHeight(16)),
        getPaddingWidget(
          EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              getCustomFont("Total", 24, Colors.black, 1,
                  fontWeight: FontWeight.w900),
              getCustomFont(
                "\$${total - discount}",
                24,
                Colors.black,
                1,
                fontWeight: FontWeight.w900,
              )
            ],
          ),
        ),
      ],
    );
  }

  Column frequentlyAddedList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getPaddingWidget(
          EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
          getCustomFont(
            "Frequently added together",
            20,
            Colors.black,
            1,
            fontWeight: FontWeight.w900,
          ),
        ),
        getVerSpace(FetchPixels.getPixelHeight(14)),
        Container(
          height: FetchPixels.getPixelHeight(291),
          margin: EdgeInsets.only(left: FetchPixels.getPixelWidth(20)),
          child: ListView.builder(
            itemCount: otherProductLists.length,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(bottom: FetchPixels.getPixelHeight(30)),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              ModelOther modelOther = otherProductLists[index];
              return Container(
                height: FetchPixels.getPixelHeight(261),
                width: FetchPixels.getPixelWidth(156),
                margin: EdgeInsets.only(right: FetchPixels.getPixelWidth(20)),
                padding: EdgeInsets.symmetric(
                    horizontal: FetchPixels.getPixelWidth(16),
                    vertical: FetchPixels.getPixelHeight(16)),
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0.0, 4.0)),
                    ],
                    borderRadius:
                        BorderRadius.circular(FetchPixels.getPixelHeight(12))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: FetchPixels.getPixelHeight(119),
                        width: FetchPixels.getPixelHeight(124),
                        decoration: BoxDecoration(
                          image: getDecorationAssetImage(
                              context, modelOther.image ?? ""),
                        ),
                      ),
                    ),
                    getVerSpace(FetchPixels.getPixelHeight(10)),
                    getCustomFont(
                      modelOther.name ?? "",
                      16,
                      Colors.black,
                      1,
                      fontWeight: FontWeight.w900,
                    ),
                    getVerSpace(FetchPixels.getPixelHeight(6)),
                    getCustomFont("\$${modelOther.price}", 14, blueColor, 1,
                        fontWeight: FontWeight.w900),
                    getVerSpace(FetchPixels.getPixelHeight(10)),
                    getButton(
                        context, Colors.white, "Add", blueColor, () {}, 14,
                        weight: FontWeight.w600,
                        isBorder: true,
                        borderRadius: BorderRadius.circular(
                            FetchPixels.getPixelHeight(10)),
                        borderColor: blueColor,
                        borderWidth: FetchPixels.getPixelHeight(1.5),
                        insetsGeometrypadding: EdgeInsets.symmetric(
                            vertical: FetchPixels.getPixelHeight(12)))
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  FutureBuilder<List<ModelCart>> cartList() {
    return FutureBuilder<List<ModelCart>>(
      future: getList(),
      builder: (context, snapshot) {
        if (snapshot.data != null && snapshot.data!.isNotEmpty) {
          list = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            primary: false,
            padding: EdgeInsets.zero,
            scrollDirection: Axis.vertical,
            itemCount: list.length,
            itemBuilder: (context, index) {
              ModelCart? modelCart = list[index];

              return Container(
                margin: EdgeInsets.only(
                    bottom: FetchPixels.getPixelHeight(20),
                    left: FetchPixels.getPixelWidth(20),
                    right: FetchPixels.getPixelWidth(20)),
                width: FetchPixels.getPixelWidth(374),
                padding: EdgeInsets.only(
                    left: FetchPixels.getPixelWidth(16),
                    right: FetchPixels.getPixelWidth(16),
                    top: FetchPixels.getPixelHeight(16),
                    bottom: FetchPixels.getPixelHeight(16)),
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0.0, 4.0)),
                    ],
                    borderRadius:
                        BorderRadius.circular(FetchPixels.getPixelHeight(12))),
                child: Row(
                  children: [
                    Container(
                      height: FetchPixels.getPixelHeight(104),
                      width: FetchPixels.getPixelHeight(104),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              FetchPixels.getPixelHeight(10)),
                          image: getDecorationAssetImage(
                              context, modelCart.image ?? "")),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(
                            left: FetchPixels.getPixelWidth(16)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getCustomFont(
                              modelCart.name ?? '',
                              16,
                              Colors.black,
                              1,
                              fontWeight: FontWeight.w900,
                            ),
                            getVerSpace(FetchPixels.getPixelHeight(4)),
                            getCustomFont(
                                modelCart.productName ?? "", 14, textColor, 1,
                                fontWeight: FontWeight.w400),
                            getVerSpace(FetchPixels.getPixelHeight(9)),
                            getCustomFont(
                                "\$${modelCart.price}", 16, blueColor, 1,
                                fontWeight: FontWeight.w900)
                          ],
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          child: getSvgImage("trash.svg",
                              width: FetchPixels.getPixelHeight(20),
                              height: FetchPixels.getPixelHeight(20)),
                          onTap: () {
                            setState(() {
                              cartLists.remove(index.toString());
                            });
                          },
                        ),
                        getVerSpace(FetchPixels.getPixelHeight(54)),
                        Row(
                          children: [
                            GestureDetector(
                              child: getSvgImage("add1.svg",
                                  width: FetchPixels.getPixelHeight(30),
                                  height: FetchPixels.getPixelHeight(30)),
                              onTap: () {
                                modelCart.quantity = (modelCart.quantity! + 1);
                                total = total + (modelCart.price! * 1);
                                setState(() {});
                              },
                            ),
                            getHorSpace(FetchPixels.getPixelWidth(10)),
                            getCustomFont(
                              modelCart.quantity.toString(),
                              14,
                              Colors.black,
                              1,
                              fontWeight: FontWeight.w400,
                            ),
                            getHorSpace(FetchPixels.getPixelWidth(10)),
                            GestureDetector(
                              child: getSvgImage("minus.svg",
                                  width: FetchPixels.getPixelHeight(30),
                                  height: FetchPixels.getPixelHeight(30)),
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
                    )
                  ],
                ),
              );
            },
          );
        } else {
          return Container();
        }
      },
    );
  }
}
