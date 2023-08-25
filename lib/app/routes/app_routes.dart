part of './app_pages.dart';

abstract class Routes {
  ///전체
  static const splashPath = "/SplashScreen";
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
  static const publisherListPath = "/PublisherListScreen";

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
  static const reportBadPostAddPath = "/ReportBadPostAddScreen";
  static const reportBadCommentAddPath = "/ReportBadCommentAddScreen";

  ///프로필
  static const tabProfilePath = "/TabProfile";
  static const settingPath = "/SettingScreen";

  ///검색
  static const searchPath = "/SearchScreen";

  ///책제보 추가
  static const reportNewBookAddPath = "/ReportNewBookAddScreen";
}
