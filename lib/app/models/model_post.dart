import 'package:baby_book/app/view/community/post_type.dart';

class ModelPost {
  String postId;
  PostType postType;
  String memberId;
  String title;
  String contents;
  String? externalLink;

  int? likeCount = 0;
  int? dislikeCount = 0;
  int? viewCount = 0;
  int? commentCount = 0;
  int? bookmarkCount = 0;

  DateTime createdAt;
  DateTime? updatedAt;

  String? postTag1;
  String? postTag2;
  String? postTag3;

  bool? liked = false;
  bool? disliked = false;
  bool? bookmark = false;

  String nickName;
  String createdAtToString;
  String timeDiffForUi;

  ModelPost({
    required this.postId,
    required this.postType,
    required this.memberId,
    required this.title,
    required this.contents,
    this.externalLink,
    this.likeCount,
    this.dislikeCount,
    this.viewCount,
    this.commentCount,
    this.bookmarkCount,
    required this.createdAt,
    this.updatedAt,
    this.postTag1,
    this.postTag2,
    this.postTag3,
    this.liked,
    this.disliked,
    this.bookmark,
    required this.nickName,
    required this.createdAtToString,
    required this.timeDiffForUi,
  });

  // JSON형태에서부터 데이터를 받아온다.
  ModelPost.fromJson(Map<String, dynamic> json)
      : postId = json['postId'],
        postType = PostType.findByCode(json['postType']),
        memberId = json['memberId'],
        title = json['title'],
        contents = json['contents'],
        externalLink = json['externalLink'],
        likeCount = json['likeCount'],
        dislikeCount = json['dislikeCount'],
        viewCount = json['viewCount'],
        commentCount = json['commentCount'],
        bookmarkCount = json['bookmarkCount'],
        createdAt = DateTime.parse(json['createdAt']),
        updatedAt = json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
        postTag1 = json['postTag1'],
        postTag2 = json['postTag2'],
        postTag3 = json['postTag3'],
        liked = json['liked'],
        disliked = json['disliked'],
        bookmark = json['bookmark'],
        nickName = json['nickName'],
        createdAtToString = json['createdAtToString'],
        timeDiffForUi = json['timeDiffForUi'];
}
