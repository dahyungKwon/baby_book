import 'package:baby_book/app/view/address/edit_address_screen.dart';
import 'package:baby_book/app/view/address/my_address_screen.dart';
import 'package:baby_book/app/view/bookings/booking_detail.dart';
import 'package:baby_book/app/view/card/card_screen.dart';
import 'package:baby_book/app/view/home/address_screen.dart';
import 'package:baby_book/app/view/home/cart_screen.dart';
import 'package:baby_book/app/view/home/category_screen.dart';
import 'package:baby_book/app/view/home/date_time_screen.dart';
import 'package:baby_book/app/view/home/home_screen.dart';
import 'package:baby_book/app/view/home/detail_screen.dart';
import 'package:baby_book/app/view/home/payment_screen.dart';
import 'package:baby_book/app/view/home/order_detail.dart';
import 'package:baby_book/app/view/intro/intro_screen.dart';
import 'package:baby_book/app/view/login/forgot_password.dart';
import 'package:baby_book/app/view/login/login_screen.dart';
import 'package:baby_book/app/view/login/reset_password.dart';
import 'package:baby_book/app/view/notification_screen.dart';
import 'package:baby_book/app/view/profile/edit_profile_screen.dart';
import 'package:baby_book/app/view/profile/profile_screen.dart';
import 'package:baby_book/app/view/search/search_screen.dart';
import 'package:baby_book/app/view/setting/help_screen.dart';
import 'package:baby_book/app/view/setting/privacy_screen.dart';
import 'package:baby_book/app/view/setting/security_screen.dart';
import 'package:baby_book/app/view/setting/setting_screen.dart';
import 'package:baby_book/app/view/setting/term_of_service_screen.dart';
import 'package:baby_book/app/view/signup/select_country.dart';
import 'package:baby_book/app/view/signup/signup_screen.dart';
import 'package:baby_book/app/view/signup/verify_screen.dart';
import 'package:flutter/cupertino.dart';

import '../view/splash_screen.dart';
import 'app_routes.dart';

class AppPages {
  static const initialRoute = Routes.homeRoute;
  static Map<String, WidgetBuilder> routes = {
    Routes.homeRoute: (context) => const SplashScreen(),
    Routes.introRoute: (context) => const IntroScreen(),
    Routes.loginRoute: (context) => const LoginScreen(),
    Routes.forgotRoute: (context) => const ForgotPassword(),
    Routes.resetRoute: (context) => const ResetPassword(),
    Routes.signupRoute: (context) => const SignUpScreen(),
    Routes.selectCountryRoute: (context) => const SelectCountry(),
    Routes.verifyRoute: (context) => const VerifyScreen(),
    Routes.homeScreenRoute: (context) => const HomeScreen(0),
    Routes.categoryRoute: (context) => const CategoryScreen(),
    Routes.detailRoute: (context) => const DetailScreen(),
    Routes.cartRoute: (context) => const CartScreen(),
    Routes.addressRoute: (context) => const AddressScreen(),
    Routes.dateTimeRoute: (context) => const DateTimeScreen(),
    Routes.paymentRoute: (context) => const PaymentScreen(),
    Routes.orderDetailRoute: (context) => const OrderDetail(),
    Routes.profileRoute: (context) => const ProfileScreen(),
    Routes.editProfileRoute: (context) => const EditProfileScreen(),
    Routes.myAddressRoute: (context) => const MyAddressScreen(),
    Routes.editAddressRoute: (context) => const EditAddressScreen(),
    Routes.cardRoute: (context) => const CardScreen(),
    Routes.settingRoute: (context) => const SettingScreen(),
    Routes.notificationRoutes: (context) => const NotificationScreen(),
    Routes.searchRoute: (context) => const SearchScreen(),
    Routes.bookingRoute: (context) => const BookingDetail(),
    Routes.helpRoute: (context) => const HelpScreen(),
    Routes.privacyRoute: (context) => const PrivacyScreen(),
    Routes.securityRoute: (context) => const SecurityScreen(),
    Routes.termOfServiceRoute: (context) => const TermOfServiceScreen()
  };
}
