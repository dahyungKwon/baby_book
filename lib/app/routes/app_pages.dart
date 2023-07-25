import 'package:baby_book/app/view/community/comment_detail_screen.dart';
import 'package:baby_book/app/view/home/home_screen.dart';
import 'package:baby_book/app/view/intro/intro_screen.dart';
import 'package:baby_book/app/view/login/join_screen.dart';
import 'package:baby_book/app/view/profile/member_community_screen.dart';
import 'package:get/get.dart';

import '../view/address/edit_address_screen.dart';
import '../view/address/my_address_screen.dart';
import '../view/bookings/booking_detail.dart';
import '../view/card/card_screen.dart';
import '../view/community/community_add_screen.dart';
import '../view/community/community_detail_screen.dart';
import '../view/home/address_screen.dart';
import '../view/home/book/book_detail_screen.dart';
import '../view/home/bookcase/book_case_screen.dart';
import '../view/home/cart_screen.dart';
import '../view/home/category_screen.dart';
import '../view/home/date_time_screen.dart';
import '../view/home/detail_screen.dart';
import '../view/home/order_detail.dart';
import '../view/home/payment_screen.dart';
import '../view/login/forgot_password.dart';
import '../view/login/login_screen.dart';
import '../view/login/privacy_policy_screen.dart';
import '../view/login/reset_password.dart';
import '../view/login/service_policy_screen.dart';
import '../view/notification_screen.dart';
import '../view/profile/edit_profile_screen.dart';
import '../view/profile/profile_screen.dart';
import '../view/search/search_screen.dart';
import '../view/setting/help_screen.dart';
import '../view/setting/privacy_screen.dart';
import '../view/setting/security_screen.dart';
import '../view/setting/setting_screen.dart';
import '../view/setting/term_of_service_screen.dart';
import '../view/signup/select_country.dart';
import '../view/signup/signup_screen.dart';
import '../view/signup/verify_screen.dart';
import '../view/splash_screen.dart';

part './app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: Routes.homepath, page: () => SplashScreen(), transition: Transition.noTransition),
    GetPage(name: Routes.loginPath, page: () => LoginScreen(), transition: Transition.noTransition),
    GetPage(name: Routes.homescreenPath, page: () => HomeScreen(0), transition: Transition.noTransition),
    GetPage(name: Routes.tabBookCasePath, page: () => HomeScreen(1), transition: Transition.noTransition),
    GetPage(name: Routes.communityListPath, page: () => HomeScreen(2), transition: Transition.noTransition),
    GetPage(name: Routes.tabProfilePath, page: () => HomeScreen(3), transition: Transition.noTransition),

    GetPage(name: Routes.communityAddPath, page: () => CommunityAddScreen(), transition: Transition.cupertino),
    GetPage(name: Routes.communityDetailPath, page: () => CommunityDetailScreen(), transition: Transition.cupertino),
    GetPage(name: Routes.commentDetailPath, page: () => CommentDetailScreen(), transition: Transition.cupertino),
    GetPage(name: Routes.bookDetailPath, page: () => BookDetailScreen(), transition: Transition.cupertino),
    GetPage(name: Routes.bookCasePath, page: () => BookCaseScreen(), transition: Transition.cupertino),
    // GetPage(name: Routes.bookCaseDetailPath, page: () => BookDetailScreen(), transition: Transition.cupertino),
    GetPage(name: Routes.joinPath, page: () => JoinScreen(), transition: Transition.noTransition),
    GetPage(name: Routes.privacyPolicyPath, page: () => PrivacyPolicyScreen(), transition: Transition.cupertino),
    GetPage(name: Routes.servicePolicyPath, page: () => ServicePolicyScreen(), transition: Transition.cupertino),
    GetPage(name: Routes.profilePath, page: () => ProfileScreen(), transition: Transition.cupertino),
    GetPage(name: Routes.editProfilePath, page: () => EditProfileScreen(), transition: Transition.cupertino),
    GetPage(name: Routes.memberCommunityPath, page: () => MemberCommunityScreen(), transition: Transition.cupertino),
    // GetPage(name: Routes.communityModifyPath, page: () => communityModifyScreen(0)),

    GetPage(name: Routes.introPath, page: () => IntroScreen()), //현재 안씀
    GetPage(name: Routes.forgotPath, page: () => ForgotPassword()), //현재 안씀
    GetPage(name: Routes.resetPath, page: () => ResetPassword()), //현재 안씀
    GetPage(name: Routes.signUpPath, page: () => SignUpScreen()), //현재 안씀
    GetPage(name: Routes.selectCountryPath, page: () => SelectCountry()), //현재 안씀
    GetPage(name: Routes.verifyPath, page: () => VerifyScreen()), //현재 안씀
    GetPage(name: Routes.categoryPath, page: () => CategoryScreen()), //현재 안씀
    GetPage(name: Routes.detailPath, page: () => DetailScreen()), //현재 안씀
    GetPage(name: Routes.cartPath, page: () => CartScreen()), //현재 안씀
    GetPage(name: Routes.addressPath, page: () => AddressScreen()), //현재 안씀
    GetPage(name: Routes.dateTimePath, page: () => DateTimeScreen()), //현재 안씀
    GetPage(name: Routes.paymentPath, page: () => PaymentScreen()), //현재 안씀
    GetPage(name: Routes.orderDetailPath, page: () => OrderDetail()), //현재 안씀

    GetPage(name: Routes.myAddressPath, page: () => MyAddressScreen()), //현재 안씀
    GetPage(name: Routes.editAddressPath, page: () => EditAddressScreen()), //현재 안씀
    GetPage(name: Routes.cardPath, page: () => CardScreen()), //현재 안씀
    GetPage(name: Routes.settingPath, page: () => SettingScreen()), //현재 안씀
    GetPage(name: Routes.notificationPath, page: () => NotificationScreen()), //현재 안씀
    GetPage(name: Routes.searchPath, page: () => SearchScreen()), //현재 안씀
    GetPage(name: Routes.bookingPath, page: () => BookingDetail()), //현재 안씀
    GetPage(name: Routes.helpPath, page: () => HelpScreen()), //현재 안씀
    GetPage(name: Routes.privacyPath, page: () => PrivacyScreen()), //현재 안씀
    GetPage(name: Routes.securityPath, page: () => SecurityScreen()), //현재 안씀
    GetPage(name: Routes.termOfServicePath, page: () => TermOfServiceScreen()), //현재 안씀
  ];
}
