import 'package:baby_book/app/data/data_file.dart';
import 'package:baby_book/app/models/model_book.dart';
import 'package:baby_book/base/resizer/fetch_pixels.dart';
import 'package:baby_book/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../base/color_data.dart';
import '../../../base/constant.dart';
import '../../models/model_book_state.dart';

class BookingDetail extends StatefulWidget {
  const BookingDetail({Key? key}) : super(key: key);

  @override
  State<BookingDetail> createState() => _BookingDetailState();
}

class _BookingDetailState extends State<BookingDetail> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();

    tag = "reading"; // TODO :: 사용자별로 책상태 받기
    setController();
  }

  setController() {
    _controller = YoutubePlayerController(
      initialVideoId: "KuGPpecYc28",
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
        hideControls: false,
      ),
    );

    setState(() {});
  }

  bool? isDetailMenu;

  ModelBook? modelBook;
  String? tag; // TODO :: 삭제

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    print(arguments['modelBook']);

    modelBook = arguments['modelBook'];

    isDetailMenu = isDetailMenu ?? true;
    FetchPixels(context);
    double defHorSpace = FetchPixels.getDefaultHorSpace(context);
    EdgeInsets edgeInsets = EdgeInsets.symmetric(horizontal: defHorSpace);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backGroundColor,
      body: SafeArea(
        child: Column(
          children: [
            getVerSpace(FetchPixels.getPixelHeight(20)),
            buildToolbar(context),
            getVerSpace(FetchPixels.getPixelHeight(10)),
            buildMainArea(context, edgeInsets, defHorSpace)
          ],
        ),
      ),
    );
  }

  Expanded buildMainArea(
      BuildContext context, EdgeInsets edgeInsets, double defHorSpace) {
    return Expanded(
      flex: 1,
      child: ListView(
        primary: true,
        shrinkWrap: true,
        children: [
          buildTop(context, edgeInsets),
          buildDown(edgeInsets, context),
        ],
      ),
    );
  }

  Widget buildTop(BuildContext context, EdgeInsets edgeInsets) {
    return Container(
      padding: EdgeInsets.only(
          top: FetchPixels.getPixelHeight(0),
          bottom: FetchPixels.getPixelHeight(14),
          left: FetchPixels.getPixelWidth(20),
          right: FetchPixels.getPixelWidth(20)),
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
        children: [
          Center(
            child: Container(
              height: FetchPixels.height/3,
              width: FetchPixels.width*0.8,
              decoration: BoxDecoration(
                image: getDecorationAssetImage(
                    context, modelBook?.logo ?? "grgr2.png"),
              ),
            ),
          ),
          getVerSpace(FetchPixels.getPixelHeight(10)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  getCustomFont(modelBook?.publisherName ?? "", 12, textColor, 1,
                      fontWeight: FontWeight.w400),
                  getCustomFont(modelBook?.name ?? "", 22, Colors.black, 1,
                      fontWeight: FontWeight.w700),
                ],
              ),
              getSvgImage("question.svg",
                  width: FetchPixels.getPixelHeight(24),
                  height: FetchPixels.getPixelHeight(24))
            ],
          ),
          getVerSpace(FetchPixels.getPixelHeight(6)),
          Row(
            children: [
              getSvgImage("star.svg",
                  width: FetchPixels.getPixelHeight(16),
                  height: FetchPixels.getPixelHeight(16)),
              getHorSpace(FetchPixels.getPixelWidth(6)),
              getCustomFont(
                modelBook?.reviewScore ?? "",
                14,
                Colors.black,
                1,
                fontWeight: FontWeight.w400,
              )
            ],
          ),
          getVerSpace(FetchPixels.getPixelHeight(20)),
          Container( height:1.0,
            width:500.0,
            color:Colors.black26,),
          getVerSpace(FetchPixels.getPixelHeight(10)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: DataFile.bookStateList
                .map(
                  (e) => GestureDetector(
                onTap: () {
                  setState(() {
                    tag = (tag == e.key) ? "" : e.key;
                  });
                  // server call :: change book state
                },
                child: renderBookState(e, e.key == tag),
              ),
            )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget buildDown(EdgeInsets edgeInsets, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getVerSpace(FetchPixels.getPixelHeight(20)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                if (!isDetailMenu!) {
                  setState(() {
                    isDetailMenu = true;
                  });
                }
              },
              child: getCustomFont(
                "상세정보",
                18,
                isDetailMenu! ? Colors.black : textColor,
                1,
                fontWeight: isDetailMenu! ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
            GestureDetector(
              onTap: () {
                if (isDetailMenu!) {
                  setState(() {
                    isDetailMenu = false;
                  });
                }
              },
              child: getCustomFont(
                "게시글",
                18,
                isDetailMenu! ? textColor : Colors.black,
                1,
                fontWeight: isDetailMenu! ? FontWeight.w500 : FontWeight.w600,
              ),
            ),
          ],
        ),
        getVerSpace(FetchPixels.getPixelHeight(10)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            AnimatedContainer(
              height:1.0,
              width:FetchPixels.width/2,
              decoration: BoxDecoration(
                color:isDetailMenu! ? Colors.black : Colors.black26,
              ),
              duration: const Duration(milliseconds: 300),
            ),
            AnimatedContainer(
              height:1.0,
              width:FetchPixels.width/2,
              curve: Curves.decelerate,
              decoration: BoxDecoration(
                color:isDetailMenu! ? Colors.black26 : Colors.black,
              ),
              duration: const Duration(milliseconds: 300),
            ),
          ],
        ),
        isDetailMenu! ? renderDetailMenu() : renderPostMenu(),
      ],
    );
  }

  Widget buildToolbar(BuildContext context) {
    return getPaddingWidget(
      EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
      gettoolbarMenu(context, "back.svg", () {
        Constant.backToPrev(context);
      },
          // title: name ?? "",
          // fontsize: 20,
          // weight: FontWeight.w900,
          // textColor: Colors.black,
          // istext: true
      ),
    );
  }

  Widget renderBookState(ModelBookState state, bool isSelected) {
    return Container(
      child: getCustomFont(
        state.name(),
        18,
        isSelected ? success : textColor,
        1,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget renderDetailMenu() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            renderDetailRow("정가", "46만원"),
            renderDetailRow("공구가", "38만원"),
            renderDetailRow("트렌드랭킹", "1위"),
            renderDetailRow("카테고리", "종합발달"),
            renderDetailRow("구성", "본책 40권"),
            renderDetailRow("공식페이지", "https://www.greatbooks.co.kr/introduce/collected/261", isLink: true),
            renderDetailRow("비교전집", "영아다중(프뢰벨), 핀덴베베(한솔)"),
            renderDetailRow("개정판별 히스토리", ""),
            Align(
              alignment: Alignment.centerLeft,
              child: getCustomFont("소개영상", 16, Colors.black54, 1,
                  fontWeight: FontWeight.w600),
            ),
            getVerSpace(FetchPixels.getPixelHeight(10)),

            YoutubePlayer(
              key: ObjectKey(_controller),
              controller: _controller,
              bottomActions: [
                CurrentPosition(),
                const SizedBox(width: 10.0),
                ProgressBar(isExpanded: true),
                const SizedBox(width: 10.0),
                RemainingDuration(),
                FullScreenButton(),
              ],
            ),

          ],
        ),
      ),
    );
  }

  Widget renderPostMenu() {
    return Container();
  }

  Widget renderDetailRow(String name, String value, {bool isLink = false}) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: (FetchPixels.width-36)*0.3,
              child: getCustomFont(name, 16, Colors.black54, 1,
                  fontWeight: FontWeight.w600),
            ),
              if(!isLink)
                Container(
                  width: (FetchPixels.width-36)*0.7,
                  child: getCustomFont(value, 16, Colors.black, 1,
                      fontWeight: FontWeight.w600),
                ),
              if(isLink)
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      final url = Uri.parse(
                        value,
                      );
                      if (await canLaunchUrl(url)) {
                        launchUrl(url);
                      } else {
                        // ignore: avoid_print
                        print("Can't launch $url");
                      }
                    },
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                        value,
                    ),
                  ),
                ),
          ],
        ),
        getVerSpace(FetchPixels.getPixelHeight(10)),
      ],
    );
  }
}
