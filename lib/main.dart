import 'package:baby_book/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:get/get.dart';

import 'base/color_data.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  // 웹 환경에서 카카오 로그인을 정상적으로 완료하려면 runApp() 호출 전 아래 메서드 호출 필요
  WidgetsFlutterBinding.ensureInitialized();

  // runApp() 호출 전 Flutter SDK 초기화
  KakaoSdk.init(
    nativeAppKey: 'd73522af0c49b3e4be2da226ea516f4d',
    javaScriptAppKey: '501ecd1d1f9a2007d192c62155596a62',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: backGroundColor,
      statusBarIconBrightness: Brightness.dark,
    ));

    return Sizer(builder: (context, orientation, deviceType) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: Routes.homepath,
        getPages: AppPages.pages,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('ko'), // English
          Locale('en'), // Spanish
        ],
        theme: ThemeData(
          // accentColor: Color(0xffBA379B).withOpacity(.6),
          // primaryColor: Color(0xffBA379B),
          textSelectionTheme: TextSelectionThemeData(
            selectionColor: Color(0xff9d9d9d).withOpacity(.5),
            cursorColor: Color(0xff000000).withOpacity(.6),
            selectionHandleColor: Color(0xff000000),
          ),
        ),
      );
    });
  }
}
