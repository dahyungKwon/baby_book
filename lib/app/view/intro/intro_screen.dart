import 'package:dots_indicator/dots_indicator.dart';
import 'package:baby_book/app/data/data_file.dart';
import 'package:baby_book/app/routes/app_routes.dart';
import 'package:baby_book/base/color_data.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:flutter/material.dart';

import '../../../base/constant.dart';
import '../../models/model_intro.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  void backClick() {
    Constant.backToPrev(context);
  }

  ValueNotifier selectedPage = ValueNotifier(0);
  final _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: buildPage(),
          ),
        ),
        onWillPop: () async {
          backClick();
          return false;
        });
  }

  PageView buildPage() {
    return PageView.builder(
      controller: _controller,
      onPageChanged: (value) {
        selectedPage.value = value;
      },
      itemCount: DataFile.introList.length,
      itemBuilder: (context, index) {
        ModelIntro introModel = DataFile.introList[index];
        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            buildImage(introModel),
            buildBottomView(introModel, index, context)
          ],
        );
      },
    );
  }

  Positioned buildBottomView(
      ModelIntro introModel, int index, BuildContext context) {
    return Positioned(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            child: getAssetImage(
                "shape.png",
                FetchPixels.getPixelWidth(double.infinity),
                FetchPixels.getPixelHeight(460),
                boxFit: BoxFit.fill),
          ),
          Positioned(
            top: FetchPixels.getPixelHeight(50),
            width: FetchPixels.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: FetchPixels.getPixelHeight(263),
                  child: getMultilineCustomFont(
                      introModel.title ?? "", 34, Colors.black,
                      fontWeight: FontWeight.w900,
                      textAlign: TextAlign.center,
                      txtHeight:1.3),
                ),
                getVerSpace(FetchPixels.getPixelHeight(10)),
                getPaddingWidget(
                  EdgeInsets.symmetric(
                      horizontal: FetchPixels.getPixelWidth(20)),
                  getMultilineCustomFont(
                      introModel.description ?? "", 16, Colors.black,
                      fontWeight: FontWeight.w400,
                      textAlign: TextAlign.center,
                      txtHeight:1.3),
                ),
                getVerSpace(FetchPixels.getPixelHeight(51)),
                DotsIndicator(
                    dotsCount: 3,
                    position: index.toDouble(),
                    decorator: DotsDecorator(
                        size: Size.square(FetchPixels.getPixelHeight(8)),
                        activeSize: Size.square(FetchPixels.getPixelHeight(8)),
                        activeColor: blueColor,
                        color: blueColor.withOpacity(0.2),
                        spacing: EdgeInsets.symmetric(
                            horizontal: FetchPixels.getPixelWidth(5)))),
                getVerSpace(FetchPixels.getPixelHeight(29)),
                getButton(context, blueColor, "Next", Colors.white, () {
                  if (index == DataFile.introList.length - 1) {
                    Constant.sendToNext(context, Routes.loginRoute);
                  } else {
                    _controller.animateToPage(index + 1,
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInSine);
                  }
                }, 18,
                    weight: FontWeight.w600,
                    buttonHeight: FetchPixels.getPixelHeight(60),
                    insetsGeometry: EdgeInsets.symmetric(
                        horizontal: FetchPixels.getPixelWidth(20)),
                    borderRadius:
                        BorderRadius.circular(FetchPixels.getPixelHeight(15))),
                getVerSpace(FetchPixels.getPixelHeight(16)),
                index == 2
                    ? Container()
                    : GestureDetector(
                        onTap: () {
                          Constant.sendToNext(context, Routes.loginRoute);
                        },
                        child: getCustomFont(
                          "Skip",
                          19,
                          blueColor,
                          1,
                          fontWeight: FontWeight.w600,
                        ),
                      )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container buildImage(ModelIntro introModel) {
    return Container(
      alignment: Alignment.topCenter,
      color: introModel.color,
      child: Column(
        children: [
          getVerSpace(FetchPixels.getPixelHeight(55)),
          getAssetImage(introModel.image ?? "", FetchPixels.getPixelWidth(277),
              FetchPixels.getPixelHeight(435))
        ],
      ),
    );
  }
}
