import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';

class ModelKakaoLinkTemplate {
  static const String sharedTypeCommunity = "COMMUNITY";
  static const String sharedTypeBook = "BOOK";

  static TextTemplate getTextTemplateForPost(String title, String sharedType, String postId) {
    return TextTemplate(
      text: title,
      link: Link(
        androidExecutionParams: {'sharedType': sharedType, 'postId': postId},
        iosExecutionParams: {'sharedType': sharedType, 'postId': postId},
      ),
      // buttons: [
      //   Button(
      //     title: '앱으로보기',
      //     link: Link(
      //       androidExecutionParams: {'key1': 'value1', 'key2': 'value2'},
      //       iosExecutionParams: {'key1': 'value1', 'key2': 'value2'},
      //     ),
      //   ),
      // ],
    );
  }

  static TextTemplate getTextTemplateForBook(String title, String sharedType, int bookSetId) {
    return TextTemplate(
      text: title,
      link: Link(
        androidExecutionParams: {'sharedType': sharedType, 'bookSetId': bookSetId.toString()},
        iosExecutionParams: {'sharedType': sharedType, 'bookSetId': bookSetId.toString()},
      ),
      // buttons: [
      //   Button(
      //     title: '앱으로보기',
      //     link: Link(
      //       androidExecutionParams: {'key1': 'value1', 'key2': 'value2'},
      //       iosExecutionParams: {'key1': 'value1', 'key2': 'value2'},
      //     ),
      //   ),
      // ],
    );
  }
}
