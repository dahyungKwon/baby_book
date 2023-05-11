import 'package:baby_book/app/data/data_file.dart';
import 'package:baby_book/app/models/model_address.dart';
import 'package:baby_book/app/routes/app_routes.dart';
import 'package:baby_book/app/view/dialog/delete_dialog.dart';
import 'package:baby_book/base/pref_data.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:flutter/material.dart';

import '../../../base/color_data.dart';
import '../../../base/constant.dart';

class MyAddressScreen extends StatefulWidget {
  const MyAddressScreen({Key? key}) : super(key: key);

  @override
  State<MyAddressScreen> createState() => _MyAddressScreenState();
}

class _MyAddressScreenState extends State<MyAddressScreen> {
  List<ModelAddress> addressList = DataFile.addressList;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: backGroundColor,
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: FetchPixels.getPixelWidth(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getVerSpace(FetchPixels.getPixelHeight(20)),
                  buildToolbar(context),
                  getVerSpace(FetchPixels.getPixelHeight(30)),
                  Visibility(
                    visible: addressList.isNotEmpty,
                    child: getCustomFont("Your addresses", 16, Colors.black, 1,
                        fontWeight: FontWeight.w400),
                  ),
                  buildExpand(context),
                  Visibility(
                    visible: addressList.isNotEmpty,
                    child: addAddressButton(context),
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

  Expanded buildExpand(BuildContext context) {
    return Expanded(
                  flex: 1,
                  child: (addressList.isEmpty)
                      ? buildEmptyWidget(context)
                      : buildAddressList(),
                );
  }

  Column buildEmptyWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: FetchPixels.getPixelHeight(124),
          width: FetchPixels.getPixelHeight(124),
          decoration: BoxDecoration(
            image: getDecorationAssetImage(context, 'home_address.png'),
          ),
        ),
        getVerSpace(FetchPixels.getPixelHeight(40)),
        getCustomFont("No Address Yet!", 20, Colors.black, 1,
            fontWeight: FontWeight.w900),
        getVerSpace(FetchPixels.getPixelHeight(10)),
        getCustomFont(
          "Add your address and lets get started.",
          16,
          Colors.black,
          1,
          fontWeight: FontWeight.w400,
        ),
        getVerSpace(FetchPixels.getPixelHeight(30)),
        getButton(context, backGroundColor, "Add Address", blueColor, () {}, 18,
            weight: FontWeight.w600,
            buttonHeight: FetchPixels.getPixelHeight(60),
            insetsGeometry:
                EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(98)),
            borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(14)),
            isBorder: true,
            borderColor: blueColor,
            borderWidth: 1.5)
      ],
    );
  }

  ListView buildAddressList() {
    return ListView.builder(
      padding: EdgeInsets.only(top: FetchPixels.getPixelHeight(20)),
      scrollDirection: Axis.vertical,
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      primary: true,
      itemCount: addressList.length,
      itemBuilder: (context, index) {
        ModelAddress modelAddress = addressList[index];
        return Container(
          margin: EdgeInsets.only(bottom: FetchPixels.getPixelHeight(20)),
          padding: EdgeInsets.only(
            bottom: FetchPixels.getPixelHeight(16),
            left: FetchPixels.getPixelWidth(16),
          ),
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.only(top: FetchPixels.getPixelHeight(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getCustomFont(
                        modelAddress.name ?? "",
                        16,
                        Colors.black,
                        1,
                        fontWeight: FontWeight.w900,
                      ),
                      getVerSpace(FetchPixels.getPixelHeight(10)),
                      SizedBox(
                        width: FetchPixels.getPixelWidth(280),
                        child: getMultilineCustomFont(
                            modelAddress.address ?? "", 16, Colors.black,
                            fontWeight: FontWeight.w400,
                            txtHeight:1.3),
                      ),
                      getVerSpace(FetchPixels.getPixelHeight(10)),
                      getCustomFont(
                        modelAddress.phone ?? "",
                        16,
                        Colors.black,
                        1,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                ),
              ),
              PopupMenuButton<int>(
                onSelected: (value) {
                  if (value == 2) {
                    PrefData.setDefIndex(index);
                    showDialog(
                        barrierDismissible: false,
                        builder: (context) {
                          return const DeleteDialog();
                        },
                        context: context);
                    setState(() {});
                  }
                  if (value == 1) {
                    Constant.sendToNext(context, Routes.editAddressRoute);
                  }
                },
                padding: EdgeInsets.only(top: FetchPixels.getPixelHeight(15)),
                icon: getSvgImage("more_vert.svg",
                    width: FetchPixels.getPixelHeight(2),
                    height: FetchPixels.getPixelHeight(16)),
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(FetchPixels.getPixelHeight(12))),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    child: getCustomFont(
                      "Edit",
                      14,
                      Colors.black,
                      1,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const PopupMenuDivider(
                    height: 0,
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: getCustomFont(
                      "Delete",
                      14,
                      Colors.black,
                      1,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
                offset: const Offset(-20, 40),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildToolbar(BuildContext context) {
    return gettoolbarMenu(context, "back.svg", () {
      Constant.backToPrev(context);
    },
        istext: true,
        title: "My Address",
        weight: FontWeight.w900,
        fontsize: 24,
        textColor: Colors.black);
  }

  Column addAddressButton(BuildContext context) {
    return Column(
      children: [
        getButton(context, blueColor, "Add New Address", Colors.white, () {
          Constant.sendToNext(context, Routes.editAddressRoute);
        }, 18,
            weight: FontWeight.w600,
            buttonHeight: FetchPixels.getPixelHeight(60),
            borderRadius:
                BorderRadius.circular(FetchPixels.getPixelHeight(14))),
        getVerSpace(FetchPixels.getPixelHeight(30))
      ],
    );
  }
}
