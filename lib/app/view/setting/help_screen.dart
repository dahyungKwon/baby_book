import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:flutter/material.dart';

import '../../../base/color_data.dart';
import '../../../base/constant.dart';
import '../../../base/widget_utils.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: backGroundColor,
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
                      istext: true,
                      title: "Help & Support",
                      weight: FontWeight.w900,
                      
                      fontsize: 24,
                      textColor: Colors.black),
                  getVerSpace(FetchPixels.getPixelHeight(30)),
                  getMultilineCustomFont(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ornare neque in eros aliquet, eget mollis leo egestas. Sed commodo efficitur eleifend. Nunc pharetra fermentum nunc, eu hendrerit purus blandit et. Nam quam lorem, rutrum nec velit a, egestas tristique nibh. Ut hendrerit tristique nibh quis hendrerit. Sed a felis nec mi maximus aliquam at ac ipsum. Cras tristique mattis augue at auctor. Nullam placerat ultrices purus non tincidunt. Nullam eget purus id urna venenatis dignissim nec id nunc. Sed condimentum arcu quis efficitur feugiat. Cras nisi felis, malesuada et tempus et, pellentesque vitae ligula. Etiam feugiat tellus nunc, nec vestibulum arcu bibendum sed. Phasellus nisi nisi, mollis vitae nibh non, dictum laoreet justo. Duis porta, velit id dictum finibus, eros sem condimentum diam, vitae blandit dui neque vel nisl. Integer hendrerit purus in nunc hendrerit, id ultrices leo auctor. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.Donec vulputate urna eget nisl scelerisque tempor. Morbi semper orci metus. Cras aliquet auctor enim, ac rutrum velit. Quisque nulla augue, cursus at nulla at, egestas imperdiet libero. Nullam sollicitudin sapien sit amet massa mattis ullamcorper eu non risus. Nulla turpis lorem, tristique a dictum sed, fermentum ut lorem. In vitae scelerisque nibh.",
                      16,
                      Colors.black,
                      fontWeight: FontWeight.w400,
                      
                      txtHeight:1.3)
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
}
