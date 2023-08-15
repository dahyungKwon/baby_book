import 'package:baby_book/app/view/community/comment_detail_screen.dart';
import 'package:baby_book/app/view/home/book/book_comment_detail_screen.dart';
import 'package:baby_book/app/view/home/home_screen.dart';
import 'package:baby_book/app/view/login/join_screen.dart';
import 'package:baby_book/app/view/profile/member_community_screen.dart';
import 'package:get/get.dart';
import '../view/community/community_add_screen.dart';
import '../view/community/community_detail_screen.dart';
import '../view/home/book/book_community_screen.dart';
import '../view/home/book/book_detail_screen.dart';
import '../view/home/book/book_member_screen.dart';
import '../view/home/bookcase/book_case_screen.dart';
import '../view/login/login_screen.dart';
import '../view/login/privacy_policy_screen.dart';
import '../view/login/re_auth_screen.dart';
import '../view/login/service_policy_screen.dart';
import '../view/profile/edit_profile_screen.dart';
import '../view/profile/profile_screen.dart';
import '../view/profile/setting_screen.dart';
import '../view/publisher/publisher_list_screen.dart';
import '../view/publisher/publisher_screen.dart';
import '../view/search/search_screen.dart';
import '../view/splash_screen.dart';

part './app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: Routes.splashPath, page: () => SplashScreen(), transition: Transition.noTransition),
    GetPage(name: Routes.loginPath, page: () => LoginScreen(), transition: Transition.noTransition),
    GetPage(name: Routes.reAuthPath, page: () => ReAuthScreen(), transition: Transition.noTransition),
    GetPage(name: Routes.homescreenPath, page: () => HomeScreen(0), transition: Transition.noTransition),
    GetPage(name: Routes.tabBookCasePath, page: () => HomeScreen(1), transition: Transition.noTransition),
    GetPage(name: Routes.communityListPath, page: () => HomeScreen(2), transition: Transition.noTransition),
    GetPage(name: Routes.tabProfilePath, page: () => HomeScreen(3), transition: Transition.noTransition),

    GetPage(name: Routes.communityAddPath, page: () => CommunityAddScreen(), transition: Transition.cupertino),
    GetPage(name: Routes.communityDetailPath, page: () => CommunityDetailScreen(), transition: Transition.cupertino),
    GetPage(name: Routes.commentDetailPath, page: () => CommentDetailScreen(), transition: Transition.cupertino),
    GetPage(name: Routes.bookDetailPath, page: () => BookDetailScreen(), transition: Transition.cupertino),
    GetPage(
        name: Routes.bookCommentDetailPath, page: () => BookCommentDetailScreen(), transition: Transition.cupertino),
    GetPage(name: Routes.bookCommunityPath, page: () => BookCommunityScreen(), transition: Transition.cupertino),
    GetPage(name: Routes.bookCasePath, page: () => BookCaseScreen(), transition: Transition.cupertino),
    GetPage(name: Routes.bookMemberPath, page: () => BookMemberScreen(), transition: Transition.cupertino),
    GetPage(name: Routes.publisherPath, page: () => PublisherScreen(), transition: Transition.cupertino),
    GetPage(name: Routes.publisherListPath, page: () => PublisherListScreen(), transition: Transition.cupertino),

    // GetPage(name: Routes.bookCaseDetailPath, page: () => BookDetailScreen(), transition: Transition.cupertino),
    GetPage(name: Routes.joinPath, page: () => JoinScreen(), transition: Transition.noTransition),
    GetPage(name: Routes.privacyPolicyPath, page: () => PrivacyPolicyScreen(), transition: Transition.cupertino),
    GetPage(name: Routes.servicePolicyPath, page: () => ServicePolicyScreen(), transition: Transition.cupertino),
    GetPage(name: Routes.profilePath, page: () => ProfileScreen(), transition: Transition.cupertino),
    GetPage(name: Routes.editProfilePath, page: () => EditProfileScreen(), transition: Transition.cupertino),
    GetPage(name: Routes.memberCommunityPath, page: () => MemberCommunityScreen(), transition: Transition.cupertino),
    GetPage(name: Routes.settingPath, page: () => SettingScreen(), transition: Transition.cupertino),
    GetPage(name: Routes.searchPath, page: () => SearchScreen(), transition: Transition.cupertino),
    // GetPage(name: Routes.communityModifyPath, page: () => communityModifyScreen(0)),
  ];
}
