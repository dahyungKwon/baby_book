part of './app_pages.dart';

abstract class Routes {
  ///전체
  static const loginPath = "/LoginScreen";
  static const reAuthPath = "/ReAuthScreen";
  static const joinPath = "/JoinScreen";
  static const servicePolicyPath = "/ServicePolicyScreen";
  static const privacyPolicyPath = "/PrivacyPolicyScreen";
  static const homescreenPath = "/HomeScreen";
  static const profilePath = "/ProfileScreen";
  static const editProfilePath = "/EditProfileScreen";
  static const memberCommunityPath = "/MemberCommunityScreen";

  ///책 상세
  static const bookDetailPath = "/BookDetailScreen";
  static const bookCommentDetailPath = "/BookCommentDetailScreen";
  static const bookCommunityPath = "/BookCommunityScreen";
  static const bookMemberPath = "/BookMemberScreen";

  ///출판사
  static const publisherPath = "/PublisherScreen";

  ///책장
  static const tabBookCasePath = "/TabBookCase";
  static const bookCasePath = "/BookCaseScreen";
  // static const bookCaseDetailPath = "/BookCaseDetailScreen";

  ///커뮤니티
  static const communityListPath = "/CommunityListScreen";
  static const communityAddPath = "/CommunityAddScreen";
  static const communityDetailPath = "/CommunityDetailScreen";
  static const communityModifyPath = "/CommunityModifyScreen";
  static const commentDetailPath = "/CommentDetailScreen";

  ///프로필
  static const tabProfilePath = "/TabProfile";
  static const settingPath = "/SettingScreen";

  ///사용안함
  static const homepath = "/";
  static const introPath = "/IntroScreen";
  static const forgotPath = "/ForgotPassword";
  static const resetPath = "/ResetPassword";
  static const signUpPath = "/SignUpScreen";
  static const selectCountryPath = "/SelectCountry";
  static const verifyPath = "/VerifyScreen";
  static const categoryPath = "/CategoryScreen";
  static const detailPath = "/DetailScreen";
  static const cartPath = "/CartScreen";
  static const addressPath = "/AddressScreen";
  static const dateTimePath = "/DateTimeScreen";
  static const paymentPath = "/PaymentScreen";
  static const orderDetailPath = "/OrderDetail";

  static const myAddressPath = "/MyAddressScreen";
  static const editAddressPath = "/EditAddressScreen";
  static const cardPath = "/CardScreen";
  // static const settingPath = "/SettingScreen";
  static const notificationPath = "/NotificationScreen";
  static const searchPath = "/SearchScreen";
  static const bookingPath = "/BookingDetail";
  static const helpPath = "/HelpScreen";
  static const privacyPath = "/PrivacyScreen";
  static const securityPath = "/SecurityScreen";
  static const termOfServicePath = "/TermOfServiceScreen";
}
