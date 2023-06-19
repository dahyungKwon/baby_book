import 'package:baby_book/app/view/community/post_type.dart';

class ModelPostRequest {
  PostType postType;
  String memberId;
  String title;
  String contents;
  String? externalLink;

  String? postTag1;
  String? postTag2;
  String? postTag3;

  ModelPostRequest({
    required this.postType,
    required this.memberId,
    required this.title,
    required this.contents,
    this.externalLink,
    this.postTag1,
    this.postTag2,
    this.postTag3,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['postType'] = postType.code;
    data['memberId'] = memberId;
    data['title'] = title;
    data['contents'] = contents;
    data['externalLink'] = externalLink;
    data['postTag1'] = postTag1;
    data['postTag2'] = postTag2;
    data['postTag3'] = postTag3;
    return data;
  }
}
