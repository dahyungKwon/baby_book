// import 'package:baby_book/app/data/data_file.dart';
// import 'package:baby_book/app/models/model_category.dart';
//
// import 'package:baby_book/app/models/model_popular_service.dart';
// import 'package:baby_book/app/routes/app_routes.dart';
// import 'package:baby_book/base/color_data.dart';
// import 'package:baby_book/base/constant.dart';
// import 'package:baby_book/base/resizer/fetch_pixels.dart';
// import 'package:baby_book/base/widget_utils.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class TabHome extends StatefulWidget {
//   const TabHome({Key? key}) : super(key: key);
//
//   @override
//   State<TabHome> createState() => _TabHomeState();
// }
//
// class _TabHomeState extends State<TabHome> {
//   TextEditingController searchController = TextEditingController();
//   static List<ModelCategory> categoryLists = DataFile.categoryList;
//   List<ModelPopularService> popularServiceLists = DataFile.popularServiceList;
//   ValueNotifier selectedPage = ValueNotifier(0);
//   final _controller = PageController();
//   SharedPreferences? selection;
//
//   @override
//   void initState() {
//     super.initState();
//
//     SharedPreferences.getInstance().then((SharedPreferences sp) {
//       selection = sp;
//       setState(() {});
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: Column(
//         children: [
//       getVerSpace(FetchPixels.getPixelHeight(21)),
//       getPaddingWidget(
//         EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             getSvgImage(
//               "menu.svg",
//             ),
//             Row(
//               children: [
//                 getSvgImage("location.svg"),
//                 getHorSpace(FetchPixels.getPixelWidth(4)),
//                 getCustomFont("Shiloh, Hawaii", 14, Colors.black, 1,
//                     fontWeight: FontWeight.w400, )
//               ],
//             ),
//             GestureDetector(
//               onTap: () {
//                 Constant.sendToNext(context, Routes.notificationRoutes);
//               },
//               child: getSvgImage(
//                 "notification.svg",
//               ),
//             ),
//           ],
//         ),
//       ),
//       getVerSpace(FetchPixels.getPixelHeight(32)),
//       getPaddingWidget(
//           EdgeInsets.symmetric(
//               horizontal: FetchPixels.getPixelWidth(20)),
//           getSearchWidget(context, searchController, () {
//             Constant.sendToNext(context, Routes.searchRoute);
//           }, (value) {})),
//       getVerSpace(FetchPixels.getPixelHeight(20)),
//       pageView(),
//       getVerSpace(FetchPixels.getPixelHeight(24)),
//       Expanded(
//         flex: 1,
//         child:ListView(
//     shrinkWrap: true,
//           primary: true,
//     children: [
//       getPaddingWidget(
//         EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             getCustomFont("Categories", 20, Colors.black, 1,
//                  fontWeight: FontWeight.w900),
//             GestureDetector(
//               onTap: () {
//                 Constant.sendToNext(context, Routes.categoryRoute);
//               },
//               child: getCustomFont("View All", 14, blueColor, 1,
//                   fontWeight: FontWeight.w600, ),
//             )
//           ],
//         ),
//       ),
//       getVerSpace(FetchPixels.getPixelHeight(16)),
//       Container(
//         height: FetchPixels.getPixelHeight(132),
//         padding: EdgeInsets.only(left: FetchPixels.getPixelWidth(20)),
//         child: ListView.builder(
//           scrollDirection: Axis.horizontal,
//           itemCount: 6,
//           physics: const BouncingScrollPhysics(),
//           itemBuilder: (context, index) {
//             ModelCategory modelCategory = categoryLists[index];
//             return GestureDetector(
//               onTap: () {
//                 // showModalBottomSheet(
//                 //     backgroundColor: backGroundColor,
//                 //     isDismissible: false,
//                 //     isScrollControlled: true,
//                 //     context: context,
//                 //     shape: RoundedRectangleBorder(
//                 //       borderRadius: BorderRadius.vertical(
//                 //         top:
//                 //             Radius.circular(FetchPixels.getPixelHeight(40)),
//                 //       ),
//                 //     ),
//                 //     builder: (context) {
//                 //       return CategoryDialog();
//                 //     });
//                 selection!.setInt("index", 1);
//                 Constant.sendToNext(context, Routes.detailRoute);
//               },
//               child: Container(
//                 margin: EdgeInsets.only(
//                     right: FetchPixels.getPixelWidth(20),
//                     bottom: FetchPixels.getPixelHeight(28)),
//                 padding: EdgeInsets.only(
//                     top: FetchPixels.getPixelHeight(16),
//                     bottom: FetchPixels.getPixelHeight(12)),
//                 width: FetchPixels.getPixelWidth(91),
//                 decoration: BoxDecoration(
//                     color: Colors.white,
//                     boxShadow: const [
//                       BoxShadow(
//                           color: Colors.black12,
//                           blurRadius: 10,
//                           offset: Offset(0.0, 4.0)),
//                     ],
//                     borderRadius: BorderRadius.circular(
//                         FetchPixels.getPixelHeight(12))),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     // getVerSpace(FetchPixels.getPixelHeight(16)),
//                     getSvgImage(modelCategory.image ?? "",
//                         width: FetchPixels.getPixelHeight(44),
//                         height: FetchPixels.getPixelHeight(44)),
//                     getVerSpace(FetchPixels.getPixelHeight(10)),
//                     getCustomFont(
//                         modelCategory.name ?? "", 14, Colors.black, 1,
//                          fontWeight: FontWeight.w400),
//                     // getVerSpace(FetchPixels.getPixelHeight(12)),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//       getPaddingWidget(
//         EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             getCustomFont("Popular Services", 20, Colors.black, 1,
//                 fontWeight: FontWeight.w900, ),
//             getCustomFont("View All", 14, blueColor, 1,
//                  fontWeight: FontWeight.w600)
//           ],
//         ),
//       ),
//       getVerSpace(FetchPixels.getPixelHeight(16)),
//       Container(
//         height: FetchPixels.getPixelHeight(215),
//         margin: EdgeInsets.only(left: FetchPixels.getPixelWidth(20)),
//         child: ListView.builder(
//           physics: const BouncingScrollPhysics(),
//           scrollDirection: Axis.horizontal,
//           itemCount: popularServiceLists.length,
//           itemBuilder: (context, index) {
//             ModelPopularService modelPopularService =
//             popularServiceLists[index];
//             return GestureDetector(
//               onTap: () {
//                 selection!.setInt("index", index);
//                 Constant.sendToNext(context, Routes.detailRoute);
//               },
//               child: Container(
//                 width: FetchPixels.getPixelWidth(177),
//                 decoration: BoxDecoration(
//                     color: Colors.white,
//                     boxShadow: const [
//                       BoxShadow(
//                           color: Colors.black12,
//                           blurRadius: 10,
//                           offset: Offset(0.0, 4.0)),
//                     ],
//                     borderRadius: BorderRadius.circular(
//                         FetchPixels.getPixelHeight(12))),
//                 padding: EdgeInsets.only(
//                     left: FetchPixels.getPixelWidth(10),
//                     right: FetchPixels.getPixelWidth(10),
//                     top: FetchPixels.getPixelHeight(10),
//                     bottom: FetchPixels.getPixelHeight(10)),
//                 margin: EdgeInsets.only(
//                     bottom: FetchPixels.getPixelHeight(24),
//                     right: FetchPixels.getPixelWidth(20)),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Hero(
//                       tag: popularServiceLists[index],
//                       child: getAssetImage(
//                           modelPopularService.image ?? "",
//                           FetchPixels.getPixelWidth(157),
//                           FetchPixels.getPixelHeight(115)),
//                     ),
//                     getVerSpace(FetchPixels.getPixelHeight(10)),
//                     Align(
//                         alignment: Alignment.topLeft,
//                         child: getCustomFont(modelPopularService.name ?? "",
//                             14, Colors.black, 1,
//                             fontWeight: FontWeight.w900, )),
//                     getVerSpace(FetchPixels.getPixelHeight(4)),
//                     Align(
//                         alignment: Alignment.topLeft,
//                         child: getCustomFont(
//                             modelPopularService.category ?? "",
//                             14,
//                             Colors.black,
//                             1,
//
//                             fontWeight: FontWeight.w400))
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       )
//     ],
//     ),
//       )
//         ],
//       ),
//     );
//   }
//
//   Column popularServiceList() {
//     return Column(
//       children: [
//         getPaddingWidget(
//           EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               getCustomFont("Popular Services", 20, Colors.black, 1,
//                   fontWeight: FontWeight.w900, ),
//               getCustomFont("View All", 14, blueColor, 1,
//                    fontWeight: FontWeight.w600)
//             ],
//           ),
//         ),
//         getVerSpace(FetchPixels.getPixelHeight(16)),
//         Container(
//           height: FetchPixels.getPixelHeight(215),
//           margin: EdgeInsets.only(left: FetchPixels.getPixelWidth(20)),
//           child: ListView.builder(
//             physics: const BouncingScrollPhysics(),
//             scrollDirection: Axis.horizontal,
//             itemCount: popularServiceLists.length,
//             itemBuilder: (context, index) {
//               ModelPopularService modelPopularService =
//                   popularServiceLists[index];
//               return GestureDetector(
//                 onTap: () {
//                   selection!.setInt("index", index);
//                   Constant.sendToNext(context, Routes.detailRoute);
//                 },
//                 child: Container(
//                   width: FetchPixels.getPixelWidth(177),
//                   decoration: BoxDecoration(
//                       color: Colors.white,
//                       boxShadow: const [
//                         BoxShadow(
//                             color: Colors.black12,
//                             blurRadius: 10,
//                             offset: Offset(0.0, 4.0)),
//                       ],
//                       borderRadius: BorderRadius.circular(
//                           FetchPixels.getPixelHeight(12))),
//                   padding: EdgeInsets.only(
//                       left: FetchPixels.getPixelWidth(10),
//                       right: FetchPixels.getPixelWidth(10),
//                       top: FetchPixels.getPixelHeight(10),
//                       bottom: FetchPixels.getPixelHeight(10)),
//                   margin: EdgeInsets.only(
//                       bottom: FetchPixels.getPixelHeight(24),
//                       right: FetchPixels.getPixelWidth(20)),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Hero(
//                         tag: popularServiceLists[index],
//                         child: getAssetImage(
//                             modelPopularService.image ?? "",
//                             FetchPixels.getPixelWidth(157),
//                             FetchPixels.getPixelHeight(115)),
//                       ),
//                       getVerSpace(FetchPixels.getPixelHeight(10)),
//                       Align(
//                           alignment: Alignment.topLeft,
//                           child: getCustomFont(modelPopularService.name ?? "",
//                               14, Colors.black, 1,
//                               fontWeight: FontWeight.w900, )),
//                       getVerSpace(FetchPixels.getPixelHeight(4)),
//                       Align(
//                           alignment: Alignment.topLeft,
//                           child: getCustomFont(
//                               modelPopularService.category ?? "",
//                               14,
//                               Colors.black,
//                               1,
//
//                               fontWeight: FontWeight.w400))
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         )
//       ],
//     );
//   }
//
//   Column categoryList(BuildContext context) {
//     return Column(
//       children: [
//         getPaddingWidget(
//           EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               getCustomFont("Categories", 20, Colors.black, 1,
//                    fontWeight: FontWeight.w900),
//               GestureDetector(
//                 onTap: () {
//                   Constant.sendToNext(context, Routes.categoryRoute);
//                 },
//                 child: getCustomFont("View All", 14, blueColor, 1,
//                     fontWeight: FontWeight.w600, ),
//               )
//             ],
//           ),
//         ),
//         getVerSpace(FetchPixels.getPixelHeight(16)),
//         Container(
//           height: FetchPixels.getPixelHeight(132),
//           padding: EdgeInsets.only(left: FetchPixels.getPixelWidth(20)),
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: 6,
//             physics: const BouncingScrollPhysics(),
//             itemBuilder: (context, index) {
//               ModelCategory modelCategory = categoryLists[index];
//               return GestureDetector(
//                 onTap: () {
//                   // showModalBottomSheet(
//                   //     backgroundColor: backGroundColor,
//                   //     isDismissible: false,
//                   //     isScrollControlled: true,
//                   //     context: context,
//                   //     shape: RoundedRectangleBorder(
//                   //       borderRadius: BorderRadius.vertical(
//                   //         top:
//                   //             Radius.circular(FetchPixels.getPixelHeight(40)),
//                   //       ),
//                   //     ),
//                   //     builder: (context) {
//                   //       return CategoryDialog();
//                   //     });
//                   selection!.setInt("index", 1);
//                   Constant.sendToNext(context, Routes.detailRoute);
//                 },
//                 child: Container(
//                   margin: EdgeInsets.only(
//                       right: FetchPixels.getPixelWidth(20),
//                       bottom: FetchPixels.getPixelHeight(28)),
//                   padding: EdgeInsets.only(
//                       top: FetchPixels.getPixelHeight(16),
//                       bottom: FetchPixels.getPixelHeight(12)),
//                   width: FetchPixels.getPixelWidth(91),
//                   decoration: BoxDecoration(
//                       color: Colors.white,
//                       boxShadow: const [
//                         BoxShadow(
//                             color: Colors.black12,
//                             blurRadius: 10,
//                             offset: Offset(0.0, 4.0)),
//                       ],
//                       borderRadius: BorderRadius.circular(
//                           FetchPixels.getPixelHeight(12))),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       // getVerSpace(FetchPixels.getPixelHeight(16)),
//                       getSvgImage(modelCategory.image ?? "",
//                           width: FetchPixels.getPixelHeight(44),
//                           height: FetchPixels.getPixelHeight(44)),
//                       getVerSpace(FetchPixels.getPixelHeight(10)),
//                       getCustomFont(
//                           modelCategory.name ?? "", 14, Colors.black, 1,
//                            fontWeight: FontWeight.w400),
//                       // getVerSpace(FetchPixels.getPixelHeight(12)),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
//
//   Column pageView() {
//     return Column(
//       children: [
//         SizedBox(
//           height: FetchPixels.getPixelHeight(184),
//           child: PageView.builder(
//             controller: _controller,
//             onPageChanged: (value) {
//               selectedPage.value = value;
//             },
//             itemCount: 3,
//             itemBuilder: (context, index) {
//               return Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   Container(
//                     width: FetchPixels.getPixelWidth(374),
//                     decoration: BoxDecoration(
//                         color: const Color(0xFFD0DDFF),
//                         borderRadius: BorderRadius.circular(
//                             FetchPixels.getPixelHeight(20)),
//                         image: getDecorationAssetImage(context, "maskgroup.png",
//                             fit: BoxFit.fill)),
//                     alignment: Alignment.center,
//                   ),
//                   Positioned(
//                       child: SizedBox(
//                     height: FetchPixels.getPixelHeight(180),
//                     width: FetchPixels.getPixelWidth(374),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         getPaddingWidget(
//                           EdgeInsets.only(
//                               left: FetchPixels.getPixelWidth(20),
//                               top: FetchPixels.getPixelHeight(20),
//                               bottom: FetchPixels.getPixelHeight(20)),
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               SizedBox(
//                                   width: FetchPixels.getPixelHeight(130),
//                                   child: getMultilineCustomFont(
//                                       "Wall Painting Service", 20, Colors.black,
//
//                                       fontWeight: FontWeight.w900,
//                                       txtHeight: 1.3)),
//                               getVerSpace(FetchPixels.getPixelHeight(6)),
//                               getCustomFont(
//                                   "Make your wall stylish", 14, Colors.black, 1,
//                                   fontWeight: FontWeight.w400,
//                                   ),
//                               getVerSpace(FetchPixels.getPixelHeight(16)),
//                               getButton(context, blueColor, "Book Now",
//                                   Colors.white, () {}, 14,
//                                   weight: FontWeight.w600,
//                                   buttonWidth: FetchPixels.getPixelWidth(108),
//                                   borderRadius: BorderRadius.circular(
//                                       FetchPixels.getPixelHeight(10)),
//                                   insetsGeometrypadding: EdgeInsets.symmetric(
//                                       vertical:
//                                           FetchPixels.getPixelHeight(12))),
//                             ],
//                           ),
//                         ),
//                         Container(
//                             margin: EdgeInsets.only(
//                                 right: FetchPixels.getPixelWidth(21)),
//                             height: FetchPixels.getPixelHeight(175),
//                             width: FetchPixels.getPixelHeight(142),
//                             color: Colors.transparent,
//                             child: getAssetImage(
//                                 "washer.png",
//                                 FetchPixels.getPixelHeight(142),
//                                 FetchPixels.getPixelHeight(175)))
//                       ],
//                     ),
//                   ))
//                 ],
//               );
//             },
//           ),
//         ),
//         getVerSpace(FetchPixels.getPixelHeight(14)),
//         ValueListenableBuilder(
//           valueListenable: selectedPage,
//           builder: (context, value, child) {
//             return Container(
//               height: FetchPixels.getPixelHeight(8),
//               width: FetchPixels.getPixelWidth(44),
//               alignment: Alignment.center,
//               child: ListView.builder(
//                 itemCount: 3,
//                 scrollDirection: Axis.horizontal,
//                 itemBuilder: (context, index) {
//                   return getPaddingWidget(
//                     EdgeInsets.only(right: FetchPixels.getPixelWidth(10)),
//                     getAssetImage(
//                       "dot.png",
//                       FetchPixels.getPixelHeight(8),
//                       FetchPixels.getPixelHeight(8),
//                       color: selectedPage.value == index
//                           ? blueColor
//                           : blueColor.withOpacity(0.2),
//                     ),
//                   );
//                 },
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }
// }
