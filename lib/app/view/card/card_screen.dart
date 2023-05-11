import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:flutter/material.dart';

import '../../../base/color_data.dart';
import '../../../base/constant.dart';
import '../../../base/widget_utils.dart';
import '../../data/data_file.dart';
import '../../models/model_card.dart';
import '../dialog/card_dialog.dart';

class CardScreen extends StatefulWidget {
  const CardScreen({Key? key}) : super(key: key);

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  List<ModelCard> cardLists = DataFile.cardList;

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
                  horizontal: FetchPixels.getDefaultHorSpace(context)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getVerSpace(FetchPixels.getPixelHeight(20)),
                  buildToolbar(context),
                  getVerSpace(FetchPixels.getPixelHeight(30)),
                  Visibility(
                      visible: cardLists.isNotEmpty,
                      child: getCustomFont("Your cards", 16, Colors.black, 1,
                          fontWeight: FontWeight.w400)),
                  getVerSpace(FetchPixels.getPixelHeight(20)),
                  buildExpandView(context),
                  Visibility(
                    visible: cardLists.isNotEmpty,
                    child: addCardButton(context),
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

  Expanded buildExpandView(BuildContext context) {
    return Expanded(
      flex: 1,
      child: cardLists.isEmpty ? nullListView(context) : buildCardList(),
    );
  }

  ListView buildCardList() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: cardLists.length,
      shrinkWrap: true,
      primary: true,
      itemBuilder: (context, index) {
        ModelCard modelCard = cardLists[index];
        return GestureDetector(
          onTap: () {},
          child: Container(
            margin: EdgeInsets.only(bottom: FetchPixels.getPixelHeight(20)),
            width: FetchPixels.getPixelWidth(374),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                getSvgImage(modelCard.image ?? '',
                    width: FetchPixels.getPixelHeight(46),
                    height: FetchPixels.getPixelHeight(46)),
                getHorSpace(FetchPixels.getPixelWidth(14)),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getCustomFont(
                          modelCard.cardName ?? "", 16, Colors.black, 1,
                          fontWeight: FontWeight.w900),
                      getVerSpace(FetchPixels.getPixelHeight(2)),
                      getCustomFont(
                        modelCard.cardNumber ?? "",
                        16,
                        Colors.black,
                        1,
                        fontWeight: FontWeight.w400,
                      )
                    ],
                  ),
                ),
                getSvgImage("more_vert.svg",
                    height: FetchPixels.getPixelHeight(16),
                    width: FetchPixels.getPixelHeight(2))
              ],
            ),
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
        title: "My Cards",
        weight: FontWeight.w900,
        fontsize: 24,
        textColor: Colors.black);
  }

  Column addCardButton(BuildContext context) {
    return Column(
      children: [
        getButton(context, blueColor, "Add New Card", Colors.white, () {
          showModalBottomSheet(
              backgroundColor: backGroundColor,
              isDismissible: false,
              isScrollControlled: true,
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(FetchPixels.getPixelHeight(40)),
                ),
              ),
              builder: (context) {
                return const CardDialog();
              });
        }, 18,
            weight: FontWeight.w600,
            buttonHeight: FetchPixels.getPixelHeight(60),
            borderRadius:
                BorderRadius.circular(FetchPixels.getPixelHeight(14))),
        getVerSpace(FetchPixels.getPixelHeight(30))
      ],
    );
  }

  // Column cardList() {
  //   return Column(
  //     children: [
  //       getVerSpace(FetchPixels.getPixelHeight(30)),
  //       Align(
  //         alignment: Alignment.topLeft,
  //         child: getCustomFont("Your cards", 16, Colors.black, 1,
  //              fontWeight: FontWeight.w400),
  //       ),
  //       getVerSpace(FetchPixels.getPixelHeight(20)),
  //       ListView.builder(
  //         padding: EdgeInsets.zero,
  //         itemCount: cardLists.length,
  //         shrinkWrap: true,
  //         primary: true,
  //         itemBuilder: (context, index) {
  //           ModelCard modelCard = cardLists[index];
  //           return GestureDetector(
  //             onTap: () {},
  //             child: Container(
  //               margin: EdgeInsets.only(bottom: FetchPixels.getPixelHeight(20)),
  //               width: FetchPixels.getPixelWidth(374),
  //               padding: EdgeInsets.symmetric(
  //                   horizontal: FetchPixels.getPixelWidth(16),
  //                   vertical: FetchPixels.getPixelHeight(16)),
  //               decoration: BoxDecoration(
  //                   color: Colors.white,
  //                   boxShadow: const [
  //                     BoxShadow(
  //                         color: Colors.black12,
  //                         blurRadius: 10,
  //                         offset: Offset(0.0, 4.0)),
  //                   ],
  //                   borderRadius:
  //                       BorderRadius.circular(FetchPixels.getPixelHeight(12))),
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Row(
  //                     children: [
  //                       getSvgImage(modelCard.image ?? '',
  //                           width: FetchPixels.getPixelHeight(46),
  //                           height: FetchPixels.getPixelHeight(46)),
  //                       getHorSpace(FetchPixels.getPixelWidth(14)),
  //                       Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           getCustomFont(
  //                               modelCard.cardName ?? "", 16, Colors.black, 1,
  //
  //                               fontWeight: FontWeight.w900),
  //                           getVerSpace(FetchPixels.getPixelHeight(2)),
  //                           getCustomFont(
  //                               modelCard.cardNumber ?? "", 16, Colors.black, 1,
  //                               fontWeight: FontWeight.w400,
  //                               )
  //                         ],
  //                       )
  //                     ],
  //                   ),
  //                   getSvgImage("more_vert.svg",
  //                       height: FetchPixels.getPixelHeight(16),
  //                       width: FetchPixels.getPixelHeight(2))
  //                 ],
  //               ),
  //             ),
  //           );
  //         },
  //       ),
  //     ],
  //   );
  // }

  Expanded nullListView(BuildContext context) {
    return Expanded(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: FetchPixels.getPixelHeight(124),
          width: FetchPixels.getPixelHeight(124),
          decoration: BoxDecoration(
              image: getDecorationAssetImage(context, "wallet_card.png")),
        ),
        getVerSpace(FetchPixels.getPixelHeight(40)),
        getCustomFont("No Cards Yet!", 20, Colors.black, 1,
            fontWeight: FontWeight.w900),
        getVerSpace(FetchPixels.getPixelHeight(10)),
        getCustomFont(
          "Add your card and lets get started.",
          16,
          Colors.black,
          1,
          fontWeight: FontWeight.w400,
        ),
        getVerSpace(FetchPixels.getPixelHeight(30)),
        getButton(context, backGroundColor, "Add Card", blueColor, () {}, 18,
            weight: FontWeight.w600,
            buttonHeight: FetchPixels.getPixelHeight(60),
            insetsGeometry:
                EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(98)),
            borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(14)),
            isBorder: true,
            borderColor: blueColor,
            borderWidth: 1.5)
      ],
    ));
  }
}
