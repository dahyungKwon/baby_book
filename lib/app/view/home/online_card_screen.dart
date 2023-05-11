import 'package:baby_book/app/data/data_file.dart';
import 'package:baby_book/app/models/model_card.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../base/color_data.dart';
import '../../../base/widget_utils.dart';
import '../dialog/card_dialog.dart';

class OnlineCardScreen extends StatefulWidget {
  const OnlineCardScreen({Key? key}) : super(key: key);

  @override
  State<OnlineCardScreen> createState() => _OnlineCardScreenState();
}

class _OnlineCardScreenState extends State<OnlineCardScreen> {
  SharedPreferences? selection;

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((SharedPreferences sp) {
      selection = sp;
      setState(() {});
    });
  }

  List<ModelCard> cardLists = DataFile.cardList;
  int? select;

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return Column(
      children: [
        // getVerSpace(FetchPixels.getPixelHeight(30)),
        cardList(),
        getVerSpace(FetchPixels.getPixelHeight(10)),
        addCardButton(context)
      ],
    );
  }

  Widget addCardButton(BuildContext context) {
    return getButton(context, const Color(0xFFF2F4F8), "+ Add New Card", blueColor,
        () {
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
        buttonWidth: FetchPixels.getPixelWidth(224),
        buttonHeight: FetchPixels.getPixelHeight(60),
        borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(14)));
  }

  ListView cardList() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: cardLists.length,
      shrinkWrap: true,
      primary: true,
      itemBuilder: (context, index) {
        ModelCard modelCard = cardLists[index];
        return GestureDetector(
          onTap: () {
            setState(() {
              select = index;
              selection!.setString("image", modelCard.image ?? '');
              selection!.setString("cardname", modelCard.cardName ?? "");
              selection!.setString("cardnumber", modelCard.cardNumber ?? "");
            });
          },
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    getSvgImage(modelCard.image ?? '',
                        width: FetchPixels.getPixelHeight(46),
                        height: FetchPixels.getPixelHeight(46)),
                    getHorSpace(FetchPixels.getPixelWidth(14)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getCustomFont(
                            modelCard.cardName ?? "", 16, Colors.black, 1,
                             fontWeight: FontWeight.w900),
                        getVerSpace(FetchPixels.getPixelHeight(2)),
                        getCustomFont(
                            modelCard.cardNumber ?? "", 16, Colors.black, 1,
                            fontWeight: FontWeight.w400, )
                      ],
                    )
                  ],
                ),
                getSvgImage(select == index ? "selected.svg" : "unselected.svg",
                    height: FetchPixels.getPixelHeight(24),
                    width: FetchPixels.getPixelHeight(24))
              ],
            ),
          ),
        );
      },
    );
  }
}
